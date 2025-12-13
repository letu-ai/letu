import React, { useEffect, useState, useMemo, useCallback, useRef } from "react";
import { Tabs, TreeSelect, Select, Typography, Spin } from "antd";
import { UserOutlined, TeamOutlined, ApartmentOutlined, IdcardOutlined, GlobalOutlined } from "@ant-design/icons";
import type {
    RecipientSelectorProps,
    RecipientValue,
    SendScopeType,
    DepartmentTreeNode,
    RoleOption,
    PositionOption,
    SelectOption
} from "./types";
import { SendScopeType as SendScopeTypeEnum } from "./types";
import { getDepartmentTree, getAllRoles, getAllPositions, getUserOptions, getUsersByIds } from "./service";
import { debounce } from "lodash";

const { Text } = Typography;

const RecipientSelector: React.FC<RecipientSelectorProps> = ({
    value,
    onChange,
    disabled = false,
}) => {
    const [activeTab, setActiveTab] = useState<string>(SendScopeTypeEnum.ALL_USERS.toString());
    const [loading, setLoading] = useState(false);
    const [usersLoading, setUsersLoading] = useState(false);

    // 数据状态
    const [departments, setDepartments] = useState<DepartmentTreeNode[]>([]);
    const [roles, setRoles] = useState<RoleOption[]>([]);
    const [positions, setPositions] = useState<PositionOption[]>([]);
    const [users, setUsers] = useState<SelectOption[]>([]);

    // 缓存静态数据
    const [dataCache, setDataCache] = useState<{
        departments?: DepartmentTreeNode[];
        roles?: RoleOption[];
        positions?: PositionOption[];
    }>({});

    // 选择状态
    const [selectedUsers, setSelectedUsers] = useState<string[]>([]);
    const [selectedRoles, setSelectedRoles] = useState<string[]>([]);
    const [selectedDepartments, setSelectedDepartments] = useState<string[]>([]);
    const [selectedPositions, setSelectedPositions] = useState<string[]>([]);

    // 用于跟踪是否正在同步外部值，避免触发onChange
    const isSyncingFromExternalValue = useRef(false);

    // 不再在初始化时加载基础数据，改为按需加载

    // 按需加载数据：根据当前选中的标签页加载对应数据（除了指定用户）
    useEffect(() => {
        const loadDataForTab = async () => {
            switch (parseInt(activeTab)) {
                case SendScopeTypeEnum.SPECIFIC_USERS:
                    // 指定用户不自动加载，除非已有选中的用户
                    if (selectedUsers.length === 0) {
                        setUsers([]);
                    }
                    break;
                case SendScopeTypeEnum.BY_ROLE:
                    // 加载角色数据
                    if (dataCache.roles) {
                        setRoles(dataCache.roles);
                    } else {
                        await loadRoles();
                    }
                    break;
                case SendScopeTypeEnum.BY_DEPARTMENT:
                    // 加载部门数据
                    if (dataCache.departments) {
                        setDepartments(dataCache.departments);
                    } else {
                        await loadDepartments();
                    }
                    break;
                case SendScopeTypeEnum.BY_POSITION:
                    // 加载职位数据
                    if (dataCache.positions) {
                        setPositions(dataCache.positions);
                    } else {
                        await loadPositions();
                    }
                    break;
                case SendScopeTypeEnum.ALL_USERS:
                    // 全体用户不需要加载额外数据
                    break;
            }
        };

        loadDataForTab();
    }, [activeTab, dataCache.departments, dataCache.positions, dataCache.roles, selectedUsers.length]);

    // 用于跟踪已经加载过的用户IDs，避免重复请求
    const loadedUserIdsRef = useRef<Set<string>>(new Set());

    const updateValue = useCallback(() => {
        const sendScopeType = parseInt(activeTab) as SendScopeType;
        let sendScopeValue: string | undefined;

        switch (sendScopeType) {
            case SendScopeTypeEnum.SPECIFIC_USERS:
                sendScopeValue = selectedUsers.join(",");
                break;
            case SendScopeTypeEnum.BY_ROLE:
                sendScopeValue = selectedRoles.join(",");
                break;
            case SendScopeTypeEnum.BY_DEPARTMENT:
                sendScopeValue = selectedDepartments.join(",");
                break;
            case SendScopeTypeEnum.BY_POSITION:
                sendScopeValue = selectedPositions.join(",");
                break;
            case SendScopeTypeEnum.ALL_USERS:
                sendScopeValue = undefined;
                break;
        }

        // 检查是否与当前值相同，避免不必要的更新
        const newValue: RecipientValue = {
            sendScopeType,
            sendScopeValue,
        };

        // 只有当值真正改变时才触发onChange
        if (!value ||
            value.sendScopeType !== newValue.sendScopeType ||
            value.sendScopeValue !== newValue.sendScopeValue) {
            onChange?.(newValue);
        }
    }, [activeTab, selectedUsers, selectedRoles, selectedDepartments, selectedPositions, onChange, value]);

    // 同步外部value到内部状态
    useEffect(() => {
        if (value) {
            isSyncingFromExternalValue.current = true;

            setActiveTab(value.sendScopeType.toString());

            const scopeValues = value.sendScopeValue ? value.sendScopeValue.split(",") : [];

            switch (value.sendScopeType) {
                case SendScopeTypeEnum.SPECIFIC_USERS:
                    setSelectedUsers(scopeValues);
                    // 对于指定用户，需要预加载用户数据以显示姓名
                    // 只加载未加载过的用户
                    if (scopeValues.length > 0) {
                        const unloadedUserIds = scopeValues.filter(userId =>
                            !loadedUserIdsRef.current.has(userId)
                        );
                        if (unloadedUserIds.length > 0) {
                            loadUsersByIds(unloadedUserIds);
                            // 标记这些用户ID已经请求过
                            unloadedUserIds.forEach(id => loadedUserIdsRef.current.add(id));
                        }
                    }
                    break;
                case SendScopeTypeEnum.BY_ROLE:
                    setSelectedRoles(scopeValues);
                    break;
                case SendScopeTypeEnum.BY_DEPARTMENT:
                    setSelectedDepartments(scopeValues);
                    break;
                case SendScopeTypeEnum.BY_POSITION:
                    setSelectedPositions(scopeValues);
                    break;
            }

            // 使用 setTimeout 确保状态更新完成后再重置标志
            setTimeout(() => {
                isSyncingFromExternalValue.current = false;
            }, 0);
        }
    }, [value]);

    // 当选择变化时，触发onChange
    useEffect(() => {
        // 如果正在同步外部值，则不触发onChange避免循环更新
        if (!isSyncingFromExternalValue.current) {
            updateValue();
        }
    }, [activeTab, selectedUsers, selectedRoles, selectedDepartments, selectedPositions, updateValue]);

    // 独立的数据加载函数
    const loadDepartments = async () => {
        try {
            setLoading(true);
            const departmentData = await getDepartmentTree();
            setDepartments(departmentData);
            setDataCache(prev => ({ ...prev, departments: departmentData }));
        } catch (error) {
            console.error("Failed to load departments:", error);
        } finally {
            setLoading(false);
        }
    };

    const loadRoles = async () => {
        try {
            setLoading(true);
            const roleData = await getAllRoles();
            setRoles(roleData);
            setDataCache(prev => ({ ...prev, roles: roleData }));
        } catch (error) {
            console.error("Failed to load roles:", error);
        } finally {
            setLoading(false);
        }
    };

    const loadPositions = async () => {
        try {
            setLoading(true);
            const positionData = await getAllPositions();
            setPositions(positionData);
            setDataCache(prev => ({ ...prev, positions: positionData }));
        } catch (error) {
            console.error("Failed to load positions:", error);
        } finally {
            setLoading(false);
        }
    };

    const loadUsers = useCallback(async (keyword?: string) => {
        try {
            setUsersLoading(true);
            const response = await getUserOptions(keyword);
            setUsers(response || []);
        } catch (error) {
            console.error("Failed to load users:", error);
            setUsers([]);
        } finally {
            setUsersLoading(false);
        }
    }, []);

    const loadUsersByIds = async (userIds: string[]) => {
        try {
            setUsersLoading(true);
            const response = await getUsersByIds(userIds);
            // 合并新数据而不是替换，保持已有的用户数据
            setUsers(prev => {
                const existingMap = new Map(prev.map(emp => [emp.value, emp]));
                response?.forEach(emp => {
                    existingMap.set(emp.value, emp);
                });
                return Array.from(existingMap.values());
            });
        } catch (error) {
            console.error("Failed to load users by ids:", error);
        } finally {
            setUsersLoading(false);
        }
    };

    // 防抖搜索用户
    const debouncedSearchUsers = useCallback(
        debounce((keyword: string) => {
            // 只在有关键字时才请求
            if (keyword && keyword.trim()) {
                loadUsers(keyword.trim());
            } else {
                setUsers([]);
            }
        }, 300), []);

    // 转换部门数据为TreeSelect格式，只选择部门节点（type=1）
    const departmentTreeData = useMemo(() => {
        const convertToTreeData = (nodes: DepartmentTreeNode[]): any[] => {
            return nodes
                ?.filter(node => node.type === 1) // 只要部门节点
                ?.map((node) => ({
                    title: node.label,
                    value: node.value,
                    key: node.value,
                    disabled: false, // 强制启用所有部门节点
                    children: node.children ? convertToTreeData(node.children) : undefined,
                })) || [];
        };
        return convertToTreeData(departments);
    }, [departments]);

    // 转换职位数据为TreeSelect格式
    const positionTreeData = useMemo(() => {
        const convertPositionToTreeData = (positions: PositionOption[]): any[] => {
            return positions?.map((position) => ({
                title: position.title || position.key || position.label,
                value: position.value,
                key: position.value,
                disabled: false,
            })) || [];
        };
        return convertPositionToTreeData(positions);
    }, [positions]);

    const tabItems = [
        {
            key: SendScopeTypeEnum.SPECIFIC_USERS.toString(),
            label: (
                <span>
                    <UserOutlined /> 指定用户
                </span>
            ),
            children: (
                <Select
                    mode="multiple"
                    placeholder="请输入姓名搜索用户"
                    style={{ width: "100%" }}
                    disabled={disabled}
                    showSearch
                    loading={usersLoading}
                    filterOption={false}
                    onSearch={debouncedSearchUsers}
                    notFoundContent={usersLoading ? <Spin size="small" /> : ((users?.length || 0) === 0 ? "请输入姓名关键字搜索用户" : "未找到匹配的用户")}
                    value={selectedUsers}
                    onChange={setSelectedUsers}
                    options={users}
                />
            ),
        },
        {
            key: SendScopeTypeEnum.BY_ROLE.toString(),
            label: (
                <span>
                    <TeamOutlined /> 按角色
                </span>
            ),
            children: (
                <Select
                    mode="multiple"
                    placeholder="请选择角色"
                    style={{ width: "100%" }}
                    disabled={disabled || loading}
                    loading={loading && parseInt(activeTab) === SendScopeTypeEnum.BY_ROLE}
                    value={selectedRoles}
                    onChange={setSelectedRoles}
                    options={roles.map((role) => ({
                        label: role.label,
                        value: role.value,
                    }))}
                />
            ),
        },
        {
            key: SendScopeTypeEnum.BY_DEPARTMENT.toString(),
            label: (
                <span>
                    <ApartmentOutlined /> 按部门
                </span>
            ),
            children: (
                <TreeSelect
                    multiple
                    placeholder="请选择部门"
                    style={{ width: "100%" }}
                    disabled={disabled || loading}
                    loading={loading && parseInt(activeTab) === SendScopeTypeEnum.BY_DEPARTMENT}
                    treeCheckable
                    showCheckedStrategy={TreeSelect.SHOW_PARENT}
                    value={selectedDepartments}
                    onChange={setSelectedDepartments}
                    treeData={departmentTreeData}
                />
            ),
        },
        {
            key: SendScopeTypeEnum.BY_POSITION.toString(),
            label: (
                <span>
                    <IdcardOutlined /> 按职位
                </span>
            ),
            children: (
                <TreeSelect
                    multiple
                    placeholder="请选择职位"
                    style={{ width: "100%" }}
                    disabled={disabled || loading}
                    loading={loading && parseInt(activeTab) === SendScopeTypeEnum.BY_POSITION}
                    treeCheckable
                    showCheckedStrategy={TreeSelect.SHOW_PARENT}
                    value={selectedPositions}
                    onChange={setSelectedPositions}
                    treeData={positionTreeData}
                />
            ),
        },
        {
            key: SendScopeTypeEnum.ALL_USERS.toString(),
            label: (
                <span>
                    <GlobalOutlined /> 全体用户
                </span>
            ),
            children: (
                <div style={{ textAlign: "center", padding: "20px" }}>
                    <GlobalOutlined style={{ fontSize: "24px", color: "#1890ff" }} />
                    <div style={{ marginTop: "8px" }}>
                        <Text type="secondary">将通知发送给所有员工</Text>
                    </div>
                </div>
            ),
        },
    ];

    return (
        <div>
            <Tabs
                activeKey={activeTab}
                onChange={setActiveTab}
                items={tabItems}
                size="small"
            />
        </div>
    );
};

export default RecipientSelector;