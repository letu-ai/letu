using DbCompareTool.Config;
using DbCompareTool.Core.Interfaces;
using DbCompareTool.Core.Models;
using Npgsql;

namespace DbCompareTool.Extractors;

public class PostgreSqlSchemaExtractor : ISchemaExtractor
{
    public async Task<DatabaseSchema> ExtractAsync(ConnectionConfig connection, FilterConfig filter, CancellationToken ct = default)
    {
        var schema = new DatabaseSchema
        {
            Host = connection.Host,
            Port = connection.Port,
            DatabaseName = connection.Database
        };

        await using var conn = new NpgsqlConnection(connection.BuildConnectionString());
        await conn.OpenAsync(ct);

        // 获取数据库版本
        await using (var cmd = new NpgsqlCommand("SELECT version()", conn))
        {
            var version = await cmd.ExecuteScalarAsync(ct);
            schema.Version = version?.ToString() ?? string.Empty;
        }

        // 获取需要扫描的schemas
        var schemas = filter.IncludeSchemas
            .Where(s => !filter.ExcludeSchemas.Contains(s))
            .ToList();

        // 提取所有表
        var tables = await ExtractTablesAsync(conn, schemas, filter, ct);
        foreach (var table in tables)
        {
            schema.AddTable(table);
        }

        // 提取列信息
        await ExtractColumnsAsync(conn, tables, ct);

        // 提取主键
        await ExtractPrimaryKeysAsync(conn, tables, ct);

        // 提取外键
        await ExtractForeignKeysAsync(conn, tables, ct);

        // 提取唯一约束
        await ExtractUniqueConstraintsAsync(conn, tables, ct);

        // 提取检查约束
        await ExtractCheckConstraintsAsync(conn, tables, ct);

        // 提取索引
        await ExtractIndexesAsync(conn, tables, ct);

        return schema;
    }

    private async Task<List<TableSchema>> ExtractTablesAsync(NpgsqlConnection conn, List<string> schemas, FilterConfig filter, CancellationToken ct)
    {
        var tables = new List<TableSchema>();
        var schemaList = string.Join(",", schemas.Select(s => $"'{s}'"));
        var sql = $@"
            SELECT
                t.table_schema AS ""SchemaName"",
                t.table_name AS ""TableName"",
                obj_description((t.table_schema||'.'||t.table_name)::regclass, 'pg_class') AS ""TableComment""
            FROM information_schema.tables t
            WHERE t.table_schema IN ({schemaList})
                AND t.table_type = 'BASE TABLE'
            ORDER BY t.table_schema, t.table_name";

        await using var cmd = new NpgsqlCommand(sql, conn);

        await using var reader = await cmd.ExecuteReaderAsync(ct);
        while (await reader.ReadAsync(ct))
        {
            var schemaName = reader.GetString(0);
            var tableName = reader.GetString(1);

            if (!filter.ShouldIncludeTable(tableName))
                continue;

            tables.Add(new TableSchema
            {
                SchemaName = schemaName,
                TableName = tableName,
                TableComment = reader.IsDBNull(2) ? "" : reader.GetString(2)
            });
        }

        return tables;
    }

    private async Task ExtractColumnsAsync(NpgsqlConnection conn, List<TableSchema> tables, CancellationToken ct)
    {
        if (tables.Count == 0) return;

        var sql = @"
            SELECT
                c.table_schema AS ""SchemaName"",
                c.table_name AS ""TableName"",
                c.column_name AS ""ColumnName"",
                c.data_type AS ""DataType"",
                c.character_maximum_length AS ""CharacterMaximumLength"",
                c.numeric_precision AS ""NumericPrecision"",
                c.numeric_scale AS ""NumericScale"",
                c.datetime_precision AS ""DateTimePrecision"",
                c.is_nullable AS ""IsNullable"",
                c.column_default AS ""DefaultValue"",
                c.ordinal_position AS ""OrdinalPosition"",
                pgd.description AS ""ColumnComment"",
                c.is_identity AS ""IsIdentity"",
                c.identity_generation AS ""IdentityGeneration"",
                c.is_generated AS ""IsGenerated"",
                c.generation_expression AS ""GenerationExpression""
            FROM information_schema.columns c
            LEFT JOIN pg_catalog.pg_description pgd
                ON pgd.objoid = (
                    SELECT oid FROM pg_class
                    WHERE relname = c.table_name
                        AND relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = c.table_schema)
                )
                AND pgd.objsubid = c.ordinal_position
            WHERE c.table_schema = @schemaName
                AND c.table_name = @tableName
            ORDER BY c.table_schema, c.table_name, c.ordinal_position";

