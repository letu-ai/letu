--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_access_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_access_log (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    path character varying(255),
    method character varying(255),
    ip character varying(32),
    request_time timestamp(6) without time zone NOT NULL,
    response_time timestamp(6) without time zone,
    duration bigint,
    user_id uuid,
    user_name character varying(32),
    request_body text,
    response_body text,
    browser character varying(512),
    query_string character varying(2048),
    trace_id character varying(50),
    operate_type integer[],
    operate_name character varying(32),
    tenant_id uuid
);


ALTER TABLE public.api_access_log OWNER TO postgres;

--
-- Name: exception_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exception_log (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    exception_type character varying(255),
    message text,
    stack_trace text,
    inner_exception text,
    request_path character varying(255),
    request_method character varying(255),
    user_id uuid,
    user_name character varying(255),
    ip character varying(32),
    browser character varying(512),
    trace_id character varying(255),
    is_handled boolean NOT NULL,
    handled_time timestamp(6) without time zone,
    handled_by character varying(255),
    tenant_id uuid
);


ALTER TABLE public.exception_log OWNER TO postgres;

--
-- Name: log_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_record (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    type character varying(255) NOT NULL,
    sub_type character varying(255) NOT NULL,
    biz_no character varying(255) NOT NULL,
    content character varying(255) NOT NULL,
    browser character varying(512),
    ip character varying(32),
    trace_id character varying(255),
    tenant_id uuid,
    user_id uuid,
    user_name character varying(255)
);


ALTER TABLE public.log_record OWNER TO postgres;

--
-- Name: org_employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_employee (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp(6) without time zone,
    code character varying(64) NOT NULL,
    name character varying(64) NOT NULL,
    sex integer NOT NULL,
    id_no character varying(32),
    front_id_no_url character varying(512),
    back_id_no_url character varying(512),
    birthday timestamp(6) without time zone,
    address character varying(512),
    email character varying(64),
    in_time timestamp(6) without time zone NOT NULL,
    out_time timestamp(6) without time zone,
    status integer NOT NULL,
    user_id uuid,
    dept_id uuid,
    position_id uuid,
    tenant_id uuid
);


ALTER TABLE public.org_employee OWNER TO postgres;

--
-- Name: TABLE org_employee; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.org_employee IS '员工表';


--
-- Name: COLUMN org_employee.code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.code IS '工号';


--
-- Name: COLUMN org_employee.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.name IS '姓名';


--
-- Name: COLUMN org_employee.sex; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.sex IS '性别';


--
-- Name: COLUMN org_employee.id_no; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.id_no IS '身份证';


--
-- Name: COLUMN org_employee.front_id_no_url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.front_id_no_url IS '身份证正面';


--
-- Name: COLUMN org_employee.back_id_no_url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.back_id_no_url IS '身份证背面';


--
-- Name: COLUMN org_employee.birthday; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.birthday IS '生日';


--
-- Name: COLUMN org_employee.address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.address IS '现住址';


--
-- Name: COLUMN org_employee.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.email IS '邮箱';


--
-- Name: COLUMN org_employee.in_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.in_time IS '入职时间';


--
-- Name: COLUMN org_employee.out_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.out_time IS '离职时间';


--
-- Name: COLUMN org_employee.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.status IS '状态 1正常2离职';


--
-- Name: COLUMN org_employee.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.user_id IS '关联用户ID';


--
-- Name: COLUMN org_employee.dept_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.dept_id IS '部门ID';


--
-- Name: COLUMN org_employee.position_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.position_id IS '职位ID';


--
-- Name: COLUMN org_employee.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.tenant_id IS '租户ID';


--
-- Name: org_position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_position (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp(6) without time zone,
    code character varying(32) NOT NULL,
    name character varying(64) NOT NULL,
    level integer NOT NULL,
    status integer NOT NULL,
    description character varying(512),
    group_id uuid,
    tenant_id uuid
);


ALTER TABLE public.org_position OWNER TO postgres;

--
-- Name: TABLE org_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.org_position IS '职位表';


--
-- Name: COLUMN org_position.code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.code IS '职位编号';


--
-- Name: COLUMN org_position.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.name IS '职位名称';


--
-- Name: COLUMN org_position.level; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.level IS '职级';


--
-- Name: COLUMN org_position.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.status IS '状态：1正常2停用';


--
-- Name: COLUMN org_position.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.description IS '描述';


--
-- Name: COLUMN org_position.group_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.group_id IS '职位分组';


--
-- Name: COLUMN org_position.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position.tenant_id IS '租户ID';


--
-- Name: org_position_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_position_group (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    group_name character varying(64) NOT NULL,
    remark character varying(512),
    parent_id uuid,
    parent_ids character varying(1024),
    sort integer NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.org_position_group OWNER TO postgres;

--
-- Name: TABLE org_position_group; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.org_position_group IS '职位分组';


--
-- Name: COLUMN org_position_group.group_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position_group.group_name IS '分组名';


--
-- Name: COLUMN org_position_group.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position_group.remark IS '备注';


--
-- Name: COLUMN org_position_group.parent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position_group.parent_id IS '父ID';


--
-- Name: COLUMN org_position_group.parent_ids; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position_group.parent_ids IS '层级父ID';


--
-- Name: COLUMN org_position_group.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position_group.sort IS '排序值';


--
-- Name: COLUMN org_position_group.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_position_group.tenant_id IS '租户ID';


--
-- Name: scheduled_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduled_tasks (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    task_key character varying(100) NOT NULL,
    task_description character varying(512),
    cron_expression character varying(50) NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE public.scheduled_tasks OWNER TO postgres;

--
-- Name: sys_audit_log_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_audit_log_actions (
    id uuid NOT NULL,
    tenant_id uuid,
    audit_log_id uuid NOT NULL,
    service_name character varying(256),
    method_name character varying(128),
    parameters character varying(2000),
    execution_time timestamp without time zone NOT NULL,
    execution_duration integer NOT NULL,
    extra_properties character varying(2000)
);


ALTER TABLE public.sys_audit_log_actions OWNER TO postgres;

--
-- Name: sys_audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_audit_logs (
    id uuid NOT NULL,
    application_name character varying(96),
    user_id uuid,
    user_name character varying(256),
    tenant_id uuid,
    tenant_name character varying(64),
    impersonator_user_id uuid,
    impersonator_tenant_id uuid,
    impersonator_tenant_name character varying(64),
    impersonator_user_name character varying(256),
    execution_time timestamp without time zone NOT NULL,
    execution_duration integer NOT NULL,
    client_ip_address character varying(64),
    client_name character varying(128),
    client_id character varying(64),
    correlation_id character varying(64),
    browser_info character varying(512),
    http_method character varying(16),
    url character varying(256),
    http_status_code integer,
    exceptions character varying(255),
    comments character varying(256),
    extra_properties character varying(2000),
    concurrency_stamp character varying(40)
);


ALTER TABLE public.sys_audit_logs OWNER TO postgres;

--
-- Name: sys_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_config (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    name character varying(256) NOT NULL,
    key character varying(128) NOT NULL,
    value character varying(1024) NOT NULL,
    group_key character varying(64),
    remark character varying(512),
    tenant_id uuid
);


ALTER TABLE public.sys_config OWNER TO postgres;

--
-- Name: TABLE sys_config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_config IS '系统配置';


--
-- Name: COLUMN sys_config.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_config.name IS '配置名称';


--
-- Name: COLUMN sys_config.key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_config.key IS '配置键名';


--
-- Name: COLUMN sys_config.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_config.value IS '配置键值';


--
-- Name: COLUMN sys_config.group_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_config.group_key IS '组别';


--
-- Name: COLUMN sys_config.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_config.remark IS '备注';


--
-- Name: COLUMN sys_config.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_config.tenant_id IS '租户ID';


--
-- Name: sys_data_dictionary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_data_dictionary (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    display_name character varying(128) NOT NULL,
    name character varying(128) NOT NULL,
    remark character varying(512),
    is_enabled boolean NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_data_dictionary OWNER TO postgres;

--
-- Name: TABLE sys_data_dictionary; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_data_dictionary IS '字典类型表';


--
-- Name: COLUMN sys_data_dictionary.display_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary.display_name IS '字典名称';


--
-- Name: COLUMN sys_data_dictionary.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary.name IS '字典名称';


--
-- Name: COLUMN sys_data_dictionary.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary.remark IS '备注';


--
-- Name: COLUMN sys_data_dictionary.is_enabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary.is_enabled IS '是否开启';


--
-- Name: COLUMN sys_data_dictionary.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary.tenant_id IS '租户ID';


--
-- Name: sys_data_dictionary_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_data_dictionary_item (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    value character varying(256) NOT NULL,
    label character varying(32),
    dictionary_name character varying(128) NOT NULL,
    remark character varying(512),
    sort integer NOT NULL,
    is_enabled boolean NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_data_dictionary_item OWNER TO postgres;

--
-- Name: TABLE sys_data_dictionary_item; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_data_dictionary_item IS '字典数据表';


--
-- Name: COLUMN sys_data_dictionary_item.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.value IS '字典值';


--
-- Name: COLUMN sys_data_dictionary_item.label; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.label IS '显示文本';


--
-- Name: COLUMN sys_data_dictionary_item.dictionary_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.dictionary_name IS '所属字典名称';


--
-- Name: COLUMN sys_data_dictionary_item.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.remark IS '备注';


--
-- Name: COLUMN sys_data_dictionary_item.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.sort IS '排序值';


--
-- Name: COLUMN sys_data_dictionary_item.is_enabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.is_enabled IS '是否开启';


--
-- Name: COLUMN sys_data_dictionary_item.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_data_dictionary_item.tenant_id IS '租户ID';


--
-- Name: sys_dept; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_dept (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp(6) without time zone,
    code character varying(32) NOT NULL,
    name character varying(64) NOT NULL,
    sort integer NOT NULL,
    description character varying(512),
    status integer NOT NULL,
    curator_id uuid,
    email character varying(64),
    phone character varying(64),
    parent_id uuid,
    parent_ids character varying(1024),
    layer integer NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_dept OWNER TO postgres;

--
-- Name: TABLE sys_dept; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_dept IS '部门表';


--
-- Name: COLUMN sys_dept.code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.code IS '部门编号';


--
-- Name: COLUMN sys_dept.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.name IS '部门名称';


--
-- Name: COLUMN sys_dept.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.sort IS '排序';


--
-- Name: COLUMN sys_dept.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.description IS '描述';


--
-- Name: COLUMN sys_dept.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.status IS '状态：1正常2停用';


--
-- Name: COLUMN sys_dept.curator_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.curator_id IS '负责人';


--
-- Name: COLUMN sys_dept.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.email IS '邮箱';


--
-- Name: COLUMN sys_dept.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.phone IS '电话';


--
-- Name: COLUMN sys_dept.parent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.parent_id IS '父ID';


--
-- Name: COLUMN sys_dept.parent_ids; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.parent_ids IS '层级父ID';


--
-- Name: COLUMN sys_dept.layer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.layer IS '层级';


--
-- Name: COLUMN sys_dept.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dept.tenant_id IS '租户ID';


--
-- Name: sys_edition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_edition (
    id uuid NOT NULL,
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp without time zone,
    name character varying(64) NOT NULL,
    description character varying(512)
);


ALTER TABLE public.sys_edition OWNER TO postgres;

--
-- Name: TABLE sys_edition; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_edition IS '版本表';


--
-- Name: COLUMN sys_edition.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_edition.name IS '版本名称';


--
-- Name: COLUMN sys_edition.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_edition.description IS '描述';


--
-- Name: sys_entity_changes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_entity_changes (
    id uuid NOT NULL,
    tenant_id uuid,
    audit_log_id uuid NOT NULL,
    change_time timestamp without time zone NOT NULL,
    change_type integer NOT NULL,
    entity_id character varying(128),
    entity_type_full_name character varying(128) NOT NULL,
    extra_properties character varying(2000),
    entity_tenant_id uuid
);


ALTER TABLE public.sys_entity_changes OWNER TO postgres;

--
-- Name: sys_feature_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_feature_groups (
    id uuid NOT NULL,
    name character varying(128) NOT NULL,
    display_name character varying(256) NOT NULL
);


ALTER TABLE public.sys_feature_groups OWNER TO postgres;

--
-- Name: sys_feature_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_feature_values (
    id uuid NOT NULL,
    name character varying(128) NOT NULL,
    value character varying(128) NOT NULL,
    provider_name character varying(64),
    provider_key character varying(64)
);


ALTER TABLE public.sys_feature_values OWNER TO postgres;

--
-- Name: sys_features; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_features (
    id uuid NOT NULL,
    group_name character varying(128) NOT NULL,
    name character varying(128) NOT NULL,
    parent_name character varying(128),
    display_name character varying(256) NOT NULL,
    description character varying(256),
    default_value character varying(256),
    is_visible_to_clients boolean NOT NULL,
    is_available_to_host boolean NOT NULL,
    allowed_providers character varying(256),
    value_type character varying(2048)
);


ALTER TABLE public.sys_features OWNER TO postgres;

--
-- Name: sys_integration_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_integration_settings (
    id uuid NOT NULL,
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    tenant_id uuid,
    name character varying(255),
    is_enabled boolean NOT NULL,
    "values" jsonb
);


ALTER TABLE public.sys_integration_settings OWNER TO postgres;

--
-- Name: sys_login_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_login_log (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    user_name character varying(32) NOT NULL,
    ip character varying(32),
    address character varying(256),
    os character varying(64),
    browser character varying(512),
    operation_msg character varying(128),
    is_success boolean NOT NULL,
    session_id character varying(36),
    tenant_id uuid
);


ALTER TABLE public.sys_login_log OWNER TO postgres;

--
-- Name: TABLE sys_login_log; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_login_log IS '登录日志';


--
-- Name: COLUMN sys_login_log.user_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.user_name IS '账号';


--
-- Name: COLUMN sys_login_log.ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.ip IS 'IP';


--
-- Name: COLUMN sys_login_log.address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.address IS '登录地址';


--
-- Name: COLUMN sys_login_log.os; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.os IS '系统';


--
-- Name: COLUMN sys_login_log.browser; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.browser IS '浏览器';


--
-- Name: COLUMN sys_login_log.operation_msg; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.operation_msg IS '操作信息';


--
-- Name: COLUMN sys_login_log.is_success; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.is_success IS '是否成功';


--
-- Name: COLUMN sys_login_log.session_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.session_id IS '会话ID';


--
-- Name: COLUMN sys_login_log.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_login_log.tenant_id IS '租户ID';


--
-- Name: sys_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu (
    id uuid NOT NULL,
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    title character varying(32) NOT NULL,
    icon character varying(64),
    path character varying(256),
    application_name character varying(32) NOT NULL,
    menu_type integer NOT NULL,
    parent_id uuid,
    sort integer NOT NULL,
    display boolean NOT NULL,
    tenant_id uuid,
    is_external boolean NOT NULL
);


ALTER TABLE public.sys_menu OWNER TO postgres;

--
-- Name: TABLE sys_menu; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_menu IS '菜单表';


--
-- Name: COLUMN sys_menu.title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.title IS '显示标题/名称';


--
-- Name: COLUMN sys_menu.icon; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.icon IS '图标';


--
-- Name: COLUMN sys_menu.path; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.path IS '路由/地址';


--
-- Name: COLUMN sys_menu.menu_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.menu_type IS '功能类型';


--
-- Name: COLUMN sys_menu.parent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.parent_id IS '父级ID';


--
-- Name: COLUMN sys_menu.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.sort IS '排序';


--
-- Name: COLUMN sys_menu.display; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.display IS '是否隐藏';


--
-- Name: COLUMN sys_menu.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.tenant_id IS '租户ID';


--
-- Name: COLUMN sys_menu.is_external; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.is_external IS '是否外链';


--
-- Name: sys_menu_feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu_feature (
    id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    feature character varying(255) NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_menu_feature OWNER TO postgres;

--
-- Name: TABLE sys_menu_feature; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_menu_feature IS '角色菜单表';


--
-- Name: COLUMN sys_menu_feature.menu_item_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu_feature.menu_item_id IS '菜单ID';


--
-- Name: COLUMN sys_menu_feature.feature; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu_feature.feature IS '角色ID';


--
-- Name: COLUMN sys_menu_feature.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu_feature.tenant_id IS '租户ID';


--
-- Name: sys_menu_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu_permission (
    id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    permission character varying(255) NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_menu_permission OWNER TO postgres;

--
-- Name: TABLE sys_menu_permission; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_menu_permission IS '角色菜单表';


--
-- Name: COLUMN sys_menu_permission.menu_item_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu_permission.menu_item_id IS '菜单ID';


--
-- Name: COLUMN sys_menu_permission.permission; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu_permission.permission IS '角色ID';


--
-- Name: COLUMN sys_menu_permission.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu_permission.tenant_id IS '租户ID';


--
-- Name: sys_notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_notification (
    id uuid NOT NULL,
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    title character varying(128) NOT NULL,
    content character varying(2000),
    notification_type integer NOT NULL,
    send_scope_type integer NOT NULL,
    send_scope_value character varying(500),
    status integer NOT NULL,
    publish_time timestamp without time zone,
    expire_time timestamp without time zone,
    priority integer NOT NULL,
    employee_id uuid NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_notification OWNER TO postgres;

--
-- Name: COLUMN sys_notification.title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.title IS '通知标题';


--
-- Name: COLUMN sys_notification.content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.content IS '通知内容';


--
-- Name: COLUMN sys_notification.notification_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.notification_type IS '通知类型：1=系统公告,2=任务提醒,3=审批通知,4=其他';


--
-- Name: COLUMN sys_notification.send_scope_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.send_scope_type IS '发送范围类型：1=指定用户,2=按角色,3=按部门,4=按职位,5=全体员工';


--
-- Name: COLUMN sys_notification.send_scope_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.send_scope_value IS '发送范围值（角色ID、部门ID、职位ID等，多个用逗号分隔）';


--
-- Name: COLUMN sys_notification.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.status IS '通知状态：1=草稿,2=已发布,3=已撤回';


--
-- Name: COLUMN sys_notification.publish_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.publish_time IS '发布时间';


--
-- Name: COLUMN sys_notification.expire_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.expire_time IS '过期时间';


--
-- Name: COLUMN sys_notification.priority; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.priority IS '优先级：1=普通,2=重要,3=紧急';


--
-- Name: COLUMN sys_notification.employee_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.employee_id IS '发送人ID';


--
-- Name: COLUMN sys_notification.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.tenant_id IS '租户ID';


--
-- Name: sys_organization_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_organization_unit (
    id uuid NOT NULL,
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp without time zone,
    parent_id uuid,
    tenant_id uuid,
    code character varying(32) NOT NULL,
    name character varying(64) NOT NULL,
    sort integer NOT NULL,
    category integer,
    type integer,
    region_code character varying(12),
    street_name character varying(64),
    address character varying(256),
    contact_person character varying(64),
    contact_phone character varying(64),
    longitude numeric(18,6),
    latitude numeric(18,6)
);


ALTER TABLE public.sys_organization_unit OWNER TO postgres;

--
-- Name: TABLE sys_organization_unit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_organization_unit IS '组织机构单元表';


--
-- Name: COLUMN sys_organization_unit.parent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.parent_id IS '父ID';


--
-- Name: COLUMN sys_organization_unit.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.tenant_id IS '租户ID';


--
-- Name: COLUMN sys_organization_unit.code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.code IS '组织机构单元编号';


--
-- Name: COLUMN sys_organization_unit.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.name IS '组织机构单元名称';


--
-- Name: COLUMN sys_organization_unit.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.sort IS '排序';


--
-- Name: COLUMN sys_organization_unit.category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.category IS '分类（用于机构种类）';


--
-- Name: COLUMN sys_organization_unit.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.type IS '类型（值来自字典项的 Value 转换为 int）';


--
-- Name: COLUMN sys_organization_unit.region_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.region_code IS '所属行政区域（关联 Region.Code）';


--
-- Name: COLUMN sys_organization_unit.street_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.street_name IS '行政区域街道名称';


--
-- Name: COLUMN sys_organization_unit.address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.address IS '地址';


--
-- Name: COLUMN sys_organization_unit.contact_person; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.contact_person IS '联系人';


--
-- Name: COLUMN sys_organization_unit.contact_phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.contact_phone IS '联系电话';


--
-- Name: COLUMN sys_organization_unit.longitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.longitude IS '经度';


--
-- Name: COLUMN sys_organization_unit.latitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_organization_unit.latitude IS '纬度';


--
-- Name: sys_permission_grants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_permission_grants (
    id uuid NOT NULL,
    tenant_id uuid,
    name character varying(128) NOT NULL,
    provider_name character varying(64) NOT NULL,
    provider_key character varying(64) NOT NULL
);


ALTER TABLE public.sys_permission_grants OWNER TO postgres;

--
-- Name: sys_permission_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_permission_groups (
    id uuid NOT NULL,
    name character varying(128) NOT NULL,
    display_name character varying(256) NOT NULL
);


ALTER TABLE public.sys_permission_groups OWNER TO postgres;

--
-- Name: sys_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_permissions (
    id uuid NOT NULL,
    group_name character varying(128) NOT NULL,
    name character varying(128) NOT NULL,
    parent_name character varying(128),
    display_name character varying(256) NOT NULL,
    is_enabled boolean NOT NULL,
    multi_tenancy_side smallint NOT NULL,
    providers character varying(128),
    state_checkers character varying(256)
);


ALTER TABLE public.sys_permissions OWNER TO postgres;

--
-- Name: sys_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_region (
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    id integer NOT NULL,
    parent_code character varying(12),
    code character varying(12) NOT NULL,
    name character varying(64) NOT NULL,
    path character varying(100),
    center character varying(32),
    level integer NOT NULL,
    next_level integer NOT NULL,
    sort integer NOT NULL
);


ALTER TABLE public.sys_region OWNER TO postgres;

--
-- Name: TABLE sys_region; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_region IS '行政区域表';


--
-- Name: COLUMN sys_region.parent_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.parent_code IS '父级ID';


--
-- Name: COLUMN sys_region.code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.code IS '行政区域代码（如：110000北京市、110101东城区）';


--
-- Name: COLUMN sys_region.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.name IS '区域名称';


--
-- Name: COLUMN sys_region.path; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.path IS '层级路径，如"110000/110100/110101"
            用于高效的层级查询';


--
-- Name: COLUMN sys_region.center; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.center IS '中心点坐标';


--
-- Name: COLUMN sys_region.level; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.level IS '级别：1省/直辖市，2市/州，3县/区，4街道/乡镇';


--
-- Name: COLUMN sys_region.next_level; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.next_level IS '下级类型
            因为部分城市和省直辖县没有区县的级别，故市级的下一级就是街道。
            例如：广东-东莞、海南-文昌市';


--
-- Name: COLUMN sys_region.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region.sort IS '排序';


--
-- Name: sys_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sys_region ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.sys_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sys_region_street; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_region_street (
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    last_modification_time timestamp without time zone,
    last_modifier_id uuid,
    id integer NOT NULL,
    region_code character varying(12) NOT NULL,
    name character varying(64) NOT NULL,
    center character varying(32),
    sort integer NOT NULL
);


ALTER TABLE public.sys_region_street OWNER TO postgres;

--
-- Name: TABLE sys_region_street; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_region_street IS '街道表';


--
-- Name: COLUMN sys_region_street.region_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region_street.region_code IS '高德地图区域代码（可能与父级相同）';


--
-- Name: COLUMN sys_region_street.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region_street.name IS '街道名称';


--
-- Name: COLUMN sys_region_street.center; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region_street.center IS '中心点坐标';


--
-- Name: COLUMN sys_region_street.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_region_street.sort IS '排序';


--
-- Name: sys_region_street_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sys_region_street ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.sys_region_street_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sys_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_role (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp(6) without time zone,
    name character varying(64) NOT NULL,
    remark character varying(512),
    power_data_type integer NOT NULL,
    tenant_id uuid,
    is_enabled boolean NOT NULL
);


ALTER TABLE public.sys_role OWNER TO postgres;

--
-- Name: TABLE sys_role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_role IS '角色表';


--
-- Name: COLUMN sys_role.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role.name IS '角色名';


--
-- Name: COLUMN sys_role.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role.remark IS '备注';


--
-- Name: COLUMN sys_role.power_data_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role.power_data_type IS '数据权限类型';


--
-- Name: COLUMN sys_role.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role.tenant_id IS '租户ID';


--
-- Name: COLUMN sys_role.is_enabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role.is_enabled IS '是否启用';


--
-- Name: sys_role_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_role_menu (
    id uuid NOT NULL,
    menu_id uuid NOT NULL,
    role_id uuid NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_role_menu OWNER TO postgres;

--
-- Name: TABLE sys_role_menu; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_role_menu IS '角色菜单表';


--
-- Name: COLUMN sys_role_menu.menu_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role_menu.menu_id IS '菜单ID';


--
-- Name: COLUMN sys_role_menu.role_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role_menu.role_id IS '角色ID';


--
-- Name: COLUMN sys_role_menu.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role_menu.tenant_id IS '租户ID';


--
-- Name: sys_setting_definitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_setting_definitions (
    id uuid NOT NULL,
    name character varying(128) NOT NULL,
    display_name character varying(256) NOT NULL,
    description character varying(512),
    default_value character varying(2048),
    is_visible_to_clients boolean NOT NULL,
    providers character varying(1024),
    is_inherited boolean NOT NULL,
    is_encrypted boolean NOT NULL
);


ALTER TABLE public.sys_setting_definitions OWNER TO postgres;

--
-- Name: sys_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_settings (
    id uuid NOT NULL,
    name character varying(128) NOT NULL,
    value character varying(2048) NOT NULL,
    provider_name character varying(64),
    provider_key character varying(64)
);


ALTER TABLE public.sys_settings OWNER TO postgres;

--
-- Name: sys_tenant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_tenant (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    name character varying(64) NOT NULL,
    remark character varying(512),
    domain character varying(256),
    edition_id uuid,
    bind_domain character varying(128),
    expire_date timestamp without time zone,
    contact_name character varying(64),
    contact_phone character varying(32),
    admin_email character varying(128),
    website_name character varying(128),
    logo character varying(256),
    icp_number character varying(64),
    is_active boolean NOT NULL,
    normalized_name character varying(64) NOT NULL
);


ALTER TABLE public.sys_tenant OWNER TO postgres;

--
-- Name: COLUMN sys_tenant.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.name IS '租户名称';


--
-- Name: COLUMN sys_tenant.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.remark IS '备注';


--
-- Name: COLUMN sys_tenant.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.domain IS '租户域名';


--
-- Name: COLUMN sys_tenant.edition_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.edition_id IS '版本ID';


--
-- Name: COLUMN sys_tenant.bind_domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.bind_domain IS '绑定域名';


--
-- Name: COLUMN sys_tenant.expire_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.expire_date IS '失效日期';


--
-- Name: COLUMN sys_tenant.contact_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.contact_name IS '联系人姓名';


--
-- Name: COLUMN sys_tenant.contact_phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.contact_phone IS '联系电话';


--
-- Name: COLUMN sys_tenant.admin_email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.admin_email IS '管理员邮箱';


--
-- Name: COLUMN sys_tenant.website_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.website_name IS '网站名称';


--
-- Name: COLUMN sys_tenant.logo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.logo IS 'Logo';


--
-- Name: COLUMN sys_tenant.icp_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.icp_number IS 'ICP备案号';


--
-- Name: COLUMN sys_tenant.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.is_active IS '有效状态';


--
-- Name: sys_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp(6) without time zone,
    user_name character varying(32) NOT NULL,
    password_hash character varying(512) NOT NULL,
    password_salt character varying(256) NOT NULL,
    avatar character varying(256),
    nick_name character varying(32) NOT NULL,
    is_enabled boolean NOT NULL,
    tenant_id uuid,
    phone character varying(16),
    email character varying(64),
    department_id uuid,
    position_id uuid,
    employee_id uuid,
    organization_unit_id uuid
);


ALTER TABLE public.sys_user OWNER TO postgres;

--
-- Name: TABLE sys_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_user IS '用户表';


--
-- Name: COLUMN sys_user.user_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.user_name IS '用户名';


--
-- Name: COLUMN sys_user.password_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.password_hash IS '密码哈希';


--
-- Name: COLUMN sys_user.password_salt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.password_salt IS '密码盐';


--
-- Name: COLUMN sys_user.avatar; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.avatar IS '头像';


--
-- Name: COLUMN sys_user.nick_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.nick_name IS '昵称';


--
-- Name: COLUMN sys_user.is_enabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.is_enabled IS '是否启用';


--
-- Name: COLUMN sys_user.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.tenant_id IS '租户ID';


--
-- Name: COLUMN sys_user.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.phone IS '手机号码';


--
-- Name: COLUMN sys_user.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.email IS '邮箱';


--
-- Name: COLUMN sys_user.department_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.department_id IS '部门ID';


--
-- Name: COLUMN sys_user.position_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.position_id IS '职位ID';


--
-- Name: COLUMN sys_user.employee_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.employee_id IS '关联员工ID';


--
-- Name: COLUMN sys_user.organization_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.organization_unit_id IS '组织单元ID';


--
-- Name: sys_user_notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user_notification (
    id uuid NOT NULL,
    creation_time timestamp without time zone NOT NULL,
    creator_id uuid,
    notification_id uuid NOT NULL,
    user_id uuid NOT NULL,
    is_read boolean NOT NULL,
    read_time timestamp without time zone,
    is_deleted boolean NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_user_notification OWNER TO postgres;

--
-- Name: COLUMN sys_user_notification.notification_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_notification.notification_id IS '通知ID';


--
-- Name: COLUMN sys_user_notification.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_notification.user_id IS '用户ID（员工ID）';


--
-- Name: COLUMN sys_user_notification.is_read; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_notification.is_read IS '是否已读';


--
-- Name: COLUMN sys_user_notification.read_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_notification.read_time IS '阅读时间';


--
-- Name: COLUMN sys_user_notification.is_deleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_notification.is_deleted IS '是否删除（用户删除通知）';


--
-- Name: COLUMN sys_user_notification.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_notification.tenant_id IS '租户ID';


--
-- Name: sys_user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user_role (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_user_role OWNER TO postgres;

--
-- Name: TABLE sys_user_role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_user_role IS '用户角色关联表';


--
-- Name: COLUMN sys_user_role.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_role.user_id IS '用户ID';


--
-- Name: COLUMN sys_user_role.role_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_role.role_id IS '角色ID';


--
-- Name: COLUMN sys_user_role.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user_role.tenant_id IS '租户ID';


--
-- Name: task_execution_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_execution_logs (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    task_key character varying(100),
    status integer NOT NULL,
    result text,
    node_id character varying(128),
    execution_time timestamp(6) without time zone NOT NULL,
    cost integer NOT NULL
);


ALTER TABLE public.task_execution_logs OWNER TO postgres;

--
-- Name: api_access_log public_api_access_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_access_log
    ADD CONSTRAINT public_api_access_log_pkey PRIMARY KEY (id);


--
-- Name: exception_log public_exception_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exception_log
    ADD CONSTRAINT public_exception_log_pkey PRIMARY KEY (id);


--
-- Name: log_record public_log_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_record
    ADD CONSTRAINT public_log_record_pkey PRIMARY KEY (id);


--
-- Name: org_employee public_org_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_employee
    ADD CONSTRAINT public_org_employee_pkey PRIMARY KEY (id);


--
-- Name: org_position_group public_org_position_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_position_group
    ADD CONSTRAINT public_org_position_group_pkey PRIMARY KEY (id);


--
-- Name: org_position public_org_position_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_position
    ADD CONSTRAINT public_org_position_pkey PRIMARY KEY (id);


--
-- Name: scheduled_tasks public_scheduled_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_tasks
    ADD CONSTRAINT public_scheduled_tasks_pkey PRIMARY KEY (id);


--
-- Name: sys_audit_log_actions public_sys_audit_log_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_audit_log_actions
    ADD CONSTRAINT public_sys_audit_log_actions_pkey PRIMARY KEY (id);


--
-- Name: sys_audit_logs public_sys_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_audit_logs
    ADD CONSTRAINT public_sys_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: sys_config public_sys_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_config
    ADD CONSTRAINT public_sys_config_pkey PRIMARY KEY (id);


--
-- Name: sys_dept public_sys_dept_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_dept
    ADD CONSTRAINT public_sys_dept_pkey PRIMARY KEY (id);


--
-- Name: sys_data_dictionary_item public_sys_dict_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_data_dictionary_item
    ADD CONSTRAINT public_sys_dict_data_pkey PRIMARY KEY (id);


--
-- Name: sys_data_dictionary public_sys_dict_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_data_dictionary
    ADD CONSTRAINT public_sys_dict_type_pkey PRIMARY KEY (id);


--
-- Name: sys_edition public_sys_edition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_edition
    ADD CONSTRAINT public_sys_edition_pkey PRIMARY KEY (id);


--
-- Name: sys_entity_changes public_sys_entity_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_entity_changes
    ADD CONSTRAINT public_sys_entity_changes_pkey PRIMARY KEY (id);


--
-- Name: sys_feature_groups public_sys_feature_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_feature_groups
    ADD CONSTRAINT public_sys_feature_groups_pkey PRIMARY KEY (id);


--
-- Name: sys_feature_values public_sys_feature_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_feature_values
    ADD CONSTRAINT public_sys_feature_values_pkey PRIMARY KEY (id);


--
-- Name: sys_features public_sys_features_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_features
    ADD CONSTRAINT public_sys_features_pkey PRIMARY KEY (id);


--
-- Name: sys_integration_settings public_sys_integration_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_integration_settings
    ADD CONSTRAINT public_sys_integration_settings_pkey PRIMARY KEY (id);


--
-- Name: sys_login_log public_sys_login_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_login_log
    ADD CONSTRAINT public_sys_login_log_pkey PRIMARY KEY (id);


--
-- Name: sys_menu_feature public_sys_menu_feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu_feature
    ADD CONSTRAINT public_sys_menu_feature_pkey PRIMARY KEY (id);


--
-- Name: sys_menu_permission public_sys_menu_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu_permission
    ADD CONSTRAINT public_sys_menu_permission_pkey PRIMARY KEY (id);


--
-- Name: sys_menu public_sys_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu
    ADD CONSTRAINT public_sys_menu_pkey PRIMARY KEY (id);


--
-- Name: sys_notification public_sys_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_notification
    ADD CONSTRAINT public_sys_notification_pkey PRIMARY KEY (id);


--
-- Name: sys_organization_unit public_sys_organization_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_organization_unit
    ADD CONSTRAINT public_sys_organization_unit_pkey PRIMARY KEY (id);


--
-- Name: sys_permission_grants public_sys_permission_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_permission_grants
    ADD CONSTRAINT public_sys_permission_grants_pkey PRIMARY KEY (id);


--
-- Name: sys_permission_groups public_sys_permission_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_permission_groups
    ADD CONSTRAINT public_sys_permission_groups_pkey PRIMARY KEY (id);


--
-- Name: sys_permissions public_sys_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_permissions
    ADD CONSTRAINT public_sys_permissions_pkey PRIMARY KEY (id);


--
-- Name: sys_region public_sys_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_region
    ADD CONSTRAINT public_sys_region_pkey PRIMARY KEY (id);


--
-- Name: sys_region_street public_sys_region_street_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_region_street
    ADD CONSTRAINT public_sys_region_street_pkey PRIMARY KEY (id);


--
-- Name: sys_role_menu public_sys_role_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_menu
    ADD CONSTRAINT public_sys_role_menu_pkey PRIMARY KEY (id);


--
-- Name: sys_role public_sys_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role
    ADD CONSTRAINT public_sys_role_pkey PRIMARY KEY (id);


--
-- Name: sys_setting_definitions public_sys_setting_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_setting_definitions
    ADD CONSTRAINT public_sys_setting_definitions_pkey PRIMARY KEY (id);


--
-- Name: sys_settings public_sys_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_settings
    ADD CONSTRAINT public_sys_settings_pkey PRIMARY KEY (id);


--
-- Name: sys_tenant public_sys_tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_tenant
    ADD CONSTRAINT public_sys_tenant_pkey PRIMARY KEY (id);


--
-- Name: sys_user_notification public_sys_user_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user_notification
    ADD CONSTRAINT public_sys_user_notification_pkey PRIMARY KEY (id);


--
-- Name: sys_user public_sys_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT public_sys_user_pkey PRIMARY KEY (id);


--
-- Name: sys_user_role public_sys_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user_role
    ADD CONSTRAINT public_sys_user_role_pkey PRIMARY KEY (id);


--
-- Name: task_execution_logs public_task_execution_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_execution_logs
    ADD CONSTRAINT public_task_execution_logs_pkey PRIMARY KEY (id);


--
-- Name: idx_0000bb52; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0000bb52 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_00caa5a8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_00caa5a8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_01f0ee7d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_01f0ee7d ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_01f9bf90; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_01f9bf90 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_0207a284; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0207a284 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_02fca069; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_02fca069 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_03c792e0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_03c792e0 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_047aad5f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_047aad5f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_04f02b26; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_04f02b26 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_05dd19d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_05dd19d7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_06080d44; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_06080d44 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_06453a97; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_06453a97 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_06a969ae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_06a969ae ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_074a7c6b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_074a7c6b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_081d5a13; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_081d5a13 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_085d75ef; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_085d75ef ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0877af41; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0877af41 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_0891952d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0891952d ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_089d7dee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_089d7dee ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_08bde18a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_08bde18a ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_08d056f7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_08d056f7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_090ccd3c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_090ccd3c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_090de7e5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_090de7e5 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_09338313; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_09338313 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_09a93220; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_09a93220 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_09d5b684; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_09d5b684 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_09f0ec59; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_09f0ec59 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_09f80baa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_09f80baa ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0a7455d0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0a7455d0 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0b9fa6d3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0b9fa6d3 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_0c5bc3c5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0c5bc3c5 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_0c6b0f03; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0c6b0f03 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_0c7e4b8f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0c7e4b8f ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_0cc3afa7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0cc3afa7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0ceb25ae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0ceb25ae ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_0d09e88a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0d09e88a ON public.sys_permissions USING btree (name);


--
-- Name: idx_0d8ad234; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0d8ad234 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0da17237; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_0da17237 ON public.sys_features USING btree (group_name);


--
-- Name: idx_0dca4068; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_0dca4068 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_0f54fa0f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0f54fa0f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0f968ab2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0f968ab2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_0fc57e54; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_0fc57e54 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_105941e7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_105941e7 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_10e02dde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_10e02dde ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_10e532a0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_10e532a0 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_11988b42; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_11988b42 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_12626b77; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_12626b77 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1265195f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1265195f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_12b0a3d3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_12b0a3d3 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_12b55336; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_12b55336 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_136402cd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_136402cd ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_13ef6934; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_13ef6934 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_147c5c2f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_147c5c2f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_149de572; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_149de572 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_1506d308; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1506d308 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_167e8628; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_167e8628 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_16ee54d1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_16ee54d1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_173bd8d0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_173bd8d0 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_17c5c7c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_17c5c7c7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_184a2b86; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_184a2b86 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_189bed1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_189bed1b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_1914e2a1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1914e2a1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1ab072a3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1ab072a3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1aed616e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1aed616e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_1c09c7e9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1c09c7e9 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_1c88db69; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1c88db69 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_1cc41165; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1cc41165 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_1d077fb0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1d077fb0 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1dd53858; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1dd53858 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1e28425b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1e28425b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1ed85fa7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1ed85fa7 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_1f487b2b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1f487b2b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1fd40538; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1fd40538 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1fd98b80; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1fd98b80 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_1fd9b4a4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_1fd9b4a4 ON public.sys_permissions USING btree (name);


--
-- Name: idx_2067dcb2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_2067dcb2 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_20bd4284; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_20bd4284 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_20eda142; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_20eda142 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2215e19f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2215e19f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2283c9ad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2283c9ad ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_23f799c3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_23f799c3 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_242949d8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_242949d8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2444ea7f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2444ea7f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_247e6377; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_247e6377 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2567ff0b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2567ff0b ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_2698b477; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2698b477 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_28d0adbb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_28d0adbb ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_28ee1928; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_28ee1928 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_28fcc82e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_28fcc82e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2940fe6b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2940fe6b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_29d6cfc1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_29d6cfc1 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_2a1b2188; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2a1b2188 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_2a2cb263; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2a2cb263 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2ad457c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2ad457c0 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2c1d3276; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2c1d3276 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2cbaa03a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2cbaa03a ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_2d359b93; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2d359b93 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2d4a51a9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2d4a51a9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2d9de1eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2d9de1eb ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2dc93a6b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2dc93a6b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_2dd391b9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_2dd391b9 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_2ecdd8ab; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2ecdd8ab ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_2f514d17; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2f514d17 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_2f78f396; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2f78f396 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2f935484; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2f935484 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2fae1605; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2fae1605 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_2fb7c9dd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2fb7c9dd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_2ff9520e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_2ff9520e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_301cb45d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_301cb45d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_302b9c1d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_302b9c1d ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_3038d130; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3038d130 ON public.sys_permissions USING btree (name);


--
-- Name: idx_30f5c754; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_30f5c754 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_314cb1f1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_314cb1f1 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_3175d8d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3175d8d7 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_31880e6f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_31880e6f ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_3304ca06; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3304ca06 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_337cdfda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_337cdfda ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_33e2a6a9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_33e2a6a9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3488dc02; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3488dc02 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_34c5168e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_34c5168e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3535bfaf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3535bfaf ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_361b9dc5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_361b9dc5 ON public.sys_permissions USING btree (name);


--
-- Name: idx_376374fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_376374fa ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_38529278; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_38529278 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3868fcea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3868fcea ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_38f6e83b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_38f6e83b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_39aa025d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_39aa025d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3a340eb2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3a340eb2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3ac5f139; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3ac5f139 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3bb0a180; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3bb0a180 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3c5a8a18; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3c5a8a18 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3c60d0bc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3c60d0bc ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_3d22cb62; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3d22cb62 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3d2d665d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3d2d665d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3dc3366e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3dc3366e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3e1d780b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3e1d780b ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_3e3b70f4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_3e3b70f4 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_3e41e8b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3e41e8b2 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_3e544b84; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3e544b84 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_3e8af3e4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3e8af3e4 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_3f02ee4f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_3f02ee4f ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_3f433bbe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3f433bbe ON public.sys_permissions USING btree (name);


--
-- Name: idx_3f4901e6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3f4901e6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_3ff3c5ff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_3ff3c5ff ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_403705e8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_403705e8 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_40854841; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_40854841 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_41fd9851; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_41fd9851 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_42e89f52; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_42e89f52 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_432cbcbd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_432cbcbd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_44169d75; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_44169d75 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_448bc064; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_448bc064 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_44a2d209; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_44a2d209 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_44e0a047; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_44e0a047 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_469df6aa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_469df6aa ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_46a431f2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_46a431f2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_472d8eaf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_472d8eaf ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_479dedba; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_479dedba ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_48471967; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_48471967 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_499831f6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_499831f6 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_49a00743; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_49a00743 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_49bfadc2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_49bfadc2 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_4a641d81; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4a641d81 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_4b0cb4ad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4b0cb4ad ON public.sys_permissions USING btree (name);


--
-- Name: idx_4b5d4d96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4b5d4d96 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_4c1440af; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4c1440af ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_4c35bfe0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4c35bfe0 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_4c37116c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4c37116c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_4c8a2570; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4c8a2570 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_4cee9ab9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4cee9ab9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_4d300b92; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4d300b92 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_4e3cea68; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4e3cea68 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_4e4f734f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_4e4f734f ON public.sys_features USING btree (group_name);


--
-- Name: idx_4eb71363; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4eb71363 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_4f3167aa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4f3167aa ON public.sys_permissions USING btree (name);


--
-- Name: idx_4f37ddde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4f37ddde ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_4f3afdc8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4f3afdc8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_4f47ede2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4f47ede2 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_4f8b570f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4f8b570f ON public.sys_permissions USING btree (name);


--
-- Name: idx_4faf27a9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_4faf27a9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5014d01e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5014d01e ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_50814e85; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_50814e85 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_508d14a3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_508d14a3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5091cbae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5091cbae ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_50aacd24; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_50aacd24 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_50f29e1d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_50f29e1d ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_5160f79c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5160f79c ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_516bb490; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_516bb490 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_51c2e4b6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_51c2e4b6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_53032d93; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_53032d93 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_5306f482; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5306f482 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_5382ae54; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5382ae54 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_54507c21; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_54507c21 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_54d1f69f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_54d1f69f ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_55023c42; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_55023c42 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5587d352; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5587d352 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_55cf7ca7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_55cf7ca7 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_56408330; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_56408330 ON public.sys_feature_groups USING btree (name);


--
-- Name: idx_56c2a3b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_56c2a3b2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_56c83d2f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_56c83d2f ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_578f4934; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_578f4934 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_57940cd4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_57940cd4 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_57b0dc45; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_57b0dc45 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_57d18603; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_57d18603 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_5860f571; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5860f571 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5905e115; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5905e115 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5906c994; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5906c994 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_591b36ac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_591b36ac ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_593e2de2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_593e2de2 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_5a49e69a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5a49e69a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5a978fb5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5a978fb5 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5b8735d4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5b8735d4 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5b8ef77b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5b8ef77b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_5bcca266; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5bcca266 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_5c86a691; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5c86a691 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5cbdc6cf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5cbdc6cf ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_5cc30149; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5cc30149 ON public.sys_permissions USING btree (name);


--
-- Name: idx_5ceda191; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5ceda191 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5cef059c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5cef059c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_5d3e3ab5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5d3e3ab5 ON public.sys_feature_groups USING btree (name);


--
-- Name: idx_5d50a31e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5d50a31e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5dae701f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5dae701f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5db1d4e6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5db1d4e6 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_5df07a18; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5df07a18 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5e9660cf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5e9660cf ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_5e9ba3aa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5e9ba3aa ON public.sys_features USING btree (name);


--
-- Name: idx_5ee1066b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5ee1066b ON public.sys_permissions USING btree (name);


--
-- Name: idx_5fb89b1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_5fb89b1b ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_603c9bd9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_603c9bd9 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_60a49fc0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_60a49fc0 ON public.sys_feature_groups USING btree (name);


--
-- Name: idx_610bf92a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_610bf92a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_61e3a421; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_61e3a421 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_62205792; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_62205792 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_628bc415; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_628bc415 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_62dd6485; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_62dd6485 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_635c9d41; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_635c9d41 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_644590ed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_644590ed ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6446a729; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6446a729 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_64e69c29; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_64e69c29 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_651f1819; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_651f1819 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_652c3c2f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_652c3c2f ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_655deba2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_655deba2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6625c26e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6625c26e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_668a95e2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_668a95e2 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_66b08308; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_66b08308 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_66ef4296; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_66ef4296 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_66fb4e22; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_66fb4e22 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_6730e89e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6730e89e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_67a28a2b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_67a28a2b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_67b75240; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_67b75240 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_67c78d99; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_67c78d99 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_67f489fb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_67f489fb ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_683679e2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_683679e2 ON public.sys_features USING btree (name);


--
-- Name: idx_685538e7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_685538e7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_688cf0ad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_688cf0ad ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_68e746ee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_68e746ee ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_693998d5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_693998d5 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_69f71259; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_69f71259 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6a5e4f0b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6a5e4f0b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6a849ab9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6a849ab9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6a8fa0b1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6a8fa0b1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6ab2d4f4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6ab2d4f4 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6ab5767c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6ab5767c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6adc608d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6adc608d ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_6c5a124f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6c5a124f ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_6c8f3476; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6c8f3476 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_6cbd3867; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6cbd3867 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6d154afc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6d154afc ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_6d52d0e6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6d52d0e6 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_6d5a0b18; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6d5a0b18 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6d66c986; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6d66c986 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6e70334f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6e70334f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_6f715b04; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6f715b04 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_6fe2c1fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_6fe2c1fa ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_702c30b1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_702c30b1 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_708593b4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_708593b4 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7178b6c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7178b6c7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_728c9452; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_728c9452 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_72edc4c1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_72edc4c1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_732a0b41; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_732a0b41 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_73947402; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_73947402 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_75aa8727; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_75aa8727 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7603af2f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7603af2f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_763b67a7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_763b67a7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_766e835f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_766e835f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_76ab0c2f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_76ab0c2f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7770d6b7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7770d6b7 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_77c2294c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_77c2294c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_78155a9a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_78155a9a ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_782b6e0c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_782b6e0c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_78985b65; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_78985b65 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_79484088; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_79484088 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_79b14a6a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_79b14a6a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7a3c6dee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7a3c6dee ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_7a6049b4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7a6049b4 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_7b05c73f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7b05c73f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7b740e1d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7b740e1d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7b8d37fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7b8d37fa ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_7c3a5a71; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7c3a5a71 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7c7704ae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7c7704ae ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_7c937797; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7c937797 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7cc3dea5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7cc3dea5 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7ccbaad7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7ccbaad7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7d00aa87; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7d00aa87 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_7d5d5c8c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7d5d5c8c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_7d6cdfda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7d6cdfda ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7d8ab909; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7d8ab909 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7d98fc23; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7d98fc23 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_7ebeb7b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7ebeb7b2 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_7f279579; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7f279579 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_7f351b40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7f351b40 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7f92ebe8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7f92ebe8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_7ff12e5f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_7ff12e5f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_80ff29ae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_80ff29ae ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_819d0e3f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_819d0e3f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_81b7c82b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_81b7c82b ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_81e9d4c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_81e9d4c7 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_82bce028; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_82bce028 ON public.sys_permissions USING btree (name);


--
-- Name: idx_82f4ee1f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_82f4ee1f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_83ff3067; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_83ff3067 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_840281a1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_840281a1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_84fbfc1a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_84fbfc1a ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_8524714e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8524714e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_855d72e4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_855d72e4 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_858ee603; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_858ee603 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_85fcf54d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_85fcf54d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_861c4211; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_861c4211 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_86281774; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_86281774 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8713b9c2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8713b9c2 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_87162225; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_87162225 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_87319750; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_87319750 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_873696fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_873696fa ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_879374de; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_879374de ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8866e867; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8866e867 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_886bda2d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_886bda2d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_88983556; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_88983556 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_88c5f978; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_88c5f978 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_89f73478; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_89f73478 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_89ff2943; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_89ff2943 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8a267128; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8a267128 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8b5cfed1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8b5cfed1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8b6f7047; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8b6f7047 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_8baa148d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8baa148d ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_8bb1c497; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8bb1c497 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_8beb311a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8beb311a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8c6b7d93; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8c6b7d93 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8c6dee6e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8c6dee6e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8c89f515; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8c89f515 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8cc46150; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8cc46150 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8cf05118; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8cf05118 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8d63785e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8d63785e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_8d689be2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8d689be2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8d6ceea2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8d6ceea2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8de95f12; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8de95f12 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_8eda128f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8eda128f ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_8f19378f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_8f19378f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_90a70600; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_90a70600 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_9102bd66; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9102bd66 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_9167cc57; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9167cc57 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_91d644ba; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_91d644ba ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_91ea8999; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_91ea8999 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_92009f1d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_92009f1d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9263fb24; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9263fb24 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_92c17803; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_92c17803 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_92d3ecc3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_92d3ecc3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_92ddb0ba; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_92ddb0ba ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_93826ceb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_93826ceb ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_940c68fd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_940c68fd ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_947bb8c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_947bb8c7 ON public.sys_permissions USING btree (name);


--
-- Name: idx_94decf7b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_94decf7b ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_958140a6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_958140a6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_95aa8c32; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_95aa8c32 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_95e992b4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_95e992b4 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_95f10842; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_95f10842 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_961839c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_961839c7 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_964b32c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_964b32c9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_96a702fb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_96a702fb ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_96ab852a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_96ab852a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9724a90d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9724a90d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9735d4b1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9735d4b1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_973c2d27; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_973c2d27 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_97825722; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_97825722 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_979e2f60; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_979e2f60 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_9821e452; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9821e452 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_984dc04a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_984dc04a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_984f4dd1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_984f4dd1 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_98d898fe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_98d898fe ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9940c769; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9940c769 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_99589b3c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_99589b3c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_99b8dd26; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_99b8dd26 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_99c581e6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_99c581e6 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_99f6b234; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_99f6b234 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9a140563; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9a140563 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_9a78a35c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9a78a35c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9ac7311f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9ac7311f ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_9acf3a37; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9acf3a37 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9be66dc1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9be66dc1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9c31d385; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9c31d385 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9c358906; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9c358906 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_9dbf54b9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9dbf54b9 ON public.sys_permissions USING btree (name);


--
-- Name: idx_9e3d3bc6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9e3d3bc6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9e74dc9a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9e74dc9a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9e98690c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9e98690c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9f0f45cb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9f0f45cb ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9f1f0bc3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9f1f0bc3 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_9f275680; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9f275680 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_9fd38a37; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9fd38a37 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_9ffc86f0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_9ffc86f0 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a0c29cc3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a0c29cc3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_a13ae257; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a13ae257 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a1bc37bd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a1bc37bd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_a283f50c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a283f50c ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a2c5d6b6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a2c5d6b6 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a32f57ef; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a32f57ef ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_a33ae65a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a33ae65a ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_a3a3d5ef; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a3a3d5ef ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a3a6f184; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a3a6f184 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_a3bdd99a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a3bdd99a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_a4ca1b52; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_a4ca1b52 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_a4de6ded; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a4de6ded ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_a5072660; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a5072660 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a64dd411; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a64dd411 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a66688eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a66688eb ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_a6bf37e1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a6bf37e1 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_a88ed08a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a88ed08a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_a8d3256a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_a8d3256a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_aa6b36ce; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_aa6b36ce ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_aa9c2db6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_aa9c2db6 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_aaf8d902; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_aaf8d902 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ab5b6fda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ab5b6fda ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_abafc539; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_abafc539 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ac9d6ce1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ac9d6ce1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ad4af060; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ad4af060 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ad7e2955; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ad7e2955 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ae0edd79; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ae0edd79 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_ae4abf9d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ae4abf9d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_aef5678c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_aef5678c ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_af3ef142; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_af3ef142 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b036f34c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b036f34c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b0517d03; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b0517d03 ON public.sys_features USING btree (name);


--
-- Name: idx_b1611d27; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b1611d27 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_b1620579; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b1620579 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b2afbec6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b2afbec6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b32d04c3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b32d04c3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b42d161e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_b42d161e ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_b42e3067; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b42e3067 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b48b4e18; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b48b4e18 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b4fc40ca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b4fc40ca ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b52e60ec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b52e60ec ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_b55d042f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b55d042f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b620e973; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b620e973 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_b647a9e8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_b647a9e8 ON public.sys_features USING btree (group_name);


--
-- Name: idx_b6d202ce; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b6d202ce ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b705812f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b705812f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b72ffd1e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b72ffd1e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_b7a889ed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_b7a889ed ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_b839aae6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b839aae6 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_b8466e72; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b8466e72 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b8b1953c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_b8b1953c ON public.sys_features USING btree (group_name);


--
-- Name: idx_b9428f32; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b9428f32 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_b95b956c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b95b956c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_b9ab08b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b9ab08b2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_b9b1b1b8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_b9b1b1b8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ba2b1ac5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ba2b1ac5 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ba3e46aa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ba3e46aa ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ba839c44; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ba839c44 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_baece643; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_baece643 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bbf2bb38; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bbf2bb38 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_bc4c8141; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bc4c8141 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_bc546e39; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bc546e39 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bc60b236; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bc60b236 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bc773b47; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bc773b47 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_bd02e75b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bd02e75b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bd8ad8a3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bd8ad8a3 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_bda5f1ea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bda5f1ea ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bdc53a4c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bdc53a4c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bdf568c2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bdf568c2 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_be609261; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_be609261 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_be6715bb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_be6715bb ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_be6c0ba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_be6c0ba6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_be90e56a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_be90e56a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_beabc6ff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_beabc6ff ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_bf5200a2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bf5200a2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bf6a483d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bf6a483d ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_bfd2708a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bfd2708a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_bfd3429d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_bfd3429d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c04e7b0f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c04e7b0f ON public.sys_features USING btree (name);


--
-- Name: idx_c102ffa7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c102ffa7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c1046ec5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c1046ec5 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c21c9ceb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c21c9ceb ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c2612eec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c2612eec ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_c2d1c8f8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c2d1c8f8 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_c30167a9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c30167a9 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_c33bb646; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c33bb646 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_c3f88123; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c3f88123 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_c4578648; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c4578648 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c4895920; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c4895920 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c5d2f3dd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c5d2f3dd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c5df98ef; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c5df98ef ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c6050961; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_c6050961 ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_c619dff6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c619dff6 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_c6da51a7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c6da51a7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c6de3a45; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c6de3a45 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c6ee028e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c6ee028e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c7304151; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c7304151 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c7a23687; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c7a23687 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_c812f95b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c812f95b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c8425d14; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c8425d14 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_c898c8f9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c898c8f9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c8c5541c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c8c5541c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c92c0a50; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c92c0a50 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_c9629d45; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c9629d45 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_c9b632cb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_c9b632cb ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_ca4088f9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ca4088f9 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_ca4d22ab; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ca4d22ab ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ca50bde0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ca50bde0 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ca79b405; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ca79b405 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cb11d9a8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cb11d9a8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cb393857; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cb393857 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cb550d44; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cb550d44 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cb62709b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cb62709b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cb8ea788; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cb8ea788 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_cbff1a23; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cbff1a23 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ccbc0596; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ccbc0596 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cd01ac34; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cd01ac34 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_cd518fd6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cd518fd6 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_cdc08432; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cdc08432 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_cec6e30c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cec6e30c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_cf1fbbde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cf1fbbde ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_cf471897; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cf471897 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_cf7bfaa7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cf7bfaa7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d052f845; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d052f845 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d0ffac78; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d0ffac78 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d12ec025; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d12ec025 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_d1307106; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d1307106 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d14b927d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d14b927d ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_d15941fe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d15941fe ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d1801d1f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d1801d1f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d1b9f0c2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d1b9f0c2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d1d9521a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d1d9521a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d26298de; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d26298de ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d2a29abe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d2a29abe ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d2ad3eb3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d2ad3eb3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d3dbc663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d3dbc663 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d4b17bda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d4b17bda ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d5c2c6fd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d5c2c6fd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d64214e2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d64214e2 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_d706921a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_d706921a ON public.sys_permissions USING btree (group_name);


--
-- Name: idx_d7360e06; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d7360e06 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d7dec523; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d7dec523 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d7fbc58a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d7fbc58a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d83f670a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d83f670a ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_d8c0be57; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d8c0be57 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_d8cbf0ee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d8cbf0ee ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d8d50f41; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d8d50f41 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_d953d26c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d953d26c ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_d9bf05f7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_d9bf05f7 ON public.sys_feature_groups USING btree (name);


--
-- Name: idx_da4a36ad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_da4a36ad ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_da793b6e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_da793b6e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_db1625a1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_db1625a1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_dbab1b2e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dbab1b2e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_dc206641; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dc206641 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_dc8447c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dc8447c9 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_dd632c65; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dd632c65 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_dd8d8e93; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dd8d8e93 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_dd986631; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dd986631 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_ddac36c4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ddac36c4 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_ddb23eb3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ddb23eb3 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_de2a6a5b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_de2a6a5b ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_de5f2b7d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_de5f2b7d ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_df8cc129; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_df8cc129 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_dffb5e95; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_dffb5e95 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e03148d4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e03148d4 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_e05c1f90; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e05c1f90 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e088089f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e088089f ON public.sys_permissions USING btree (name);


--
-- Name: idx_e090908f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e090908f ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e0b9afc8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e0b9afc8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e0c929fd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e0c929fd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e1e54cc6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e1e54cc6 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e229a43b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e229a43b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e2399bf8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e2399bf8 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_e23e9d4d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e23e9d4d ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_e2adcebc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e2adcebc ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e3449728; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e3449728 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e354102b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e354102b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e4483eb8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e4483eb8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e571282a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e571282a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e571cdca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e571cdca ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_e71b9ca4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e71b9ca4 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e78a5a64; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e78a5a64 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e802b260; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e802b260 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e827975e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e827975e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e8634f20; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e8634f20 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_e86b1c6b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e86b1c6b ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e8b7224e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e8b7224e ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e8d32767; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e8d32767 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e8fb40d1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e8fb40d1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_e9695d9d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e9695d9d ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_e9fdaf34; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_e9fdaf34 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ea3d5418; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ea3d5418 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_eae2e323; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_eae2e323 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_eaf6d2d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_eaf6d2d7 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ec311bf7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ec311bf7 ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_ece23b61; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ece23b61 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ecfcf757; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ecfcf757 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ed37e498; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ed37e498 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ed7b4212; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ed7b4212 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_ed996113; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ed996113 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_edac9098; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_edac9098 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_edbe8d10; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_edbe8d10 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_edc4e965; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_edc4e965 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ee03e3c6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ee03e3c6 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ee921df1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ee921df1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_efccf17d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_efccf17d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_efed2a4c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_efed2a4c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_execution_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_execution_time ON public.task_execution_logs USING btree (execution_time);


--
-- Name: idx_f0afbfdd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f0afbfdd ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f0ddf415; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f0ddf415 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_f174c796; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f174c796 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_f245518c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f245518c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_f27d789c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f27d789c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f2a5dfb9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f2a5dfb9 ON public.sys_permissions USING btree (name);


--
-- Name: idx_f2ae1845; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f2ae1845 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_f30505af; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f30505af ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_f38059b6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f38059b6 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_f39d3a18; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f39d3a18 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_f39ece5e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f39ece5e ON public.sys_setting_definitions USING btree (name);


--
-- Name: idx_f47927dc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f47927dc ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f4f60b67; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f4f60b67 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f5c3466a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f5c3466a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f65dfb89; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f65dfb89 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_f66b5faa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f66b5faa ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f6719f5d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f6719f5d ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f70106a8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f70106a8 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f74eda16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f74eda16 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f7599b92; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f7599b92 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f761593e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f761593e ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f76d066c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f76d066c ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f7752753; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f7752753 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f78e5ca1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f78e5ca1 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f7e39f48; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f7e39f48 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_f84c387c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f84c387c ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_f8ae8d47; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_f8ae8d47 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_fac2bbe7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fac2bbe7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_fafafa6b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fafafa6b ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_fb1bfcde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fb1bfcde ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_fb4ea61a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fb4ea61a ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_fbbc1f03; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fbbc1f03 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_fbc9c962; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fbc9c962 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_fc6231e5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fc6231e5 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_fd51884d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fd51884d ON public.sys_permissions USING btree (name);


--
-- Name: idx_fd74035a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fd74035a ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_fe6bd387; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fe6bd387 ON public.sys_feature_values USING btree (name, provider_name, provider_key);


--
-- Name: idx_fed5c028; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_fed5c028 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ff714c51; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ff714c51 ON public.sys_settings USING btree (name, provider_name, provider_key);


--
-- Name: idx_ff9b1aa2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ff9b1aa2 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_ffcb96e9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ffcb96e9 ON public.sys_permission_groups USING btree (name);


--
-- Name: idx_ffdb87c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ffdb87c7 ON public.sys_permission_grants USING btree (tenant_id, name, provider_name, provider_key);


--
-- Name: idx_region_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_region_code ON public.sys_region USING btree (code);


--
-- Name: idx_region_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_region_path ON public.sys_region USING btree (path);


--
-- Name: idx_region_street_region_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_region_street_region_code ON public.sys_region_street USING btree (region_code);


--
-- Name: idx_task_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_key ON public.task_execution_logs USING btree (task_key);


--
-- Name: uk_task_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uk_task_key ON public.scheduled_tasks USING btree (task_key);


--
-- PostgreSQL database dump complete
--