        foreach (var table in tables)
        {
            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("schemaName", table.SchemaName);
            cmd.Parameters.AddWithValue("tableName", table.TableName);

            await using var reader = await cmd.ExecuteReaderAsync(ct);
            while (await reader.ReadAsync(ct))
            {
                table.Columns.Add(new ColumnSchema
                {
                    ColumnName = reader.GetString(2),
                    DataType = reader.GetString(3),
                    CharacterMaximumLength = reader.IsDBNull(4) ? null : reader.GetInt32(4),
                    NumericPrecision = reader.IsDBNull(5) ? null : (int?)reader.GetInt32(5),
                    NumericScale = reader.IsDBNull(6) ? null : (int?)reader.GetInt32(6),
                    DateTimePrecision = reader.IsDBNull(7) ? null : (int?)reader.GetInt32(7),
                    IsNullable = reader.GetString(8) == "YES",
                    DefaultValue = reader.IsDBNull(9) ? null : reader.GetString(9),
                    OrdinalPosition = reader.GetInt32(10),
                    ColumnComment = reader.IsDBNull(11) ? null : reader.GetString(11),
                    IsIdentity = reader.GetString(12) == "YES",
                    IdentityGeneration = reader.IsDBNull(13) ? null : reader.GetString(13),
                    IsGenerated = reader.GetString(14) == "ALWAYS",
                    GenerationExpression = reader.IsDBNull(15) ? null : reader.GetString(15)
                });
            }
            await reader.DisposeAsync();
        }
    }

    private async Task ExtractPrimaryKeysAsync(NpgsqlConnection conn, List<TableSchema> tables, CancellationToken ct)
    {
        var sql = @"
            SELECT
                tc.table_schema AS ""SchemaName"",
                tc.table_name AS ""TableName"",
                tc.constraint_name AS ""ConstraintName"",
                kcu.column_name AS ""ColumnName"",
                kcu.ordinal_position AS ""OrdinalPosition""
            FROM information_schema.table_constraints tc
            INNER JOIN information_schema.key_column_usage kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
                AND tc.table_name = kcu.table_name
            WHERE tc.constraint_type = 'PRIMARY KEY'
                AND tc.table_schema = @schemaName
                AND tc.table_name = @tableName
            ORDER BY tc.table_schema, tc.table_name, kcu.ordinal_position";

        foreach (var table in tables)
        {
            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("schemaName", table.SchemaName);
            cmd.Parameters.AddWithValue("tableName", table.TableName);

            await using var reader = await cmd.ExecuteReaderAsync(ct);
            var primaryKey = new PrimaryKeySchema();
            var hasPk = false;

            while (await reader.ReadAsync(ct))
            {
                hasPk = true;
                primaryKey.ConstraintName = reader.GetString(2);
                primaryKey.ColumnNames.Add(reader.GetString(3));
            }

            if (hasPk)
            {
                table.PrimaryKeys.Add(primaryKey);
            }
        }
    }

    private async Task ExtractForeignKeysAsync(NpgsqlConnection conn, List<TableSchema> tables, CancellationToken ct)
    {
        var sql = @"
            SELECT
                tc.table_schema AS ""SchemaName"",
                tc.table_name AS ""TableName"",
                tc.constraint_name AS ""ConstraintName"",
                kcu.column_name AS ""ColumnName"",
                kcu.ordinal_position AS ""OrdinalPosition"",
                ccu.table_schema AS ""ReferencedSchemaName"",
                ccu.table_name AS ""ReferencedTableName"",
                ccu.column_name AS ""ReferencedColumnName"",
                rc.delete_rule AS ""OnDeleteAction"",
                rc.update_rule AS ""OnUpdateAction""
            FROM information_schema.table_constraints tc
            INNER JOIN information_schema.key_column_usage kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
                AND tc.table_name = kcu.table_name
            INNER JOIN information_schema.constraint_column_usage ccu
                ON ccu.constraint_name = tc.constraint_name
                AND ccu.table_schema = tc.table_schema
            LEFT JOIN information_schema.referential_constraints rc
                ON rc.constraint_name = tc.constraint_name
                AND rc.constraint_schema = tc.table_schema
            WHERE tc.constraint_type = 'FOREIGN KEY'
                AND tc.table_schema = @schemaName
                AND tc.table_name = @tableName
            ORDER BY tc.table_schema, tc.table_name, kcu.ordinal_position";

        var foreignKeys = new Dictionary<string, ForeignKeySchema>();

        foreach (var table in tables)
        {
            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("schemaName", table.SchemaName);
            cmd.Parameters.AddWithValue("tableName", table.TableName);

            await using var reader = await cmd.ExecuteReaderAsync(ct);
            while (await reader.ReadAsync(ct))
            {
                var constraintName = reader.GetString(2);

                if (!foreignKeys.ContainsKey(constraintName))
                {
                    foreignKeys[constraintName] = new ForeignKeySchema
                    {
                        ConstraintName = constraintName,
                        ReferencedSchemaName = reader.GetString(5),
                        ReferencedTable = reader.GetString(6),
                        OnDeleteAction = reader.GetString(8),
                        OnUpdateAction = reader.GetString(9)
                    };
                }

                foreignKeys[constraintName].ColumnNames.Add(reader.GetString(3));
                foreignKeys[constraintName].ReferencedColumns.Add(reader.GetString(7));
            }

            foreach (var fk in foreignKeys.Values)
            {
                table.ForeignKeys.Add(fk);
            }
            foreignKeys.Clear();
        }
    }

    private async Task ExtractUniqueConstraintsAsync(NpgsqlConnection conn, List<TableSchema> tables, CancellationToken ct)
    {
        var sql = @"
            SELECT
                tc.table_schema AS ""SchemaName"",
                tc.table_name AS ""TableName"",
                tc.constraint_name AS ""ConstraintName"",
                kcu.column_name AS ""ColumnName"",
                kcu.ordinal_position AS ""OrdinalPosition""
            FROM information_schema.table_constraints tc
            INNER JOIN information_schema.key_column_usage kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
                AND tc.table_name = kcu.table_name
            WHERE tc.constraint_type = 'UNIQUE'
                AND tc.table_schema = @schemaName
                AND tc.table_name = @tableName
            ORDER BY tc.table_schema, tc.table_name, kcu.ordinal_position";

        foreach (var table in tables)
        {
            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("schemaName", table.SchemaName);
            cmd.Parameters.AddWithValue("tableName", table.TableName);

            await using var reader = await cmd.ExecuteReaderAsync(ct);
            var uniqueConstraints = new Dictionary<string, UniqueConstraintSchema>();

            while (await reader.ReadAsync(ct))
            {
                var constraintName = reader.GetString(2);

                if (!uniqueConstraints.ContainsKey(constraintName))
                {
                    uniqueConstraints[constraintName] = new UniqueConstraintSchema
                    {
                        ConstraintName = constraintName
                    };
                }

                uniqueConstraints[constraintName].ColumnNames.Add(reader.GetString(3));
            }

            foreach (var uc in uniqueConstraints.Values)
            {
                table.UniqueConstraints.Add(uc);
            }
        }
    }

    private async Task ExtractCheckConstraintsAsync(NpgsqlConnection conn, List<TableSchema> tables, CancellationToken ct)
    {
        var sql = @"
            SELECT
                con.conname AS ""ConstraintName"",
                n.nspname AS ""SchemaName"",
                t.relname AS ""TableName"",
                pg_get_constraintdef(con.oid) AS ""ConstraintDefinition""
            FROM pg_catalog.pg_constraint con
            JOIN pg_catalog.pg_class t ON con.conrelid = t.oid
            JOIN pg_catalog.pg_namespace n ON t.relnamespace = n.oid
            WHERE con.contype = 'c'
                AND n.nspname = @schemaName
                AND t.relname = @tableName
            ORDER BY n.nspname, t.relname, con.conname";

        foreach (var table in tables)
        {
            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("schemaName", table.SchemaName);
            cmd.Parameters.AddWithValue("tableName", table.TableName);

            await using var reader = await cmd.ExecuteReaderAsync(ct);
            while (await reader.ReadAsync(ct))
            {
                table.CheckConstraints.Add(new CheckConstraintSchema
                {
                    ConstraintName = reader.GetString(0),
                    ConstraintDefinition = reader.GetString(3)
                });
            }
        }
    }

    private async Task ExtractIndexesAsync(NpgsqlConnection conn, List<TableSchema> tables, CancellationToken ct)
    {
        var sql = @"
            SELECT
                n.nspname AS ""SchemaName"",
                t.relname AS ""TableName"",
                i.relname AS ""IndexName"",
                am.amname AS ""IndexType"",
                idx.indisunique AS ""IsUnique"",
                idx.indisprimary AS ""IsPrimary"",
                a.attname AS ""ColumnName"",
                obj_description(i.oid, 'pg_class') AS ""IndexComment"",
                idx.indpred IS NOT NULL AS ""IsPartial"",
                pg_get_expr(idx.indpred, idx.indrelid) AS ""PartialPredicate""
            FROM pg_index idx
            JOIN pg_class t ON idx.indrelid = t.oid
            JOIN pg_class i ON idx.indexrelid = i.oid
            JOIN pg_namespace n ON t.relnamespace = n.oid
            JOIN pg_am am ON i.relam = am.oid
            JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(idx.indkey)
            WHERE n.nspname = @schemaName
                AND t.relname = @tableName
            ORDER BY n.nspname, t.relname, i.relname, array_position(idx.indkey, a.attnum)";

        foreach (var table in tables)
        {
            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("schemaName", table.SchemaName);
            cmd.Parameters.AddWithValue("tableName", table.TableName);

            await using var reader = await cmd.ExecuteReaderAsync(ct);
            var indexes = new Dictionary<string, IndexSchema>();

            while (await reader.ReadAsync(ct))
            {
                var indexName = reader.GetString(2);

                if (!indexes.ContainsKey(indexName))
                {
                    indexes[indexName] = new IndexSchema
                    {
                        IndexName = indexName,
                        IndexType = reader.GetString(3),
                        IsUnique = reader.GetBoolean(4),
                        IsPrimary = reader.GetBoolean(5),
                        IsUniqueConstraint = false,
                        IndexComment = reader.IsDBNull(7) ? null : reader.GetString(7),
                        IsPartial = reader.GetBoolean(8),
                        PartialPredicate = reader.IsDBNull(9) ? null : reader.GetString(9)
                    };
                }

                indexes[indexName].Columns.Add(new IndexColumn
                {
                    ColumnName = reader.GetString(6),
                    Direction = "ASC"
                });
            }

            foreach (var index in indexes.Values)
            {
                if (!index.IsPrimary)
                {
                    table.Indexes.Add(index);
                }
            }
        }
    }
}
