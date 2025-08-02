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

--
-- Name: cap; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA cap;


ALTER SCHEMA cap OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: published; Type: TABLE; Schema: cap; Owner: postgres
--

CREATE TABLE cap.published (
    "Id" bigint NOT NULL,
    "Version" character varying(20) NOT NULL,
    "Name" character varying(200) NOT NULL,
    "Content" text,
    "Retries" integer NOT NULL,
    "Added" timestamp without time zone NOT NULL,
    "ExpiresAt" timestamp without time zone,
    "StatusName" character varying(50) NOT NULL
);


ALTER TABLE cap.published OWNER TO postgres;

--
-- Name: received; Type: TABLE; Schema: cap; Owner: postgres
--

CREATE TABLE cap.received (
    "Id" bigint NOT NULL,
    "Version" character varying(20) NOT NULL,
    "Name" character varying(200) NOT NULL,
    "Group" character varying(200),
    "Content" text,
    "Retries" integer NOT NULL,
    "Added" timestamp without time zone NOT NULL,
    "ExpiresAt" timestamp without time zone,
    "StatusName" character varying(50) NOT NULL
);


ALTER TABLE cap.received OWNER TO postgres;

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
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id uuid NOT NULL,
    concurrency_stamp character varying(255),
    application_name character varying(255),
    user_id uuid,
    user_name character varying(255),
    tenant_id uuid,
    tenant_name character varying(255),
    impersonator_user_id uuid,
    impersonator_user_name character varying(255),
    impersonator_tenant_id uuid,
    impersonator_tenant_name character varying(255),
    execution_time timestamp without time zone NOT NULL,
    execution_duration integer NOT NULL,
    client_ip_address character varying(255),
    client_name character varying(255),
    client_id character varying(255),
    correlation_id character varying(255),
    browser_info character varying(255),
    http_method character varying(255),
    url character varying(255),
    exceptions character varying(255),
    comments character varying(255),
    http_status_code integer
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- Name: entity_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_change (
    id uuid NOT NULL,
    audit_log_id uuid NOT NULL,
    tenant_id uuid,
    change_time timestamp without time zone NOT NULL,
    change_type integer NOT NULL,
    entity_tenant_id uuid,
    entity_id character varying(255),
    entity_type_full_name character varying(255)
);


ALTER TABLE public.entity_change OWNER TO postgres;

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
    phone character varying(16) NOT NULL,
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
-- Name: COLUMN org_employee.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.org_employee.phone IS '手机号码';


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
    creation_time timestamp without time zone NOT NULL
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
-- Name: sys_dict_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_dict_data (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    value character varying(256) NOT NULL,
    label character varying(128) NOT NULL,
    dict_type character varying(128) NOT NULL,
    remark character varying(512),
    sort integer NOT NULL,
    is_enabled boolean NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_dict_data OWNER TO postgres;

--
-- Name: TABLE sys_dict_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_dict_data IS '字典数据表';


--
-- Name: COLUMN sys_dict_data.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.value IS '字典值';


--
-- Name: COLUMN sys_dict_data.label; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.label IS '显示文本';


--
-- Name: COLUMN sys_dict_data.dict_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.dict_type IS '字典类型';


--
-- Name: COLUMN sys_dict_data.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.remark IS '备注';


--
-- Name: COLUMN sys_dict_data.sort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.sort IS '排序值';


--
-- Name: COLUMN sys_dict_data.is_enabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.is_enabled IS '是否开启';


--
-- Name: COLUMN sys_dict_data.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_data.tenant_id IS '租户ID';


--
-- Name: sys_dict_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_dict_type (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    name character varying(128) NOT NULL,
    dict_type character varying(128) NOT NULL,
    remark character varying(512),
    is_enabled boolean NOT NULL,
    tenant_id uuid
);


ALTER TABLE public.sys_dict_type OWNER TO postgres;

--
-- Name: TABLE sys_dict_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sys_dict_type IS '字典类型表';


--
-- Name: COLUMN sys_dict_type.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_type.name IS '字典名称';


--
-- Name: COLUMN sys_dict_type.dict_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_type.dict_type IS '字典类型';


--
-- Name: COLUMN sys_dict_type.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_type.remark IS '备注';


--
-- Name: COLUMN sys_dict_type.is_enabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_type.is_enabled IS '是否开启';


--
-- Name: COLUMN sys_dict_type.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_dict_type.tenant_id IS '租户ID';


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
    extra_properties character varying(2000)
);


ALTER TABLE public.sys_entity_changes OWNER TO postgres;

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
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    title character varying(32) NOT NULL,
    icon character varying(64),
    path character varying(256),
    component character varying(256),
    menu_type integer NOT NULL,
    permission character varying(128),
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
-- Name: COLUMN sys_menu.component; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.component IS '组件地址';


--
-- Name: COLUMN sys_menu.menu_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.menu_type IS '功能类型';


--
-- Name: COLUMN sys_menu.permission; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_menu.permission IS '授权码';


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
-- Name: sys_notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_notification (
    id uuid NOT NULL,
    creator_id uuid,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    title character varying(128) NOT NULL,
    content character varying(512),
    employee_id uuid NOT NULL,
    is_readed boolean NOT NULL,
    readed_time timestamp(6) without time zone NOT NULL,
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
-- Name: COLUMN sys_notification.employee_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.employee_id IS '通知员工';


--
-- Name: COLUMN sys_notification.is_readed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.is_readed IS '是否已读(true已读false未读)';


--
-- Name: COLUMN sys_notification.readed_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.readed_time IS '已读时间';


--
-- Name: COLUMN sys_notification.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_notification.tenant_id IS '租户ID';


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
    role_name character varying(64) NOT NULL,
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
-- Name: COLUMN sys_role.role_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_role.role_name IS '角色名';


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
    domain character varying(256)
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
    password character varying(512) NOT NULL,
    password_salt character varying(256) NOT NULL,
    avatar character varying(256),
    nick_name character varying(64) NOT NULL,
    sex integer NOT NULL,
    is_enabled boolean NOT NULL,
    tenant_id uuid,
    phone character varying(11)
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
-- Name: COLUMN sys_user.password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.password IS '密码';


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
-- Name: COLUMN sys_user.sex; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_user.sex IS '性别';


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
-- Data for Name: published; Type: TABLE DATA; Schema: cap; Owner: postgres
--

COPY cap.published ("Id", "Version", "Name", "Content", "Retries", "Added", "ExpiresAt", "StatusName") FROM stdin;
3595776189596008470	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008470","cap-corr-id":"3595776189596008470","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.8248107+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"abc990ab158cca08fbf3cdc0f710984a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:43.82497	2025-07-28 16:46:43.831641	Succeeded
3595776189596008475	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008475","cap-corr-id":"3595776189596008475","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:52:48"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c","Method":"PUT","RequestTime":"2025-07-27T16:52:48.2020119+08:00","ResponseTime":"2025-07-27T16:52:48.231875+08:00","Duration":30,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022RoleName\\u0022:\\u0022\\u6D4B\\u8BD5\\u0022,\\u0022Remark\\u0022:\\u0022\\u6D4B\\u8BD5\\u83DC\\u5355\\u6743\\u9650\\u0022,\\u0022IsEnabled\\u0022:true}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u89D2\\u8272","TraceId":"3bbbf64cf7e715cbddd616be411e0891","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:52:48.232058	2025-07-28 16:52:48.242309	Succeeded
3595776189596008478	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008478","cap-corr-id":"3595776189596008478","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.782176+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0f967483acb706f1afd3f68dd545f944","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.782312	2025-07-28 16:53:47.78881	Succeeded
3595776189596008477	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008477","cap-corr-id":"3595776189596008477","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.7520157+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"cc6f0b646c3dad1af01d0c7d524a21a0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.752264	2025-07-28 16:53:47.760581	Succeeded
3595776189596008449	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008449","cap-corr-id":"3595776189596008449","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 15:44:59"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469929745626697728","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 15:45:00.03028	2025-07-28 15:45:00.078272	Succeeded
3595776189596008451	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008451","cap-corr-id":"3595776189596008451","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 16:37:15"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469942895910588416","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 16:37:15.012636	2025-07-28 16:37:15.029087	Succeeded
3595776189596008453	v1	log_record_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008453","cap-corr-id":"3595776189596008453","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:42:24"},"Value":{"Type":"\\u5B57\\u5178\\u6570\\u636E","SubType":"\\u7F16\\u8F91\\u5B57\\u5178\\u6570\\u636E","BizNo":"68602622-e22b-e780-00f8-5c9d688361b4","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u503C=1,\\u542F\\u7528=True","TraceId":"9a950cae333377316b799fb0ddd70449","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:42:24.2061492+08:00"}}	0	2025-07-27 16:42:24.220161	2025-07-28 16:42:24.25056	Succeeded
3595776189596008455	v1	log_record_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008455","cap-corr-id":"3595776189596008455","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:44:11"},"Value":{"Type":"\\u914D\\u7F6E\\u7BA1\\u7406","SubType":"\\u7F16\\u8F91\\u914D\\u7F6E","BizNo":"68758b9b-e6de-0d4c-0000-b9861878b283","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u952E=StorageType\\uFF0C\\u503C=1\\uFF0C\\u7EC4=System","TraceId":"fda514554eb678cf78a78392545893b4","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:44:11.2352973+08:00"}}	0	2025-07-27 16:44:11.235495	2025-07-28 16:44:11.246768	Succeeded
3595776189596008456	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008456","cap-corr-id":"3595776189596008456","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:11"},"Value":{"Path":"/api/admin/settings","Method":"PUT","RequestTime":"2025-07-27T16:44:10.9081541+08:00","ResponseTime":"2025-07-27T16:44:11.2587541+08:00","Duration":351,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u002268758b9b-e6de-0d4c-0000-b9861878b283\\u0022,\\u0022Name\\u0022:\\u0022\\u6587\\u4EF6\\u5B58\\u50A8\\u9A71\\u52A8\\u7C7B\\u578B\\u0022,\\u0022Key\\u0022:\\u0022StorageType\\u0022,\\u0022Value\\u0022:\\u00221\\u0022,\\u0022GroupKey\\u0022:\\u0022System\\u0022,\\u0022Remark\\u0022:\\u0022\\u672C\\u5730\\u670D\\u52A1\\u5668=1\\uFF0C\\u963F\\u91CC\\u4E91OSS=2\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u914D\\u7F6E","TraceId":"fda514554eb678cf78a78392545893b4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:11.341919	2025-07-28 16:44:11.355265	Succeeded
3595776189596008481	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008481","cap-corr-id":"3595776189596008481","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.2809683+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"20c035c0b3df346e568ea6708f11a0df","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:50.281925	2025-07-28 16:53:50.28931	Succeeded
3595776189596008459	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008459","cap-corr-id":"3595776189596008459","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:16"},"Value":{"Path":"/api/admin/tenants","Method":"PUT","RequestTime":"2025-07-27T16:44:16.638703+08:00","ResponseTime":"2025-07-27T16:44:16.6997772+08:00","Duration":61,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00226876c45d-e5f2-35dc-00d1-48ee38eafd16\\u0022,\\u0022Name\\u0022:\\u0022\\u6E56\\u5357\\u5C0F\\u5356\\u90E8\\u0022,\\u0022TenantId\\u0022:\\u0022hn_market\\u0022,\\u0022Remark\\u0022:null,\\u0022Domain\\u0022:\\u0022hn.market.crackerwork.cn\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u79DF\\u6237","TraceId":"cdeef92f21253c78c6e7648ec7aea1f1","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:16.700028	2025-07-28 16:44:16.712615	Succeeded
3595776189596008473	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008473","cap-corr-id":"3595776189596008473","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:51:57"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus","Method":"PUT","RequestTime":"2025-07-27T16:51:57.1929992+08:00","ResponseTime":"2025-07-27T16:51:57.3033286+08:00","Duration":110,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022RoleId\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022MenuIds\\u0022:[\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u00223a13bcfd-52bb-db4a-d508-eea8536c8bdc\\u0022,\\u00223a174174-857e-2328-55e6-395fcffb3774\\u0022]}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u5206\\u914D\\u83DC\\u5355\\u6743\\u9650","TraceId":"476c6dd70974bab96e2484ff1ed4b7fa","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:51:57.303633	2025-07-28 16:51:57.313834	Succeeded
3595776189596008461	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008461","cap-corr-id":"3595776189596008461","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:29"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:29.8009887+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"c3c991571f397d82e8dab27272eb6dbd","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:29.80318	2025-07-28 16:46:29.811607	Succeeded
3595776189596008462	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008462","cap-corr-id":"3595776189596008462","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:29"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:29.8514407+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"f04cb8808073002ff26522e74452e2fb","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:29.851582	2025-07-28 16:46:29.858632	Succeeded
3595776189596008465	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008465","cap-corr-id":"3595776189596008465","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:39"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:39.0120788+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"1ee9b3aca7f96e0a260fb120749e7a5c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:39.012263	2025-07-28 16:46:39.021622	Succeeded
3595776189596008466	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008466","cap-corr-id":"3595776189596008466","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:39"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:39.0435411+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"aeb3709aba8fb3f1d959f0cdae992711","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:39.043767	2025-07-28 16:46:39.050651	Succeeded
3595776189596008469	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008469","cap-corr-id":"3595776189596008469","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.7983262+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0e537e170cc04e79647d088cc722815d","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:43.798557	2025-07-28 16:46:43.805554	Succeeded
3595776189596008482	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008482","cap-corr-id":"3595776189596008482","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.3306817+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"757fac8794844e0ef0b9e162bc6bb0b6","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:50.330856	2025-07-28 16:53:50.336778	Succeeded
3595776189596008485	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008485","cap-corr-id":"3595776189596008485","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:58"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T16:53:58.4262333+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"3a6a52bf8e08dc56e0c553afdcc98ea0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:58.427172	2025-07-28 16:53:58.433288	Succeeded
3595776189596008486	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008486","cap-corr-id":"3595776189596008486","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:58"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T16:53:58.4885647+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"b0f61adaac14abadfdd20057b88074f6","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:58.488736	2025-07-28 16:53:58.495563	Succeeded
\.


--
-- Data for Name: received; Type: TABLE DATA; Schema: cap; Owner: postgres
--

COPY cap.received ("Id", "Version", "Name", "Group", "Content", "Retries", "Added", "ExpiresAt", "StatusName") FROM stdin;
3595776189596008471	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008469","cap-corr-id":"3595776189596008469","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.7983262+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0e537e170cc04e79647d088cc722815d","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:44.644665	2025-07-28 16:46:44.719375	Succeeded
3595776189596008484	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008482","cap-corr-id":"3595776189596008482","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.3306817+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"757fac8794844e0ef0b9e162bc6bb0b6","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:51.130486	2025-07-28 16:53:51.179046	Succeeded
3595776189596008450	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008449","cap-corr-id":"3595776189596008449","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 15:44:59","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469929745626697728","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T15:45:00.6357359+08:00","Id":"6886497c-83c0-4b38-0034-fa222d8e3040"}}	0	2025-07-27 15:45:00.415885	2025-07-28 15:45:00.762168	Succeeded
3595776189596008476	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008475","cap-corr-id":"3595776189596008475","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:52:48","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c","Method":"PUT","RequestTime":"2025-07-27T16:52:48.2020119+08:00","ResponseTime":"2025-07-27T16:52:48.231875+08:00","Duration":30,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022RoleName\\u0022:\\u0022\\u6D4B\\u8BD5\\u0022,\\u0022Remark\\u0022:\\u0022\\u6D4B\\u8BD5\\u83DC\\u5355\\u6743\\u9650\\u0022,\\u0022IsEnabled\\u0022:true}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u89D2\\u8272","TraceId":"3bbbf64cf7e715cbddd616be411e0891","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:52:48.976244	2025-07-28 16:52:49.052017	Succeeded
3595776189596008452	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008451","cap-corr-id":"3595776189596008451","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 16:37:15","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469942895910588416","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T16:37:15.8035406+08:00","Id":"688655bb-83c0-4b38-0034-fa577ee5667e"}}	0	2025-07-27 16:37:15.775088	2025-07-28 16:37:15.812973	Succeeded
3595776189596008454	v1	log_record_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008453","cap-corr-id":"3595776189596008453","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:42:24","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Type":"\\u5B57\\u5178\\u6570\\u636E","SubType":"\\u7F16\\u8F91\\u5B57\\u5178\\u6570\\u636E","BizNo":"68602622-e22b-e780-00f8-5c9d688361b4","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u503C=1,\\u542F\\u7528=True","TraceId":"9a950cae333377316b799fb0ddd70449","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:42:24.2061492+08:00"}}	0	2025-07-27 16:42:24.776111	2025-07-28 16:42:24.861752	Succeeded
3595776189596008474	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008473","cap-corr-id":"3595776189596008473","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:51:57","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus","Method":"PUT","RequestTime":"2025-07-27T16:51:57.1929992+08:00","ResponseTime":"2025-07-27T16:51:57.3033286+08:00","Duration":110,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022RoleId\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022MenuIds\\u0022:[\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u00223a13bcfd-52bb-db4a-d508-eea8536c8bdc\\u0022,\\u00223a174174-857e-2328-55e6-395fcffb3774\\u0022]}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u5206\\u914D\\u83DC\\u5355\\u6743\\u9650","TraceId":"476c6dd70974bab96e2484ff1ed4b7fa","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:51:58.12355	2025-07-28 16:51:58.191724	Succeeded
3595776189596008487	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008485","cap-corr-id":"3595776189596008485","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:58","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T16:53:58.4262333+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"3a6a52bf8e08dc56e0c553afdcc98ea0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:59.439494	2025-07-28 16:53:59.487728	Succeeded
3595776189596008488	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008486","cap-corr-id":"3595776189596008486","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:58","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T16:53:58.4885647+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"b0f61adaac14abadfdd20057b88074f6","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:59.497603	2025-07-28 16:53:59.550038	Succeeded
3595776189596008457	v1	log_record_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008455","cap-corr-id":"3595776189596008455","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:44:11","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Type":"\\u914D\\u7F6E\\u7BA1\\u7406","SubType":"\\u7F16\\u8F91\\u914D\\u7F6E","BizNo":"68758b9b-e6de-0d4c-0000-b9861878b283","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u952E=StorageType\\uFF0C\\u503C=1\\uFF0C\\u7EC4=System","TraceId":"fda514554eb678cf78a78392545893b4","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:44:11.2352973+08:00"}}	0	2025-07-27 16:44:11.622217	2025-07-28 16:44:11.754318	Succeeded
3595776189596008479	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008477","cap-corr-id":"3595776189596008477","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.7520157+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"cc6f0b646c3dad1af01d0c7d524a21a0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.826366	2025-07-28 16:53:47.876009	Succeeded
3595776189596008480	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008478","cap-corr-id":"3595776189596008478","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.782176+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0f967483acb706f1afd3f68dd545f944","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.884244	2025-07-28 16:53:47.929256	Succeeded
3595776189596008458	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008456","cap-corr-id":"3595776189596008456","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:11","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/settings","Method":"PUT","RequestTime":"2025-07-27T16:44:10.9081541+08:00","ResponseTime":"2025-07-27T16:44:11.2587541+08:00","Duration":351,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u002268758b9b-e6de-0d4c-0000-b9861878b283\\u0022,\\u0022Name\\u0022:\\u0022\\u6587\\u4EF6\\u5B58\\u50A8\\u9A71\\u52A8\\u7C7B\\u578B\\u0022,\\u0022Key\\u0022:\\u0022StorageType\\u0022,\\u0022Value\\u0022:\\u00221\\u0022,\\u0022GroupKey\\u0022:\\u0022System\\u0022,\\u0022Remark\\u0022:\\u0022\\u672C\\u5730\\u670D\\u52A1\\u5668=1\\uFF0C\\u963F\\u91CC\\u4E91OSS=2\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u914D\\u7F6E","TraceId":"fda514554eb678cf78a78392545893b4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:11.788432	2025-07-28 16:44:11.974333	Succeeded
3595776189596008460	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008459","cap-corr-id":"3595776189596008459","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:16","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/tenants","Method":"PUT","RequestTime":"2025-07-27T16:44:16.638703+08:00","ResponseTime":"2025-07-27T16:44:16.6997772+08:00","Duration":61,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00226876c45d-e5f2-35dc-00d1-48ee38eafd16\\u0022,\\u0022Name\\u0022:\\u0022\\u6E56\\u5357\\u5C0F\\u5356\\u90E8\\u0022,\\u0022TenantId\\u0022:\\u0022hn_market\\u0022,\\u0022Remark\\u0022:null,\\u0022Domain\\u0022:\\u0022hn.market.crackerwork.cn\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u79DF\\u6237","TraceId":"cdeef92f21253c78c6e7648ec7aea1f1","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:17.170458	2025-07-28 16:44:17.269763	Succeeded
3595776189596008472	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008470","cap-corr-id":"3595776189596008470","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.8248107+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"abc990ab158cca08fbf3cdc0f710984a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:44.729255	2025-07-28 16:46:44.777569	Succeeded
3595776189596008483	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008481","cap-corr-id":"3595776189596008481","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.2809683+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"20c035c0b3df346e568ea6708f11a0df","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:51.031446	2025-07-28 16:53:51.120681	Succeeded
3595776189596008463	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008461","cap-corr-id":"3595776189596008461","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:29","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:29.8009887+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"c3c991571f397d82e8dab27272eb6dbd","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:29.930071	2025-07-28 16:46:29.978027	Succeeded
3595776189596008464	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008462","cap-corr-id":"3595776189596008462","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:29","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:29.8514407+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"f04cb8808073002ff26522e74452e2fb","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:29.984019	2025-07-28 16:46:30.019526	Succeeded
3595776189596008467	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008465","cap-corr-id":"3595776189596008465","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:39","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:39.0120788+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"1ee9b3aca7f96e0a260fb120749e7a5c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:39.331911	2025-07-28 16:46:39.395403	Succeeded
3595776189596008468	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008466","cap-corr-id":"3595776189596008466","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:39","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:39.0435411+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"aeb3709aba8fb3f1d959f0cdae992711","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:39.414995	2025-07-28 16:46:39.470469	Succeeded
\.


--
-- Data for Name: api_access_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_access_log (id, creator_id, creation_time, path, method, ip, request_time, response_time, duration, user_id, user_name, request_body, response_body, browser, query_string, trace_id, operate_type, operate_name, tenant_id) FROM stdin;
68848c0d-b246-eb1c-00f9-f33f51dd0d50	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-26 08:04:29.631622	/api/OnlineUser/GetOnlineUserList	GET	::1	2025-07-26 08:04:28.568117	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	db5020ba8039c79ce67d950f57d50be6	{2}	在线用户列表	\N
68848c0d-b246-eb1c-00f9-f3402df49d0d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-26 08:04:29.866071	/api/OnlineUser/GetOnlineUserList	GET	::1	2025-07-26 08:04:29.010323	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d0e8ea793f049412dfc61c516a91410d	{2}	在线用户列表	\N
68848c25-b246-eb1c-00f9-f341292a68ae	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-26 08:04:53.938973	/api/menu/list	GET	::1	2025-07-26 08:04:52.825541	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	1e860296ce9978fd6c0a07ddbf49ef25	{2}	\N	\N
68848c26-b246-eb1c-00f9-f34262f4d45a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-26 08:04:54.055233	/api/menu/list	GET	::1	2025-07-26 08:04:53.1325	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	35aeb9fa7373c9c35bcc5cd17138de49	{2}	\N	\N
6885faa3-adfa-4e0c-0012-a73d5d70160b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:08:35.880452	/api/admin/users	GET	::1	2025-07-27 10:08:35.421348	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	bddd716271a1aefe2b605a40ff0248e3	\N	用户分页列表	\N
6885faa3-adfa-4e0c-0012-a73e3fcc1f6a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:08:35.99482	/api/admin/users	GET	::1	2025-07-27 10:08:35.548192	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2a7ff47ef0a166bc323de478768e149c	\N	用户分页列表	\N
6885faf9-adfa-4e0c-0012-a7411a0dfd54	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:01.779043	/api/admin/users	GET	::1	2025-07-27 10:10:00.875892	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	8f2134839509239d15d4567a7cc79c7a	\N	用户分页列表	\N
6885faf9-adfa-4e0c-0012-a7424402a02f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:01.817036	/api/admin/users	GET	::1	2025-07-27 10:10:00.906148	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	55218186137516529150976ba6a90b0c	\N	用户分页列表	\N
6885fafc-adfa-4e0c-0012-a743668bc49d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:04.996586	/api/admin/menus	GET	::1	2025-07-27 10:10:04.078596	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	54103b98cf64d9c1c4d5df3f3a806b17	{2}	\N	\N
6885fafd-adfa-4e0c-0012-a74454367419	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:05.087592	/api/admin/menus	GET	::1	2025-07-27 10:10:04.136489	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2320b2e4776e986f904bf97c3020e3db	{2}	\N	\N
6885fb26-adfa-4e0c-0012-a74546cd41ae	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:46.596937	/api/admin/online-users	GET	::1	2025-07-27 10:10:46.096681	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	9138761fc1131d59b3538cbe7ced6a45	{2}	在线用户列表	\N
6885fb26-adfa-4e0c-0012-a7462b96fc21	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:46.638034	/api/admin/online-users	GET	::1	2025-07-27 10:10:46.153831	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	321ff740e0a155165b9d3ccb4f400f5b	{2}	在线用户列表	\N
6885fb33-adfa-4e0c-0012-a74702cb6d5c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:59.020423	/api/admin/online-users	GET	::1	2025-07-27 10:10:58.470879	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	de080b1a5c0c26d095b6cf521a90b374	{2}	在线用户列表	\N
6885fb33-adfa-4e0c-0012-a7483d45183a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:10:59.099018	/api/admin/online-users	GET	::1	2025-07-27 10:10:58.540596	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	267786f48a29a5527d2ca81efb89db2b	{2}	在线用户列表	\N
6885fb46-adfa-4e0c-0012-a74a4acf0f84	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:11:18.75525	/api/admin/menus	GET	::1	2025-07-27 10:11:18.652301	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	e8d9d56355f8757db6f8cd2827b12b2e	{2}	\N	\N
6885fb46-adfa-4e0c-0012-a74b364611a2	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:11:18.811929	/api/admin/menus	GET	::1	2025-07-27 10:11:18.684917	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	e1a73a24caed36e2cabb4ad27f1d1148	{2}	\N	\N
6885fcdf-adfa-4e0c-0012-a7530d8350a8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:18:07.208091	/api/admin/menus	GET	::1	2025-07-27 10:18:07.062788	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	49eabbc9c7e04ea782fe9c80c31a91b2	{2}	\N	\N
6885fe6f-adfa-4e0c-0012-a75a3013ad76	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:24:47.856093	/api/admin/menus	GET	::1	2025-07-27 10:24:47.126643	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	848fcde8a87e1d039394deed87fa8008	{2}	\N	\N
6885fe6f-adfa-4e0c-0012-a75b4142a657	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:24:47.915923	/api/admin/menus	GET	::1	2025-07-27 10:24:47.167822	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	728502a759b02ac422919ffe4a1db6d8	{2}	\N	\N
68860569-adfa-4e0c-0012-a78b03f73fb4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:54:33.596295	/api/admin/users	GET	::1	2025-07-27 10:54:33.027186	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	fba10d742e5e7355ec4d1edf5404ce7a	\N	用户分页列表	\N
6885fe77-adfa-4e0c-0012-a75c3f960b39	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:24:55.234426	/api/admin/menus	PUT	::1	2025-07-27 10:24:54.049925	2025-07-27 10:24:54.2253	175	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"3a13a4fe-6f74-733b-a628-6125c0325481","Title":"组织架构","Icon":"antd:TeamOutlined","Path":"/admin","MenuType":1,"Permission":null,"ParentId":null,"Sort":1,"Display":true,"Component":null,"IsExternal":false}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		ebde6ea815ea6cad2306e701e697d709	{3}	修改菜单	\N
6885fe77-adfa-4e0c-0012-a75d7592fb11	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:24:55.370451	/api/admin/menus	GET	::1	2025-07-27 10:24:54.273931	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	7b9300fb350788a6a26848819fe34b61	{2}	\N	\N
6885fe80-adfa-4e0c-0012-a75f5e04d01c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:25:04.705803	/api/admin/menus	PUT	::1	2025-07-27 10:25:04.46234	2025-07-27 10:25:04.513121	51	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"3a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361","Title":"职位管理","Icon":null,"Path":"/admin/positions","MenuType":2,"Permission":null,"ParentId":"3a13a4fe-6f74-733b-a628-6125c0325481","Sort":2,"Display":true,"Component":"org/position","IsExternal":false}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		7239431f0e1943ad53d7e7b4340eed02	{3}	修改菜单	\N
6885fe80-adfa-4e0c-0012-a760082d3a14	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:25:04.782514	/api/admin/menus	GET	::1	2025-07-27 10:25:04.548061	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d9496ce2500032d29d4d4822ff89d734	{2}	\N	\N
6886036e-adfa-4e0c-0012-a77845161e07	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:46:06.489995	/api/admin/employees/68860360-adfa-4e0c-0012-a7760a0242a1	DELETE	::1	2025-07-27 10:46:05.462264	2025-07-27 10:46:05.499156	37	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"68860360-adfa-4e0c-0012-a7760a0242a1"}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		5ad066caa80d686b080c8d29b60fbc82	{4}	删除员工	\N
688604fe-adfa-4e0c-0012-a77f632a201f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:52:46.474002	/api/admin/menus	GET	::1	2025-07-27 10:52:46.37369	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	82bbdc666ca8a5f063f9e05edf4498af	{2}	\N	\N
688604fe-adfa-4e0c-0012-a78028f0dcde	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:52:46.525677	/api/admin/menus	GET	::1	2025-07-27 10:52:46.408736	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	8716d68a8ea9d482609648ea9bd2d55e	{2}	\N	\N
68860518-adfa-4e0c-0012-a78232e5855f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:53:12.539904	/api/admin/menus	PUT	::1	2025-07-27 10:53:11.788393	2025-07-27 10:53:11.824908	37	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"3a13bcf2-3701-be8e-4ec8-ad5f77536101","Title":"职位分组","Icon":"","Path":"/admin/position/groups","MenuType":2,"Permission":null,"ParentId":"3a13a4fe-6f74-733b-a628-6125c0325481","Sort":1,"Display":true,"Component":"org/positionGroup","IsExternal":false}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		6c496a0868f18e11bdddbe1d9dc8d6c5	{3}	修改菜单	\N
68860518-adfa-4e0c-0012-a7837a0e5aef	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:53:12.590386	/api/admin/menus	GET	::1	2025-07-27 10:53:11.85195	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d954bef62ce033e8f6395430323cf0e0	{2}	\N	\N
6886051f-adfa-4e0c-0012-a78448aa1f67	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:53:19.922423	/api/admin/menus	PUT	::1	2025-07-27 10:53:19.359038	2025-07-27 10:53:19.395946	37	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"3a13bcf2-3701-be8e-4ec8-ad5f77536101","Title":"职位分组","Icon":"","Path":"/admin/positions/groups","MenuType":2,"Permission":null,"ParentId":"3a13a4fe-6f74-733b-a628-6125c0325481","Sort":1,"Display":true,"Component":"org/positionGroup","IsExternal":false}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		d7646796e543d2c2c889f4abcb231efd	{3}	修改菜单	\N
6886051f-adfa-4e0c-0012-a7851855e5f6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:53:19.959001	/api/admin/menus	GET	::1	2025-07-27 10:53:19.421734	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	cdbe799b98321bb6d19c5ce6e09510e4	{2}	\N	\N
68860553-adfa-4e0c-0012-a78821491ece	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:54:11.698377	/api/admin/users	GET	::1	2025-07-27 10:54:10.612431	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	fc1bd434180f50ca249ae907097d910a	\N	用户分页列表	\N
68860553-adfa-4e0c-0012-a789112d45f4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:54:11.742512	/api/admin/users	GET	::1	2025-07-27 10:54:10.642993	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	682d9e94bf8fc65b095156837e8d94f7	\N	用户分页列表	\N
68860569-adfa-4e0c-0012-a78a654fac44	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:54:33.542171	/api/admin/users	GET	::1	2025-07-27 10:54:32.994503	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2ea994cfd806f4d0eea19d9919230cb8	\N	用户分页列表	\N
688605fe-adfa-4e0c-0012-a78f06a8408d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:57:02.471808	/api/admin/menus	GET	::1	2025-07-27 10:57:01.832434	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	3a527112f1d920c535736614c2690ea4	{2}	\N	\N
688605fe-adfa-4e0c-0012-a7901a31f1fb	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:57:02.560484	/api/admin/menus	GET	::1	2025-07-27 10:57:01.865007	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c071716b7821334cc8c73f23c7b64474	{2}	\N	\N
6886064e-adfa-4e0c-0012-a7920b01f250	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:58:22.531439	/api/admin/menus	GET	::1	2025-07-27 10:58:22.182593	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	85a28218f2b2e80f57a884adb7eed36c	{2}	\N	\N
6886064e-adfa-4e0c-0012-a793719e5e99	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 10:58:22.653299	/api/admin/menus	GET	::1	2025-07-27 10:58:22.218743	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	bf0779630692338ff7f34b8c470f87b5	{2}	\N	\N
688606c1-adfa-4e0c-0012-a7964f03e01e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:00:17.574249	/api/admin/menus	GET	::1	2025-07-27 11:00:16.49785	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	6aa95bcb3c22352a8b76c91472af59ba	{2}	\N	\N
688606c1-adfa-4e0c-0012-a79734133866	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:00:17.683348	/api/admin/menus	GET	::1	2025-07-27 11:00:16.555423	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d38e96d7bba6881e90e78413685513cc	{2}	\N	\N
68860717-adfa-4e0c-0012-a79904df06c6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:01:43.725561	/api/admin/menus	GET	::1	2025-07-27 11:01:43.488003	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d73b4509da352404c2ccb5428ad6a5e1	{2}	\N	\N
68860717-adfa-4e0c-0012-a79a5e0e377d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:01:43.785533	/api/admin/menus	GET	::1	2025-07-27 11:01:43.516679	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c001b241d228590e25ff914e83ddca12	{2}	\N	\N
688608c9-adfa-4e0c-0012-a7a23e796aeb	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:08:57.341967	/api/admin/online-users	GET	::1	2025-07-27 11:08:56.307166	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	b80eeecaff64cb74dc9d26e64abc282f	{2}	在线用户列表	\N
688608c9-adfa-4e0c-0012-a7a33d267082	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:08:57.44736	/api/admin/online-users	GET	::1	2025-07-27 11:08:56.404575	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	54dc1da2c133b3b19bf062b973fd7849	{2}	在线用户列表	\N
688608ef-adfa-4e0c-0012-a7a54d418f6e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:09:35.759355	/api/admin/menus	GET	::1	2025-07-27 11:09:35.438694	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2014afeeca7c43e6d04dc30c636efc03	{2}	\N	\N
688608ef-adfa-4e0c-0012-a7a674ff2119	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:09:35.919718	/api/admin/menus	GET	::1	2025-07-27 11:09:35.473041	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	24707a96eeeff143ec56992f92397a0b	{2}	\N	\N
68860912-adfa-4e0c-0012-a7a8152ccac8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:10.053607	/api/admin/menus	PUT	::1	2025-07-27 11:10:09.271639	2025-07-27 11:10:09.319642	48	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"6865a9ef-4217-02ac-0070-b65a7ed7d760","Title":"访问日志","Icon":null,"Path":"/admin/loggings/access","MenuType":2,"Permission":null,"ParentId":"3a174174-857e-2328-55e6-395fcffb3774","Sort":3,"Display":true,"Component":"monitor/apiAccessLog","IsExternal":false}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		b36a2569f564a373ac5b39e70130a9b4	{3}	修改菜单	\N
68860912-adfa-4e0c-0012-a7a9147c8c71	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:10.133902	/api/admin/menus	GET	::1	2025-07-27 11:10:09.375384	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	f341f4c3698af096fdfe7dceba7ce482	{2}	\N	\N
68860923-adfa-4e0c-0012-a7ab5877fdc4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:27.899041	/api/admin/online-users	GET	::1	2025-07-27 11:10:26.895457	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	1cf8bbc3d389c6880f5b4893a33edee7	{2}	在线用户列表	\N
68860923-adfa-4e0c-0012-a7ac205a9a56	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:27.977123	/api/admin/online-users	GET	::1	2025-07-27 11:10:26.941762	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	50b5c931cea0da483edd6a3da296b13f	{2}	在线用户列表	\N
6886092b-adfa-4e0c-0012-a7ad292d519b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:35.328232	/api/admin/menus	GET	::1	2025-07-27 11:10:34.508952	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	274cfb47d8b698e9ae464a5447921416	{2}	\N	\N
6886092b-adfa-4e0c-0012-a7ae12f869f2	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:35.500019	/api/admin/menus	GET	::1	2025-07-27 11:10:34.543487	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	346128b4d1ac8bb6bac2b47001c32b15	{2}	\N	\N
6886092d-adfa-4e0c-0012-a7af60091d85	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:37.662761	/api/admin/users	GET	::1	2025-07-27 11:10:37.0093	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d3cd54986710c5ea6fd9fb83b2ccba95	\N	用户分页列表	\N
6886092d-adfa-4e0c-0012-a7b00e8f7e5a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 11:10:37.768642	/api/admin/users	GET	::1	2025-07-27 11:10:37.044089	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	35bcfdc4987c51369da4154f0f55b10e	\N	用户分页列表	\N
6886575b-83c0-4b38-0034-fa61731e6d2b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:44:11.900401	/api/admin/settings	PUT	::1	2025-07-27 16:44:10.908154	2025-07-27 16:44:11.258754	351	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"68758b9b-e6de-0d4c-0000-b9861878b283","Name":"文件存储驱动类型","Key":"StorageType","Value":"1","GroupKey":"System","Remark":"本地服务器=1，阿里云OSS=2"}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		fda514554eb678cf78a78392545893b4	{3}	修改配置	\N
68865761-83c0-4b38-0034-fa620b6900ff	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:44:17.261022	/api/admin/tenants	PUT	::1	2025-07-27 16:44:16.638703	2025-07-27 16:44:16.699777	61	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":"6876c45d-e5f2-35dc-00d1-48ee38eafd16","Name":"湖南小卖部","TenantId":"hn_market","Remark":null,"Domain":"hn.market.crackerwork.cn"}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		cdeef92f21253c78c6e7648ec7aea1f1	{3}	修改租户	\N
688657e5-83c0-4b38-0034-fa6541a93d17	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:46:29.972152	/api/admin/users	GET	::1	2025-07-27 16:46:29.800988	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c3c991571f397d82e8dab27272eb6dbd	\N	用户分页列表	\N
688657e6-83c0-4b38-0034-fa662516ed65	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:46:30.014858	/api/admin/users	GET	::1	2025-07-27 16:46:29.85144	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	f04cb8808073002ff26522e74452e2fb	\N	用户分页列表	\N
688657ef-83c0-4b38-0034-fa67053558b1	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:46:39.388926	/api/admin/users	GET	::1	2025-07-27 16:46:39.012078	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	1ee9b3aca7f96e0a260fb120749e7a5c	\N	用户分页列表	\N
688657ef-83c0-4b38-0034-fa6879dc3410	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:46:39.46486	/api/admin/users	GET	::1	2025-07-27 16:46:39.043541	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	aeb3709aba8fb3f1d959f0cdae992711	\N	用户分页列表	\N
688657f4-83c0-4b38-0034-fa6950bbe680	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:46:44.712252	/api/admin/users	GET	::1	2025-07-27 16:46:43.798326	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	0e537e170cc04e79647d088cc722815d	\N	用户分页列表	\N
688657f4-83c0-4b38-0034-fa6a12a07ed0	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:46:44.772501	/api/admin/users	GET	::1	2025-07-27 16:46:43.82481	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	abc990ab158cca08fbf3cdc0f710984a	\N	用户分页列表	\N
6886592e-83c0-4b38-0034-fa7414d333f6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:51:58.185223	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus	PUT	::1	2025-07-27 16:51:57.192999	2025-07-27 16:51:57.303328	110	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"687047ef-1649-9660-0098-4182062f682c","dto":{"RoleId":"687047ef-1649-9660-0098-4182062f682c","MenuIds":["3a13a4fe-6f74-733b-a628-6125c0325481","3a13bcf2-3701-be8e-4ec8-ad5f77536101","3a13bcfd-52bb-db4a-d508-eea8536c8bdc","3a174174-857e-2328-55e6-395fcffb3774"]}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		476c6dd70974bab96e2484ff1ed4b7fa	{3}	分配菜单权限	\N
68865961-83c0-4b38-0034-fa765178a4f6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:52:49.0439	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c	PUT	::1	2025-07-27 16:52:48.202011	2025-07-27 16:52:48.231875	30	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"687047ef-1649-9660-0098-4182062f682c","dto":{"Id":"687047ef-1649-9660-0098-4182062f682c","RoleName":"测试","Remark":"测试菜单权限","IsEnabled":true}}	{"Value":{"Code":"0","Message":null,"Data":true},"Formatters":[],"ContentTypes":[],"DeclaredType":"Letu.Shared.Models.AppResponse`1[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null","StatusCode":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		3bbbf64cf7e715cbddd616be411e0891	{3}	修改角色	\N
6886599b-83c0-4b38-0034-fa7856abe33a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:53:47.868534	/api/admin/users	GET	::1	2025-07-27 16:53:47.752015	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	cc6f0b646c3dad1af01d0c7d524a21a0	\N	用户分页列表	\N
6886599b-83c0-4b38-0034-fa792e9537be	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:53:47.923923	/api/admin/users	GET	::1	2025-07-27 16:53:47.782176	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	0f967483acb706f1afd3f68dd545f944	\N	用户分页列表	\N
6886599f-83c0-4b38-0034-fa7a7a9111da	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:53:51.110029	/api/admin/menus	GET	::1	2025-07-27 16:53:50.280968	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	20c035c0b3df346e568ea6708f11a0df	{2}	\N	\N
6886599f-83c0-4b38-0034-fa7b0d026568	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:53:51.173457	/api/admin/menus	GET	::1	2025-07-27 16:53:50.330681	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	757fac8794844e0ef0b9e162bc6bb0b6	{2}	\N	\N
688659a7-83c0-4b38-0034-fa7c1b5346c2	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:53:59.482711	/api/admin/online-users	GET	::1	2025-07-27 16:53:58.426233	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	3a6a52bf8e08dc56e0c553afdcc98ea0	{2}	在线用户列表	\N
688659a7-83c0-4b38-0034-fa7d004a3a8a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:53:59.544368	/api/admin/online-users	GET	::1	2025-07-27 16:53:58.488564	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	b0f61adaac14abadfdd20057b88074f6	{2}	在线用户列表	\N
6888e026-4bd6-2248-0033-d98d5d3c8b6e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:52:22.385977	/api/admin/users	GET	::1	2025-07-29 14:52:22.208835	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	6d185b8c64601fef5b642f4b0dd52bfb	\N	用户分页列表	\N
6888e026-4bd6-2248-0033-d98e6de4ee07	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:52:22.459415	/api/admin/users	GET	::1	2025-07-29 14:52:22.401319	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	6e3f6da13e668fb19d4bf0f66babccfa	\N	用户分页列表	\N
6888e02a-4bd6-2248-0033-d98f3ddc9e24	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:52:26.508468	/api/admin/menus	GET	::1	2025-07-29 14:52:26.432361	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	0acb462bf87d00a2f6c49aca15ea5060	{2}	\N	\N
6888e02a-4bd6-2248-0033-d99056f84a06	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:52:26.624181	/api/admin/menus	GET	::1	2025-07-29 14:52:26.527738	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	08717decbf33b6501117ccff19b94a07	{2}	\N	\N
6888e2af-fa0e-1c34-002b-ca7427c6631c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:03:11.404598	/api/admin/users	GET	::1	2025-07-29 15:03:11.276193	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	54c8a947d8ec5a9fc380b11d06f02807	\N	用户分页列表	\N
6888e2af-fa0e-1c34-002b-ca7556e030b0	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:03:11.644454	/api/admin/users	GET	::1	2025-07-29 15:03:11.544857	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	ebeb4457f1e829dfb9abd880f2495a92	\N	用户分页列表	\N
6888e2b2-fa0e-1c34-002b-ca7638101e23	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:03:14.518333	/api/admin/menus	GET	::1	2025-07-29 15:03:14.443454	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	f4cca97dbf4c54d548d0b1018a5c1110	{2}	\N	\N
6888e2b2-fa0e-1c34-002b-ca7776719392	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:03:14.590436	/api/admin/menus	GET	::1	2025-07-29 15:03:14.542442	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	8f608453dc65bacc285b0b3f0af0edb3	{2}	\N	\N
6888e41a-aa3b-a858-0035-efef5c36bf13	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:09:14.446885	/api/admin/menus	GET	::1	2025-07-29 15:09:13.141191	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	bc81c4d5b6535605d51bdabc5c4a8384	{2}	\N	\N
6888e41b-aa3b-a858-0035-eff063766a17	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:09:15.013824	/api/admin/menus	GET	::1	2025-07-29 15:09:14.920534	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	737502a7079b26208f1035d84c393d9b	{2}	\N	\N
6888e636-97f4-a6b4-0020-819e3dce1fd6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:18:14.861333	/api/admin/online-users	GET	::1	2025-07-29 15:18:14.740772	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2b151741d8e643a76bbd1a354e4b8563	{2}	在线用户列表	\N
6888e636-97f4-a6b4-0020-819f6e0e8f5c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:18:14.959184	/api/admin/online-users	GET	::1	2025-07-29 15:18:14.885897	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	88ffaf074af94c4adff3c136bde60884	{2}	在线用户列表	\N
68890fa2-21b2-19c0-00d4-131f6272f44f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:14:58.534575	/api/admin/users	GET	::1	2025-07-29 18:14:58.445181	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c4b94ee2807a3a1555715c17c06c5fad	\N	用户分页列表	\N
68890fa2-21b2-19c0-00d4-13200f45828b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:14:58.607288	/api/admin/users	GET	::1	2025-07-29 18:14:58.558464	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	0c218f2982c0fc86357c58758fd72bb1	\N	用户分页列表	\N
68890fc3-21b2-19c0-00d4-13253b8b38bd	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:15:31.362907	/api/admin/users	GET	::1	2025-07-29 18:15:31.300062	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c548fce4cccd85f591980845920aaa40	\N	用户分页列表	\N
68890fc3-21b2-19c0-00d4-132615d5bdc4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:15:31.425259	/api/admin/users	GET	::1	2025-07-29 18:15:31.37507	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c843d06d975000e5a40a98a9e71e8cc7	\N	用户分页列表	\N
68890fcf-21b2-19c0-00d4-132c5577984c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:15:43.415164	/api/admin/users/reset-password	PUT	::1	2025-07-29 18:15:43.253385	2025-07-29 18:15:43.383135	130	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserId":"00de38c4-17bd-415f-bf1c-2e0873eb177e","Password":"123qwe*"}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		32850d750e735878505a1a45a0d80115	{3}	重置用户密码	\N
68891169-9894-256c-00d8-1ccc32bfcb9d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:22:33.385193	/api/admin/users	GET	::1	2025-07-29 18:22:33.278254	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	de136f6865de582ee6ec0009c2386124	\N	用户分页列表	\N
68891169-9894-256c-00d8-1ccd19ee814f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:22:33.506457	/api/admin/users	GET	::1	2025-07-29 18:22:33.445613	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	3e71ed2a2b96e0f93ea465fa889e8800	\N	用户分页列表	\N
688911b7-9894-256c-00d8-1cd3607eb89f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:23:51.914536	/api/admin/users/3e64db48-e302-46f7-87d8-dc3f8c4bd428/assign-role	POST	::1	2025-07-29 18:23:51.820167	2025-07-29 18:23:51.883964	64	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"3e64db48-e302-46f7-87d8-dc3f8c4bd428","input":{"RoleIds":["687047ef-1649-9660-0098-4182062f682c"]}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		2c89ef62d2d1214989cccdd56b0940f6	{3}	分配角色	\N
688911c5-9894-256c-00d8-1cd80afaae4d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:05.798192	/api/admin/users	POST	::1	2025-07-29 18:24:05.694378	2025-07-29 18:24:05.768512	74	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":null,"UserName":"admin1","Password":"123qwe*","Avatar":null,"NickName":"111","Sex":1,"Phone":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		f4a9981c6ee25730126b26892d5d9445	{1}	新增用户	\N
688911cc-9894-256c-00d8-1cdf51ec7685	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:12.832722	/api/admin/users/89d5a892-4153-459b-89cb-b5fa7ccfabc2/assign-role	POST	::1	2025-07-29 18:24:12.720697	2025-07-29 18:24:12.764311	44	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"89d5a892-4153-459b-89cb-b5fa7ccfabc2","input":{"RoleIds":["3a172369-28a4-e37e-b78a-8c3eaec17359"]}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		6136440295679eb4f3ba10893438914c	{3}	分配角色	\N
688911d9-9894-256c-00d8-1cf252e004a2	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:25.328374	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c	PUT	::1	2025-07-29 18:24:25.207747	2025-07-29 18:24:25.270323	63	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"687047ef-1649-9660-0098-4182062f682c","dto":{"Id":"687047ef-1649-9660-0098-4182062f682c","RoleName":"\\u6D4B\\u8BD5","Remark":"\\u6D4B\\u8BD5\\u83DC\\u5355\\u6743\\u9650","IsEnabled":true}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		71db0b931af2660730f689955e8cad34	{3}	修改角色	\N
688911c5-9894-256c-00d8-1cd9740938b5	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:05.870889	/api/admin/users	GET	::1	2025-07-29 18:24:05.819675	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	3472424a7ce394ae3a4b8d635aedf64d	\N	用户分页列表	\N
688911d0-9894-256c-00d8-1ce40f9fec56	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:16.618517	/api/admin/users	GET	::1	2025-07-29 18:24:16.577082	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	b062a428a800374b5c268caf10e8d75a	\N	用户分页列表	\N
688911d5-9894-256c-00d8-1ced1514c9ff	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:21.789139	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus	PUT	::1	2025-07-29 18:24:21.67863	2025-07-29 18:24:21.756242	78	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"687047ef-1649-9660-0098-4182062f682c","dto":{"RoleId":"687047ef-1649-9660-0098-4182062f682c","MenuIds":["3a13a4fe-6f74-733b-a628-6125c0325481","3a13bcf2-3701-be8e-4ec8-ad5f77536101","3a13bcfd-52bb-db4a-d508-eea8536c8bdc","3a174174-857e-2328-55e6-395fcffb3774"]}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		4173ff7c272e1ecc604647891b375143	{3}	分配菜单权限	\N
688911dc-9894-256c-00d8-1cf3044fcd62	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:28.769522	/api/admin/menus	GET	::1	2025-07-29 18:24:28.656463	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	bd5a32125e30335de5d254fe30e62f7f	{2}	\N	\N
688911dc-9894-256c-00d8-1cf47bcad080	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:24:28.838162	/api/admin/menus	GET	::1	2025-07-29 18:24:28.786397	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	16adf4ac9621e3cf35cc410ae220f785	{2}	\N	\N
6889f84f-d022-c7cc-0034-4d2d4535d4d4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:47:43.955051	/api/admin/users	GET	::1	2025-07-30 10:47:43.812099	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	91646cc1700b043cba386f6d6b9243c9	\N	用户分页列表	\N
6889f850-d022-c7cc-0034-4d2e255f7257	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:47:44.04015	/api/admin/users	GET	::1	2025-07-30 10:47:43.979265	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	e4f3e7e0ef9945e8db95f9fd1bae4509	\N	用户分页列表	\N
6889f85b-d022-c7cc-0034-4d3451c57cff	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:47:55.44579	/api/admin/users	POST	::1	2025-07-30 10:47:55.336231	2025-07-30 10:47:55.409494	73	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Id":null,"UserName":"admin1","Password":"123qwe*","Avatar":null,"NickName":"222","Sex":2,"Phone":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		aee0acd6eebb4118ed56840d5a946c80	{1}	新增用户	\N
6889f85b-d022-c7cc-0034-4d3535e83030	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:47:55.524922	/api/admin/users	GET	::1	2025-07-30 10:47:55.473384	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	7ffa389dcaf74af50785ffe2454d6862	\N	用户分页列表	\N
6889f9fc-c58e-60d8-0066-5ecf2015a6a9	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:54:52.984385	/api/admin/tenants	POST	::1	2025-07-30 10:54:52.848496	2025-07-30 10:54:52.917322	69	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Name":"test","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		a2e0911e55d0326446615a708c28dc42	{1}	添加租户	\N
6889fa87-c58e-60d8-0066-5ed4117e8f13	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:57:11.631161	/api/admin/tenants/6889f9fc-c58e-60d8-0066-5ecc5acf27d0	PUT	::1	2025-07-30 10:57:11.497894	2025-07-30 10:57:11.592669	95	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"6889f9fc-c58e-60d8-0066-5ecc5acf27d0","input":{"Name":"test","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		facea12ec982641d9a6e72e1c0ab4c1a	{3}	修改租户	\N
6889fc74-5050-4dc8-0093-d0304e864359	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:05:24.428952	/api/admin/tenants	POST	::1	2025-07-30 11:05:24.306293	2025-07-30 11:05:24.375448	69	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Name":"test11","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		a701eec18ae3ec470869ecbcf6a6493c	{1}	添加租户	\N
6889fdaf-0676-5e5c-0010-caa879a1cd53	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:10:39.877992	/api/admin/tenants/6889fc74-5050-4dc8-0093-d02d618ab933	PUT	::1	2025-07-30 11:10:39.725407	2025-07-30 11:10:39.828793	103	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"6889fc74-5050-4dc8-0093-d02d618ab933","input":{"Name":"test11","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		df82573fe48953d23315690a819c0ff5	{3}	修改租户	\N
688a019f-2e5c-a0f8-0014-50d04513a235	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:27:27.25876	/api/admin/tenants	POST	::1	2025-07-30 11:27:27.121061	2025-07-30 11:27:27.186803	66	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Name":"test111","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		f6f01e1e2cea4a6dc3be30332c376529	{1}	添加租户	\N
688a023b-2e5c-a0f8-0014-50d953fe2559	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:30:03.566993	/api/admin/tenants	POST	::1	2025-07-30 11:30:03.493881	2025-07-30 11:30:03.538945	45	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Name":"\\u963F\\u8428","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		cc73ef39c98aab4d2a5970d3f68684bd	{1}	添加租户	\N
7fd7c47c-9226-58c7-7830-3a1b6c22e6ac	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 14:12:34.60496	/api/admin/tenants/688a023b-2e5c-a0f8-0014-50d6450e48fc	PUT	::1	2025-07-30 14:12:32.898747	2025-07-30 14:12:33.565824	667	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"688a023b-2e5c-a0f8-0014-50d6450e48fc","input":{"Name":"\\u963F\\u8428","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		ece43632048d69b690934f0dae0fd82b	{3}	修改租户	\N
fd707ce4-0f1a-3a12-2b8a-3a1b6c22fb2c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 14:12:39.853011	/api/admin/tenants/688a023b-2e5c-a0f8-0014-50d6450e48fc	PUT	::ffff:127.0.0.1	2025-07-30 14:12:38.476693	2025-07-30 14:12:39.196408	720	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"688a023b-2e5c-a0f8-0014-50d6450e48fc","input":{"Name":"\\u963F\\u8428","Remark":null,"Domain":null}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		626b8a88cd1738281c016b3f75131131	{3}	修改租户	\N
d829a36f-13c5-85f9-5686-3a1b6cf02b99	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 17:56:47.12982	/api/admin/online-users	GET	::1	2025-07-30 17:56:46.996428	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	e1f224463c8b01aa944b34f817c99491	{2}	在线用户列表	\N
f11f2713-4104-d53d-1caf-3a1b6cf02c5b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 17:56:47.323354	/api/admin/online-users	GET	::1	2025-07-30 17:56:47.256489	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	064f35e90eb67d9df0c0fff37aff981b	{2}	在线用户列表	\N
1cf1e410-2348-d20d-864e-3a1b6cf069a6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 17:57:03.01436	/api/admin/online-users	GET	::1	2025-07-30 17:57:02.975955	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d2ea9844ddaf22cb6ff697cf37fd855f	{2}	在线用户列表	\N
813243b4-caa2-ae80-fde5-3a1b6cf41aa3	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:01:04.93168	/api/admin/menus	GET	::1	2025-07-30 18:01:04.893464	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2b7cbf1d37460e8f783ef5faeb34a6fe	{2}	\N	\N
69797eb5-e7d9-faed-5514-3a1b6cf41ad0	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:01:04.976765	/api/admin/menus	GET	::1	2025-07-30 18:01:04.948901	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	3d9280c4da01063289dd74f737235064	{2}	\N	\N
41ea0a18-7cd2-c3c1-eb79-3a1b6cf0695b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 17:57:02.939793	/api/admin/online-users	GET	::1	2025-07-30 17:57:02.889252	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	0495b7028912bd2fdd9dea6609b5e73d	{2}	在线用户列表	\N
e4739e7b-34b0-fb5e-db6d-3a1b6cf53381	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:02:16.833471	/api/admin/menus	GET	::1	2025-07-30 18:02:16.796926	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	23961ed72770efdfeff382b6d6ec59cd	{2}	\N	\N
1650e7a0-3d69-f368-e554-3a1b6cf55171	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:02:24.497799	/api/admin/menus	GET	::1	2025-07-30 18:02:24.461691	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	a6c4e7e759e677837ffc3b9b4e527cd1	{2}	\N	\N
e99a155d-6a03-7862-4906-3a1b6cf551b1	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:02:24.561316	/api/admin/menus	GET	::1	2025-07-30 18:02:24.51376	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	4a606d09e56036918362429e85b7b957	{2}	\N	\N
707eddf6-104d-cb7a-8d3b-3a1b6cf599e8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:02:43.048195	/api/admin/menus	GET	::1	2025-07-30 18:02:43.012768	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	45a4a7e9ffef89b0869d1403c0ac87a4	{2}	\N	\N
37aa63e6-31e0-3f0b-f29a-3a1b6cf59a26	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:02:43.110639	/api/admin/menus	GET	::1	2025-07-30 18:02:43.083657	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	c1b1afd4d149fd7fa3c5b9ba45b3d6f2	{2}	\N	\N
15dc65b8-1e11-8975-4bc3-3a1b6cf7df23	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:05:11.844	/api/admin/users	GET	::1	2025-07-30 18:05:11.774838	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	ce53d863844b43857d3437a45e185601	\N	用户分页列表	\N
3f9f1e33-743b-023c-1e6e-3a1b6cf7df51	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:05:11.889364	/api/admin/users	GET	::1	2025-07-30 18:05:11.863772	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	faf0a8ffdaaddecaf11bc29c7b65fee2	\N	用户分页列表	\N
9b4b1f6d-b3e6-1674-4537-3a1b700bbda9	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:25:45.641863	/api/admin/menus	GET	::1	2025-07-31 08:25:45.567111	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	4bb04f72e21910b8970b418d637f9677	{2}	\N	\N
84547f5e-9f1f-8fb2-e00c-3a1b700bbded	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:25:45.709388	/api/admin/menus	GET	::1	2025-07-31 08:25:45.670339	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	4eec8035d471ef50bbbad1156387a709	{2}	\N	\N
209f4d9b-e71e-7736-f746-3a1b700e82e5	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:28:47.205928	/api/admin/menus	GET	::1	2025-07-31 08:28:47.152799	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	ec0c27e84892c6e7e6d4ff1a62cfe4bc	{2}	\N	\N
98e1eab9-f264-529d-8e30-3a1b700e8308	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:28:47.240723	/api/admin/menus	GET	::1	2025-07-31 08:28:47.21668	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	d4fb9e024c38e6b8a6b7d13d2278bdb4	{2}	\N	\N
4d440d77-a2b8-073f-3b54-3a1b70166a7f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:37:25.24744	/api/admin/menus	GET	::1	2025-07-31 08:37:25.185356	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	96accd49424e2e7ac415f8e38c9152b3	{2}	\N	\N
a184a0ea-bf67-5bbd-4957-3a1b70166ac5	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:37:25.317769	/api/admin/menus	GET	::1	2025-07-31 08:37:25.285928	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	415f4de7c302ea6ce08812130cdfb2f7	{2}	\N	\N
eddf73f2-84be-9fd5-f35b-3a1b7016a81f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:37:41.023786	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	PUT	::1	2025-07-31 08:37:35.42497	2025-07-31 08:37:41.004601	5580	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"Title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","Icon":null,"Path":"/admin/loggings/auditlog","MenuType":2,"Permission":null,"ParentId":"3a174174-857e-2328-55e6-395fcffb3774","Sort":0,"Display":true,"Component":"log","IsExternal":false}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		4ea8b186d397f8b652dee7d4f42de8cd	{3}	修改菜单	\N
59d8913e-db0e-43d4-1ecf-3a1b7016a852	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:37:41.074175	/api/admin/menus	GET	::1	2025-07-31 08:37:41.051951	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	5857e4b9888d041b4ff1a5f17c9c2e12	{2}	\N	\N
0e2e17b0-be67-5b72-f087-3a1b7016c5d8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:37:48.632672	/api/admin/menus	GET	::1	2025-07-31 08:37:48.609532	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	bc9d007bc4c1d70fc1f4ce0a96a492f3	{2}	\N	\N
590afe79-934d-6681-d5d0-3a1b7016c61d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:37:48.701468	/api/admin/menus	GET	::1	2025-07-31 08:37:48.644321	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	bdd37da3e99d54da1183184ce7b037c6	{2}	\N	\N
7db3c8f2-1b57-a80d-cb11-3a1b70f32541	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 12:38:30.97805	/api/admin/online-users	GET	::1	2025-07-31 12:38:30.878341	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	8cc81997fad1bd2afce07cb074f2add3	{2}	在线用户列表	\N
f7f9fb1c-efa8-1e44-690a-3a1b70f3259f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 12:38:31.071885	/api/admin/online-users	GET	::1	2025-07-31 12:38:31.005056	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2d528803850493d9dadd5a2720dc4cbc	{2}	在线用户列表	\N
71567bca-2ded-fee2-7fea-3a1b71587ae4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:29:12.036914	/api/admin/menus	GET	::1	2025-07-31 14:29:11.974188	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	9c883673e3b9d2bc34892158a2bc16c5	{2}	\N	\N
8f9504da-1852-2c98-5cc5-3a1b71587b0e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:29:12.078475	/api/admin/menus	GET	::1	2025-07-31 14:29:12.055548	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2f9cfaa3d45695c587b841ff124d2b1a	{2}	\N	\N
11c0f9b5-16f6-6ad2-f247-3a1b7158b470	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:29:26.769008	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	PUT	::1	2025-07-31 14:29:23.840804	2025-07-31 14:29:26.745074	2904	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"Title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","Icon":null,"Path":"/admin/loggings/auditlog/request","MenuType":2,"Permission":null,"ParentId":"3a174174-857e-2328-55e6-395fcffb3774","Sort":0,"Display":true,"Component":"log","IsExternal":false}}	{}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0		71ceb103adeebbcb2262cfe98ba7df1f	{3}	修改菜单	\N
0c312f68-f6c3-0b3a-afda-3a1b7158b49c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:29:26.81242	/api/admin/menus	GET	::1	2025-07-31 14:29:26.790927	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"Title":null,"Path":null}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	ddb26479a4418e686a05df3e5c37c0b0	{2}	\N	\N
e249b508-7568-341c-d925-3a1b71660ddb	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:44:01.627148	/api/admin/online-users	GET	::1	2025-07-31 14:44:01.569125	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	6cb7e9145d54ce4f8b649a3201a8f6ea	{2}	在线用户列表	\N
0ee67e44-3870-cb70-e6a4-3a1b71660e15	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:44:01.685633	/api/admin/online-users	GET	::1	2025-07-31 14:44:01.660887	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	f2c531d4e39a7ab26a38f96647cf898a	{2}	在线用户列表	\N
d6af5b53-b7f3-aaff-c63b-3a1b717e2698	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 15:10:20.824597	/api/admin/online-users	GET	::1	2025-07-31 15:10:20.679251	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	4aa43c6c63b3fe040773354e05075eed	{2}	在线用户列表	\N
6e251d0b-427b-9a54-a220-3a1b717e26c0	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 15:10:20.864775	/api/admin/online-users	GET	::1	2025-07-31 15:10:20.83976	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	2745fff44b4bcf5c98f7e95f2b5bc214	{2}	在线用户列表	\N
0910cf4c-f747-01c0-4d3d-3a1b71c71090	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 16:29:59.312343	/api/admin/online-users	GET	::1	2025-07-31 16:29:59.222875	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	7e11c82054bec2c6e12ea078e449969d	{2}	在线用户列表	\N
01e37b48-4b49-4d5c-259a-3a1b71c710d3	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 16:29:59.379898	/api/admin/online-users	GET	::1	2025-07-31 16:29:59.339633	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	7c91253f4dd3554ed79d10f1851e8ca3	{2}	在线用户列表	\N
afb10e7f-8326-ddea-276e-3a1b7704370f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-08-01 16:54:52.943441	/api/admin/online-users	GET	::1	2025-08-01 16:54:52.845534	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	42fa95fe41ee1255e71ea0d74906e73e	{2}	在线用户列表	\N
e0bd1e3d-396b-5c55-b20b-3a1b77043776	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-08-01 16:54:53.047055	/api/admin/online-users	GET	::1	2025-08-01 16:54:52.973766	\N	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	{"dto":{"UserName":null,"PageSize":10,"Current":1}}	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	?current=1&pageSize=10	da85e17b8c79f854491c034f0e83e250	{2}	在线用户列表	\N
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, concurrency_stamp, application_name, user_id, user_name, tenant_id, tenant_name, impersonator_user_id, impersonator_user_name, impersonator_tenant_id, impersonator_tenant_name, execution_time, execution_duration, client_ip_address, client_name, client_id, correlation_id, browser_info, http_method, url, exceptions, comments, http_status_code) FROM stdin;
3fb0b9b1-4c1b-0914-c4ce-3a1b7740bab7	068c69975c1a4b65865a63400c8406d6	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-08-01 18:00:58.207255	591	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	\N		200
\.


--
-- Data for Name: entity_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_change (id, audit_log_id, tenant_id, change_time, change_type, entity_tenant_id, entity_id, entity_type_full_name) FROM stdin;
\.


--
-- Data for Name: exception_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exception_log (id, creator_id, creation_time, exception_type, message, stack_trace, inner_exception, request_path, request_method, user_id, user_name, ip, browser, trace_id, is_handled, handled_time, handled_by, tenant_id) FROM stdin;
6888c9cd-6ea6-3348-0094-098c3504d8be	00000000-0000-0000-0000-000000000000	2025-07-29 13:17:01.354316	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Letu.Basis.Controllers.Accont.AccountController -> Letu.Basis.Account.AccountAppService.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService(IServiceProvider provider, Type serviceType)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerFactoryProvider.<>c__DisplayClass6_0.<CreateControllerFactory>g__CreateController|0(ControllerContext controllerContext)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Basis.Account.AccountAppService' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'FreeRedis.IRedisClient redisDb' of constructor 'Void .ctor(Letu.Repository.IRepository`1[Letu.Basis.Admin.Users.User], Letu.Repository.IRepository`1[Letu.Basis.Admin.Menus.MenuItem], Microsoft.Extensions.Configuration.IConfiguration, FreeRedis.IRedisClient, Volo.Abp.EventBus.Local.ILocalEventBus, Letu.Basis.SharedService.IdentitySharedService, Microsoft.AspNetCore.Http.IHttpContextAccessor, Microsoft.Extensions.Caching.Memory.IMemoryCache)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/account/login	POST	\N	\N	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	3aa5f9bd4830f0b38fb3f78e65a0d265	f	\N	\N	\N
6888ca1c-44ae-eba8-0073-4023068b6230	00000000-0000-0000-0000-000000000000	2025-07-29 13:18:20.246512	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Letu.Basis.Controllers.Accont.AccountController -> Letu.Basis.Account.AccountAppService.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Pipeline.ResolvePipelineBuilder.<>c__DisplayClass14_0.<BuildPipeline>b__1(ResolveRequestContext context)\r\n   at Autofac.Core.Pipeline.ResolvePipeline.Invoke(ResolveRequestContext context)\r\n   at Autofac.Core.Resolving.Middleware.RegistrationPipelineInvokeMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Pipeline.ResolvePipelineBuilder.<>c__DisplayClass14_0.<BuildPipeline>b__1(ResolveRequestContext context)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Pipeline.ResolvePipelineBuilder.<>c__DisplayClass14_0.<BuildPipeline>b__1(ResolveRequestContext context)\r\n   at Autofac.Core.Resolving.Pipeline.ResolvePipelineBuilder.<>c__DisplayClass14_0.<BuildPipeline>b__1(ResolveRequestContext context)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Pipeline.ResolvePipelineBuilder.<>c__DisplayClass14_0.<BuildPipeline>b__1(ResolveRequestContext context)\r\n   at Autofac.Core.Pipeline.ResolvePipeline.Invoke(ResolveRequestContext context)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.Execute(ResolveRequest& request)\r\n   at Autofac.Core.Lifetime.LifetimeScope.ResolveComponent(ResolveRequest& request)\r\n   at Autofac.Core.Lifetime.LifetimeScope.Autofac.IComponentContext.ResolveComponent(ResolveRequest& request)\r\n   at Autofac.ResolutionExtensions.TryResolveService(IComponentContext context, Service service, IEnumerable`1 parameters, Object& instance)\r\n   at Autofac.ResolutionExtensions.ResolveService(IComponentContext context, Service service, IEnumerable`1 parameters)\r\n   at Autofac.ResolutionExtensions.Resolve(IComponentContext context, Type serviceType, IEnumerable`1 parameters)\r\n   at Autofac.ResolutionExtensions.Resolve(IComponentContext context, Type serviceType)\r\n   at Autofac.Extensions.DependencyInjection.AutofacServiceProvider.GetRequiredService(Type serviceType)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerFactoryProvider.<>c__DisplayClass6_0.<CreateControllerFactory>g__CreateController|0(ControllerContext controllerContext)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Basis.Account.AccountAppService' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'FreeRedis.IRedisClient redisDb' of constructor 'Void .ctor(Letu.Repository.IRepository`1[Letu.Basis.Admin.Users.User], Letu.Repository.IRepository`1[Letu.Basis.Admin.Menus.MenuItem], Microsoft.Extensions.Configuration.IConfiguration, FreeRedis.IRedisClient, Volo.Abp.EventBus.Local.ILocalEventBus, Letu.Basis.SharedService.IdentitySharedService, Microsoft.AspNetCore.Http.IHttpContextAccessor, Microsoft.Extensions.Caching.Memory.IMemoryCache)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/account/login	POST	\N	\N	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	0fffd4d9818a51f9c2bf7137081504f1	f	\N	\N	\N
6888d83b-8465-d6cc-0063-58d6116db646	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:18:35.523905	AutoMapper.AutoMapperMappingException	Missing type map configuration or unsupported mapping.\r\n\r\nMapping types:\r\nMenuItem -> FrontendMenu\r\nLetu.Basis.Admin.Menus.MenuItem -> Letu.Shared.Models.FrontendMenu	   at lambda_method1419(Closure, Object, FrontendMenu, ResolutionContext)\r\n   at Volo.Abp.AutoMapper.AutoMapperAutoObjectMappingProvider.Map[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.AutoMap[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.Map[TSource,TDestination](TSource source)\r\n   at Letu.Basis.Account.AccountAppService.GetFrontMenus() in E:\\Git\\letu\\backend\\Letu.Basis\\Account\\AccountAppService.cs:line 68\r\n   at Letu.Basis.Account.AccountAppService.GetUserAuthInfoAsync() in E:\\Git\\letu\\backend\\Letu.Basis\\Account\\AccountAppService.cs:line 39\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Accont.AccountController.GetUserAuthInfoAsync() in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Accont\\AccountController.cs:line 92\r\n   at lambda_method1408(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	\N	/api/account/userAuth	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	7561d6de824c795dc0221bd78e04d894	f	\N	\N	\N
6888d847-8465-d6cc-0063-58dc70b3910f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:18:47.682707	AutoMapper.AutoMapperMappingException	Missing type map configuration or unsupported mapping.\r\n\r\nMapping types:\r\nMenuItem -> FrontendMenu\r\nLetu.Basis.Admin.Menus.MenuItem -> Letu.Shared.Models.FrontendMenu	   at lambda_method1419(Closure, Object, FrontendMenu, ResolutionContext)\r\n   at Volo.Abp.AutoMapper.AutoMapperAutoObjectMappingProvider.Map[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.AutoMap[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.Map[TSource,TDestination](TSource source)\r\n   at Letu.Basis.Account.AccountAppService.GetFrontMenus() in E:\\Git\\letu\\backend\\Letu.Basis\\Account\\AccountAppService.cs:line 68\r\n   at Letu.Basis.Account.AccountAppService.GetUserAuthInfoAsync() in E:\\Git\\letu\\backend\\Letu.Basis\\Account\\AccountAppService.cs:line 39\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Accont.AccountController.GetUserAuthInfoAsync() in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Accont\\AccountController.cs:line 92\r\n   at lambda_method1408(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	\N	/api/account/userAuth	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	5f59b69558e774011593c4586d2cbb7b	f	\N	\N	\N
70a2b8f1-3d4f-7af2-0ca4-3a1b700f8b42	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:29:54.882582	System.Exception	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	   at FreeSql.Internal.CommonProvider.AdoProvider.LoggerException(IObjectPool`1 pool, PrepareCommandResult pc, Exception ex, DateTime dt, StringBuilder logtxt, Boolean isThrowException)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQueryAsync(DbConnection connection, DbTransaction transaction, CommandType cmdType, String cmdText, Int32 cmdTimeout, Func`2 cmdAfterHandler, DbParameter[] cmdParms, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass68_0.<<RawExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.ToSqlFetchAsync(Func`2 fetchAsync)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.RawExecuteAffrowsAsync(CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass66_0.<<SplitExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAsync(Int32 valuesLimit, Int32 parameterLimit, String traceName, Func`1 executeAsync, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAffrowsAsync(Int32 valuesLimit, Int32 parameterLimit, CancellationToken cancellationToken)\r\n   at FreeSql.DbSet`1.DbContextBatchUpdatePrivAsync(EntityState[] ups, Boolean isLiveUpdate, CancellationToken cancellationToken)\r\n   at FreeSql.DbContext.<>c__DisplayClass60_0.<<FlushCommandAsync>g__funcUpdate|3>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.DbContext.FlushCommandAsync(CancellationToken cancellationToken)\r\n   at FreeSql.RepositoryDbContext.SaveChangesAsync(CancellationToken cancellationToken)\r\n   at Letu.Basis.Admin.Menus.MenuAppService.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Menus\\MenuAppService.cs:line 172\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.MenuController.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\MenuController.cs:line 61\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.TaskResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	PUT	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	0173df854a4398187962266590bde847	f	\N	\N	\N
6888da19-46f2-018c-0056-9da2646c36c5	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:26:33.715301	AutoMapper.AutoMapperMappingException	Missing type map configuration or unsupported mapping.\r\n\r\nMapping types:\r\nMenuItem -> FrontendMenu\r\nLetu.Basis.Admin.Menus.MenuItem -> Letu.Shared.Models.FrontendMenu	   at lambda_method1419(Closure, Object, FrontendMenu, ResolutionContext)\r\n   at Volo.Abp.AutoMapper.AutoMapperAutoObjectMappingProvider.Map[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.AutoMap[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.Map[TSource,TDestination](TSource source)\r\n   at Letu.Basis.Account.AccountAppService.GetFrontMenus() in E:\\Git\\letu\\backend\\Letu.Basis\\Account\\AccountAppService.cs:line 68\r\n   at Letu.Basis.Account.AccountAppService.GetUserAuthInfoAsync() in E:\\Git\\letu\\backend\\Letu.Basis\\Account\\AccountAppService.cs:line 39\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Accont.AccountController.GetUserAuthInfoAsync() in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Accont\\AccountController.cs:line 92\r\n   at lambda_method1408(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	\N	/api/account/userAuth	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	f0692188d3e5d1a2ed837fd28daeb337	f	\N	\N	\N
6888dd2c-a97c-0cb0-0051-847e266a3fbf	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:39:40.762533	AutoMapper.AutoMapperMappingException	Error mapping types.\r\n\r\nMapping types:\r\nList`1 -> List`1\r\nSystem.Collections.Generic.List`1[[Letu.Basis.Admin.Positions.PositionGroup, Letu.Basis, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null]] -> System.Collections.Generic.List`1[[Letu.Basis.Admin.Positions.Dtos.PositionGroupListOutput, Letu.Basis, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null]]	   at lambda_method1450(Closure, Object, List`1, ResolutionContext)\r\n   at Volo.Abp.AutoMapper.AutoMapperAutoObjectMappingProvider.Map[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.AutoMap[TSource,TDestination](Object source)\r\n   at Volo.Abp.ObjectMapping.DefaultObjectMapper.Map[TSource,TDestination](TSource source)\r\n   at Letu.Basis.Admin.Positions.PositionAppService.GetPositionGroupListAsync(PositionGroupListInput dto) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Positions\\PositionAppService.cs:line 66\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.PositionController.GetPositionGroupsAsync(PositionGroupListInput dto) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\PositionController.cs:line 115\r\n   at lambda_method1434(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	Error mapping types.\r\n\r\nMapping types:\r\nPositionGroup -> PositionGroupListOutput\r\nLetu.Basis.Admin.Positions.PositionGroup -> Letu.Basis.Admin.Positions.Dtos.PositionGroupListOutput\r\n\r\nType Map configuration:\r\nPositionGroup -> PositionGroupListOutput\r\nLetu.Basis.Admin.Positions.PositionGroup -> Letu.Basis.Admin.Positions.Dtos.PositionGroupListOutput\r\n\r\nDestination Member:\r\nChildren\r\n	/api/admin/positions/groups	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	b59d38d365b8cf57f6a907b06dfb26c7	f	\N	\N	\N
6888e02d-4bd6-2248-0033-d99108fa6dcf	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:52:29.247602	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Letu.Basis.Controllers.Admin.SettingsController.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService(IServiceProvider provider, Type serviceType)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerFactoryProvider.<>c__DisplayClass6_0.<CreateControllerFactory>g__CreateController|0(ControllerContext controllerContext)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Basis.Controllers.Admin.SettingsController' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'Letu.Basis.Admin.Settings.IConfigService settingsService' of constructor 'Void .ctor(Letu.Basis.Admin.Settings.IConfigService)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/admin/settings	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	aba7195ef873c45e6e553d7fa165fbf9	f	\N	\N	\N
6888e02d-4bd6-2248-0033-d99213cba5da	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 14:52:29.369222	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Letu.Basis.Controllers.Admin.SettingsController.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService(IServiceProvider provider, Type serviceType)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerFactoryProvider.<>c__DisplayClass6_0.<CreateControllerFactory>g__CreateController|0(ControllerContext controllerContext)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Basis.Controllers.Admin.SettingsController' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'Letu.Basis.Admin.Settings.IConfigService settingsService' of constructor 'Void .ctor(Letu.Basis.Admin.Settings.IConfigService)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/admin/settings	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	2aa7bb6b32f21b6fb48c9ad7d1b46892	f	\N	\N	\N
688a0212-2e5c-a0f8-0014-50d37e1ae262	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:29:22.231741	Microsoft.AspNetCore.Server.Kestrel.Core.BadHttpRequestException	Unexpected end of request content.	   at Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.Http1ContentLengthMessageBody.ReadAsyncInternal(CancellationToken cancellationToken)\r\n   at System.Runtime.CompilerServices.PoolingAsyncValueTaskMethodBuilder`1.StateMachineBox`1.System.Threading.Tasks.Sources.IValueTaskSource<TResult>.GetResult(Int16 token)\r\n   at Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpRequestStream.ReadAsyncInternal(Memory`1 destination, CancellationToken cancellationToken)\r\n   at System.Runtime.CompilerServices.PoolingAsyncValueTaskMethodBuilder`1.StateMachineBox`1.System.Threading.Tasks.Sources.IValueTaskSource<TResult>.GetResult(Int16 token)\r\n   at System.Text.Json.Serialization.ReadBufferState.ReadFromStreamAsync(Stream utf8Json, CancellationToken cancellationToken, Boolean fillBuffer)\r\n   at System.Text.Json.Serialization.Metadata.JsonTypeInfo`1.DeserializeAsync(Stream utf8Json, CancellationToken cancellationToken)\r\n   at System.Text.Json.Serialization.Metadata.JsonTypeInfo`1.DeserializeAsObjectAsync(Stream utf8Json, CancellationToken cancellationToken)\r\n   at Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonInputFormatter.ReadRequestBodyAsync(InputFormatterContext context, Encoding encoding)\r\n   at Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonInputFormatter.ReadRequestBodyAsync(InputFormatterContext context, Encoding encoding)\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.Binders.BodyModelBinder.BindModelAsync(ModelBindingContext bindingContext)\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.ParameterBinder.BindModelAsync(ActionContext actionContext, IModelBinder modelBinder, IValueProvider valueProvider, ParameterDescriptor parameter, ModelMetadata metadata, Object value, Object container)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerBinderDelegateProvider.<>c__DisplayClass0_0.<<CreateBinderDelegate>g__Bind|0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	\N	/api/admin/tenants	POST	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	128f3c150b23a5a02988870f3fc1a65a	f	\N	\N	\N
6888e2b5-fa0e-1c34-002b-ca7866d5e482	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:03:17.921489	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Letu.Basis.Controllers.Admin.SettingsController -> Letu.Basis.Admin.Settings.SettingAppService -> Letu.Basis.SharedService.ConfigSharedService.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService(IServiceProvider provider, Type serviceType)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerFactoryProvider.<>c__DisplayClass6_0.<CreateControllerFactory>g__CreateController|0(ControllerContext controllerContext)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Basis.SharedService.ConfigSharedService' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'FreeRedis.IRedisClient redisClient' of constructor 'Void .ctor(Letu.Repository.IRepository`1[Letu.Basis.Admin.Settings.ConfigDO], FreeRedis.IRedisClient)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/admin/settings	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	858bf7477141b54d76b75d7f7fabeffc	f	\N	\N	\N
6888e2b6-fa0e-1c34-002b-ca797d77dbfd	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:03:18.063286	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Letu.Basis.Controllers.Admin.SettingsController -> Letu.Basis.Admin.Settings.SettingAppService -> Letu.Basis.SharedService.ConfigSharedService.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService(IServiceProvider provider, Type serviceType)\r\n   at Microsoft.AspNetCore.Mvc.Controllers.ControllerFactoryProvider.<>c__DisplayClass6_0.<CreateControllerFactory>g__CreateController|0(ControllerContext controllerContext)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Basis.SharedService.ConfigSharedService' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'FreeRedis.IRedisClient redisClient' of constructor 'Void .ctor(Letu.Repository.IRepository`1[Letu.Basis.Admin.Settings.ConfigDO], FreeRedis.IRedisClient)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/admin/settings	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	14088c9cca2c62cde2b722f393d76373	f	\N	\N	\N
6888e4ae-aa3b-a858-0035-eff50973cf31	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:11:42.34419	System.Exception	42804: column "tenant_id" cannot be cast automatically to type uuid	   at FreeSql.Internal.CommonProvider.AdoProvider.LoggerException(IObjectPool`1 pool, PrepareCommandResult pc, Exception ex, DateTime dt, StringBuilder logtxt, Boolean isThrowException)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQuery(DbConnection connection, DbTransaction transaction, CommandType cmdType, String cmdText, Int32 cmdTimeout, Action`1 cmdAfterHandler, DbParameter[] cmdParms)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQuery(CommandType cmdType, String cmdText, DbParameter[] cmdParms)\r\n   at FreeSql.Internal.CommonProvider.CodeFirstProvider.ExecuteDDLStatements(String ddl)\r\n   at FreeSql.Internal.CommonProvider.CodeFirstProvider.SyncStructure(TypeSchemaAndName[] objects)\r\n   at FreeSql.Internal.CommonProvider.CodeFirstProvider.SyncStructure[TEntity]()\r\n   at FreeSql.Internal.CommonProvider.Select0Provider`2..ctor(IFreeSql orm, CommonUtils commonUtils, CommonExpression commonExpression, Object dywhere)\r\n   at FreeSql.Internal.CommonProvider.Select1Provider`1..ctor(IFreeSql orm, CommonUtils commonUtils, CommonExpression commonExpression, Object dywhere)\r\n   at FreeSql.PostgreSQL.Curd.PostgreSQLSelect`1..ctor(IFreeSql orm, CommonUtils commonUtils, CommonExpression commonExpression, Object dywhere)\r\n   at FreeSql.PostgreSQL.PostgreSQLProvider`1.CreateSelectProvider[T1](Object dywhere)\r\n   at FreeSql.Internal.CommonProvider.BaseDbProvider.Select[T1]()\r\n   at FreeSql.DbSet`1.OrmSelect(Object dywhere)\r\n   at FreeSql.RepositoryDbSet`1.OrmSelect(Object dywhere)\r\n   at FreeSql.RepositoryDbSet`1.OrmSelectInternal(Object dywhere)\r\n   at FreeSql.BaseRepository`1.get_Select()\r\n   at Letu.Basis.Admin.Tenants.TenantAppService.GetTenantListAsync(TenantSearchDto dto) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Tenants\\TenantAppService.cs:line 42\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.TenantController.GetTenantListAsync(TenantSearchDto dto) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\TenantController.cs:line 45\r\n   at lambda_method1465(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	42804: column "tenant_id" cannot be cast automatically to type uuid	/api/admin/tenants	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	8bd50e66d491cd1f22d8f8588f3e8c00	f	\N	\N	\N
6888e4ae-aa3b-a858-0035-eff677c8aa10	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 15:11:42.352439	System.Exception	42804: column "tenant_id" cannot be cast automatically to type uuid	   at FreeSql.Internal.CommonProvider.AdoProvider.LoggerException(IObjectPool`1 pool, PrepareCommandResult pc, Exception ex, DateTime dt, StringBuilder logtxt, Boolean isThrowException)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQuery(DbConnection connection, DbTransaction transaction, CommandType cmdType, String cmdText, Int32 cmdTimeout, Action`1 cmdAfterHandler, DbParameter[] cmdParms)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQuery(CommandType cmdType, String cmdText, DbParameter[] cmdParms)\r\n   at FreeSql.Internal.CommonProvider.CodeFirstProvider.ExecuteDDLStatements(String ddl)\r\n   at FreeSql.Internal.CommonProvider.CodeFirstProvider.SyncStructure(TypeSchemaAndName[] objects)\r\n   at FreeSql.Internal.CommonProvider.CodeFirstProvider.SyncStructure[TEntity]()\r\n   at FreeSql.Internal.CommonProvider.Select0Provider`2..ctor(IFreeSql orm, CommonUtils commonUtils, CommonExpression commonExpression, Object dywhere)\r\n   at FreeSql.Internal.CommonProvider.Select1Provider`1..ctor(IFreeSql orm, CommonUtils commonUtils, CommonExpression commonExpression, Object dywhere)\r\n   at FreeSql.PostgreSQL.Curd.PostgreSQLSelect`1..ctor(IFreeSql orm, CommonUtils commonUtils, CommonExpression commonExpression, Object dywhere)\r\n   at FreeSql.PostgreSQL.PostgreSQLProvider`1.CreateSelectProvider[T1](Object dywhere)\r\n   at FreeSql.Internal.CommonProvider.BaseDbProvider.Select[T1]()\r\n   at FreeSql.DbSet`1.OrmSelect(Object dywhere)\r\n   at FreeSql.RepositoryDbSet`1.OrmSelect(Object dywhere)\r\n   at FreeSql.RepositoryDbSet`1.OrmSelectInternal(Object dywhere)\r\n   at FreeSql.BaseRepository`1.get_Select()\r\n   at Letu.Basis.Admin.Tenants.TenantAppService.GetTenantListAsync(TenantSearchDto dto) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Tenants\\TenantAppService.cs:line 42\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.TenantController.GetTenantListAsync(TenantSearchDto dto) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\TenantController.cs:line 45\r\n   at lambda_method1465(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	42804: column "tenant_id" cannot be cast automatically to type uuid	/api/admin/tenants	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	41b9cbcf4a52e736d4d9e0bc05df7222	f	\N	\N	\N
43d694d4-8d18-77c4-0a2f-3a1b6cf74900	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:04:33.409156	System.Exception	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	   at FreeSql.Internal.CommonProvider.AdoProvider.LoggerException(IObjectPool`1 pool, PrepareCommandResult pc, Exception ex, DateTime dt, StringBuilder logtxt, Boolean isThrowException)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQueryAsync(DbConnection connection, DbTransaction transaction, CommandType cmdType, String cmdText, Int32 cmdTimeout, Func`2 cmdAfterHandler, DbParameter[] cmdParms, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass68_0.<<RawExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.ToSqlFetchAsync(Func`2 fetchAsync)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.RawExecuteAffrowsAsync(CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass66_0.<<SplitExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAsync(Int32 valuesLimit, Int32 parameterLimit, String traceName, Func`1 executeAsync, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAffrowsAsync(Int32 valuesLimit, Int32 parameterLimit, CancellationToken cancellationToken)\r\n   at FreeSql.DbSet`1.DbContextBatchUpdatePrivAsync(EntityState[] ups, Boolean isLiveUpdate, CancellationToken cancellationToken)\r\n   at FreeSql.DbContext.<>c__DisplayClass60_0.<<FlushCommandAsync>g__funcUpdate|3>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.DbContext.FlushCommandAsync(CancellationToken cancellationToken)\r\n   at FreeSql.RepositoryDbContext.SaveChangesAsync(CancellationToken cancellationToken)\r\n   at Letu.Basis.Admin.Menus.MenuAppService.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Menus\\MenuAppService.cs:line 172\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.MenuController.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\MenuController.cs:line 61\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.TaskResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	PUT	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	f05224b218ba86fe1ff255636a924df4	f	\N	\N	\N
faa9d414-897b-bd45-00f1-3a1b7010e858	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:31:24.248311	System.Exception	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	   at FreeSql.Internal.CommonProvider.AdoProvider.LoggerException(IObjectPool`1 pool, PrepareCommandResult pc, Exception ex, DateTime dt, StringBuilder logtxt, Boolean isThrowException)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQueryAsync(DbConnection connection, DbTransaction transaction, CommandType cmdType, String cmdText, Int32 cmdTimeout, Func`2 cmdAfterHandler, DbParameter[] cmdParms, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass68_0.<<RawExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.ToSqlFetchAsync(Func`2 fetchAsync)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.RawExecuteAffrowsAsync(CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass66_0.<<SplitExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAsync(Int32 valuesLimit, Int32 parameterLimit, String traceName, Func`1 executeAsync, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAffrowsAsync(Int32 valuesLimit, Int32 parameterLimit, CancellationToken cancellationToken)\r\n   at FreeSql.DbSet`1.DbContextBatchUpdatePrivAsync(EntityState[] ups, Boolean isLiveUpdate, CancellationToken cancellationToken)\r\n   at FreeSql.DbContext.<>c__DisplayClass60_0.<<FlushCommandAsync>g__funcUpdate|3>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.DbContext.FlushCommandAsync(CancellationToken cancellationToken)\r\n   at FreeSql.RepositoryDbContext.SaveChangesAsync(CancellationToken cancellationToken)\r\n   at Letu.Basis.Admin.Menus.MenuAppService.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Menus\\MenuAppService.cs:line 172\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.MenuController.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\MenuController.cs:line 61\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.TaskResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	PUT	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	67e0d7fddbb0fb7870c2b0ce3da85603	f	\N	\N	\N
027046aa-7d42-bb52-c0e3-3a1b70135a94	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 08:34:04.564504	System.Exception	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	   at FreeSql.Internal.CommonProvider.AdoProvider.LoggerException(IObjectPool`1 pool, PrepareCommandResult pc, Exception ex, DateTime dt, StringBuilder logtxt, Boolean isThrowException)\r\n   at FreeSql.Internal.CommonProvider.AdoProvider.ExecuteNonQueryAsync(DbConnection connection, DbTransaction transaction, CommandType cmdType, String cmdText, Int32 cmdTimeout, Func`2 cmdAfterHandler, DbParameter[] cmdParms, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass68_0.<<RawExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.ToSqlFetchAsync(Func`2 fetchAsync)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.RawExecuteAffrowsAsync(CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.<>c__DisplayClass66_0.<<SplitExecuteAffrowsAsync>b__0>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAsync(Int32 valuesLimit, Int32 parameterLimit, String traceName, Func`1 executeAsync, CancellationToken cancellationToken)\r\n   at FreeSql.Internal.CommonProvider.UpdateProvider`1.SplitExecuteAffrowsAsync(Int32 valuesLimit, Int32 parameterLimit, CancellationToken cancellationToken)\r\n   at FreeSql.DbSet`1.DbContextBatchUpdatePrivAsync(EntityState[] ups, Boolean isLiveUpdate, CancellationToken cancellationToken)\r\n   at FreeSql.DbContext.<>c__DisplayClass60_0.<<FlushCommandAsync>g__funcUpdate|3>d.MoveNext()\r\n--- End of stack trace from previous location ---\r\n   at FreeSql.DbContext.FlushCommandAsync(CancellationToken cancellationToken)\r\n   at FreeSql.RepositoryDbContext.SaveChangesAsync(CancellationToken cancellationToken)\r\n   at Letu.Basis.Admin.Menus.MenuAppService.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\Menus\\MenuAppService.cs:line 172\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProceedByLoggingAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, IAuditingHelper auditingHelper, IAuditLogScope auditLogScope)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.ProcessWithNewAuditingScopeAsync(IAbpMethodInvocation invocation, AbpAuditingOptions options, ICurrentUser currentUser, IAuditingManager auditingManager, IAuditingHelper auditingHelper, IUnitOfWorkManager unitOfWorkManager)\r\n   at Volo.Abp.Auditing.AuditingInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous(IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapter.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync(IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.MenuController.UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\MenuController.cs:line 61\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.TaskResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	23502: null value in column "permission" of relation "sys_menu" violates not-null constraint	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	PUT	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	b998fc001789d6261375060fd2cf1836	f	\N	\N	\N
3e12f462-3aa7-9095-1677-3a1b773c6aae	\N	2025-08-01 17:56:16.176852	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Volo.Abp.Auditing.AuditingManager -> Volo.Abp.Auditing.AuditingHelper -> Letu.Logging.Auditing.LetuAuditingStore.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.Execute(ResolveRequest& request)\r\n   at Autofac.Core.Lifetime.LifetimeScope.ResolveComponent(ResolveRequest& request)\r\n   at Autofac.Core.Lifetime.LifetimeScope.Autofac.IComponentContext.ResolveComponent(ResolveRequest& request)\r\n   at Autofac.ResolutionExtensions.TryResolveService(IComponentContext context, Service service, IEnumerable`1 parameters, Object& instance)\r\n   at Autofac.ResolutionExtensions.ResolveService(IComponentContext context, Service service, IEnumerable`1 parameters)\r\n   at Autofac.ResolutionExtensions.Resolve(IComponentContext context, Type serviceType, IEnumerable`1 parameters)\r\n   at Autofac.ResolutionExtensions.Resolve(IComponentContext context, Type serviceType)\r\n   at Autofac.Extensions.DependencyInjection.AutofacServiceProvider.GetRequiredService(Type serviceType)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService[T](IServiceProvider provider)\r\n   at Volo.Abp.AspNetCore.Mvc.AbpActionContextExtensions.GetRequiredService[T](FilterContext context)\r\n   at Volo.Abp.AspNetCore.Mvc.Auditing.AbpAuditActionFilter.ShouldSaveAudit(ActionExecutingContext context, AuditLogInfo& auditLog, AuditLogActionInfo& auditLogAction)\r\n   at Volo.Abp.AspNetCore.Mvc.Auditing.AbpAuditActionFilter.OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Logging.Auditing.LetuAuditingStore' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'Volo.Abp.AuditLogging.IAuditLogRepository auditLogRepository' of constructor 'Void .ctor(Volo.Abp.AuditLogging.IAuditLogRepository, Volo.Abp.Uow.IUnitOfWorkManager, Microsoft.Extensions.Options.IOptions`1[Volo.Abp.Auditing.AbpAuditingOptions], Volo.Abp.AuditLogging.IAuditLogInfoToAuditLogConverter, IFreeSql)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/account/login	POST	\N	\N	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	21f30e6901abae5a030be5adf9b292b4	f	\N	\N	\N
923d9d09-3154-25ac-59a8-3a1b773cde00	\N	2025-08-01 17:56:45.696355	Autofac.Core.DependencyResolutionException	An exception was thrown while activating Volo.Abp.Auditing.AuditingManager -> Volo.Abp.Auditing.AuditingHelper -> Letu.Logging.Auditing.LetuAuditingStore.	   at Autofac.Core.Resolving.Middleware.ActivatorErrorHandlingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.SharingMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.Middleware.CircularDependencyDetectorMiddleware.Execute(ResolveRequestContext context, Action`1 next)\r\n   at Autofac.Core.Resolving.ResolveOperation.GetOrCreateInstance(ISharingLifetimeScope currentOperationScope, ResolveRequest& request)\r\n   at Autofac.Core.Resolving.ResolveOperation.ExecuteOperation(ResolveRequest& request)\r\n   at Autofac.ResolutionExtensions.TryResolveService(IComponentContext context, Service service, IEnumerable`1 parameters, Object& instance)\r\n   at Autofac.ResolutionExtensions.ResolveService(IComponentContext context, Service service, IEnumerable`1 parameters)\r\n   at Autofac.ResolutionExtensions.Resolve(IComponentContext context, Type serviceType)\r\n   at Autofac.Extensions.DependencyInjection.AutofacServiceProvider.GetRequiredService(Type serviceType)\r\n   at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService[T](IServiceProvider provider)\r\n   at Volo.Abp.AspNetCore.Mvc.AbpActionContextExtensions.GetRequiredService[T](FilterContext context)\r\n   at Volo.Abp.AspNetCore.Mvc.Auditing.AbpAuditActionFilter.ShouldSaveAudit(ActionExecutingContext context, AuditLogInfo& auditLog, AuditLogActionInfo& auditLogAction)\r\n   at Volo.Abp.AspNetCore.Mvc.Auditing.AbpAuditActionFilter.OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	None of the constructors found on type 'Letu.Logging.Auditing.LetuAuditingStore' can be invoked with the available services and parameters:\r\nCannot resolve parameter 'Volo.Abp.AuditLogging.IAuditLogRepository auditLogRepository' of constructor 'Void .ctor(Volo.Abp.AuditLogging.IAuditLogRepository, Volo.Abp.Uow.IUnitOfWorkManager, Microsoft.Extensions.Options.IOptions`1[Volo.Abp.Auditing.AbpAuditingOptions], Volo.Abp.AuditLogging.IAuditLogInfoToAuditLogConverter, IFreeSql)'.\n\nSee https://autofac.rtfd.io/help/no-constructors-bindable for more info.	/api/account/login	POST	\N	\N	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	427a2fdf5fb11473604326e3794e0b88	f	\N	\N	\N
125b8d2e-2b33-1a5e-5ac0-3a1b7741321c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-08-01 18:01:29.37305	System.Exception	FreeSql: [OneToMany] Navigation property Volo.Abp.AuditLogging.AuditLog.Actions did not find a corresponding field in AuditLogAction, such as: ActionsAuditLogId, ActionsAuditLog_Id	   at FreeSql.Internal.Model.TableInfo.GetTableRef(String propertyName, Boolean isThrowException, Boolean isCascadeQuery)\r\n   at FreeSql.Internal.CommonProvider.Select1Provider`1.IncludeMany[TNavigate](Expression`1 navigateSelector, Action`1 then)\r\n   at Letu.Basis.Admin.AuditLogging.AuditLogs.AuditLogAppService.GetAsync(Guid id) in E:\\Git\\letu\\backend\\Letu.Basis\\Admin\\AuditLogging\\AuditLogs\\AuditLogAppService.cs:line 68\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.GlobalFeatures.GlobalFeatureInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Validation.ValidationInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Castle.DynamicProxy.AsyncInterceptorBase.ProceedAsynchronous[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAbpMethodInvocationAdapterWithReturnValue`1.ProceedAsync()\r\n   at Volo.Abp.Uow.UnitOfWorkInterceptor.InterceptAsync(IAbpMethodInvocation invocation)\r\n   at Volo.Abp.Castle.DynamicProxy.CastleAsyncAbpInterceptorAdapter`1.InterceptAsync[TResult](IInvocation invocation, IInvocationProceedInfo proceedInfo, Func`3 proceed)\r\n   at Letu.Basis.Controllers.Admin.AuditLogController.GetAsync(Guid id) in E:\\Git\\letu\\backend\\Letu.Basis\\Controllers\\Admin\\AuditLogController.cs:line 36\r\n   at lambda_method1440(Closure, Object)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.AwaitableObjectResultExecutor.Execute(ActionContext actionContext, IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextExceptionFilterAsync>g__Awaited|26_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)	\N	/api/admin/auditlog/3fb0b9b1-4c1b-0914-c4ce-3a1b7740bab7	GET	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	4fcfaa0b10f34e237dbc2e5525ddbf26	f	\N	\N	\N
\.


--
-- Data for Name: log_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_record (id, creator_id, creation_time, type, sub_type, biz_no, content, browser, ip, trace_id, tenant_id, user_id, user_name) FROM stdin;
688656f0-83c0-4b38-0034-fa5d0e9d12bd	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:42:24.206149	字典数据	编辑字典数据	68602622-e22b-e780-00f8-5c9d688361b4	编辑后：值=1,启用=True	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	::1	9a950cae333377316b799fb0ddd70449	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin
6886575b-83c0-4b38-0034-fa60788c715a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:44:11.235297	配置管理	编辑配置	68758b9b-e6de-0d4c-0000-b9861878b283	编辑后：键=StorageType，值=1，组=System	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	::1	fda514554eb678cf78a78392545893b4	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin
68890fcf-21b2-19c0-00d4-132b494ea7a4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:15:43.293336	系统用户	重置用户密码	00de38c4-17bd-415f-bf1c-2e0873eb177e	重置用户coco登录密码	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	::1	32850d750e735878505a1a45a0d80115	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin
\.


--
-- Data for Name: org_employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_employee (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, code, name, sex, phone, id_no, front_id_no_url, back_id_no_url, birthday, address, email, in_time, out_time, status, user_id, dept_id, position_id, tenant_id) FROM stdin;
68890d70-7361-2460-0074-66f80ab6611b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:05:36.549702	\N	\N	f	\N	\N	123	test	1	123	\N	\N	\N	\N	\N	scfido@gmail.com	2025-06-29 16:00:00	\N	1	\N	\N	\N	\N
6869907c-9c93-beac-0062-34172a640e0e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-05 20:52:12.138175	2025-07-05 21:45:13.910127	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	001	tom	1	18211114444	\N	\N	\N	\N	\N	\N	0001-01-01 00:00:00	\N	1	\N	6861a4ed-de18-91c8-009e-ef9b36642c3c	685f2cd3-7ef6-c114-0022-88b50a861368	\N
\.


--
-- Data for Name: org_position; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_position (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, code, name, level, status, description, group_id, tenant_id) FROM stdin;
6888fe1a-7361-2460-0074-66d67566ad8a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 17:00:10.07522	\N	\N	f	\N	\N	d	test	2	1	\N	685f2f1d-7ef6-c114-0022-88b738cf5c1c	\N
686a9bac-aad5-2c54-003c-a0450445a76f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-06 15:52:12.404982	2025-07-29 16:41:37.514011	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	001	前端开发工程师	2	1	\N	685f2f1d-7ef6-c114-0022-88b738cf5c1c	\N
\.


--
-- Data for Name: org_position_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_position_group (id, creator_id, creation_time, last_modification_time, last_modifier_id, group_name, remark, parent_id, parent_ids, sort, tenant_id) FROM stdin;
685f2cd3-7ef6-c114-0022-88b50a861368	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-27 23:44:19.081278	2025-06-28 15:57:31.895397	3a172a37-55d5-ee9b-dc92-e07386eadc7c	软件	软件研发岗位	\N	\N	1	\N
685f2f1d-7ef6-c114-0022-88b738cf5c1c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-27 23:54:05.887842	2025-07-29 16:33:01.770598	3a172a37-55d5-ee9b-dc92-e07386eadc7c	前端	\N	685f2cd3-7ef6-c114-0022-88b50a861368	685f2cd3-7ef6-c114-0022-88b50a861368	0	\N
6888f7c8-97f4-a6b4-0020-81d1788d7110	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 16:33:12.868611	\N	\N	士大夫	士大夫	685f2f1d-7ef6-c114-0022-88b738cf5c1c	685f2cd3-7ef6-c114-0022-88b50a861368,685f2f1d-7ef6-c114-0022-88b738cf5c1c	3	\N
\.


--
-- Data for Name: scheduled_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_tasks (id, creator_id, creation_time, last_modification_time, last_modifier_id, task_key, task_description, cron_expression, is_active) FROM stdin;
687ae246-5252-956c-0036-60534c5f630a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:09:42.631289	\N	\N	NotificationJob	通知定时提醒	0 0/1 * * * ?	t
\.


--
-- Data for Name: sys_audit_log_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_audit_log_actions (id, tenant_id, audit_log_id, service_name, method_name, parameters, execution_time, execution_duration, extra_properties) FROM stdin;
6888cff1-ca52-4bb0-008f-b8a62f1b5bf1	\N	6888cff0-ca52-4bb0-008f-b8a53cedc68c	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:43:12.661092	266	Volo.Abp.Data.ExtraPropertyDictionary
6888cffd-ca52-4bb0-008f-b8a905c2acca	\N	6888cffd-ca52-4bb0-008f-b8a84cb901ba	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:43:25.086987	67	Volo.Abp.Data.ExtraPropertyDictionary
6888d018-ca52-4bb0-008f-b8ac4299598f	\N	6888d018-ca52-4bb0-008f-b8ab2da9cc71	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:43:52.235401	39	Volo.Abp.Data.ExtraPropertyDictionary
6888d22f-ca52-4bb0-008f-b8af3c9a6723	\N	6888d22f-ca52-4bb0-008f-b8ae5f500ff9	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:52:47.138341	71	Volo.Abp.Data.ExtraPropertyDictionary
6888d239-ca52-4bb0-008f-b8b24902999c	\N	6888d239-ca52-4bb0-008f-b8b1402836c0	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:52:57.475437	45	Volo.Abp.Data.ExtraPropertyDictionary
6888d249-ca52-4bb0-008f-b8b565444225	\N	6888d249-ca52-4bb0-008f-b8b4601873d9	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:53:13.874031	47	Volo.Abp.Data.ExtraPropertyDictionary
6888d2d3-ca52-4bb0-008f-b8b871f9dca2	\N	6888d2d3-ca52-4bb0-008f-b8b73550f70c	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:55:31.560218	46	Volo.Abp.Data.ExtraPropertyDictionary
6888d3a9-1523-a9f0-0020-a91e4b7ddee0	\N	6888d3a9-1523-a9f0-0020-a91d031a40a4	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:59:05.579331	206	Volo.Abp.Data.ExtraPropertyDictionary
6888d3b7-1523-a9f0-0020-a92142be1096	\N	6888d3b7-1523-a9f0-0020-a92040d0c560	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:59:19.239068	105	Volo.Abp.Data.ExtraPropertyDictionary
6888d3c4-1523-a9f0-0020-a92422cef9e0	\N	6888d3c4-1523-a9f0-0020-a92314f3bd90	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 13:59:32.946317	33	Volo.Abp.Data.ExtraPropertyDictionary
6888d82b-8465-d6cc-0063-58d26dafc059	\N	6888d82b-8465-d6cc-0063-58d116dc39b3	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 14:18:19.02541	200	Volo.Abp.Data.ExtraPropertyDictionary
6888d835-8465-d6cc-0063-58d540e0336c	\N	6888d835-8465-d6cc-0063-58d41e42f792	Letu.Basis.Account.AccountAppService	GetUserAuthInfoAsync	{}	2025-07-29 14:18:22.284413	7621	Volo.Abp.Data.ExtraPropertyDictionary
6888d83e-8465-d6cc-0063-58d820779268	\N	6888d83e-8465-d6cc-0063-58d73ea0db05	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 14:18:38.697392	107	Volo.Abp.Data.ExtraPropertyDictionary
6888d845-8465-d6cc-0063-58db747a3afe	\N	6888d845-8465-d6cc-0063-58da52c560a3	Letu.Basis.Account.AccountAppService	GetUserAuthInfoAsync	{}	2025-07-29 14:18:39.597788	5793	Volo.Abp.Data.ExtraPropertyDictionary
6888da08-46f2-018c-0056-9d9e1841311c	\N	6888da08-46f2-018c-0056-9d9d41dcd516	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 14:26:15.982926	233	Volo.Abp.Data.ExtraPropertyDictionary
6888da18-46f2-018c-0056-9da14d9a574d	\N	6888da18-46f2-018c-0056-9da00a51e1fe	Letu.Basis.Account.AccountAppService	GetUserAuthInfoAsync	{}	2025-07-29 14:26:27.507912	4853	Volo.Abp.Data.ExtraPropertyDictionary
6888da8f-f6b8-0774-00c0-ae7f2436bdce	\N	6888da8f-f6b8-0774-00c0-ae7e267752c0	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 14:28:30.786783	230	Volo.Abp.Data.ExtraPropertyDictionary
6888dd09-a97c-0cb0-0051-847a28a6772b	\N	6888dd09-a97c-0cb0-0051-84796050cc54	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 14:39:04.740555	237	Volo.Abp.Data.ExtraPropertyDictionary
6888dd29-a97c-0cb0-0051-847d654bb2a5	\N	6888dd29-a97c-0cb0-0051-847c2951a5e5	Letu.Basis.Admin.Positions.PositionAppService	GetPositionGroupListAsync	{"dto":{"groupName":null,"pageSize":10,"current":1}}	2025-07-29 14:39:21.831064	15679	Volo.Abp.Data.ExtraPropertyDictionary
6888e00c-4bd6-2248-0033-d98b56b51f15	\N	6888e00c-4bd6-2248-0033-d98a7797ed82	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 14:51:55.974424	337	Volo.Abp.Data.ExtraPropertyDictionary
6888e2a1-fa0e-1c34-002b-ca7267878b6f	\N	6888e2a1-fa0e-1c34-002b-ca7139ec675d	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 15:02:56.907659	207	Volo.Abp.Data.ExtraPropertyDictionary
6888e411-aa3b-a858-0035-efed281be90a	\N	6888e411-aa3b-a858-0035-efec129da163	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 15:09:05.286174	313	Volo.Abp.Data.ExtraPropertyDictionary
6888e42c-aa3b-a858-0035-eff22763d3b6	\N	6888e42c-aa3b-a858-0035-eff17811d3c7	Letu.Basis.Admin.Tenants.TenantAppService	GetTenantListAsync	{"dto":{"keyword":null,"pageSize":10,"current":1}}	2025-07-29 15:09:18.198859	14329	Volo.Abp.Data.ExtraPropertyDictionary
6888e4ac-aa3b-a858-0035-eff429955d22	\N	6888e42e-aa3b-a858-0035-eff3496eeec0	Letu.Basis.Admin.Tenants.TenantAppService	GetTenantListAsync	{"dto":{"keyword":null,"pageSize":10,"current":1}}	2025-07-29 15:09:32.556974	1727	Volo.Abp.Data.ExtraPropertyDictionary
6888e627-97f4-a6b4-0020-819c43a0c617	\N	6888e627-97f4-a6b4-0020-819b3fe0ef34	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 15:17:58.780393	299	Volo.Abp.Data.ExtraPropertyDictionary
6888e646-97f4-a6b4-0020-81a160210626	\N	6888e646-97f4-a6b4-0020-81a07f374d51	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0f6cd4d7-802b-d83b-1bed-3a1b67386c04","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc1Mjc4LCJpYXQiOjE3NTM3NzM0NzgsIm5iZiI6MTc1Mzc3MzQ3OCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMGY2Y2Q0ZDctODAyYi1kODNiLTFiZWQtM2ExYjY3Mzg2YzA0IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.KJs_nDC17y05ZG6NuaQzBvh7j3jH4-Hf9GqemUziC7k"}	2025-07-29 15:18:30.475852	0	Volo.Abp.Data.ExtraPropertyDictionary
6888e651-97f4-a6b4-0020-81a379625a2a	\N	6888e651-97f4-a6b4-0020-81a22e5dc4f4	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0f6cd4d7-802b-d83b-1bed-3a1b67386c04","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc1Mjc4LCJpYXQiOjE3NTM3NzM0NzgsIm5iZiI6MTc1Mzc3MzQ3OCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMGY2Y2Q0ZDctODAyYi1kODNiLTFiZWQtM2ExYjY3Mzg2YzA0IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.KJs_nDC17y05ZG6NuaQzBvh7j3jH4-Hf9GqemUziC7k"}	2025-07-29 15:18:41.210603	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fc57-7361-2460-0074-66cf39707f8f	\N	6888fc57-7361-2460-0074-66ce252c30e3	Letu.Basis.Admin.Positions.PositionAppService	UpdatePositionAsync	{"id":"686a9bac-aad5-2c54-003c-a0450445a76f","dto":{"name":"\\u524D\\u7AEF\\u5F00\\u53D1\\u5DE5\\u7A0B\\u5E08","code":"001","level":1,"status":1,"description":null,"groupId":"685f2f1d-7ef6-c114-0022-88b738cf5c1c"}}	2025-07-29 16:52:39.622529	30	Volo.Abp.Data.ExtraPropertyDictionary
6888e788-97f4-a6b4-0020-81a51e6c949d	\N	6888e788-97f4-a6b4-0020-81a4352019e2	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0f6cd4d7-802b-d83b-1bed-3a1b67386c04","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc1Mjc4LCJpYXQiOjE3NTM3NzM0NzgsIm5iZiI6MTc1Mzc3MzQ3OCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMGY2Y2Q0ZDctODAyYi1kODNiLTFiZWQtM2ExYjY3Mzg2YzA0IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.KJs_nDC17y05ZG6NuaQzBvh7j3jH4-Hf9GqemUziC7k"}	2025-07-29 15:23:52.443121	0	Volo.Abp.Data.ExtraPropertyDictionary
6888e796-97f4-a6b4-0020-81a70311dd6d	\N	6888e796-97f4-a6b4-0020-81a6139fdaf5	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0f6cd4d7-802b-d83b-1bed-3a1b67386c04","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc1Mjc4LCJpYXQiOjE3NTM3NzM0NzgsIm5iZiI6MTc1Mzc3MzQ3OCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMGY2Y2Q0ZDctODAyYi1kODNiLTFiZWQtM2ExYjY3Mzg2YzA0IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.KJs_nDC17y05ZG6NuaQzBvh7j3jH4-Hf9GqemUziC7k"}	2025-07-29 15:24:06.674511	0	Volo.Abp.Data.ExtraPropertyDictionary
6888e7e3-97f4-a6b4-0020-81a94df574bd	\N	6888e7e3-97f4-a6b4-0020-81a8261a8ec2	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0f6cd4d7-802b-d83b-1bed-3a1b67386c04","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc1Mjc4LCJpYXQiOjE3NTM3NzM0NzgsIm5iZiI6MTc1Mzc3MzQ3OCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMGY2Y2Q0ZDctODAyYi1kODNiLTFiZWQtM2ExYjY3Mzg2YzA0IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.KJs_nDC17y05ZG6NuaQzBvh7j3jH4-Hf9GqemUziC7k"}	2025-07-29 15:25:23.302335	0	Volo.Abp.Data.ExtraPropertyDictionary
6888eec7-97f4-a6b4-0020-81ab7873621a	\N	6888eec7-97f4-a6b4-0020-81aa7ee92288	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 15:54:47.297072	73	Volo.Abp.Data.ExtraPropertyDictionary
6888eee3-97f4-a6b4-0020-81ae3851c3f3	\N	6888eee3-97f4-a6b4-0020-81ad02bcafcc	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 15:55:15.410423	0	Volo.Abp.Data.ExtraPropertyDictionary
6888ef21-97f4-a6b4-0020-81b0003e9e32	\N	6888ef21-97f4-a6b4-0020-81af56a4904d	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 15:56:17.077252	0	Volo.Abp.Data.ExtraPropertyDictionary
6888ef26-97f4-a6b4-0020-81b20db2c5c3	\N	6888ef26-97f4-a6b4-0020-81b13de19057	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 15:56:22.046617	0	Volo.Abp.Data.ExtraPropertyDictionary
6888ef2a-97f4-a6b4-0020-81b42009ca2a	\N	6888ef2a-97f4-a6b4-0020-81b33dafd972	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 15:56:26.55912	0	Volo.Abp.Data.ExtraPropertyDictionary
6888ef30-97f4-a6b4-0020-81b6754feade	\N	6888ef30-97f4-a6b4-0020-81b52ffeb558	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 15:56:32.148575	0	Volo.Abp.Data.ExtraPropertyDictionary
6888ef34-97f4-a6b4-0020-81b85f47017f	\N	6888ef34-97f4-a6b4-0020-81b76880528a	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 15:56:36.17213	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f04b-97f4-a6b4-0020-81ba3ef7c833	\N	6888f04b-97f4-a6b4-0020-81b94afc9252	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 16:01:15.834322	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f24b-97f4-a6b4-0020-81bc3bf69b12	\N	6888f24b-97f4-a6b4-0020-81bb15cff48b	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 16:09:47.777128	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f54c-97f4-a6b4-0020-81bf68d77c12	\N	6888f54c-97f4-a6b4-0020-81bd6164c6c2	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 16:22:36.294849	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f54c-97f4-a6b4-0020-81c056f3e631	\N	6888f54c-97f4-a6b4-0020-81be06514060	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 16:22:36.296217	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f54c-97f4-a6b4-0020-81c2137e6eaf	\N	6888f54c-97f4-a6b4-0020-81c12badb51b	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"492c91f31a7bc04f59303a1b675a1ead"}	2025-07-29 16:22:36.468849	51	Volo.Abp.Data.ExtraPropertyDictionary
6888f54c-97f4-a6b4-0020-81c4091d5b6f	\N	6888f54c-97f4-a6b4-0020-81c37066f2e2	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"492c91f31a7bc04f59303a1b675a1ead"}	2025-07-29 16:22:36.464763	71	Volo.Abp.Data.ExtraPropertyDictionary
6888f54c-97f4-a6b4-0020-81c83703a5a6	\N	6888f54c-97f4-a6b4-0020-81c71328a970	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc3NDg3LCJpYXQiOjE3NTM3NzU2ODcsIm5iZiI6MTc1Mzc3NTY4NywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.b0rpRB7gAMKzZiZc81jYtryXs1fGdnbiFiGoMnQ1FFk"}	2025-07-29 16:22:36.609479	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f56f-97f4-a6b4-0020-81ca022269ff	\N	6888f56f-97f4-a6b4-0020-81c9301f0117	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:23:11.458969	0	Volo.Abp.Data.ExtraPropertyDictionary
68890d2b-7361-2460-0074-66ed6338cfc2	\N	68890d2b-7361-2460-0074-66ec7117b19d	Letu.Basis.Admin.Departments.DepartmentAppService	AddDeptAsync	{"dto":{"id":null,"name":"test","code":"d","sort":0,"description":null,"status":1,"curatorId":null,"email":null,"phone":null,"parentId":"6861a4ed-de18-91c8-009e-ef9b36642c3c"}}	2025-07-29 18:04:27.153728	32	Volo.Abp.Data.ExtraPropertyDictionary
6888f7bd-97f4-a6b4-0020-81cc084639e3	\N	6888f7bd-97f4-a6b4-0020-81cb1ee00262	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:33:01.615512	1	Volo.Abp.Data.ExtraPropertyDictionary
6888f7bd-97f4-a6b4-0020-81ce62df3ca6	\N	6888f7bd-97f4-a6b4-0020-81cd22ec828d	Letu.Basis.Admin.Positions.PositionAppService	UpdatePositionGroupAsync	{"id":"685f2f1d-7ef6-c114-0022-88b738cf5c1c","dto":{"parentId":"685f2cd3-7ef6-c114-0022-88b50a861368","groupName":"\\u524D\\u7AEF","remark":null,"sort":0}}	2025-07-29 16:33:01.752269	59	Volo.Abp.Data.ExtraPropertyDictionary
6888f7c8-97f4-a6b4-0020-81d0176fe318	\N	6888f7c8-97f4-a6b4-0020-81cf38ea8555	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:33:12.791008	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f7c8-97f4-a6b4-0020-81d365812d61	\N	6888f7c8-97f4-a6b4-0020-81d25ef8c517	Letu.Basis.Admin.Positions.PositionAppService	AddPositionGroupAsync	{"dto":{"parentId":"685f2f1d-7ef6-c114-0022-88b738cf5c1c","groupName":"\\u58EB\\u5927\\u592B","remark":"\\u58EB\\u5927\\u592B","sort":3}}	2025-07-29 16:33:12.85166	26	Volo.Abp.Data.ExtraPropertyDictionary
6888f9c1-97f4-a6b4-0020-81d555da432b	\N	6888f9c1-97f4-a6b4-0020-81d47cef1696	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:41:37.446358	0	Volo.Abp.Data.ExtraPropertyDictionary
6888f9c1-97f4-a6b4-0020-81d7605849ae	\N	6888f9c1-97f4-a6b4-0020-81d619d3d6d6	Letu.Basis.Admin.Positions.PositionAppService	UpdatePositionAsync	{"id":"686a9bac-aad5-2c54-003c-a0450445a76f","dto":{"name":"\\u524D\\u7AEF\\u5F00\\u53D1\\u5DE5\\u7A0B\\u5E08","code":"001","level":1,"status":1,"description":null,"groupId":"685f2f1d-7ef6-c114-0022-88b738cf5c1c"}}	2025-07-29 16:41:37.498371	33	Volo.Abp.Data.ExtraPropertyDictionary
6888fa1c-97f4-a6b4-0020-81d90de692a9	\N	6888fa1c-97f4-a6b4-0020-81d87b5c8b7a	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:43:08.356448	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fa6d-97f4-a6b4-0020-81db0fa4f6a0	\N	6888fa6d-97f4-a6b4-0020-81da04a4c550	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"2c5508362a1027ed816f3a1b677396c8"}	2025-07-29 16:43:08.400168	81474	Volo.Abp.Data.ExtraPropertyDictionary
6888fa70-97f4-a6b4-0020-81dd262c3179	\N	6888fa70-97f4-a6b4-0020-81dc228bc289	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:44:32.356203	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fa72-97f4-a6b4-0020-81df18b3c78b	\N	6888fa72-97f4-a6b4-0020-81de7049be52	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"2c5508362a1027ed816f3a1b677396c8"}	2025-07-29 16:44:32.408148	1855	Volo.Abp.Data.ExtraPropertyDictionary
6888fa74-97f4-a6b4-0020-81e146607c4a	\N	6888fa74-97f4-a6b4-0020-81e026fba60c	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:44:36.526002	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fa76-97f4-a6b4-0020-81e36503c959	\N	6888fa76-97f4-a6b4-0020-81e27ca3b069	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"2c5508362a1027ed816f3a1b677396c8"}	2025-07-29 16:44:36.584931	1723	Volo.Abp.Data.ExtraPropertyDictionary
688911cc-9894-256c-00d8-1cde76d593f2	\N	688911cc-9894-256c-00d8-1cdd1d7b2dff	Letu.Basis.Admin.Users.UserAppService	AssignRoleAsync	{"userId":"89d5a892-4153-459b-89cb-b5fa7ccfabc2","input":{"roleIds":["3a172369-28a4-e37e-b78a-8c3eaec17359"]}}	2025-07-29 18:24:12.721187	16	Volo.Abp.Data.ExtraPropertyDictionary
6888fa78-97f4-a6b4-0020-81e5447de041	\N	6888fa78-97f4-a6b4-0020-81e41612b86f	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:44:40.221024	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fa7a-97f4-a6b4-0020-81e74f2d96bc	\N	6888fa7a-97f4-a6b4-0020-81e64e5a4195	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"2c5508362a1027ed816f3a1b677396c8"}	2025-07-29 16:44:40.291983	1791	Volo.Abp.Data.ExtraPropertyDictionary
6888fa7d-97f4-a6b4-0020-81e94aa4354b	\N	6888fa7d-97f4-a6b4-0020-81e801c7299d	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:44:45.123784	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fa88-97f4-a6b4-0020-81eb6e0219bb	\N	6888fa88-97f4-a6b4-0020-81ea62254b63	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"2c5508362a1027ed816f3a1b677396c8"}	2025-07-29 16:44:45.161371	10913	Volo.Abp.Data.ExtraPropertyDictionary
6888fa92-97f4-a6b4-0020-81ed0ee2ee45	\N	6888fa92-97f4-a6b4-0020-81ec1221a8f3	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:45:06.023116	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fabc-97f4-a6b4-0020-81ef77734feb	\N	6888fabc-97f4-a6b4-0020-81ee435609af	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"2c5508362a1027ed816f3a1b677396c8"}	2025-07-29 16:45:06.059701	42831	Volo.Abp.Data.ExtraPropertyDictionary
6888faf7-7361-2460-0074-66b2660c3335	\N	6888faf6-7361-2460-0074-66b144af62c8	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:46.872504	14	Volo.Abp.Data.ExtraPropertyDictionary
6888faf8-7361-2460-0074-66b430e3dba6	\N	6888faf8-7361-2460-0074-66b33338ffb6	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:48.942431	4	Volo.Abp.Data.ExtraPropertyDictionary
6888faf9-7361-2460-0074-66b60bcaae33	\N	6888faf9-7361-2460-0074-66b516e33374	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:49.004351	0	Volo.Abp.Data.ExtraPropertyDictionary
6888faf9-7361-2460-0074-66b800ff658d	\N	6888faf9-7361-2460-0074-66b761bc3715	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:49.153414	0	Volo.Abp.Data.ExtraPropertyDictionary
6889fc74-5050-4dc8-0093-d02f6eafeefb	\N	6889fc74-5050-4dc8-0093-d02e19a9eaa2	Letu.Basis.Admin.Tenants.TenantAppService	AddTenantAsync	{"input":{"name":"test11","remark":null,"domain":null}}	2025-07-30 11:05:24.310819	32	Volo.Abp.Data.ExtraPropertyDictionary
6888faf9-7361-2460-0074-66bb48df16a3	\N	6888faf9-7361-2460-0074-66b91c7a7e0b	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:49.643839	1	Volo.Abp.Data.ExtraPropertyDictionary
6888faf9-7361-2460-0074-66bd29ffef84	\N	6888faf9-7361-2460-0074-66ba582925a4	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:49.651997	1	Volo.Abp.Data.ExtraPropertyDictionary
6888faf9-7361-2460-0074-66be1a5a33c4	\N	6888faf9-7361-2460-0074-66bc53437ab4	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:49.68895	7	Volo.Abp.Data.ExtraPropertyDictionary
6888fafa-7361-2460-0074-66c02d161832	\N	6888fafa-7361-2460-0074-66bf1a09069d	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:50.818898	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fafc-7361-2460-0074-66c20bf506bb	\N	6888fafc-7361-2460-0074-66c13024966c	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:52.893014	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fb00-7361-2460-0074-66c413ebc1a7	\N	6888fb00-7361-2460-0074-66c354e65f44	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:46:56.971536	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fb99-7361-2460-0074-66c742ae788f	\N	6888fb99-7361-2460-0074-66c51403fa62	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:49:29.640423	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fb99-7361-2460-0074-66c827c169b9	\N	6888fb99-7361-2460-0074-66c650faab78	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzc5MTU2LCJpYXQiOjE3NTM3NzczNTYsIm5iZiI6MTc1Mzc3NzM1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiOGVkMmZmNzUtOGVjNS03YmUxLWJkMTQtM2ExYjY3NWExZWFjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HSUQXLDVC9jXdeOLDAWLPLnsi5CRTG8KFOJerl0ew3U"}	2025-07-29 16:49:29.640193	1	Volo.Abp.Data.ExtraPropertyDictionary
6888fbd1-7361-2460-0074-66ca04466978	\N	6888fbd1-7361-2460-0074-66c931fc1e7e	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 16:50:25.534595	170	Volo.Abp.Data.ExtraPropertyDictionary
6888fc57-7361-2460-0074-66cd76ac5f0d	\N	6888fc57-7361-2460-0074-66cc3fb3244e	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"be846636-b2fd-98dc-822c-3a1b678d0ede","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzgwODI1LCJpYXQiOjE3NTM3NzkwMjUsIm5iZiI6MTc1Mzc3OTAyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmU4NDY2MzYtYjJmZC05OGRjLTgyMmMtM2ExYjY3OGQwZWRlIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HH5I9Z5UsgeTksYcKflYVblzu_XGKpGSJDFtZBdCfB4"}	2025-07-29 16:52:39.565033	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fe0d-7361-2460-0074-66d1443d1c4e	\N	6888fe0c-7361-2460-0074-66d064019396	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"be846636-b2fd-98dc-822c-3a1b678d0ede","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzgwODI1LCJpYXQiOjE3NTM3NzkwMjUsIm5iZiI6MTc1Mzc3OTAyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmU4NDY2MzYtYjJmZC05OGRjLTgyMmMtM2ExYjY3OGQwZWRlIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HH5I9Z5UsgeTksYcKflYVblzu_XGKpGSJDFtZBdCfB4"}	2025-07-29 16:59:56.995546	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fe0d-7361-2460-0074-66d312915497	\N	6888fe0d-7361-2460-0074-66d215db80e9	Letu.Basis.Admin.Positions.PositionAppService	UpdatePositionAsync	{"id":"686a9bac-aad5-2c54-003c-a0450445a76f","dto":{"name":"\\u524D\\u7AEF\\u5F00\\u53D1\\u5DE5\\u7A0B\\u5E08","code":"001","level":1,"status":1,"description":null,"groupId":"685f2f1d-7ef6-c114-0022-88b738cf5c1c"}}	2025-07-29 16:59:57.066664	12	Volo.Abp.Data.ExtraPropertyDictionary
6888fe1a-7361-2460-0074-66d559344283	\N	6888fe19-7361-2460-0074-66d44be04d92	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"be846636-b2fd-98dc-822c-3a1b678d0ede","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzgwODI1LCJpYXQiOjE3NTM3NzkwMjUsIm5iZiI6MTc1Mzc3OTAyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmU4NDY2MzYtYjJmZC05OGRjLTgyMmMtM2ExYjY3OGQwZWRlIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HH5I9Z5UsgeTksYcKflYVblzu_XGKpGSJDFtZBdCfB4"}	2025-07-29 17:00:09.993791	0	Volo.Abp.Data.ExtraPropertyDictionary
6888fe1a-7361-2460-0074-66d85bd7f517	\N	6888fe1a-7361-2460-0074-66d7161ffaee	Letu.Basis.Admin.Positions.PositionAppService	AddPositionAsync	{"dto":{"name":"test","code":"d","level":2,"status":1,"description":null,"groupId":"685f2f1d-7ef6-c114-0022-88b738cf5c1c"}}	2025-07-29 17:00:10.052624	30	Volo.Abp.Data.ExtraPropertyDictionary
6889029a-7361-2460-0074-66da443fd112	\N	6889029a-7361-2460-0074-66d90ba0603d	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"be846636-b2fd-98dc-822c-3a1b678d0ede","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzgwODI1LCJpYXQiOjE3NTM3NzkwMjUsIm5iZiI6MTc1Mzc3OTAyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmU4NDY2MzYtYjJmZC05OGRjLTgyMmMtM2ExYjY3OGQwZWRlIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.HH5I9Z5UsgeTksYcKflYVblzu_XGKpGSJDFtZBdCfB4"}	2025-07-29 17:19:22.32742	0	Volo.Abp.Data.ExtraPropertyDictionary
6889029a-7361-2460-0074-66dc2d379515	\N	6889029a-7361-2460-0074-66db4ffe39a9	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"35362a2ba1905be438953a1b678d0ee7"}	2025-07-29 17:19:22.405535	46	Volo.Abp.Data.ExtraPropertyDictionary
68890459-7361-2460-0074-66df5399053e	\N	68890459-7361-2460-0074-66de6557945c	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"be846636-b2fd-98dc-822c-3a1b678d0ede","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzgyNTYyLCJpYXQiOjE3NTM3ODA3NjIsIm5iZiI6MTc1Mzc4MDc2MiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmU4NDY2MzYtYjJmZC05OGRjLTgyMmMtM2ExYjY3OGQwZWRlIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.u9_JUuUQwxUE5cqAt20hge_1AVFyN3ooTqwisFfVh2A"}	2025-07-29 17:26:49.814446	0	Volo.Abp.Data.ExtraPropertyDictionary
6889045a-7361-2460-0074-66e17bf38049	\N	6889045a-7361-2460-0074-66e05672b64c	Letu.Basis.Admin.Positions.PositionAppService	UpdatePositionAsync	{"id":"686a9bac-aad5-2c54-003c-a0450445a76f","dto":{"name":"\\u524D\\u7AEF\\u5F00\\u53D1\\u5DE5\\u7A0B\\u5E08","code":"001","level":2,"status":1,"description":null,"groupId":"685f2f1d-7ef6-c114-0022-88b738cf5c1c"}}	2025-07-29 17:26:49.960965	46	Volo.Abp.Data.ExtraPropertyDictionary
68890aff-7361-2460-0074-66e376ec8acd	\N	68890aff-7361-2460-0074-66e2431e007e	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 17:55:11.40816	70	Volo.Abp.Data.ExtraPropertyDictionary
68890d1d-7361-2460-0074-66e67290a4ca	\N	68890d1d-7361-2460-0074-66e52ee1c677	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:04:13.89174	0	Volo.Abp.Data.ExtraPropertyDictionary
68890d1e-7361-2460-0074-66e840bf8851	\N	68890d1e-7361-2460-0074-66e72a859e32	Letu.Basis.Admin.Departments.DepartmentAppService	UpdateDeptAsync	{"dto":{"id":"6861a4ed-de18-91c8-009e-ef9b36642c3c","name":"\\u79D1\\u6280\\u6709\\u9650\\u516C\\u53F8","code":"root","sort":1,"description":null,"status":1,"curatorId":"6869907c-9c93-beac-0062-34172a640e0e","email":null,"phone":null,"parentId":"6861a543-de18-91c8-009e-ef9c48eee11a"}}	2025-07-29 18:04:13.956348	112	Volo.Abp.Data.ExtraPropertyDictionary
68890d2b-7361-2460-0074-66ea27d9b934	\N	68890d2b-7361-2460-0074-66e909becc0b	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:04:27.10805	0	Volo.Abp.Data.ExtraPropertyDictionary
68890d46-7361-2460-0074-66ef55c36ed6	\N	68890d46-7361-2460-0074-66ee1120605c	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:04:54.302689	0	Volo.Abp.Data.ExtraPropertyDictionary
68890d50-7361-2460-0074-66f54113ab65	\N	68890d50-7361-2460-0074-66f40a86893a	Letu.Basis.Admin.Employees.EmployeeAppService	EmployeeBindUserAsync	{"dto":{"userId":"3e64db48-e302-46f7-87d8-dc3f8c4bd428","employeeId":"6869907c-9c93-beac-0062-34172a640e0e"}}	2025-07-29 18:05:04.51279	26	Volo.Abp.Data.ExtraPropertyDictionary
68890d70-7361-2460-0074-66fa611e8db1	\N	68890d70-7361-2460-0074-66f9453c1a6b	Letu.Basis.Admin.Employees.EmployeeAppService	AddEmployeeAsync	{"dto":{"id":null,"name":"test","code":"123","sex":1,"phone":"123","idNo":null,"frontIdNoUrl":null,"backIdNoUrl":null,"birthday":null,"address":null,"email":"scfido@gmail.com","inTime":"2025-06-29T16:00:00Z","outTime":null,"status":1,"userId":null,"deptId":null,"positionId":null,"isAddUser":false,"userPassword":null}}	2025-07-29 18:05:36.528118	30	Volo.Abp.Data.ExtraPropertyDictionary
68890d46-7361-2460-0074-66f10a8f72c0	\N	68890d46-7361-2460-0074-66f03f58c53c	Letu.Basis.Admin.Employees.EmployeeAppService	UpdateEmployeeAsync	{"dto":{"id":"6869907c-9c93-beac-0062-34172a640e0e","name":"tom","code":"001","sex":1,"phone":"18211114444","idNo":null,"frontIdNoUrl":null,"backIdNoUrl":null,"birthday":null,"address":null,"email":null,"inTime":"0001-01-01T00:00:00","outTime":null,"status":1,"userId":null,"deptId":"6861a4ed-de18-91c8-009e-ef9b36642c3c","positionId":"685f2cd3-7ef6-c114-0022-88b50a861368","isAddUser":false,"userPassword":null}}	2025-07-29 18:04:54.368082	37	Volo.Abp.Data.ExtraPropertyDictionary
68890d50-7361-2460-0074-66f323fbd102	\N	68890d50-7361-2460-0074-66f25865b238	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:05:04.448762	0	Volo.Abp.Data.ExtraPropertyDictionary
68890d70-7361-2460-0074-66f766ba4d40	\N	68890d70-7361-2460-0074-66f6507a203f	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:05:36.463521	0	Volo.Abp.Data.ExtraPropertyDictionary
68890dc6-7361-2460-0074-66fc7c2ab1c5	\N	68890dc6-7361-2460-0074-66fb268ec0f4	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:07:02.478016	0	Volo.Abp.Data.ExtraPropertyDictionary
68890e44-21b2-19c0-00d4-130e475b1abd	\N	68890e44-21b2-19c0-00d4-130d4e28cc74	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:09:08.515919	10	Volo.Abp.Data.ExtraPropertyDictionary
68890e49-21b2-19c0-00d4-13106b4d0250	\N	68890e49-21b2-19c0-00d4-130f7745359c	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:09:13.69634	0	Volo.Abp.Data.ExtraPropertyDictionary
68890e4d-21b2-19c0-00d4-13122224a900	\N	68890e4d-21b2-19c0-00d4-1311201ceaf7	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:09:17.791	0	Volo.Abp.Data.ExtraPropertyDictionary
68890e62-21b2-19c0-00d4-13144805e3a5	\N	68890e62-21b2-19c0-00d4-1313785a3713	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:09:38.211357	0	Volo.Abp.Data.ExtraPropertyDictionary
688b9b25-9fe2-97e8-002b-fddc1f2a1f1b	\N	b7d658d9-2bed-f286-5881-3a1b71cb6df8	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 16:34:45.096393	222	Volo.Abp.Data.ExtraPropertyDictionary
688b9b4a-9fe2-97e8-002b-fddd652270fa	\N	8c930681-0ea9-827b-74f3-3a1b71cbff53	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 16:35:22.576015	3	Volo.Abp.Data.ExtraPropertyDictionary
688b9b4c-9fe2-97e8-002b-fdde0b65efec	\N	aff9616f-29f8-4cc4-2d21-3a1b71cc069a	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 16:35:24.403058	40	Volo.Abp.Data.ExtraPropertyDictionary
68890ebe-21b2-19c0-00d4-131623e7eeb8	\N	68890ebe-21b2-19c0-00d4-1315772558c6	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"4d98b780-c3ef-e5b3-2631-3a1b67c859d2","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg0NzExLCJpYXQiOjE3NTM3ODI5MTEsIm5iZiI6MTc1Mzc4MjkxMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNGQ5OGI3ODAtYzNlZi1lNWIzLTI2MzEtM2ExYjY3Yzg1OWQyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.e4TjNaPdtXDyXxePMFpNCXeYXvc5Xh20WmugjzZkrEs"}	2025-07-29 18:11:10.35401	0	Volo.Abp.Data.ExtraPropertyDictionary
68890f63-21b2-19c0-00d4-131876e53686	\N	68890f63-21b2-19c0-00d4-1317270bfaab	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 18:13:55.601872	241	Volo.Abp.Data.ExtraPropertyDictionary
68890f9b-21b2-19c0-00d4-131b397247bc	\N	68890f9b-21b2-19c0-00d4-131a202da3c1	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"699573ed-159e-cf7b-7f28-3a1b67d981b0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg1ODM1LCJpYXQiOjE3NTM3ODQwMzUsIm5iZiI6MTc1Mzc4NDAzNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNjk5NTczZWQtMTU5ZS1jZjdiLTdmMjgtM2ExYjY3ZDk4MWIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.jqA3UV03KVGHT4eInSrhiObVUv7yzim4o0hdkFPUqsw"}	2025-07-29 18:14:51.36129	0	Volo.Abp.Data.ExtraPropertyDictionary
68890f9b-21b2-19c0-00d4-131e7bfab25c	\N	68890f9b-21b2-19c0-00d4-131d34251a24	Letu.Basis.Admin.Notifications.NotificationAppService	AddNotificationAsync	{"dto":{"title":"test","content":null,"employeeId":"6869907c-9c93-beac-0062-34172a640e0e"}}	2025-07-29 18:14:51.420485	28	Volo.Abp.Data.ExtraPropertyDictionary
68890fc0-21b2-19c0-00d4-132254aec734	\N	68890fc0-21b2-19c0-00d4-132104dbe7f3	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"699573ed-159e-cf7b-7f28-3a1b67d981b0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg1ODM1LCJpYXQiOjE3NTM3ODQwMzUsIm5iZiI6MTc1Mzc4NDAzNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNjk5NTczZWQtMTU5ZS1jZjdiLTdmMjgtM2ExYjY3ZDk4MWIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.jqA3UV03KVGHT4eInSrhiObVUv7yzim4o0hdkFPUqsw"}	2025-07-29 18:15:28.632689	0	Volo.Abp.Data.ExtraPropertyDictionary
68890fc0-21b2-19c0-00d4-132416b19efe	\N	68890fc0-21b2-19c0-00d4-13233f546eec	Letu.Basis.Admin.Employees.EmployeeAppService	UpdateEmployeeAsync	{"dto":{"id":"6869907c-9c93-beac-0062-34172a640e0e","name":"tom","code":"001","sex":1,"phone":"18211114444","idNo":null,"frontIdNoUrl":null,"backIdNoUrl":null,"birthday":null,"address":null,"email":null,"inTime":"0001-01-01T00:00:00","outTime":null,"status":1,"userId":null,"deptId":"6861a4ed-de18-91c8-009e-ef9b36642c3c","positionId":"685f2cd3-7ef6-c114-0022-88b50a861368","isAddUser":false,"userPassword":null}}	2025-07-29 18:15:28.716614	63	Volo.Abp.Data.ExtraPropertyDictionary
68890fcf-21b2-19c0-00d4-13283e706ea7	\N	68890fcf-21b2-19c0-00d4-13270a2e84f9	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"699573ed-159e-cf7b-7f28-3a1b67d981b0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg1ODM1LCJpYXQiOjE3NTM3ODQwMzUsIm5iZiI6MTc1Mzc4NDAzNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNjk5NTczZWQtMTU5ZS1jZjdiLTdmMjgtM2ExYjY3ZDk4MWIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.jqA3UV03KVGHT4eInSrhiObVUv7yzim4o0hdkFPUqsw"}	2025-07-29 18:15:43.119157	0	Volo.Abp.Data.ExtraPropertyDictionary
68890fcf-21b2-19c0-00d4-132a3bf5eca9	\N	68890fcf-21b2-19c0-00d4-13295663609c	Letu.Basis.Admin.Users.UserAppService	ResetUserPasswordAsync	{"dto":{"userId":"00de38c4-17bd-415f-bf1c-2e0873eb177e","password":"123qwe*"}}	2025-07-29 18:15:43.255219	39	Volo.Abp.Data.ExtraPropertyDictionary
68891162-9894-256c-00d8-1cca773305b8	\N	68891162-9894-256c-00d8-1cc96ea601fb	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-29 18:22:26.527639	216	Volo.Abp.Data.ExtraPropertyDictionary
688911b7-9894-256c-00d8-1ccf4e6923a0	\N	688911b7-9894-256c-00d8-1cce4d0ae716	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"868d0315-0bd1-5032-ac8c-3a1b67e14d58","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg2MzQ2LCJpYXQiOjE3NTM3ODQ1NDYsIm5iZiI6MTc1Mzc4NDU0NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODY4ZDAzMTUtMGJkMS01MDMyLWFjOGMtM2ExYjY3ZTE0ZDU4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.VLXElH383lU6eByDvQTla6K4xYFripCIUU2RjAHIcfI"}	2025-07-29 18:23:51.785689	0	Volo.Abp.Data.ExtraPropertyDictionary
688911b7-9894-256c-00d8-1cd2298da3e4	\N	688911b7-9894-256c-00d8-1cd13358c8c5	Letu.Basis.Admin.Users.UserAppService	AssignRoleAsync	{"userId":"3e64db48-e302-46f7-87d8-dc3f8c4bd428","input":{"roleIds":["687047ef-1649-9660-0098-4182062f682c"]}}	2025-07-29 18:23:51.822254	30	Volo.Abp.Data.ExtraPropertyDictionary
688911c5-9894-256c-00d8-1cd55b390dc3	\N	688911c5-9894-256c-00d8-1cd4155745a7	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"868d0315-0bd1-5032-ac8c-3a1b67e14d58","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg2MzQ2LCJpYXQiOjE3NTM3ODQ1NDYsIm5iZiI6MTc1Mzc4NDU0NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODY4ZDAzMTUtMGJkMS01MDMyLWFjOGMtM2ExYjY3ZTE0ZDU4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.VLXElH383lU6eByDvQTla6K4xYFripCIUU2RjAHIcfI"}	2025-07-29 18:24:05.643437	0	Volo.Abp.Data.ExtraPropertyDictionary
688911c5-9894-256c-00d8-1cd71200ac4d	\N	688911c5-9894-256c-00d8-1cd642fe9f78	Letu.Basis.Admin.Users.UserAppService	AddUserAsync	{"dto":{"id":null,"userName":"admin1","password":"123qwe*","avatar":null,"nickName":"111","sex":1,"phone":null}}	2025-07-29 18:24:05.699452	37	Volo.Abp.Data.ExtraPropertyDictionary
688911cc-9894-256c-00d8-1cdb5d745d81	\N	688911cc-9894-256c-00d8-1cda5a1cceed	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"868d0315-0bd1-5032-ac8c-3a1b67e14d58","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg2MzQ2LCJpYXQiOjE3NTM3ODQ1NDYsIm5iZiI6MTc1Mzc4NDU0NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODY4ZDAzMTUtMGJkMS01MDMyLWFjOGMtM2ExYjY3ZTE0ZDU4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.VLXElH383lU6eByDvQTla6K4xYFripCIUU2RjAHIcfI"}	2025-07-29 18:24:12.686945	0	Volo.Abp.Data.ExtraPropertyDictionary
688911d5-9894-256c-00d8-1ce60ff0234e	\N	688911d5-9894-256c-00d8-1ce5739c5f6f	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"868d0315-0bd1-5032-ac8c-3a1b67e14d58","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg2MzQ2LCJpYXQiOjE3NTM3ODQ1NDYsIm5iZiI6MTc1Mzc4NDU0NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODY4ZDAzMTUtMGJkMS01MDMyLWFjOGMtM2ExYjY3ZTE0ZDU4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.VLXElH383lU6eByDvQTla6K4xYFripCIUU2RjAHIcfI"}	2025-07-29 18:24:21.621184	0	Volo.Abp.Data.ExtraPropertyDictionary
688911d5-9894-256c-00d8-1cec6a08ba08	\N	688911d5-9894-256c-00d8-1ceb0979b354	Letu.Basis.Admin.Roles.RoleAppService	AssignMenuAsync	{"dto":{"roleId":"687047ef-1649-9660-0098-4182062f682c","menuIds":["3a13a4fe-6f74-733b-a628-6125c0325481","3a13bcf2-3701-be8e-4ec8-ad5f77536101","3a13bcfd-52bb-db4a-d508-eea8536c8bdc","3a174174-857e-2328-55e6-395fcffb3774"]}}	2025-07-29 18:24:21.680511	46	Volo.Abp.Data.ExtraPropertyDictionary
688911d9-9894-256c-00d8-1cef1ea9c245	\N	688911d9-9894-256c-00d8-1cee612e2f7f	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"868d0315-0bd1-5032-ac8c-3a1b67e14d58","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg2MzQ2LCJpYXQiOjE3NTM3ODQ1NDYsIm5iZiI6MTc1Mzc4NDU0NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODY4ZDAzMTUtMGJkMS01MDMyLWFjOGMtM2ExYjY3ZTE0ZDU4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.VLXElH383lU6eByDvQTla6K4xYFripCIUU2RjAHIcfI"}	2025-07-29 18:24:25.165761	0	Volo.Abp.Data.ExtraPropertyDictionary
688911d0-9894-256c-00d8-1ce1494a87a7	\N	688911d0-9894-256c-00d8-1ce00cf1b018	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"868d0315-0bd1-5032-ac8c-3a1b67e14d58","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzNzg2MzQ2LCJpYXQiOjE3NTM3ODQ1NDYsIm5iZiI6MTc1Mzc4NDU0NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODY4ZDAzMTUtMGJkMS01MDMyLWFjOGMtM2ExYjY3ZTE0ZDU4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.VLXElH383lU6eByDvQTla6K4xYFripCIUU2RjAHIcfI"}	2025-07-29 18:24:16.460205	0	Volo.Abp.Data.ExtraPropertyDictionary
688911d0-9894-256c-00d8-1ce303f42119	\N	688911d0-9894-256c-00d8-1ce21b129d23	Letu.Basis.Admin.Users.UserAppService	DeleteUserAsync	{"id":"89d5a892-4153-459b-89cb-b5fa7ccfabc2"}	2025-07-29 18:24:16.519302	20	Volo.Abp.Data.ExtraPropertyDictionary
688911d9-9894-256c-00d8-1cf15be8d552	\N	688911d9-9894-256c-00d8-1cf01140617f	Letu.Basis.Admin.Roles.RoleAppService	UpdateRoleAsync	{"dto":{"id":"687047ef-1649-9660-0098-4182062f682c","roleName":"\\u6D4B\\u8BD5","remark":"\\u6D4B\\u8BD5\\u83DC\\u5355\\u6743\\u9650","isEnabled":true}}	2025-07-29 18:24:25.210331	32	Volo.Abp.Data.ExtraPropertyDictionary
6889f848-d022-c7cc-0034-4d2b08615063	\N	6889f848-d022-c7cc-0034-4d2a4a4bb31f	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 10:47:35.877606	363	Volo.Abp.Data.ExtraPropertyDictionary
6889f85b-d022-c7cc-0034-4d301cd36ac7	\N	6889f85b-d022-c7cc-0034-4d2f69153b18	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"5deb6a75-40d3-8048-3864-3a1b6b673d4c","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ1NDU2LCJpYXQiOjE3NTM4NDM2NTYsIm5iZiI6MTc1Mzg0MzY1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNWRlYjZhNzUtNDBkMy04MDQ4LTM4NjQtM2ExYjZiNjczZDRjIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.AQZtVr_SqSQ1lwJd0XHLWZmhI5gh4eN13NASM3SsHG0"}	2025-07-30 10:47:55.260732	0	Volo.Abp.Data.ExtraPropertyDictionary
6889f85b-d022-c7cc-0034-4d3308c9a935	\N	6889f85b-d022-c7cc-0034-4d3270b0ca08	Letu.Basis.Admin.Users.UserAppService	AddUserAsync	{"dto":{"id":null,"userName":"admin1","password":"123qwe*","avatar":null,"nickName":"222","sex":2,"phone":null}}	2025-07-30 10:47:55.344595	36	Volo.Abp.Data.ExtraPropertyDictionary
6889f9e9-c58e-60d8-0066-5ec85668bb95	\N	6889f9e9-c58e-60d8-0066-5ec744c3c90b	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 10:54:33.404779	206	Volo.Abp.Data.ExtraPropertyDictionary
6889f9fc-c58e-60d8-0066-5ecb74862ec6	\N	6889f9fc-c58e-60d8-0066-5eca1d71cdd0	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"25e2e3df-6169-32d2-0359-3a1b6b6d9c27","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ1ODczLCJpYXQiOjE3NTM4NDQwNzMsIm5iZiI6MTc1Mzg0NDA3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMjVlMmUzZGYtNjE2OS0zMmQyLTAzNTktM2ExYjZiNmQ5YzI3IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.yRcZcXgaUugg_mLOHyhGjDYwBpwDPw6_J8rTWQUu8b8"}	2025-07-30 10:54:52.787737	0	Volo.Abp.Data.ExtraPropertyDictionary
6889f9fc-c58e-60d8-0066-5ece2056cd7e	\N	6889f9fc-c58e-60d8-0066-5ecd27d4e51a	Letu.Basis.Admin.Tenants.TenantAppService	AddTenantAsync	{"input":{"name":"test","remark":null,"domain":null}}	2025-07-30 10:54:52.852988	30	Volo.Abp.Data.ExtraPropertyDictionary
6889fa87-c58e-60d8-0066-5ed16a87884e	\N	6889fa87-c58e-60d8-0066-5ed0695c4ee5	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"25e2e3df-6169-32d2-0359-3a1b6b6d9c27","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ1ODczLCJpYXQiOjE3NTM4NDQwNzMsIm5iZiI6MTc1Mzg0NDA3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMjVlMmUzZGYtNjE2OS0zMmQyLTAzNTktM2ExYjZiNmQ5YzI3IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.yRcZcXgaUugg_mLOHyhGjDYwBpwDPw6_J8rTWQUu8b8"}	2025-07-30 10:57:11.437996	0	Volo.Abp.Data.ExtraPropertyDictionary
6889fa87-c58e-60d8-0066-5ed33147ed81	\N	6889fa87-c58e-60d8-0066-5ed246814f37	Letu.Basis.Admin.Tenants.TenantAppService	UpdateTenantAsync	{"id":"6889f9fc-c58e-60d8-0066-5ecc5acf27d0","input":{"name":"test","remark":null,"domain":null}}	2025-07-30 10:57:11.500571	64	Volo.Abp.Data.ExtraPropertyDictionary
6889fc62-5050-4dc8-0093-d0273691afc2	\N	6889fc62-5050-4dc8-0093-d0261dd4871b	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"25e2e3df-6169-32d2-0359-3a1b6b6d9c27","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ1ODczLCJpYXQiOjE3NTM4NDQwNzMsIm5iZiI6MTc1Mzg0NDA3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMjVlMmUzZGYtNjE2OS0zMmQyLTAzNTktM2ExYjZiNmQ5YzI3IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.yRcZcXgaUugg_mLOHyhGjDYwBpwDPw6_J8rTWQUu8b8"}	2025-07-30 11:05:06.136385	11	Volo.Abp.Data.ExtraPropertyDictionary
6889fc68-5050-4dc8-0093-d02911ac2a37	\N	6889fc68-5050-4dc8-0093-d02833c7f716	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 11:05:12.191274	184	Volo.Abp.Data.ExtraPropertyDictionary
6889fc74-5050-4dc8-0093-d02c36dd6bbe	\N	6889fc74-5050-4dc8-0093-d02b2c6fd180	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0236f48a-8bae-fd19-9437-3a1b6b775b4f","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ2NTEyLCJpYXQiOjE3NTM4NDQ3MTIsIm5iZiI6MTc1Mzg0NDcxMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMDIzNmY0OGEtOGJhZS1mZDE5LTk0MzctM2ExYjZiNzc1YjRmIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.40DN_SvXXWypial5m2IUhOZ0xTe-DVN-OImmxrB9TtQ"}	2025-07-30 11:05:24.268065	0	Volo.Abp.Data.ExtraPropertyDictionary
688b9d41-018f-b848-003c-a9017dcd342b	\N	f3768cb8-4ae9-7213-087d-3a1b71d3ab2d	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 16:43:45.249691	19	Volo.Abp.Data.ExtraPropertyDictionary
6889fd9c-0676-5e5c-0010-ca9e415a0a96	\N	6889fd9c-0676-5e5c-0010-ca9d5553ece0	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0236f48a-8bae-fd19-9437-3a1b6b775b4f","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ2NTEyLCJpYXQiOjE3NTM4NDQ3MTIsIm5iZiI6MTc1Mzg0NDcxMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMDIzNmY0OGEtOGJhZS1mZDE5LTk0MzctM2ExYjZiNzc1YjRmIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.40DN_SvXXWypial5m2IUhOZ0xTe-DVN-OImmxrB9TtQ"}	2025-07-30 11:08:26.320691	14	Volo.Abp.Data.ExtraPropertyDictionary
6889fd9e-0676-5e5c-0010-caa02cc37e48	\N	6889fd9e-0676-5e5c-0010-ca9f52ff1d75	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"0236f48a-8bae-fd19-9437-3a1b6b775b4f","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ2NTEyLCJpYXQiOjE3NTM4NDQ3MTIsIm5iZiI6MTc1Mzg0NDcxMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMDIzNmY0OGEtOGJhZS1mZDE5LTk0MzctM2ExYjZiNzc1YjRmIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.40DN_SvXXWypial5m2IUhOZ0xTe-DVN-OImmxrB9TtQ"}	2025-07-30 11:10:22.876491	0	Volo.Abp.Data.ExtraPropertyDictionary
6889fda4-0676-5e5c-0010-caa271d88469	\N	6889fda4-0676-5e5c-0010-caa11ee62eb3	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 11:10:28.542667	185	Volo.Abp.Data.ExtraPropertyDictionary
6889fdaf-0676-5e5c-0010-caa502b9c98c	\N	6889fdaf-0676-5e5c-0010-caa452d16b37	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"6db9de80-b812-fedc-56cd-3a1b6b7c2f0a","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ2ODI4LCJpYXQiOjE3NTM4NDUwMjgsIm5iZiI6MTc1Mzg0NTAyOCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiNmRiOWRlODAtYjgxMi1mZWRjLTU2Y2QtM2ExYjZiN2MyZjBhIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.5WGCYR9llJD7eqc3MKNZW1n07xeQyXH1uWDaqK5bRpc"}	2025-07-30 11:10:39.666187	0	Volo.Abp.Data.ExtraPropertyDictionary
6889fdaf-0676-5e5c-0010-caa72357ad89	\N	6889fdaf-0676-5e5c-0010-caa646ad329c	Letu.Basis.Admin.Tenants.TenantAppService	UpdateTenantAsync	{"id":"6889fc74-5050-4dc8-0093-d02d618ab933","input":{"name":"test11","remark":null,"domain":null}}	2025-07-30 11:10:39.73209	67	Volo.Abp.Data.ExtraPropertyDictionary
688a0190-2e5c-a0f8-0014-50c902c15920	\N	688a0190-2e5c-a0f8-0014-50c87b1d671b	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 11:27:12.526214	250	Volo.Abp.Data.ExtraPropertyDictionary
688a019f-2e5c-a0f8-0014-50cc36e19169	\N	688a019f-2e5c-a0f8-0014-50cb4f83da8f	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"b168c0f7-072b-ba57-87ad-3a1b6b8b80f6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ3ODMyLCJpYXQiOjE3NTM4NDYwMzIsIm5iZiI6MTc1Mzg0NjAzMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYjE2OGMwZjctMDcyYi1iYTU3LTg3YWQtM2ExYjZiOGI4MGY2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.kSd1WoHi7JwA2KgtIQ69gzTdp7VVjpkq_75oo5QHmsU"}	2025-07-30 11:27:27.062725	0	Volo.Abp.Data.ExtraPropertyDictionary
688a019f-2e5c-a0f8-0014-50cf028d7665	\N	688a019f-2e5c-a0f8-0014-50ce1dbccc83	Letu.Basis.Admin.Tenants.TenantAppService	AddTenantAsync	{"input":{"name":"test111","remark":null,"domain":null}}	2025-07-30 11:27:27.125206	30	Volo.Abp.Data.ExtraPropertyDictionary
688a01ea-2e5c-a0f8-0014-50d225195285	\N	688a01bf-2e5c-a0f8-0014-50d15ef6d024	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"b168c0f7-072b-ba57-87ad-3a1b6b8b80f6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ3ODMyLCJpYXQiOjE3NTM4NDYwMzIsIm5iZiI6MTc1Mzg0NjAzMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYjE2OGMwZjctMDcyYi1iYTU3LTg3YWQtM2ExYjZiOGI4MGY2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.kSd1WoHi7JwA2KgtIQ69gzTdp7VVjpkq_75oo5QHmsU"}	2025-07-30 11:27:45.973214	0	Volo.Abp.Data.ExtraPropertyDictionary
688a023b-2e5c-a0f8-0014-50d57ea2c441	\N	688a023b-2e5c-a0f8-0014-50d464a92e6b	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"b168c0f7-072b-ba57-87ad-3a1b6b8b80f6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ3ODMyLCJpYXQiOjE3NTM4NDYwMzIsIm5iZiI6MTc1Mzg0NjAzMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYjE2OGMwZjctMDcyYi1iYTU3LTg3YWQtM2ExYjZiOGI4MGY2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.kSd1WoHi7JwA2KgtIQ69gzTdp7VVjpkq_75oo5QHmsU"}	2025-07-30 11:29:59.29646	0	Volo.Abp.Data.ExtraPropertyDictionary
688a023b-2e5c-a0f8-0014-50d83637c9e0	\N	688a023b-2e5c-a0f8-0014-50d7328fa292	Letu.Basis.Admin.Tenants.TenantAppService	AddTenantAsync	{"input":{"name":"\\u963F\\u8428","remark":null,"domain":null}}	2025-07-30 11:30:03.494525	18	Volo.Abp.Data.ExtraPropertyDictionary
688a047b-087b-11a0-005c-ff2e458b048a	\N	688a035c-087b-11a0-005c-ff2d00e05a06	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"b168c0f7-072b-ba57-87ad-3a1b6b8b80f6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ3ODMyLCJpYXQiOjE3NTM4NDYwMzIsIm5iZiI6MTc1Mzg0NjAzMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYjE2OGMwZjctMDcyYi1iYTU3LTg3YWQtM2ExYjZiOGI4MGY2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.kSd1WoHi7JwA2KgtIQ69gzTdp7VVjpkq_75oo5QHmsU"}	2025-07-30 11:34:44.753419	11	Volo.Abp.Data.ExtraPropertyDictionary
688a047e-087b-11a0-005c-ff3049098891	\N	688a047e-087b-11a0-005c-ff2f0dd49dd3	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"b168c0f7-072b-ba57-87ad-3a1b6b8b80f6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODQ3ODMyLCJpYXQiOjE3NTM4NDYwMzIsIm5iZiI6MTc1Mzg0NjAzMiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYjE2OGMwZjctMDcyYi1iYTU3LTg3YWQtM2ExYjZiOGI4MGY2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.kSd1WoHi7JwA2KgtIQ69gzTdp7VVjpkq_75oo5QHmsU"}	2025-07-30 11:39:42.70291	1	Volo.Abp.Data.ExtraPropertyDictionary
688a0484-087b-11a0-005c-ff321551ede0	\N	688a0484-087b-11a0-005c-ff3111237a8b	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 11:39:48.471394	155	Volo.Abp.Data.ExtraPropertyDictionary
688a051a-2ff3-6778-0069-50e407ace60a	\N	688a0519-2ff3-6778-0069-50e37dbf4656	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 11:42:17.731957	216	Volo.Abp.Data.ExtraPropertyDictionary
688a0de3-2ff3-6778-0069-50e720aa3889	\N	688a0de3-2ff3-6778-0069-50e61010b473	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 12:19:47.308824	113	Volo.Abp.Data.ExtraPropertyDictionary
688a0e79-bafd-73c0-00f7-94ba536ebf81	\N	688a0e79-bafd-73c0-00f7-94b95a125300	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 12:22:17.050326	206	Volo.Abp.Data.ExtraPropertyDictionary
688a0e95-bafd-73c0-00f7-94bc08e41669	\N	688a0e95-bafd-73c0-00f7-94bb173b710b	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 12:22:45.573794	46	Volo.Abp.Data.ExtraPropertyDictionary
688a1e3d-c4de-0474-001d-ea2a07eb4d93	\N	b75d2378-2731-c070-061c-3a1b6bfb1ac7	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-30 13:26:17.150242	4	Volo.Abp.Data.ExtraPropertyDictionary
688a2831-8748-ea78-0020-95492196c213	\N	9609d11d-2794-6d1e-0ac2-3a1b6c223914	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 14:11:35.211427	214	Volo.Abp.Data.ExtraPropertyDictionary
688a2836-8748-ea78-0020-954a7adbe8a4	\N	f14b7caa-24c4-c60f-0009-3a1b6c22792c	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 14:12:05.7117	62	Volo.Abp.Data.ExtraPropertyDictionary
688a2850-8748-ea78-0020-954b1c6be315	\N	97835fff-8efa-0e68-722b-3a1b6c22dfd3	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"ee4ef8db-a64b-0f99-ac89-3a1b6c2275e0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODU3NzI1LCJpYXQiOjE3NTM4NTU5MjUsIm5iZiI6MTc1Mzg1NTkyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZWU0ZWY4ZGItYTY0Yi0wZjk5LWFjODktM2ExYjZjMjI3NWUwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.U_mG1EWBBnJgnT9-H1x2e41HPhdFklQWemAiP97JP_s"}	2025-07-30 14:12:24.323747	0	Volo.Abp.Data.ExtraPropertyDictionary
688a2851-8748-ea78-0020-954c1db35c5e	\N	41facc1d-4ed8-c163-0688-3a1b6c22e26b	Letu.Basis.Admin.Tenants.TenantAppService	UpdateTenantAsync	{"id":"688a023b-2e5c-a0f8-0014-50d6450e48fc","input":{"name":"\\u963F\\u8428","remark":null,"domain":null}}	2025-07-30 14:12:32.903801	68	Volo.Abp.Data.ExtraPropertyDictionary
688a2856-8748-ea78-0020-954d2adb7e5e	\N	7ae88bae-6fcf-61d3-3479-3a1b6c22f5ab	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"ee4ef8db-a64b-0f99-ac89-3a1b6c2275e0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODU3NzI1LCJpYXQiOjE3NTM4NTU5MjUsIm5iZiI6MTc1Mzg1NTkyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZWU0ZWY4ZGItYTY0Yi0wZjk5LWFjODktM2ExYjZjMjI3NWUwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.U_mG1EWBBnJgnT9-H1x2e41HPhdFklQWemAiP97JP_s"}	2025-07-30 14:12:37.605827	0	Volo.Abp.Data.ExtraPropertyDictionary
688a2857-8748-ea78-0020-954e0ea1fe0d	\N	e1b16e66-c91d-4530-b08f-3a1b6c22f868	Letu.Basis.Admin.Tenants.TenantAppService	UpdateTenantAsync	{"id":"688a023b-2e5c-a0f8-0014-50d6450e48fc","input":{"name":"\\u963F\\u8428","remark":null,"domain":null}}	2025-07-30 14:12:38.477145	20	Volo.Abp.Data.ExtraPropertyDictionary
688a5cc8-7bfd-0374-005e-94565c7bed99	\N	1518415e-d09f-53c0-80b8-3a1b6cefd3a8	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 17:56:24.203322	375	Volo.Abp.Data.ExtraPropertyDictionary
688a5e28-7bfd-0374-005e-945762ec2613	\N	ea8f3122-7295-91e6-f969-3a1b6cf5330e	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"2c886111-3cd1-e141-d22c-3a1b6cefd288","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODcxMTg0LCJpYXQiOjE3NTM4NjkzODQsIm5iZiI6MTc1Mzg2OTM4NCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMmM4ODYxMTEtM2NkMS1lMTQxLWQyMmMtM2ExYjZjZWZkMjg4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.fhiAl984WnWxTkzqjkiGlY2cj3CtaQWipztjIWYluZQ"}	2025-07-30 18:02:16.71806	0	Volo.Abp.Data.ExtraPropertyDictionary
688a5e28-7bfd-0374-005e-94581b7abdfc	\N	18702a64-2cab-2eff-938c-3a1b6cf5334d	Letu.Basis.Admin.Menus.MenuAppService	AddMenuAsync	{"dto":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/logging/auditlog","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-30 18:02:16.754398	27	Volo.Abp.Data.ExtraPropertyDictionary
688a5e3b-7bfd-0374-005e-94594473c695	\N	8fb80185-6db9-1d33-dae7-3a1b6cf57c3a	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-30 18:02:35.44729	3	Volo.Abp.Data.ExtraPropertyDictionary
688a5e3d-7bfd-0374-005e-945a0becbbd9	\N	9ff2e22e-57e6-de67-5f61-3a1b6cf5825e	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-30 18:02:36.995199	27	Volo.Abp.Data.ExtraPropertyDictionary
688b9d46-018f-b848-003c-a9024e1f0dfa	\N	4120609b-7285-615c-2e24-3a1b71d3bdaf	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 16:43:49.761916	301	Volo.Abp.Data.ExtraPropertyDictionary
688b9d47-018f-b848-003c-a9036add2335	\N	e4adc0d8-b54e-abed-1412-3a1b71d3c4f9	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 16:43:51.71872	210	Volo.Abp.Data.ExtraPropertyDictionary
688a5e78-7bfd-0374-005e-945b6026de1c	\N	be1a468b-8e3a-d5be-4e71-3a1b6cf66c91	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"cd9b52a4-d4f3-bcd6-413b-3a1b6cf58247","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzODcxNTU2LCJpYXQiOjE3NTM4Njk3NTYsIm5iZiI6MTc1Mzg2OTc1NiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiY2Q5YjUyYTQtZDRmMy1iY2Q2LTQxM2ItM2ExYjZjZjU4MjQ3IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.cDAYIlHJJETy-UEYInsyqObICJ0WkZdHqEzL_rbIa-M"}	2025-07-30 18:03:36.977399	0	Volo.Abp.Data.ExtraPropertyDictionary
688a5eaf-7bfd-0374-005e-945c2dfd4aa8	\N	97fffeae-ec96-08c7-05c9-3a1b6cf742f4	Letu.Basis.Admin.Menus.MenuAppService	UpdateMenuAsync	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/logging/auditlog","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-30 18:03:36.999	54824	Volo.Abp.Data.ExtraPropertyDictionary
688b280d-8338-0804-00e1-eb227363d21b	\N	5a0ce7ac-a415-03e6-ab7b-3a1b7009d7af	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 08:23:40.982628	209	Volo.Abp.Data.ExtraPropertyDictionary
688b2960-8338-0804-00e1-eb2361815281	\N	66cdc347-b706-9c88-bba9-3a1b700f04ea	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"bbd81f4b-c4f0-5f9d-d66f-3a1b7009d725","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTIzMjIxLCJpYXQiOjE3NTM5MjE0MjEsIm5iZiI6MTc1MzkyMTQyMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmJkODFmNGItYzRmMC01ZjlkLWQ2NmYtM2ExYjcwMDlkNzI1IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.T8_cDUuMIBUWXUKn7MKpL6ZHpXlGyvJWoACYJTAB33o"}	2025-07-31 08:29:20.489506	0	Volo.Abp.Data.ExtraPropertyDictionary
688b2980-8338-0804-00e1-eb24347c0ba4	\N	f0e57d3e-98cf-80fd-b9c6-3a1b700f82db	Letu.Basis.Admin.Menus.MenuAppService	UpdateMenuAsync	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/loggings/auditlog","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-31 08:29:20.549857	32142	Volo.Abp.Data.ExtraPropertyDictionary
688b29d2-8338-0804-00e1-eb256187d3c0	\N	0ddb30d6-7327-2a5a-d8cf-3a1b7010c250	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"bbd81f4b-c4f0-5f9d-d66f-3a1b7009d725","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTIzMjIxLCJpYXQiOjE3NTM5MjE0MjEsIm5iZiI6MTc1MzkyMTQyMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmJkODFmNGItYzRmMC01ZjlkLWQ2NmYtM2ExYjcwMDlkNzI1IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.T8_cDUuMIBUWXUKn7MKpL6ZHpXlGyvJWoACYJTAB33o"}	2025-07-31 08:31:14.512503	0	Volo.Abp.Data.ExtraPropertyDictionary
688b29d9-8338-0804-00e1-eb261bfb9228	\N	fe372de5-1549-0d10-d88f-3a1b7010ddfa	Letu.Basis.Admin.Menus.MenuAppService	UpdateMenuAsync	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/loggings/auditlog","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-31 08:31:14.526617	7066	Volo.Abp.Data.ExtraPropertyDictionary
688b2a01-8338-0804-00e1-eb273c7e0d3b	\N	68394a8c-120a-6a8e-5c41-3a1b70117ba8	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"bbd81f4b-c4f0-5f9d-d66f-3a1b7009d725","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTIzMjIxLCJpYXQiOjE3NTM5MjE0MjEsIm5iZiI6MTc1MzkyMTQyMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmJkODFmNGItYzRmMC01ZjlkLWQ2NmYtM2ExYjcwMDlkNzI1IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.T8_cDUuMIBUWXUKn7MKpL6ZHpXlGyvJWoACYJTAB33o"}	2025-07-31 08:32:01.959722	0	Volo.Abp.Data.ExtraPropertyDictionary
688b2a7a-8338-0804-00e1-eb287b978291	\N	28db079b-1eda-e41e-b0b5-3a1b70135155	Letu.Basis.Admin.Menus.MenuAppService	UpdateMenuAsync	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/loggings/auditlog","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-31 08:32:01.971757	120195	Volo.Abp.Data.ExtraPropertyDictionary
688b2b38-059d-e1c8-0002-09a7367cdd52	\N	4f9b2d03-5d03-4f88-e82b-3a1b70163900	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"bbd81f4b-c4f0-5f9d-d66f-3a1b7009d725","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTIzMjIxLCJpYXQiOjE3NTM5MjE0MjEsIm5iZiI6MTc1MzkyMTQyMSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYmJkODFmNGItYzRmMC01ZjlkLWQ2NmYtM2ExYjcwMDlkNzI1IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.T8_cDUuMIBUWXUKn7MKpL6ZHpXlGyvJWoACYJTAB33o"}	2025-07-31 08:37:12.511046	10	Volo.Abp.Data.ExtraPropertyDictionary
688b2b3e-059d-e1c8-0002-09a81bee1df6	\N	9b9dc516-4a2c-b032-f769-3a1b701650ee	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 08:37:18.401863	299	Volo.Abp.Data.ExtraPropertyDictionary
688b2b54-059d-e1c8-0002-09aa44da9327	\N	3cce58d1-f398-3c5b-67eb-3a1b7016a801	Letu.Basis.Admin.Menus.MenuAppService	UpdateMenuAsync	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/loggings/auditlog","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-31 08:37:35.432929	5561	Volo.Abp.Data.ExtraPropertyDictionary
688b2b65-059d-e1c8-0002-09ab0e848036	\N	3d012352-3f4d-ff4e-88ca-3a1b7016e71f	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 08:37:57.147835	3	Volo.Abp.Data.ExtraPropertyDictionary
688b2b66-059d-e1c8-0002-09ac316eaaa2	\N	5f657b01-575a-c28a-f78d-3a1b7016ec50	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 08:37:58.455796	25	Volo.Abp.Data.ExtraPropertyDictionary
688b2b4f-059d-e1c8-0002-09a90335d2c0	\N	18b1976a-d1de-928b-b501-3a1b70169220	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"28787c7e-2aed-5aa1-74b0-3a1b70165008","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTI0MDM4LCJpYXQiOjE3NTM5MjIyMzgsIm5iZiI6MTc1MzkyMjIzOCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMjg3ODdjN2UtMmFlZC01YWExLTc0YjAtM2ExYjcwMTY1MDA4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.3Z6plZbgZ8wKpR6ID7fKByg2zg0V7qLqAWAE6cvHhKA"}	2025-07-31 08:37:35.39216	0	Volo.Abp.Data.ExtraPropertyDictionary
688b5070-4223-d8d0-0090-061049e94f56	\N	7ad1ecf9-0507-a5e8-80b8-3a1b70a79d10	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 11:16:00.508142	365	Volo.Abp.Data.ExtraPropertyDictionary
688b55d0-4223-d8d0-0090-061107e8325a	\N	485a8845-72c8-6e21-d9ef-3a1b70bc99de	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"e68dd374-14ee-a420-fa00-3a1b70a79be6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTMzNTYwLCJpYXQiOjE3NTM5MzE3NjAsIm5iZiI6MTc1MzkzMTc2MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZTY4ZGQzNzQtMTRlZS1hNDIwLWZhMDAtM2ExYjcwYTc5YmU2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.QAwCjN8vlNuWxFrHe-uquZuyGRcrQEKF5N0c18GcZbs"}	2025-07-31 11:38:56.349743	1	Volo.Abp.Data.ExtraPropertyDictionary
688b55d0-4223-d8d0-0090-06122bcfc046	\N	dc28e395-4fba-b234-0e86-3a1b70bc9a8d	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"e68dd374-14ee-a420-fa00-3a1b70a79be6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTMzNTYwLCJpYXQiOjE3NTM5MzE3NjAsIm5iZiI6MTc1MzkzMTc2MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZTY4ZGQzNzQtMTRlZS1hNDIwLWZhMDAtM2ExYjcwYTc5YmU2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.QAwCjN8vlNuWxFrHe-uquZuyGRcrQEKF5N0c18GcZbs"}	2025-07-31 11:38:56.525292	0	Volo.Abp.Data.ExtraPropertyDictionary
688b55d0-4223-d8d0-0090-061309312539	\N	c054340b-c304-49c1-3534-3a1b70bc99de	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"e68dd374-14ee-a420-fa00-3a1b70a79be6","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTMzNTYwLCJpYXQiOjE3NTM5MzE3NjAsIm5iZiI6MTc1MzkzMTc2MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZTY4ZGQzNzQtMTRlZS1hNDIwLWZhMDAtM2ExYjcwYTc5YmU2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.QAwCjN8vlNuWxFrHe-uquZuyGRcrQEKF5N0c18GcZbs"}	2025-07-31 11:38:56.349743	1	Volo.Abp.Data.ExtraPropertyDictionary
688b55d0-4223-d8d0-0090-061448a2301b	\N	02e37517-7222-6bdc-a766-3a1b70bc9c09	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"c4fe25b84e7109b96f4e3a1b70a79c1a"}	2025-07-31 11:38:56.609188	295	Volo.Abp.Data.ExtraPropertyDictionary
688b55d0-4223-d8d0-0090-061614b0460f	\N	60da2920-3682-cff1-4f36-3a1b70bc9c1f	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"c4fe25b84e7109b96f4e3a1b70a79c1a"}	2025-07-31 11:38:56.618278	309	Volo.Abp.Data.ExtraPropertyDictionary
688b55d0-4223-d8d0-0090-06151f6d9313	\N	ed2697f4-fc2d-e6da-1ab1-3a1b70bc9c1e	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"c4fe25b84e7109b96f4e3a1b70a79c1a"}	2025-07-31 11:38:56.609342	317	Volo.Abp.Data.ExtraPropertyDictionary
688b55d8-4223-d8d0-0090-061772e5c2f5	\N	8d4e576b-580b-37bf-b65d-3a1b70bcb84a	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 11:39:04.106575	32	Volo.Abp.Data.ExtraPropertyDictionary
688b5e12-4223-d8d0-0090-061866f98484	\N	db1bc827-2ad2-532a-aac0-3a1b70dcdbc8	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 12:14:10.269279	107	Volo.Abp.Data.ExtraPropertyDictionary
688b62e7-4223-d8d0-0090-06191ae56805	\N	5e90a217-89bd-38f8-c375-3a1b70efbe2b	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"807a10d9-f707-368b-c3e8-3a1b70dcdbb3","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTM3MDUwLCJpYXQiOjE3NTM5MzUyNTAsIm5iZiI6MTc1MzkzNTI1MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODA3YTEwZDktZjcwNy0zNjhiLWMzZTgtM2ExYjcwZGNkYmIzIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.tZsDI_ahOsLWvhsgGHWSoLpdhqeTjiAVeJ0vfGJglSw"}	2025-07-31 12:34:47.979264	0	Volo.Abp.Data.ExtraPropertyDictionary
688b62e8-4223-d8d0-0090-061a5f140501	\N	c11b2dbd-2196-50a3-a64e-3a1b70efbe43	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"807a10d9-f707-368b-c3e8-3a1b70dcdbb3","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTM3MDUwLCJpYXQiOjE3NTM5MzUyNTAsIm5iZiI6MTc1MzkzNTI1MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODA3YTEwZDktZjcwNy0zNjhiLWMzZTgtM2ExYjcwZGNkYmIzIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.tZsDI_ahOsLWvhsgGHWSoLpdhqeTjiAVeJ0vfGJglSw"}	2025-07-31 12:34:48.002795	0	Volo.Abp.Data.ExtraPropertyDictionary
688b62e8-4223-d8d0-0090-061b4d24ecd1	\N	295b71fb-7b47-99e5-a474-3a1b70efbfba	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"37681c4fb5e2c21985c03a1b70dcdbb3"}	2025-07-31 12:34:48.033859	345	Volo.Abp.Data.ExtraPropertyDictionary
688b637c-4223-d8d0-0090-061c54c826b4	\N	9410d725-f5f0-4a66-a0b7-3a1b70f2016e	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"37681c4fb5e2c21985c03a1b70dcdbb3"}	2025-07-31 12:34:48.068574	148137	Volo.Abp.Data.ExtraPropertyDictionary
688b6385-4223-d8d0-0090-061e39b33ec3	\N	5f557f6c-5787-5287-dde5-3a1b70f2261a	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"807a10d9-f707-368b-c3e8-3a1b70dcdbb3","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTM3MDUwLCJpYXQiOjE3NTM5MzUyNTAsIm5iZiI6MTc1MzkzNTI1MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODA3YTEwZDktZjcwNy0zNjhiLWMzZTgtM2ExYjcwZGNkYmIzIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.tZsDI_ahOsLWvhsgGHWSoLpdhqeTjiAVeJ0vfGJglSw"}	2025-07-31 12:37:25.657805	0	Volo.Abp.Data.ExtraPropertyDictionary
688b6385-4223-d8d0-0090-061d2cb8c303	\N	993eed09-22a1-80bc-4392-3a1b70f2261d	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"807a10d9-f707-368b-c3e8-3a1b70dcdbb3","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTM3MDUwLCJpYXQiOjE3NTM5MzUyNTAsIm5iZiI6MTc1MzkzNTI1MCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiODA3YTEwZDktZjcwNy0zNjhiLWMzZTgtM2ExYjcwZGNkYmIzIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.tZsDI_ahOsLWvhsgGHWSoLpdhqeTjiAVeJ0vfGJglSw"}	2025-07-31 12:37:25.660839	0	Volo.Abp.Data.ExtraPropertyDictionary
688b638b-4223-d8d0-0090-061f758cb272	\N	ebb29b65-d087-dfc2-1da9-3a1b70f23d70	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 12:37:31.604211	28	Volo.Abp.Data.ExtraPropertyDictionary
688b6eb3-4223-d8d0-0090-06203d7410ce	\N	68a46604-0fb0-74be-7c00-3a1b711dcff0	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 13:25:07.113062	71	Volo.Abp.Data.ExtraPropertyDictionary
688b7d5a-4223-d8d0-0090-06211131e8db	\N	828fe0bc-ed1f-ca09-b5d9-3a1b71570e04	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 14:27:38.52549	102	Volo.Abp.Data.ExtraPropertyDictionary
688b7dc3-4223-d8d0-0090-06225bd524f1	\N	c50bed9c-2ac2-7f90-6fdc-3a1b7158a8d5	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"2fb2ba97-4b5f-081d-71d2-3a1b71570daf","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ1MDU4LCJpYXQiOjE3NTM5NDMyNTgsIm5iZiI6MTc1Mzk0MzI1OCwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiMmZiMmJhOTctNGI1Zi0wODFkLTcxZDItM2ExYjcxNTcwZGFmIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.igurR0tNmHvHffzhAEDPLJTdQgeevZKDMproZPqz6ao"}	2025-07-31 14:29:23.797282	0	Volo.Abp.Data.ExtraPropertyDictionary
688b7dc6-4223-d8d0-0090-062369992200	\N	94174934-6ac2-bc41-a6c6-3a1b7158b44e	Letu.Basis.Admin.Menus.MenuAppService	UpdateMenuAsync	{"id":"bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342","input":{"title":"\\u5BA1\\u8BA1\\u65E5\\u5FD7","icon":null,"path":"/admin/loggings/auditlog/request","menuType":2,"permission":null,"parentId":"3a174174-857e-2328-55e6-395fcffb3774","sort":0,"display":true,"component":"log","isExternal":false}}	2025-07-31 14:29:23.846038	2888	Volo.Abp.Data.ExtraPropertyDictionary
688b7dcc-4223-d8d0-0090-0624660aad06	\N	7ac8f432-51ba-b58a-1845-3a1b7158cabc	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 14:29:32.471957	5	Volo.Abp.Data.ExtraPropertyDictionary
688b7dcd-4223-d8d0-0090-06255f8e9e86	\N	5fffdc9f-d2ad-fc23-fa29-3a1b7158d00c	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 14:29:33.791735	45	Volo.Abp.Data.ExtraPropertyDictionary
688b8320-4223-d8d0-0090-0626735585cc	\N	0de204e7-4d6f-d593-6d26-3a1b716d9876	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"abcd7576-3e77-4e9e-c646-3a1b7158cfe1","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ1MTczLCJpYXQiOjE3NTM5NDMzNzMsIm5iZiI6MTc1Mzk0MzM3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYWJjZDc1NzYtM2U3Ny00ZTllLWM2NDYtM2ExYjcxNThjZmUxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.wPTWCs87dXUeP22LLjBanflhwBQ5_jUQF53akEkVaAA"}	2025-07-31 14:52:15.861578	0	Volo.Abp.Data.ExtraPropertyDictionary
688b8320-4223-d8d0-0090-062761d45ca0	\N	e1fd413d-4402-fc56-25e7-3a1b716d9916	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"abcd7576-3e77-4e9e-c646-3a1b7158cfe1","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ1MTczLCJpYXQiOjE3NTM5NDMzNzMsIm5iZiI6MTc1Mzk0MzM3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYWJjZDc1NzYtM2U3Ny00ZTllLWM2NDYtM2ExYjcxNThjZmUxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.wPTWCs87dXUeP22LLjBanflhwBQ5_jUQF53akEkVaAA"}	2025-07-31 14:52:16.020383	0	Volo.Abp.Data.ExtraPropertyDictionary
688b8320-4223-d8d0-0090-06285789cbd5	\N	2bedc938-c84d-24b3-1a20-3a1b716d9966	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"abcd7576-3e77-4e9e-c646-3a1b7158cfe1","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ1MTczLCJpYXQiOjE3NTM5NDMzNzMsIm5iZiI6MTc1Mzk0MzM3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYWJjZDc1NzYtM2U3Ny00ZTllLWM2NDYtM2ExYjcxNThjZmUxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.wPTWCs87dXUeP22LLjBanflhwBQ5_jUQF53akEkVaAA"}	2025-07-31 14:52:16.102598	0	Volo.Abp.Data.ExtraPropertyDictionary
688b8320-4223-d8d0-0090-062936b04958	\N	daa5fccf-b4fe-d192-b8f5-3a1b716d9b2c	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"abcd7576-3e77-4e9e-c646-3a1b7158cfe1","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ1MTczLCJpYXQiOjE3NTM5NDMzNzMsIm5iZiI6MTc1Mzk0MzM3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYWJjZDc1NzYtM2U3Ny00ZTllLWM2NDYtM2ExYjcxNThjZmUxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.wPTWCs87dXUeP22LLjBanflhwBQ5_jUQF53akEkVaAA"}	2025-07-31 14:52:16.556415	0	Volo.Abp.Data.ExtraPropertyDictionary
688b8320-4223-d8d0-0090-062a32513296	\N	0a56c3e8-f4a0-8a81-fdfb-3a1b716d9b31	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"abcd7576-3e77-4e9e-c646-3a1b7158cfe1","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ1MTczLCJpYXQiOjE3NTM5NDMzNzMsIm5iZiI6MTc1Mzk0MzM3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiYWJjZDc1NzYtM2U3Ny00ZTllLWM2NDYtM2ExYjcxNThjZmUxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.wPTWCs87dXUeP22LLjBanflhwBQ5_jUQF53akEkVaAA"}	2025-07-31 14:52:16.560645	0	Volo.Abp.Data.ExtraPropertyDictionary
688b8321-4223-d8d0-0090-062b2ccb878d	\N	e19ca876-07c4-0251-7375-3a1b716d9ce7	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"38db20c1aecb3fc8a76e3a1b7158cfe1"}	2025-07-31 14:52:16.104633	842	Volo.Abp.Data.ExtraPropertyDictionary
688b8321-4223-d8d0-0090-062c5bb62f78	\N	2777747b-0000-340d-2469-3a1b716d9c6b	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"38db20c1aecb3fc8a76e3a1b7158cfe1"}	2025-07-31 14:52:16.080731	657	Volo.Abp.Data.ExtraPropertyDictionary
688b8341-4223-d8d0-0090-062d708fa98e	\N	8d0cc09f-fd63-f771-bc56-3a1b716e1bbf	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"38db20c1aecb3fc8a76e3a1b7158cfe1"}	2025-07-31 14:52:16.15468	33316	Volo.Abp.Data.ExtraPropertyDictionary
688b8345-4223-d8d0-0090-062e28261c28	\N	950a51f1-7816-2f06-8be4-3a1b716e2ac2	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 14:52:53.293667	20	Volo.Abp.Data.ExtraPropertyDictionary
688b881d-4223-d8d0-0090-062f2cd48e32	\N	a97d2492-d68b-929b-97bf-3a1b718116ca	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"e8c0801d-9a9a-1f83-3958-3a1b716e2ab0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ2NTczLCJpYXQiOjE3NTM5NDQ3NzMsIm5iZiI6MTc1Mzk0NDc3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZThjMDgwMWQtOWE5YS0xZjgzLTM5NTgtM2ExYjcxNmUyYWIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.95JGPWn67nNTnC0lAsfT9U2vf0uk9p8G-abrElxWyvM"}	2025-07-31 15:13:33.385614	0	Volo.Abp.Data.ExtraPropertyDictionary
688b881d-4223-d8d0-0090-0630465ebc9f	\N	3e7f0123-5824-afeb-c0a0-3a1b718116ca	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"e8c0801d-9a9a-1f83-3958-3a1b716e2ab0","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTQ2NTczLCJpYXQiOjE3NTM5NDQ3NzMsIm5iZiI6MTc1Mzk0NDc3MywiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiZThjMDgwMWQtOWE5YS0xZjgzLTM5NTgtM2ExYjcxNmUyYWIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi6aOO5rGQIn0.95JGPWn67nNTnC0lAsfT9U2vf0uk9p8G-abrElxWyvM"}	2025-07-31 15:13:33.386396	0	Volo.Abp.Data.ExtraPropertyDictionary
688b881d-4223-d8d0-0090-06316f11fe23	\N	fb568f07-3918-7063-1556-3a1b718117cb	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"8b9ab8d278f85124069d3a1b716e2ab0"}	2025-07-31 15:13:33.411753	232	Volo.Abp.Data.ExtraPropertyDictionary
688b8822-4223-d8d0-0090-063258437a7c	\N	a0c00c05-2686-c6ab-0f91-3a1b71812943	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"8b9ab8d278f85124069d3a1b716e2ab0"}	2025-07-31 15:13:33.415852	4699	Volo.Abp.Data.ExtraPropertyDictionary
688b8831-4223-d8d0-0090-0633593eae20	\N	0de1d4ce-21c1-4721-53dc-3a1b718164be	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 15:13:53.296499	45	Volo.Abp.Data.ExtraPropertyDictionary
688b9145-53e5-7228-00d6-7aab6105e463	\N	eae0c375-2293-e669-6814-3a1b71a4dc17	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 15:52:37.368161	248	Volo.Abp.Data.ExtraPropertyDictionary
688b9159-53e5-7228-00d6-7aac7b2ec37b	\N	7aa49a5e-27ad-3c8a-0118-3a1b71a52949	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 15:52:57.41401	3	Volo.Abp.Data.ExtraPropertyDictionary
688b915b-53e5-7228-00d6-7aad5ae3132d	\N	5d67802a-8cbb-b8ae-70a1-3a1b71a531e5	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 15:52:59.582466	39	Volo.Abp.Data.ExtraPropertyDictionary
688b916b-53e5-7228-00d6-7aae0f5c56d6	\N	2ac77c76-65eb-404f-52d6-3a1b71a570c6	Letu.Basis.Identity.IdentityAppService	LogoutAsync	{}	2025-07-31 15:53:15.71772	0	Volo.Abp.Data.ExtraPropertyDictionary
688b929b-53e5-7228-00d6-7aaf08c56491	\N	d638b5c1-2c7b-544b-659d-3a1b71aa13d8	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 15:53:17.114011	302494	Volo.Abp.Data.ExtraPropertyDictionary
688b92b9-53e5-7228-00d6-7ab0455c9877	\N	b749765c-43ce-c4d8-6eff-3a1b71aa872b	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 15:58:45.755875	3375	Volo.Abp.Data.ExtraPropertyDictionary
688b98fd-53e5-7228-00d6-7ab16db9d7f9	\N	47dd5542-ff21-fc0f-6d51-3a1b71c3019a	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"cbffb5995b695e6e54113a1b71aa79fe","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTUwNTI1LCJpYXQiOjE3NTM5NDg3MjUsIm5iZiI6MTc1Mzk0ODcyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiY2JmZmI1OTk1YjY5NWU2ZTU0MTEzYTFiNzFhYTc5ZmUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiLpo47msZAifQ.fFnCqNc62eUoVIcxA1K1OXzFLeW_t8vnoLOHBaQvCf4"}	2025-07-31 16:25:33.338336	0	Volo.Abp.Data.ExtraPropertyDictionary
688b98fd-53e5-7228-00d6-7ab26a48c5a3	\N	e97c9a91-ded4-8a98-8951-3a1b71c30246	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"cbffb5995b695e6e54113a1b71aa79fe","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTUwNTI1LCJpYXQiOjE3NTM5NDg3MjUsIm5iZiI6MTc1Mzk0ODcyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiY2JmZmI1OTk1YjY5NWU2ZTU0MTEzYTFiNzFhYTc5ZmUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiLpo47msZAifQ.fFnCqNc62eUoVIcxA1K1OXzFLeW_t8vnoLOHBaQvCf4"}	2025-07-31 16:25:33.510582	0	Volo.Abp.Data.ExtraPropertyDictionary
688b98fd-53e5-7228-00d6-7ab37c877c8d	\N	8326a251-d85b-f4bf-40dd-3a1b71c3022a	Letu.Basis.Identity.IdentityAppService	ValidateTokenAsync	{"userId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","sessionId":"cbffb5995b695e6e54113a1b71aa79fe","token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAwIiwiZXhwIjoxNzUzOTUwNTI1LCJpYXQiOjE3NTM5NDg3MjUsIm5iZiI6MTc1Mzk0ODcyNSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzYTE3MmEzNy01NWQ1LWVlOWItZGM5Mi1lMDczODZlYWRjN2MiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzZXNzaW9uX2lkIjoiY2JmZmI1OTk1YjY5NWU2ZTU0MTEzYTFiNzFhYTc5ZmUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiLpo47msZAifQ.fFnCqNc62eUoVIcxA1K1OXzFLeW_t8vnoLOHBaQvCf4"}	2025-07-31 16:25:33.48135	0	Volo.Abp.Data.ExtraPropertyDictionary
688b98fd-53e5-7228-00d6-7ab46da96b15	\N	afa5adc9-aead-c387-7d6a-3a1b71c302e6	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"f0b21ce44ee72c5633f43a1b71aa79fe"}	2025-07-31 16:25:33.535994	134	Volo.Abp.Data.ExtraPropertyDictionary
688b98fd-53e5-7228-00d6-7ab51bd74fe0	\N	c976dc6a-af6a-5310-6cdc-3a1b71c302ea	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"f0b21ce44ee72c5633f43a1b71aa79fe"}	2025-07-31 16:25:33.536314	138	Volo.Abp.Data.ExtraPropertyDictionary
688b98fd-53e5-7228-00d6-7ab629a25da3	\N	b356cd77-081f-2e51-d27a-3a1b71c30312	Letu.Basis.Identity.IdentityAppService	RefreshTokenAsync	{"refreshToken":"f0b21ce44ee72c5633f43a1b71aa79fe"}	2025-07-31 16:25:33.535994	178	Volo.Abp.Data.ExtraPropertyDictionary
688b9900-53e5-7228-00d6-7ab767534c2b	\N	fa9b10a5-0eb8-4397-aaeb-3a1b71c30d26	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 16:25:36.270697	23	Volo.Abp.Data.ExtraPropertyDictionary
688b9a02-e554-6440-0006-96ff06867466	\N	0ca917b2-4878-f720-719a-3a1b71c6fe03	Letu.Basis.Identity.IdentityAppService	LoginAsync	{"input":{"userName":"admin","password":"123qwe*"}}	2025-07-31 16:29:54.225404	288	Volo.Abp.Data.ExtraPropertyDictionary
\.


--
-- Data for Name: sys_audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_audit_logs (id, application_name, user_id, user_name, tenant_id, tenant_name, impersonator_user_id, impersonator_tenant_id, impersonator_tenant_name, impersonator_user_name, execution_time, execution_duration, client_ip_address, client_name, client_id, correlation_id, browser_info, http_method, url, http_status_code, exceptions, comments, extra_properties, creation_time) FROM stdin;
6888cff0-ca52-4bb0-008f-b8a53cedc68c	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:43:12.643812	280	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:43:12.943757
6888cffd-ca52-4bb0-008f-b8a84cb901ba	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:43:25.086825	67	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:43:25.155306
6888d018-ca52-4bb0-008f-b8ab2da9cc71	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:43:52.235149	39	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:43:52.274622
6888d22f-ca52-4bb0-008f-b8ae5f500ff9	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:52:47.1382	71	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:52:47.209841
6888d239-ca52-4bb0-008f-b8b1402836c0	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:52:57.475345	45	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:52:57.520904
6888d249-ca52-4bb0-008f-b8b4601873d9	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:53:13.873896	47	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:53:13.920899
6888d2d3-ca52-4bb0-008f-b8b73550f70c	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:55:31.559595	47	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:55:31.606575
6888d3a9-1523-a9f0-0020-a91d031a40a4	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:59:05.563608	218	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:59:05.802853
6888d3b7-1523-a9f0-0020-a92040d0c560	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:59:19.23882	105	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:59:19.344396
6888d3c4-1523-a9f0-0020-a92314f3bd90	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 13:59:32.94619	33	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 13:59:32.979476
6888d82b-8465-d6cc-0063-58d116dc39b3	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 14:18:19.010667	211	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:18:19.242266
6888d835-8465-d6cc-0063-58d41e42f792	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 14:18:22.28428	7623	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	GET	/api/account/userAuth	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:18:29.911447
6888d83e-8465-d6cc-0063-58d73ea0db05	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 14:18:38.697281	107	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:18:38.804628
6888d845-8465-d6cc-0063-58da52c560a3	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 14:18:39.597738	5794	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	GET	/api/account/userAuth	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:18:45.391621
6888da08-46f2-018c-0056-9d9d41dcd516	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 14:26:15.96483	244	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:26:16.231587
6888da18-46f2-018c-0056-9da00a51e1fe	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 14:26:27.507801	4854	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	GET	/api/account/userAuth	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:26:32.364893
6888da8f-f6b8-0774-00c0-ae7e267752c0	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 14:28:30.771604	242	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:28:31.033532
6888dd09-a97c-0cb0-0051-84796050cc54	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 14:39:04.7378	242	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:39:04.996052
6888dd29-a97c-0cb0-0051-847c2951a5e5	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 14:39:21.830139	15680	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	GET	/api/admin/positions/groups	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:39:37.518983
6888e00c-4bd6-2248-0033-d98a7797ed82	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 14:51:55.973726	342	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 14:51:56.335614
6888e2a1-fa0e-1c34-002b-ca7139ec675d	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 15:02:56.892926	218	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:02:57.131076
6888e411-aa3b-a858-0035-efec129da163	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 15:09:05.285466	315	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:09:05.623626
6888e42c-aa3b-a858-0035-eff17811d3c7	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:09:18.197566	14331	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	GET	/api/admin/tenants	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:09:32.53209
6888e42e-aa3b-a858-0035-eff3496eeec0	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:09:32.5569	1727	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	GET	/api/admin/tenants	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:09:34.285755
6888e627-97f4-a6b4-0020-819b3fe0ef34	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 15:17:58.778966	301	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:17:59.096066
6888e646-97f4-a6b4-0020-81a07f374d51	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:18:30.47578	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:18:30.476199
6888e651-97f4-a6b4-0020-81a22e5dc4f4	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:18:41.210524	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:18:41.210815
6888e788-97f4-a6b4-0020-81a4352019e2	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:23:52.443044	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:23:52.443433
6888e796-97f4-a6b4-0020-81a6139fdaf5	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:24:06.674468	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:24:06.674639
6888e7e3-97f4-a6b4-0020-81a8261a8ec2	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:25:23.302278	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:25:23.302513
6888eec7-97f4-a6b4-0020-81aa7ee92288	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 15:54:47.296979	73	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:54:47.369927
6888eee3-97f4-a6b4-0020-81ad02bcafcc	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:55:15.410389	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:55:15.410536
6888ef21-97f4-a6b4-0020-81af56a4904d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:56:17.077209	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:56:17.077573
6888ef26-97f4-a6b4-0020-81b13de19057	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:56:22.046574	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:56:22.046766
6888ef2a-97f4-a6b4-0020-81b33dafd972	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:56:26.559086	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:56:26.559224
6888ef30-97f4-a6b4-0020-81b52ffeb558	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:56:32.148472	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:56:32.148719
6888ef34-97f4-a6b4-0020-81b76880528a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 15:56:36.172046	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 15:56:36.172258
6888f04b-97f4-a6b4-0020-81b94afc9252	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:01:15.834254	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:01:15.834563
6888f24b-97f4-a6b4-0020-81bb15cff48b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:09:47.77707	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:09:47.777269
6888f54c-97f4-a6b4-0020-81bd6164c6c2	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:22:36.294786	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:22:36.295256
6888f54c-97f4-a6b4-0020-81be06514060	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:22:36.296169	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:22:36.296355
6888f54c-97f4-a6b4-0020-81c12badb51b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:22:36.468799	51	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:22:36.519596
6888f54c-97f4-a6b4-0020-81c37066f2e2	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:22:36.464678	71	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:22:36.535559
6888f54c-97f4-a6b4-0020-81c71328a970	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:22:36.609426	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:22:36.609643
6888f56f-97f4-a6b4-0020-81c9301f0117	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:23:11.45894	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:23:11.459064
6888f7bd-97f4-a6b4-0020-81cb1ee00262	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:33:01.615213	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups/685f2f1d-7ef6-c114-0022-88b738cf5c1c	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:33:01.616215
6888f7bd-97f4-a6b4-0020-81cd22ec828d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:33:01.751037	60	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/groups/685f2f1d-7ef6-c114-0022-88b738cf5c1c	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:33:01.811292
6888f7c8-97f4-a6b4-0020-81cf38ea8555	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:33:12.790972	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:33:12.791144
6888f7c8-97f4-a6b4-0020-81d25ef8c517	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:33:12.851552	26	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/positions/groups	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:33:12.877274
6888f9c1-97f4-a6b4-0020-81d47cef1696	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:41:37.446321	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:41:37.4465
6888f9c1-97f4-a6b4-0020-81d619d3d6d6	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:41:37.497584	34	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:41:37.531253
688a0de3-2ff3-6778-0069-50e61010b473	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 12:19:47.304528	117	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 12:19:47.42244
6888fa1c-97f4-a6b4-0020-81d87b5c8b7a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:43:08.356376	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:43:08.356671
6888fa6d-97f4-a6b4-0020-81da04a4c550	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:43:08.400136	81474	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:29.940835
6888fa70-97f4-a6b4-0020-81dc228bc289	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:32.356156	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:32.356351
6888fa72-97f4-a6b4-0020-81de7049be52	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:32.408109	1855	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:34.263487
6888fa74-97f4-a6b4-0020-81e026fba60c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:36.525954	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:36.526172
6888fa76-97f4-a6b4-0020-81e27ca3b069	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:36.584897	1724	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:38.30848
6888fa78-97f4-a6b4-0020-81e41612b86f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:40.220932	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:40.22118
6888fa7a-97f4-a6b4-0020-81e64e5a4195	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:40.291949	1792	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:42.083637
6888fa7d-97f4-a6b4-0020-81e801c7299d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:45.12373	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:45.123952
6888fa88-97f4-a6b4-0020-81ea62254b63	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:44:45.161342	10913	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:44:56.074863
6888fa92-97f4-a6b4-0020-81ec1221a8f3	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:45:06.023076	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:45:06.023251
6888fabc-97f4-a6b4-0020-81ee435609af	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:45:06.059668	42832	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:45:48.891403
6888faf6-7361-2460-0074-66b144af62c8	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:46.854082	29	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:46.904222
6888faf8-7361-2460-0074-66b33338ffb6	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:48.941597	5	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:48.947722
6888faf9-7361-2460-0074-66b516e33374	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:49.00396	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:49.004747
6888faf9-7361-2460-0074-66b761bc3715	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:49.153307	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:49.153598
6888faf9-7361-2460-0074-66b91c7a7e0b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:49.643649	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:49.644459
6888faf9-7361-2460-0074-66ba582925a4	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:49.651781	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:49.652638
6888faf9-7361-2460-0074-66bc53437ab4	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:49.688847	7	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:49.695656
6888fafa-7361-2460-0074-66bf1a09069d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:50.818709	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:50.819116
6888fafc-7361-2460-0074-66c13024966c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:52.892889	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:52.893244
6888fb00-7361-2460-0074-66c354e65f44	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:46:56.971446	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:46:56.971727
6888fb99-7361-2460-0074-66c51403fa62	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:49:29.640318	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:49:29.640628
6888fb99-7361-2460-0074-66c650faab78	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:49:29.640047	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:49:29.640818
6888fbd1-7361-2460-0074-66c931fc1e7e	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 16:50:25.534132	171	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:50:25.705017
6888fc57-7361-2460-0074-66cc3fb3244e	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:52:39.564975	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:52:39.565215
6888fc57-7361-2460-0074-66ce252c30e3	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:52:39.620591	32	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:52:39.652961
6888fe0c-7361-2460-0074-66d064019396	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:59:56.995514	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:59:56.995664
6888fe0d-7361-2460-0074-66d215db80e9	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 16:59:57.066569	12	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 16:59:57.078871
6888fe19-7361-2460-0074-66d44be04d92	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 17:00:09.993759	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/positions	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:00:09.993892
6888fe1a-7361-2460-0074-66d7161ffaee	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 17:00:10.052497	30	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/positions	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:00:10.082951
6889029a-7361-2460-0074-66d90ba0603d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 17:19:22.32733	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:19:22.327651
6889029a-7361-2460-0074-66db4ffe39a9	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 17:19:22.405459	46	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:19:22.451273
68890459-7361-2460-0074-66de6557945c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 17:26:49.814416	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:26:49.814547
6889045a-7361-2460-0074-66e05672b64c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 17:26:49.960894	46	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/positions/686a9bac-aad5-2c54-003c-a0450445a76f	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:26:50.006923
68890aff-7361-2460-0074-66e2431e007e	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 17:55:11.408084	70	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 17:55:11.478503
68890d1d-7361-2460-0074-66e52ee1c677	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:04:13.891711	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/departments	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:04:13.89185
68890d1e-7361-2460-0074-66e72a859e32	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:04:13.955487	113	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/departments	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:04:14.068528
68890d2b-7361-2460-0074-66e909becc0b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:04:27.108019	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/departments	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:04:27.108154
68890d2b-7361-2460-0074-66ec7117b19d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:04:27.153631	32	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/departments	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:04:27.185365
68890d46-7361-2460-0074-66ee1120605c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:04:54.302652	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/employees	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:04:54.3028
68890d46-7361-2460-0074-66f03f58c53c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:04:54.365516	39	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/employees	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:04:54.404693
68890d50-7361-2460-0074-66f25865b238	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:05:04.448728	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/employees/bind-user	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:05:04.449069
68890d50-7361-2460-0074-66f40a86893a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:05:04.512358	27	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/employees/bind-user	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:05:04.539124
68890d70-7361-2460-0074-66f6507a203f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:05:36.463489	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/employees	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:05:36.463638
68890d70-7361-2460-0074-66f9453c1a6b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:05:36.528032	30	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/employees	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:05:36.55856
68890dc6-7361-2460-0074-66fb268ec0f4	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:07:02.477921	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/notifications/68848ae9-4b6b-160c-0042-19be265da2d8	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:07:02.478392
68890e44-21b2-19c0-00d4-130d4e28cc74	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:09:08.497145	24	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/notifications/68848ae9-4b6b-160c-0042-19be265da2d8	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:09:08.544284
68890e49-21b2-19c0-00d4-130f7745359c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:09:13.696154	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/notifications/68848ae9-4b6b-160c-0042-19be265da2d8	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:09:13.697272
68890e4d-21b2-19c0-00d4-1311201ceaf7	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:09:17.790888	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/notifications/68848ae9-4b6b-160c-0042-19be265da2d8	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:09:17.79119
68890e62-21b2-19c0-00d4-1313785a3713	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:09:38.211239	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/notifications/68848ae9-4b6b-160c-0042-19be265da2d8	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:09:38.211664
68890ebe-21b2-19c0-00d4-1315772558c6	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:11:10.353881	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/notifications/68848ae9-4b6b-160c-0042-19be265da2d8	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:11:10.354379
68890f63-21b2-19c0-00d4-1317270bfaab	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 18:13:55.601358	241	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:13:55.842901
68890f9b-21b2-19c0-00d4-131a202da3c1	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:14:51.361234	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/notifications	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:14:51.361429
68890f9b-21b2-19c0-00d4-131d34251a24	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:14:51.420017	28	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/notifications	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:14:51.44843
68890fc0-21b2-19c0-00d4-132104dbe7f3	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:15:28.632646	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/employees	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:15:28.632806
68890fc0-21b2-19c0-00d4-13233f546eec	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:15:28.714527	65	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/employees	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:15:28.779642
68890fcf-21b2-19c0-00d4-13270a2e84f9	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:15:43.119122	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/users/reset-password	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:15:43.119405
68890fcf-21b2-19c0-00d4-13295663609c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:15:43.255076	39	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/users/reset-password	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:15:43.293916
68891162-9894-256c-00d8-1cc96ea601fb	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-29 18:22:26.527083	218	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:22:26.763296
688911b7-9894-256c-00d8-1cce4d0ae716	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:23:51.785635	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users/3e64db48-e302-46f7-87d8-dc3f8c4bd428/assign-role	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:23:51.786172
688911b7-9894-256c-00d8-1cd13358c8c5	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:23:51.822015	30	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users/3e64db48-e302-46f7-87d8-dc3f8c4bd428/assign-role	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:23:51.852441
688911c5-9894-256c-00d8-1cd4155745a7	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:05.643351	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:05.643618
688911c5-9894-256c-00d8-1cd642fe9f78	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:05.699165	37	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:05.736471
688911cc-9894-256c-00d8-1cda5a1cceed	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:12.686872	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users/89d5a892-4153-459b-89cb-b5fa7ccfabc2/assign-role	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:12.68711
688911cc-9894-256c-00d8-1cdd1d7b2dff	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:12.721117	16	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users/89d5a892-4153-459b-89cb-b5fa7ccfabc2/assign-role	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:12.737264
688911d0-9894-256c-00d8-1ce00cf1b018	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:16.460162	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	DELETE	/api/admin/users/89d5a892-4153-459b-89cb-b5fa7ccfabc2	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:16.460333
688911d0-9894-256c-00d8-1ce21b129d23	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:16.51918	20	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	DELETE	/api/admin/users/89d5a892-4153-459b-89cb-b5fa7ccfabc2	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:16.539533
688911d5-9894-256c-00d8-1ce5739c5f6f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:21.621142	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:21.621316
688911d5-9894-256c-00d8-1ceb0979b354	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:21.680279	46	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:21.726208
688911d9-9894-256c-00d8-1cee612e2f7f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:25.165719	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:25.165889
688911d9-9894-256c-00d8-1cf01140617f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-29 18:24:25.210088	33	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/roles/687047ef-1649-9660-0098-4182062f682c	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-29 18:24:25.242855
6889f848-d022-c7cc-0034-4d2a4a4bb31f	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 10:47:35.862963	374	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:47:36.257971
6889f85b-d022-c7cc-0034-4d2f69153b18	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 10:47:55.260659	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:47:55.261029
6889f85b-d022-c7cc-0034-4d3270b0ca08	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 10:47:55.344134	37	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/users	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:47:55.380828
6889f9e9-c58e-60d8-0066-5ec744c3c90b	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 10:54:33.404336	208	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:54:33.625925
6889f9fc-c58e-60d8-0066-5eca1d71cdd0	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 10:54:52.787634	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:54:52.788212
6889f9fc-c58e-60d8-0066-5ecd27d4e51a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 10:54:52.852775	30	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:54:52.882909
6889fa87-c58e-60d8-0066-5ed0695c4ee5	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 10:57:11.437915	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/6889f9fc-c58e-60d8-0066-5ecc5acf27d0	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:57:11.438403
6889fa87-c58e-60d8-0066-5ed246814f37	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 10:57:11.500276	65	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/6889f9fc-c58e-60d8-0066-5ecc5acf27d0	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 10:57:11.565082
6889fc62-5050-4dc8-0093-d0261dd4871b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:05:06.113311	29	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:05:06.168505
6889fc68-5050-4dc8-0093-d02833c7f716	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 11:05:12.190625	184	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:05:12.375508
6889fc74-5050-4dc8-0093-d02b2c6fd180	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:05:24.267954	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:05:24.268325
6889fc74-5050-4dc8-0093-d02e19a9eaa2	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:05:24.310547	32	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:05:24.342724
6889fd9c-0676-5e5c-0010-ca9d5553ece0	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:08:26.300434	30	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/6889fc74-5050-4dc8-0093-d02d618ab933	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:08:26.353653
6889fd9e-0676-5e5c-0010-ca9f52ff1d75	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:10:22.876327	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/6889fc74-5050-4dc8-0093-d02d618ab933	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:10:22.877396
6889fda4-0676-5e5c-0010-caa11ee62eb3	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 11:10:28.542226	186	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:10:28.728046
6889fdaf-0676-5e5c-0010-caa452d16b37	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:10:39.666082	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/6889fc74-5050-4dc8-0093-d02d618ab933	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:10:39.666393
6889fdaf-0676-5e5c-0010-caa646ad329c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:10:39.731652	67	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/6889fc74-5050-4dc8-0093-d02d618ab933	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:10:39.79875
688a0190-2e5c-a0f8-0014-50c87b1d671b	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 11:27:12.511239	262	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:27:12.792896
688a019f-2e5c-a0f8-0014-50cb4f83da8f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:27:27.062639	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:27:27.063033
688a019f-2e5c-a0f8-0014-50ce1dbccc83	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:27:27.124985	30	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:27:27.15527
688a01bf-2e5c-a0f8-0014-50d15ef6d024	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:27:45.973138	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:27:45.973385
688a023b-2e5c-a0f8-0014-50d464a92e6b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:29:59.296389	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:29:59.296632
688a023b-2e5c-a0f8-0014-50d7328fa292	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:30:03.494477	18	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:30:03.512223
688a035c-087b-11a0-005c-ff2d00e05a06	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:34:44.732963	25	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:34:44.785075
688a047e-087b-11a0-005c-ff2f0dd49dd3	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 11:39:42.700636	3	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/tenants	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:39:42.704719
688a0484-087b-11a0-005c-ff3111237a8b	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 11:39:48.46988	157	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:39:48.626538
688a0519-2ff3-6778-0069-50e37dbf4656	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 11:42:17.717399	227	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 11:42:17.963619
688a0e79-bafd-73c0-00f7-94b95a125300	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 12:22:17.03211	217	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 12:22:17.276386
688a0e95-bafd-73c0-00f7-94bb173b710b	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 12:22:45.573645	46	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 12:22:45.620876
b75d2378-2731-c070-061c-3a1b6bfb1ac7	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 13:26:17.13641	10	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 13:26:17.175484
9609d11d-2794-6d1e-0ac2-3a1b6c223914	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 14:11:35.196364	226	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 14:11:35.441971
f14b7caa-24c4-c60f-0009-3a1b6c22792c	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 14:12:05.711498	62	::ffff:127.0.0.1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 14:12:05.774338
97835fff-8efa-0e68-722b-3a1b6c22dfd3	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 14:12:24.323547	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/688a023b-2e5c-a0f8-0014-50d6450e48fc	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 14:12:24.324035
41facc1d-4ed8-c163-0688-3a1b6c22e26b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 14:12:32.903458	69	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/688a023b-2e5c-a0f8-0014-50d6450e48fc	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 14:12:32.972139
7ae88bae-6fcf-61d3-3479-3a1b6c22f5ab	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 14:12:37.605727	0	::ffff:127.0.0.1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/688a023b-2e5c-a0f8-0014-50d6450e48fc	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 14:12:37.606204
e1b16e66-c91d-4530-b08f-3a1b6c22f868	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 14:12:38.477082	20	::ffff:127.0.0.1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/tenants/688a023b-2e5c-a0f8-0014-50d6450e48fc	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 14:12:38.49686
1518415e-d09f-53c0-80b8-3a1b6cefd3a8	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 17:56:24.184382	390	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 17:56:24.593395
ea8f3122-7295-91e6-f969-3a1b6cf5330e	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 18:02:16.718024	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/menus	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 18:02:16.718316
18702a64-2cab-2eff-938c-3a1b6cf5334d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 18:02:16.752679	28	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/admin/menus	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 18:02:16.781024
8fb80185-6db9-1d33-dae7-3a1b6cf57c3a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 18:02:35.44723	3	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 18:02:35.450441
9ff2e22e-57e6-de67-5f61-3a1b6cf5825e	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-30 18:02:36.995159	27	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 18:02:37.022647
be1a468b-8e3a-d5be-4e71-3a1b6cf66c91	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 18:03:36.977361	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 18:03:36.977509
97fffeae-ec96-08c7-05c9-3a1b6cf742f4	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-30 18:03:36.998772	54853	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-30 18:04:31.860433
5a0ce7ac-a415-03e6-ab7b-3a1b7009d7af	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 08:23:40.967936	221	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:23:41.20816
66cdc347-b706-9c88-bba9-3a1b700f04ea	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:29:20.489444	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:29:20.489801
f0e57d3e-98cf-80fd-b9c6-3a1b700f82db	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:29:20.549314	32149	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:29:52.730696
0ddb30d6-7327-2a5a-d8cf-3a1b7010c250	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:31:14.512408	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:31:14.512764
fe372de5-1549-0d10-d88f-3a1b7010ddfa	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:31:14.52642	7067	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:31:21.593953
68394a8c-120a-6a8e-5c41-3a1b70117ba8	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:32:01.959641	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:32:01.960103
28db079b-1eda-e41e-b0b5-3a1b70135155	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:32:01.971717	120196	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	500	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:34:02.196846
4f9b2d03-5d03-4f88-e82b-3a1b70163900	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:37:12.494612	22	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:37:12.538535
9b9dc516-4a2c-b032-f769-3a1b701650ee	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 08:37:18.401262	300	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:37:18.701992
18b1976a-d1de-928b-b501-3a1b70169220	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:37:35.392057	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:37:35.392392
3cce58d1-f398-3c5b-67eb-3a1b7016a801	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:37:35.432408	5561	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:37:40.993599
3d012352-3f4d-ff4e-88ca-3a1b7016e71f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 08:37:57.147753	3	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:37:57.150967
5f657b01-575a-c28a-f78d-3a1b7016ec50	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 08:37:58.455744	25	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 08:37:58.480792
7ad1ecf9-0507-a5e8-80b8-3a1b70a79d10	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 11:16:00.494045	376	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:16:00.890356
485a8845-72c8-6e21-d9ef-3a1b70bc99de	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 11:38:56.349589	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:38:56.350492
dc28e395-4fba-b234-0e86-3a1b70bc9a8d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 11:38:56.525111	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:38:56.525729
c054340b-c304-49c1-3534-3a1b70bc99de	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 11:38:56.349593	1	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:38:56.350504
02e37517-7222-6bdc-a766-3a1b70bc9c09	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 11:38:56.608958	296	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:38:56.90466
ed2697f4-fc2d-e6da-1ab1-3a1b70bc9c1e	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 11:38:56.609073	317	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:38:56.926425
60da2920-3682-cff1-4f36-3a1b70bc9c1f	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 11:38:56.618108	309	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:38:56.926913
8d4e576b-580b-37bf-b65d-3a1b70bcb84a	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 11:39:04.106511	32	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 11:39:04.138154
db1bc827-2ad2-532a-aac0-3a1b70dcdbc8	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 12:14:10.269193	107	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:14:10.376321
5e90a217-89bd-38f8-c375-3a1b70efbe2b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 12:34:47.979197	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:34:47.979441
c11b2dbd-2196-50a3-a64e-3a1b70efbe43	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 12:34:48.002726	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:34:48.002926
295b71fb-7b47-99e5-a474-3a1b70efbfba	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 12:34:48.033808	345	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:34:48.378617
9410d725-f5f0-4a66-a0b7-3a1b70f2016e	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 12:34:48.068519	148137	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:37:16.270422
993eed09-22a1-80bc-4392-3a1b70f2261d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 12:37:25.657047	4	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:37:25.661097
5f557f6c-5787-5287-dde5-3a1b70f2261a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 12:37:25.657719	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:37:25.658052
ebb29b65-d087-dfc2-1da9-3a1b70f23d70	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 12:37:31.604149	28	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 12:37:31.632027
68a46604-0fb0-74be-7c00-3a1b711dcff0	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 13:25:07.113007	71	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 13:25:07.184115
828fe0bc-ed1f-ca09-b5d9-3a1b71570e04	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 14:27:38.52544	102	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:27:38.62714
c50bed9c-2ac2-7f90-6fdc-3a1b7158a8d5	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:29:23.797239	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:29:23.797624
94174934-6ac2-bc41-a6c6-3a1b7158b44e	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:29:23.845653	2889	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	PUT	/api/admin/menus/bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:29:26.734375
7ac8f432-51ba-b58a-1845-3a1b7158cabc	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:29:32.471879	5	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:29:32.476577
5fffdc9f-d2ad-fc23-fa29-3a1b7158d00c	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 14:29:33.791695	45	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:29:33.836412
0de204e7-4d6f-d593-6d26-3a1b716d9876	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:15.861504	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:15.861882
e1fd413d-4402-fc56-25e7-3a1b716d9916	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.02032	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:16.022078
2bedc938-c84d-24b3-1a20-3a1b716d9966	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.102544	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:16.102742
daa5fccf-b4fe-d192-b8f5-3a1b716d9b2c	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.55637	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:16.556535
0a56c3e8-f4a0-8a81-fdfb-3a1b716d9b31	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.560588	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:16.560983
e19ca876-07c4-0251-7375-3a1b716d9ce7	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.104549	842	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:16.946462
2777747b-0000-340d-2469-3a1b716d9c6b	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.080681	657	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:16.875626
8d0cc09f-fd63-f771-bc56-3a1b716e1bbf	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:16.15462	33316	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:49.471106
950a51f1-7816-2f06-8be4-3a1b716e2ac2	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 14:52:53.293628	20	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 14:52:53.314148
a97d2492-d68b-929b-97bf-3a1b718116ca	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 15:13:33.38557	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:13:33.386084
3e7f0123-5824-afeb-c0a0-3a1b718116ca	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 15:13:33.386373	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:13:33.386477
a0c00c05-2686-c6ab-0f91-3a1b71812943	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 15:13:33.415823	4699	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	403	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:13:38.115312
0de1d4ce-21c1-4721-53dc-3a1b718164be	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 15:13:53.296347	46	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:13:53.341971
fb568f07-3918-7063-1556-3a1b718117cb	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 15:13:33.411715	232	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:13:33.643773
eae0c375-2293-e669-6814-3a1b71a4dc17	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 15:52:37.353282	259	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:52:37.631405
7aa49a5e-27ad-3c8a-0118-3a1b71a52949	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 15:52:57.413917	3	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:52:57.417122
5d67802a-8cbb-b8ae-70a1-3a1b71a531e5	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 15:52:59.582386	39	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:52:59.621077
2ac77c76-65eb-404f-52d6-3a1b71a570c6	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 15:53:15.717656	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:53:15.717845
d638b5c1-2c7b-544b-659d-3a1b71aa13d8	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 15:53:17.113929	302494	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:58:19.607801
b749765c-43ce-c4d8-6eff-3a1b71aa872b	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 15:58:45.755799	3375	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 15:58:49.131327
47dd5542-ff21-fc0f-6d51-3a1b71c3019a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:33.338243	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:33.338722
e97c9a91-ded4-8a98-8951-3a1b71c30246	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:33.510512	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:33.510724
8326a251-d85b-f4bf-40dd-3a1b71c3022a	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:33.48125	0	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:33.481509
c976dc6a-af6a-5310-6cdc-3a1b71c302ea	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:33.53628	138	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:33.673982
afa5adc9-aead-c387-7d6a-3a1b71c302e6	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:33.535886	134	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:33.670107
b356cd77-081f-2e51-d27a-3a1b71c30312	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:33.535891	178	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/refresh-token	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:33.714243
fa9b10a5-0eb8-4397-aaeb-3a1b71c30d26	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 16:25:36.270649	23	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:25:36.294179
0ca917b2-4878-f720-719a-3a1b71c6fe03	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 16:29:54.207899	304	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:29:54.534141
b7d658d9-2bed-f286-5881-3a1b71cb6df8	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 16:34:45.095778	226	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:34:45.336492
8c930681-0ea9-827b-74f3-3a1b71cbff53	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:35:22.57594	3	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:35:22.579438
aff9616f-29f8-4cc4-2d21-3a1b71cc069a	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 16:35:24.402969	40	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:35:24.442822
f3768cb8-4ae9-7213-087d-3a1b71d3ab2d	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:43:45.241605	24	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:43:45.285692
4120609b-7285-615c-2e24-3a1b71d3bdaf	Letu.Server	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin	\N	\N	\N	\N	\N	\N	2025-07-31 16:43:49.761807	301	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/logout	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:43:50.063233
e4adc0d8-b54e-abed-1412-3a1b71d3c4f9	Letu.Server	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-31 16:43:51.711703	217	::1	\N	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	POST	/api/account/login	200	\N	\N	Volo.Abp.Data.ExtraPropertyDictionary	2025-07-31 16:43:51.928851
\.


--
-- Data for Name: sys_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_config (id, creator_id, creation_time, last_modification_time, last_modifier_id, name, key, value, group_key, remark, tenant_id) FROM stdin;
68758b9b-e6de-0d4c-0000-b9861878b283	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-14 22:58:35.09269	2025-07-14 22:58:40.62024	3a172a37-55d5-ee9b-dc92-e07386eadc7c	文件存储驱动类型	StorageType	1	System	本地服务器=1，阿里云OSS=2	\N
\.


--
-- Data for Name: sys_dept; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_dept (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, code, name, sort, description, status, curator_id, email, phone, parent_id, parent_ids, layer, tenant_id) FROM stdin;
6861a543-de18-91c8-009e-ef9c48eee11a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-29 20:42:43.252466	2025-06-29 20:52:55.936051	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	IT-01	研发部	1		1	6869907c-9c93-beac-0062-34172a640e0e	crackerwork@outlook.com	18211112222	\N	6861a4ed-de18-91c8-009e-ef9b36642c3c	2	\N
6861a4ed-de18-91c8-009e-ef9b36642c3c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-29 20:41:17.23825	2025-07-14 22:01:12.096261	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	root	科技有限公司	1	\N	1	6869907c-9c93-beac-0062-34172a640e0e	\N	\N	6861a543-de18-91c8-009e-ef9c48eee11a	6861a543-de18-91c8-009e-ef9c48eee11a	2	\N
68890d2b-7361-2460-0074-66eb388cacff	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:04:27.173947	\N	\N	f	\N	\N	d	test	0	\N	1	\N	\N	\N	6861a4ed-de18-91c8-009e-ef9b36642c3c	6861a543-de18-91c8-009e-ef9c48eee11a,6861a4ed-de18-91c8-009e-ef9b36642c3c	3	\N
\.


--
-- Data for Name: sys_dict_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_dict_data (id, creator_id, creation_time, last_modification_time, last_modifier_id, value, label, dict_type, remark, sort, is_enabled, tenant_id) FROM stdin;
68602622-e22b-e780-00f8-5c9d688361b4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-28 17:28:02.919064	2025-06-28 17:28:28.158885	3a172a37-55d5-ee9b-dc92-e07386eadc7c	1	L1	positionLevel	\N	1	t	\N
6860262d-e22b-e780-00f8-5c9e382875ed	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-28 17:28:13.873205	2025-06-28 17:28:31.396049	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2	L2	positionLevel	\N	2	t	\N
68602667-e22b-e780-00f8-5c9f2187a1d8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-28 17:29:11.307524	\N	\N	3	L3	positionLevel	\N	3	t	\N
\.


--
-- Data for Name: sys_dict_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_dict_type (id, creator_id, creation_time, last_modification_time, last_modifier_id, name, dict_type, remark, is_enabled, tenant_id) FROM stdin;
6860261b-e22b-e780-00f8-5c9b126fd27d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-28 17:27:55.475365	2025-07-27 16:42:19.6365	3a172a37-55d5-ee9b-dc92-e07386eadc7c	职位职级	positionLevel	\N	t	\N
\.


--
-- Data for Name: sys_entity_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_entity_changes (id, tenant_id, audit_log_id, change_time, change_type, entity_id, entity_type_full_name, extra_properties) FROM stdin;
\.


--
-- Data for Name: sys_login_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_login_log (id, creator_id, creation_time, user_name, ip, address, os, browser, operation_msg, is_success, session_id, tenant_id) FROM stdin;
68848acd-4b6b-160c-0042-19bd6b838ff0	00000000-0000-0000-0000-000000000000	2025-07-26 07:59:09.371295	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469450117615194112	\N
6884db1f-de99-7298-00a7-c8e94240233e	00000000-0000-0000-0000-000000000000	2025-07-26 13:41:51.690159	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469536359371509760	\N
688551e6-20b6-b614-005f-da006061c039	00000000-0000-0000-0000-000000000000	2025-07-26 22:08:38.5334	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469663896177217536	\N
6885e4ba-b061-92cc-00b2-f6611323b89e	00000000-0000-0000-0000-000000000000	2025-07-27 08:35:06.470122	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469821557061455872	\N
6885f33f-adfa-4e0c-0012-a71c6577b5ff	00000000-0000-0000-0000-000000000000	2025-07-27 09:37:03.998027	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469837151425007616	\N
6885fa9c-adfa-4e0c-0012-a73c0460d575	00000000-0000-0000-0000-000000000000	2025-07-27 10:08:28.510157	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469845056844992512	\N
6885fe8c-adfa-4e0c-0012-a7614a0dddb0	00000000-0000-0000-0000-000000000000	2025-07-27 10:25:16.285808	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469849279926112256	\N
6886052b-adfa-4e0c-0012-a786167b5339	00000000-0000-0000-0000-000000000000	2025-07-27 10:53:31.368839	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469856390101864448	\N
68860918-adfa-4e0c-0012-a7aa0cd1e81d	00000000-0000-0000-0000-000000000000	2025-07-27 11:10:16.364703	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469860605226389504	\N
6886497c-83c0-4b38-0034-fa222d8e3040	00000000-0000-0000-0000-000000000000	2025-07-27 15:45:00.635735	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469929745626697728	\N
688655bb-83c0-4b38-0034-fa577ee5667e	00000000-0000-0000-0000-000000000000	2025-07-27 16:37:15.80354	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4469942895910588416	\N
6888cff1-ca52-4bb0-008f-b8a707e36c6a	00000000-0000-0000-0000-000000000000	2025-07-29 13:43:13.142094	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	7140ce80-32e7-5f6b-4243-3a1b66e1a880	\N
6888cffd-ca52-4bb0-008f-b8aa2f6f4a84	00000000-0000-0000-0000-000000000000	2025-07-29 13:43:25.202964	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	e21a7e2d-0871-7575-3d70-3a1b66e1d8b6	\N
6888d018-ca52-4bb0-008f-b8ad79466e44	00000000-0000-0000-0000-000000000000	2025-07-29 13:43:52.316163	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	dda0ca47-c806-6956-bdfb-3a1b66e242b9	\N
6888d22f-ca52-4bb0-008f-b8b0183e8acd	00000000-0000-0000-0000-000000000000	2025-07-29 13:52:47.273598	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	38b4d333-cb50-7d84-e212-3a1b66ea6c49	\N
6888d239-ca52-4bb0-008f-b8b353276a40	00000000-0000-0000-0000-000000000000	2025-07-29 13:52:57.568684	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	a0d6379e-971a-08e7-ccf5-3a1b66ea9494	\N
6888d249-ca52-4bb0-008f-b8b62d698808	00000000-0000-0000-0000-000000000000	2025-07-29 13:53:13.959804	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	2cf9c10e-a8d1-d3c1-cef0-3a1b66ead4a9	\N
6888d2d3-ca52-4bb0-008f-b8b902d757c5	00000000-0000-0000-0000-000000000000	2025-07-29 13:55:31.643791	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	34fa194c-667a-54d0-65ec-3a1b66ecee7d	\N
6888d3a9-1523-a9f0-0020-a91f50f25593	00000000-0000-0000-0000-000000000000	2025-07-29 13:59:05.991089	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	13a21fbb-f63f-043f-b5b6-3a1b66f032d5	\N
6888d3b7-1523-a9f0-0020-a9221cea28e4	00000000-0000-0000-0000-000000000000	2025-07-29 13:59:19.379378	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	3110420b-a710-c9a2-1087-3a1b66f067d8	\N
6888d3c5-1523-a9f0-0020-a9251f1a5bcc	00000000-0000-0000-0000-000000000000	2025-07-29 13:59:33.018811	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	3384f8f7-19a4-7ebe-c8be-3a1b66f09d5e	\N
6888d82b-8465-d6cc-0063-58d30e3865a2	00000000-0000-0000-0000-000000000000	2025-07-29 14:18:19.413105	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	5b3c2a7f-b419-0bbc-01ba-3a1b6701cc76	\N
6888d83e-8465-d6cc-0063-58d97ee33965	00000000-0000-0000-0000-000000000000	2025-07-29 14:18:38.855291	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	210ca3f5-ac6b-3c6f-572a-3a1b670218fb	\N
6888da08-46f2-018c-0056-9d9f7bca3bd7	00000000-0000-0000-0000-000000000000	2025-07-29 14:26:16.430023	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	19961af0-65cc-2bd1-bdff-3a1b67091399	\N
6888da8f-f6b8-0774-00c0-ae8013a1d870	00000000-0000-0000-0000-000000000000	2025-07-29 14:28:31.23027	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	0638434d-f309-c9ed-d3c0-3a1b670b222a	\N
6888dd09-a97c-0cb0-0051-847b07ab9eab	00000000-0000-0000-0000-000000000000	2025-07-29 14:39:05.185226	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	c972cc36-a520-a39f-5bc4-3a1b6714ce9b	\N
6888e00c-4bd6-2248-0033-d98c776bae7a	00000000-0000-0000-0000-000000000000	2025-07-29 14:51:56.542525	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	fce89c94-c2b8-25c7-f9e5-3a1b67209384	\N
6888e2a1-fa0e-1c34-002b-ca730a4ff330	00000000-0000-0000-0000-000000000000	2025-07-29 15:02:57.323489	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	40d09420-96e7-47e7-fd7c-3a1b672aa8f9	\N
6888e412-aa3b-a858-0035-efee1b35de58	00000000-0000-0000-0000-000000000000	2025-07-29 15:09:06.019133	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	6c4b4953-c227-3365-c158-3a1b67304836	\N
6888e627-97f4-a6b4-0020-819d0f1d7c21	00000000-0000-0000-0000-000000000000	2025-07-29 15:17:59.323381	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	0f6cd4d7-802b-d83b-1bed-3a1b67386c04	\N
6888eec7-97f4-a6b4-0020-81ac23628094	00000000-0000-0000-0000-000000000000	2025-07-29 15:54:47.4382	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac	\N
6888f54c-97f4-a6b4-0020-81c531e34a58	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 16:22:36.562829	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac	\N
6888f54c-97f4-a6b4-0020-81c64739a4e6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 16:22:36.601224	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	8ed2ff75-8ec5-7be1-bd14-3a1b675a1eac	\N
6888fbd1-7361-2460-0074-66cb5f55602c	00000000-0000-0000-0000-000000000000	2025-07-29 16:50:25.780371	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	be846636-b2fd-98dc-822c-3a1b678d0ede	\N
6889029a-7361-2460-0074-66dd452deb2a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 17:19:22.485477	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	be846636-b2fd-98dc-822c-3a1b678d0ede	\N
68890aff-7361-2460-0074-66e41b198e1f	00000000-0000-0000-0000-000000000000	2025-07-29 17:55:11.545244	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4d98b780-c3ef-e5b3-2631-3a1b67c859d2	\N
68890f63-21b2-19c0-00d4-13196ba75294	00000000-0000-0000-0000-000000000000	2025-07-29 18:13:55.927041	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	699573ed-159e-cf7b-7f28-3a1b67d981b0	\N
68891162-9894-256c-00d8-1ccb12f870ed	00000000-0000-0000-0000-000000000000	2025-07-29 18:22:26.957342	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	868d0315-0bd1-5032-ac8c-3a1b67e14d58	\N
6889f848-d022-c7cc-0034-4d2c55719e65	\N	2025-07-30 10:47:36.452258	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	5deb6a75-40d3-8048-3864-3a1b6b673d4c	\N
6889f9e9-c58e-60d8-0066-5ec968829384	\N	2025-07-30 10:54:33.785055	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	25e2e3df-6169-32d2-0359-3a1b6b6d9c27	\N
6889fc68-5050-4dc8-0093-d02a1c3a818c	\N	2025-07-30 11:05:12.439777	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	0236f48a-8bae-fd19-9437-3a1b6b775b4f	\N
6889fda4-0676-5e5c-0010-caa37e663681	\N	2025-07-30 11:10:28.803469	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	6db9de80-b812-fedc-56cd-3a1b6b7c2f0a	\N
688a0190-2e5c-a0f8-0014-50ca4df47021	\N	2025-07-30 11:27:12.987362	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	b168c0f7-072b-ba57-87ad-3a1b6b8b80f6	\N
688a04a1-087b-11a0-005c-ff330ad3e81b	e52f5df7-3de4-8839-c2cb-3a1b6b978e40	2025-07-30 11:40:17.918847	admin	::1	13e80336-5f16-c16b-02d1-3a1b6b978e45	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4b69cace-e033-6e4e-003c-3a1b6b9709c5	432e4575-af2e-f3a9-b6c0-3a1b6b978e48
688a052a-2ff3-6778-0069-50e5560752d2	1280df3a-bfd1-502b-3fbf-3a1b6bbb9ac5	2025-07-30 11:42:34.175285	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	1afa9fe1-9edc-12bc-31b6-3a1b6b9950f1	\N
688a0e0f-2ff3-6778-0069-50e81c55b7c8	\N	2025-07-30 12:20:31.347109	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	c9811f66-0aa1-799f-0536-3a1b6bbba435	\N
a3d99900-de52-cc34-0b3b-3a1b6bbe208d	\N	2025-07-30 12:22:41.814802	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	7945eb9d-0fa2-91b9-bbb6-3a1b6bbded45	\N
090a0d03-7cda-7b2b-f1e6-3a1b6bbe5fb4	\N	2025-07-30 12:22:46.452723	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	284d08b6-0eb6-b303-4fda-3a1b6bbe5c50	\N
8146afec-28e7-a39a-76d9-3a1b6c226ad3	\N	2025-07-30 14:12:02.901607	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	0c6d86b5-d335-2566-24a5-3a1b6c21ff1b	\N
a15405e6-0472-d6d5-9830-3a1b6c227bd9	\N	2025-07-30 14:12:07.258525	admin	::ffff:127.0.0.1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	ee4ef8db-a64b-0f99-ac89-3a1b6c2275e0	\N
7019543a-25f3-95db-5fd2-3a1b6cefd47b	\N	2025-07-30 17:56:24.828527	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	2c886111-3cd1-e141-d22c-3a1b6cefd288	\N
50a25e9b-54f0-dc13-4a12-3a1b6cf5826a	\N	2025-07-30 18:02:37.035323	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	cd9b52a4-d4f3-bcd6-413b-3a1b6cf58247	\N
4c326c6a-bcc5-9156-b1f0-3a1b7009d841	\N	2025-07-31 08:23:41.379273	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	bbd81f4b-c4f0-5f9d-d66f-3a1b7009d725	\N
3df65a04-85f3-93e0-10fa-3a1b70165114	\N	2025-07-31 08:37:18.741333	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	28787c7e-2aed-5aa1-74b0-3a1b70165008	\N
63579fe4-bc0b-cf80-733e-3a1b7016ec56	\N	2025-07-31 08:37:58.486959	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	90647d74-d65d-69c3-8f03-3a1b7016ec39	\N
cf391197-06aa-389a-ac6b-3a1b70a79da2	\N	2025-07-31 11:16:01.060255	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	e68dd374-14ee-a420-fa00-3a1b70a79be6	\N
5906c021-12ab-a474-9a3f-3a1b70bc9c17	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 11:38:56.920102	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	e68dd374-14ee-a420-fa00-3a1b70a79be6	\N
5e17a861-31f1-38a5-1475-3a1b70bc9c2b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 11:38:56.939628	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	e68dd374-14ee-a420-fa00-3a1b70a79be6	\N
d3fc6851-df10-4710-edf7-3a1b70bc9c2e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 11:38:56.942021	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	e68dd374-14ee-a420-fa00-3a1b70a79be6	\N
eb2fe5d7-ed3d-dfa7-4aa6-3a1b70bcb853	\N	2025-07-31 11:39:04.147915	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	c4734e5d-a30b-bf6d-2f03-3a1b70bcb82d	\N
913fb29c-8862-faea-0bd5-3a1b70dcdbd1	\N	2025-07-31 12:14:10.385621	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	807a10d9-f707-368b-c3e8-3a1b70dcdbb3	\N
ab69a3f8-ce16-a422-4ada-3a1b70efc0ee	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 12:34:48.742751	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	807a10d9-f707-368b-c3e8-3a1b70dcdbb3	\N
1f507d25-573e-a2f6-f047-3a1b70f23d7c	\N	2025-07-31 12:37:31.644129	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	71acc762-7a37-0aee-b50f-3a1b70f23d57	\N
e40cf326-7afd-3ca5-f903-3a1b711dcff9	\N	2025-07-31 13:25:07.193726	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	489f52cd-0880-b5d3-81c4-3a1b711dcfc2	\N
c5dc40fe-119e-bb59-66e6-3a1b71570e14	\N	2025-07-31 14:27:38.644565	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	2fb2ba97-4b5f-081d-71d2-3a1b71570daf	\N
228bab32-7718-5f51-e1df-3a1b7158d015	\N	2025-07-31 14:29:33.845757	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	abcd7576-3e77-4e9e-c646-3a1b7158cfe1	\N
fbc10a06-629c-67eb-39f7-3a1b716d9e6e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:52:17.390088	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	abcd7576-3e77-4e9e-c646-3a1b7158cfe1	\N
48abac59-5df5-8f64-8781-3a1b716d9e6e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 14:52:17.390088	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	abcd7576-3e77-4e9e-c646-3a1b7158cfe1	\N
ffee7315-ba01-a75f-bb91-3a1b716e2acb	\N	2025-07-31 14:52:53.323441	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	e8c0801d-9a9a-1f83-3958-3a1b716e2ab0	\N
c3bd219a-a145-b2fc-3082-3a1b71812943	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 15:13:38.115489	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	e8c0801d-9a9a-1f83-3958-3a1b716e2ab0	\N
8162cf9e-5f1d-0e6f-455f-3a1b718164c8	\N	2025-07-31 15:13:53.352546	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	5b3ca84d-37da-a838-69c6-3a1b71816493	\N
986b9771-2760-6254-6280-3a1b71a4dcb2	\N	2025-07-31 15:52:37.812215	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	7b06e661a72d45f9d5cb3a1b71a4db69	\N
c822133a-be60-e1b4-7b68-3a1b71a531ee	\N	2025-07-31 15:52:59.63075	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	1a9f1eb55406111f488c3a1b71a531c2	\N
80060e24-3e20-136c-baac-3a1b71aa13f0	\N	2025-07-31 15:58:19.632848	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	36b3fcc778218183a5db3a1b71a5763c	\N
1fb5f6fa-1c53-33ed-5fc3-3a1b71aa873d	\N	2025-07-31 15:58:49.149347	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	cbffb5995b695e6e54113a1b71aa79fe	\N
1ddb69fd-79a5-99d2-8a06-3a1b71c302fd	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 16:25:33.693608	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	cbffb5995b695e6e54113a1b71aa79fe	\N
178a86b2-47b1-85ab-7642-3a1b71c3030d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 16:25:33.709899	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	cbffb5995b695e6e54113a1b71aa79fe	\N
cce5e3a7-76eb-fcb8-53e5-3a1b71c30344	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-31 16:25:33.764076	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	刷新令牌成功	t	cbffb5995b695e6e54113a1b71aa79fe	\N
14db5092-5680-fcda-f569-3a1b71c30d2f	\N	2025-07-31 16:25:36.303627	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	bf80a038488ab41c29473a1b71c30d11	\N
5f8874fe-8f17-9fae-6e20-3a1b71c6fe9b	\N	2025-07-31 16:29:54.717021	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	b4dba76f1656473609993a1b71c6fd23	\N
e7433edc-8b9c-6015-2941-3a1b71cb6e92	\N	2025-07-31 16:34:45.524066	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	4e53effa6f19051ca1063a1b71cb6d5a	\N
9e8d8652-7b09-fdd6-e1d9-3a1b71cc06a5	\N	2025-07-31 16:35:24.453573	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	3d0febf7104db0a0701c3a1b71cc0675	\N
ab284d41-c31c-d60d-ac55-3a1b71d3c51d	\N	2025-07-31 16:43:51.967143	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	6168841ab39c999a68c43a1b71d3c482	\N
34d7f226-cec7-e262-dd85-3a1b7703e513	\N	2025-08-01 16:54:31.957219	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	d66153ab0d4d3c11216f3a1b7703e240	\N
ccbb9da5-c8d2-2ca1-2135-3a1b7740ce98	\N	2025-08-01 18:01:03.897747	admin	::1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	登录成功	t	70f88ff3815ec42b9dd53a1b7740b8da	\N
\.


--
-- Data for Name: sys_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_menu (id, creator_id, creation_time, last_modification_time, last_modifier_id, title, icon, path, component, menu_type, permission, parent_id, sort, display, tenant_id, is_external) FROM stdin;
687ae0c2-ae7b-483c-004d-1d8d2615f26d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:03:14.804374	\N	\N	新增	\N	\N	\N	3	Sys.ScheduledTask.Add	687ae050-ae7b-483c-004d-1d8725963b8d	1	t	\N	f
687ae0d2-ae7b-483c-004d-1d8f2f556b78	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:03:30.478029	\N	\N	查询	\N	\N	\N	3	Sys.ScheduledTask.List	687ae050-ae7b-483c-004d-1d8725963b8d	1	t	\N	f
687ae0dd-ae7b-483c-004d-1d917c7673ab	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:03:41.928625	\N	\N	编辑	\N	\N	\N	3	Sys.ScheduledTask.Update	687ae050-ae7b-483c-004d-1d8725963b8d	3	t	\N	f
687ae0ed-ae7b-483c-004d-1d9321d51b3c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:03:57.712663	\N	\N	删除	\N	\N	\N	3	Sys.ScheduledTask.Delete	687ae050-ae7b-483c-004d-1d8725963b8d	4	t	\N	f
686a9a99-aad5-2c54-003c-a0410adc5b1a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-06 15:47:37.613583	\N	\N	绑定用户	\N	\N	\N	3	Org.Employee.BindUser	3a13be49-5f19-8ebd-5dda-1cf390060a09	5	f	\N	f
686a9add-aad5-2c54-003c-a0434dfa66e6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-06 15:48:45.260116	\N	\N	重置密码	\N	\N	\N	3	Sys.User.ResetPwd	3a132d16-df35-09cb-9f50-0a83e8290575	9	f	\N	f
3a135caa-6050-b8fa-ba75-6aaf548a7683	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:44:19.284	\N	\N	新增	\N	\N	\N	3	Sys.User.Add	3a132d16-df35-09cb-9f50-0a83e8290575	1	t	\N	f
3a135caa-b115-4de4-3be5-4b3cc477d8f4	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:44:39.958	\N	\N	查询	\N	\N	\N	3	Sys.User.List	3a132d16-df35-09cb-9f50-0a83e8290575	2	t	\N	f
3a135cab-3200-f6de-41f9-948404a81884	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:45:12.962	\N	\N	删除	\N	\N	\N	3	Sys.User.Delete	3a132d16-df35-09cb-9f50-0a83e8290575	3	t	\N	f
3a135cab-7acb-41cf-30c4-720eea400b2c	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:45:31.598	\N	\N	分配角色	\N	\N	\N	3	Sys.User.AssignRole	3a132d16-df35-09cb-9f50-0a83e8290575	4	t	\N	f
3a135cab-fcbb-1f19-8416-25c218db4279	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:46:04.86	\N	\N	启用/禁用	\N	\N	\N	3	Sys.User.SwitchEnabledStatus	3a132d16-df35-09cb-9f50-0a83e8290575	5	t	\N	f
3a135cb0-3753-ae33-82fd-603c3622f661	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:50:42.004	\N	\N	编辑	\N	\N	\N	3	Sys.Role.Update	3a132d1f-2026-432a-885f-bf6b10bec15c	3	t	\N	f
3a13bcfc-f11b-7dce-a264-0f34b21085f1	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 14:38:03.056	\N	\N	新增	\N	\N	\N	3	Org.PositionGroup.Add	3a13bcf2-3701-be8e-4ec8-ad5f77536101	1	t	\N	f
3a13bcfd-52bb-db4a-d508-eea8536c8bdc	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 14:38:28.028	\N	\N	查询	\N	\N	\N	3	Org.PositionGroup.List	3a13bcf2-3701-be8e-4ec8-ad5f77536101	2	t	\N	f
3a13bcfd-90b2-02ef-4440-8062594e3d79	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 14:38:43.893	\N	\N	编辑	\N	\N	\N	3	Org.PositionGroup.Update	3a13bcf2-3701-be8e-4ec8-ad5f77536101	3	t	\N	f
3a13bcfd-c549-8f84-1941-1d6baccfd6b4	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 14:38:57.355	\N	\N	删除	\N	\N	\N	3	Org.PositionGroup.Delete	3a13bcf2-3701-be8e-4ec8-ad5f77536101	4	t	\N	f
3a13bdb0-d210-fbaf-ce01-6d658b1b7ec9	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 17:54:31.569	\N	\N	新增	\N	\N	\N	3	Org.Position.Add	3a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361	1	t	\N	f
3a13bdb1-26a1-79e7-6920-b40e50de0bbe	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 17:54:53.219	\N	\N	查询	\N	\N	\N	3	Org.Position.List	3a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361	2	t	\N	f
3a13bdb1-742f-1ff2-87d1-b07a807c791f	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 17:55:13.072	\N	\N	编辑	\N	\N	\N	3	Org.Position.Update	3a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361	3	t	\N	f
3a13bdb2-213b-d9fa-d067-287801312ea1	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 17:55:57.373	\N	\N	删除	\N	\N	\N	3	Org.Position.Delete	3a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361	4	t	\N	f
3a13be19-204c-f634-f95f-ef8b7dcd9117	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 19:48:27.341	\N	\N	新增	\N	\N	\N	3	Org.Dept.Add	3a13be18-7fe2-2163-01ba-4a86ca6a7c40	1	t	\N	f
3a13be19-6b83-eaa2-0194-a9f17b786109	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 19:48:46.596	\N	\N	查询	\N	\N	\N	3	Org.Dept.List	3a13be18-7fe2-2163-01ba-4a86ca6a7c40	2	t	\N	f
3a13be19-a679-8375-aa20-5ab28ad85890	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 19:49:01.689	\N	\N	编辑	\N	\N	\N	3	Org.Dept.Update	3a13be18-7fe2-2163-01ba-4a86ca6a7c40	3	t	\N	f
3a13be19-d4fe-0a05-3dd1-25310c7bd52a	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 19:49:13.599	\N	\N	删除	\N	\N	\N	3	Org.Dept.Delete	3a13be18-7fe2-2163-01ba-4a86ca6a7c40	4	t	\N	f
3a13be4b-3b01-f611-e5da-8b3a3dc41cfc	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 20:43:10.979	\N	\N	新增	\N	\N	\N	3	Org.Employee.Add	3a13be49-5f19-8ebd-5dda-1cf390060a09	1	t	\N	f
3a13be4b-8355-c505-5dd3-15fbe89e2639	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 20:43:29.495	\N	\N	查询	\N	\N	\N	3	Org.Employee.List	3a13be49-5f19-8ebd-5dda-1cf390060a09	2	t	\N	f
3a13be4c-2e0e-af01-4432-a4892ff622ab	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 20:44:13.199	\N	\N	编辑	\N	\N	\N	3	Org.Employee.Update	3a13be49-5f19-8ebd-5dda-1cf390060a09	3	t	\N	f
3a13be4c-d335-53c6-15e1-b2a16d9f94e4	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 20:44:55.479	\N	\N	删除	\N	\N	\N	3	Org.Employee.Delete	3a13be49-5f19-8ebd-5dda-1cf390060a09	4	t	\N	f
3a1993c1-445d-b8d0-32e8-d0dfeff83a05	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 20:45:10.111	\N	\N	注销	\N	\N	\N	3	Monitor.Logout	3a174175-1893-a38e-c4a2-837cd49e79f6	1	t	\N	f
3a1993cc-dce1-53b9-c08b-9b77b244263a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 20:57:50.052	\N	\N	新增	\N	\N	\N	3	Sys.DictType.Add	3a198c3b-bf80-dce3-f433-f9f221339227	1	t	\N	f
3a1993ce-9de3-0234-d9b4-3c7012f7e361	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 20:59:45.015	\N	\N	查询	\N	\N	\N	3	Sys.DictType.List	3a198c3b-bf80-dce3-f433-f9f221339227	2	t	\N	f
3a1993cf-45ce-6733-402a-63161432073c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 21:00:27.984	\N	\N	编辑	\N	\N	\N	3	Sys.DictType.Update	3a198c3b-bf80-dce3-f433-f9f221339227	3	t	\N	f
3a1993d0-7b90-8d33-94c7-f9138a5711c0	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 21:01:47.281	\N	\N	删除	\N		\N	3	Sys.DictType.Delete	3a198c3b-bf80-dce3-f433-f9f221339227	4	t	\N	f
3a1993d0-db1b-1ff9-1ce2-85ca968e7e64	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 21:02:11.74	\N	\N	新增	\N	\N	\N	3	Sys.DictData.Add	3a198d86-8791-5c15-2dac-dada4eeda0fd	1	t	\N	f
3a1993d1-2120-d4d2-e8e9-51b29d3c5cd8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 21:02:29.665	\N	\N	查询	\N	\N	\N	3	Sys.DictData.List	3a198d86-8791-5c15-2dac-dada4eeda0fd	2	t	\N	f
3a1993d2-1130-66f0-ca47-f3d73f9fb857	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 21:03:31.122	\N	\N	编辑	\N	\N	\N	3	Sys.DictData.Update	3a198d86-8791-5c15-2dac-dada4eeda0fd	3	t	\N	f
3a1993d2-62aa-5257-9d47-0d2b1548f5f1	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-29 21:03:51.978	\N	\N	删除	\N	\N	\N	3	Sys.DictData.Delete	3a198d86-8791-5c15-2dac-dada4eeda0fd	1	t	\N	f
5c74b782-3231-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:50:42.004	\N	\N	编辑	\N	\N	\N	3	Sys.Menu.Update	3a132d1f-e2dd-7447-ac4b-2250201a9bad	3	t	\N	f
5c7548d7-3231-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:44:19.284	\N	\N	新增	\N	\N	\N	3	Sys.Menu.Add	3a132d1f-e2dd-7447-ac4b-2250201a9bad	1	t	\N	f
5c75c0d0-3231-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:44:39.958	\N	\N	查询	\N	\N	\N	3	Sys.Menu.List	3a132d1f-e2dd-7447-ac4b-2250201a9bad	2	t	\N	f
5c767046-3231-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:45:12.962	\N	\N	删除	\N	\N	\N	3	Sys.Menu.Delete	3a132d1f-e2dd-7447-ac4b-2250201a9bad	4	t	\N	f
87cd2f63-3230-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:44:19.284	\N	\N	新增	\N	\N	\N	3	Sys.Role.Add	3a132d1f-2026-432a-885f-bf6b10bec15c	1	t	\N	f
9a844856-3230-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:44:39.958	\N	\N	查询	\N	\N	\N	3	Sys.Role.List	3a132d1f-2026-432a-885f-bf6b10bec15c	2	t	\N	f
9a84d205-3230-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:45:12.962	\N	\N	删除	\N	\N	\N	3	Sys.Role.Delete	3a132d1f-2026-432a-885f-bf6b10bec15c	4	t	\N	f
9a8546e3-3230-11ef-afb3-0242ac110003	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-06-24 21:45:31.598	\N	\N	分配菜单	\N	\N	\N	3	Sys.Role.AssignMenu	3a132d1f-2026-432a-885f-bf6b10bec15c	5	t	\N	f
68758a82-b420-88a8-00fb-1d622c8e1591	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-14 22:53:54.688697	\N	\N	新增	\N	\N	\N	3	Sys.Config.Add	687586db-b420-88a8-00fb-1d3b07afeda3	1	f	\N	f
3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	3a132908-ca06-34de-164e-21c96505a036	2024-06-15 15:49:13.507	\N	\N	系统管理	antd:SettingOutlined	/admin	\N	1	System	\N	2	t	\N	f
3a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 17:52:45.803	2025-07-27 10:25:04.502539	3a172a37-55d5-ee9b-dc92-e07386eadc7c	职位管理	\N	/admin/positions	org/position	2		3a13a4fe-6f74-733b-a628-6125c0325481	2	t	\N	f
687586db-b420-88a8-00fb-1d3b07afeda3	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-14 22:38:19.75711	2025-07-14 22:39:21.580963	3a172a37-55d5-ee9b-dc92-e07386eadc7c	配置管理	\N	/admin/settings	system/config	2		3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	7	t	\N	f
3a132d1f-2026-432a-885f-bf6b10bec15c	3a132908-ca06-34de-164e-21c96505a036	2024-06-15 16:10:04.215	\N	\N	角色管理	\N	/admin/roles	system/role	2	Sys:Role	3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	2	t	\N	f
3a132d1f-e2dd-7447-ac4b-2250201a9bad	3a132908-ca06-34de-164e-21c96505a036	2024-06-15 16:10:54.046	\N	\N	菜单管理	\N	/admin/menus	system/menu	2	Sys:Menu	3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	3	t	\N	f
6865a9ef-4217-02ac-0070-b65a7ed7d760	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-02 21:51:43.566378	2025-07-02 21:51:55.291719	3a172a37-55d5-ee9b-dc92-e07386eadc7c	访问日志	\N	/admin/loggings/access	monitor/apiAccessLog	2		3a174174-857e-2328-55e6-395fcffb3774	3	t	\N	f
3a13be18-7fe2-2163-01ba-4a86ca6a7c40	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 19:47:46.294	\N	\N	部门管理	\N	/admin/departments	org/dept	2	Org:Department	3a13a4fe-6f74-733b-a628-6125c0325481	3	t	\N	f
3a13be49-5f19-8ebd-5dda-1cf390060a09	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 20:41:09.171	\N	\N	员工列表	\N	/admin/employees	org/employee	2	Org:Employee	3a13a4fe-6f74-733b-a628-6125c0325481	4	t	\N	f
6876ce60-0837-6d24-002e-b3b4478ba6ea	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:55:44.831206	2025-07-15 21:56:39.208649	3a172a37-55d5-ee9b-dc92-e07386eadc7c	在线文档	antd:ApiOutlined	https://docs.letu.run	#	2		\N	99	t	\N	t
3a13a4fe-6f74-733b-a628-6125c0325481	3a13a4f2-568e-41fe-55e7-210cc37b6d8a	2024-07-08 22:48:47.742	2025-07-27 10:24:54.13774	3a172a37-55d5-ee9b-dc92-e07386eadc7c	组织架构	antd:TeamOutlined	/admin	\N	1		\N	1	t	\N	f
68758a8f-b420-88a8-00fb-1d642276ff41	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-14 22:54:07.938236	\N	\N	查询	\N	\N	\N	3	Sys.Config.List	687586db-b420-88a8-00fb-1d3b07afeda3	2	f	\N	f
68758aa2-b420-88a8-00fb-1d6600787728	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-14 22:54:26.364848	\N	\N	编辑	\N	\N	\N	3	Sys.Config.Update	687586db-b420-88a8-00fb-1d3b07afeda3	3	f	\N	f
68758aae-b420-88a8-00fb-1d686cd73d1e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-14 22:54:38.605153	\N	\N	删除	\N	\N	\N	3	Sys.Config.Delete	687586db-b420-88a8-00fb-1d3b07afeda3	4	f	\N	f
6876c245-dc2a-f770-00a6-b1cd03755041	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:04:05.703868	\N	\N	新增	\N	\N	\N	3	Sys.Tenant.Add	6876c1a4-dc2a-f770-00a6-b1c17ef49fc6	1	t	\N	f
6876c253-dc2a-f770-00a6-b1cf12c074ff	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:04:19.12469	\N	\N	查询	\N	\N	\N	3	Sys.Tenant.List	6876c1a4-dc2a-f770-00a6-b1c17ef49fc6	2	t	\N	f
6876c260-dc2a-f770-00a6-b1d11da64c80	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:04:32.976932	\N	\N	编辑	\N	\N	\N	3	Sys.Tenant.Update	6876c1a4-dc2a-f770-00a6-b1c17ef49fc6	3	t	\N	f
6876c273-dc2a-f770-00a6-b1d369d976ad	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:04:51.458147	\N	\N	删除	\N	\N	\N	3	Sys.Tenant.Delete	6876c1a4-dc2a-f770-00a6-b1c17ef49fc6	4	t	\N	f
687ab06d-3dcd-6a08-0078-e59345ff0ab1	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-18 20:37:01.851781	\N	\N	新增	\N	\N	\N	3	Sys.Notification.Add	687aafb1-3dcd-6a08-0078-e5870e6a3c24	1	t	\N	f
687ab07a-3dcd-6a08-0078-e59543d0479e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-18 20:37:14.766532	\N	\N	查询	\N	\N	\N	3	Sys.Notification.List	687aafb1-3dcd-6a08-0078-e5870e6a3c24	2	t	\N	f
687ab088-3dcd-6a08-0078-e5976d5d9585	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-18 20:37:28.704311	\N	\N	编辑	\N	\N	\N	3	Sys.Notification.Update	687aafb1-3dcd-6a08-0078-e5870e6a3c24	3	t	\N	f
687ab094-3dcd-6a08-0078-e599634196cf	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-18 20:37:40.555994	\N	\N	删除	\N	\N	\N	3	Sys.Notification.Delete	687aafb1-3dcd-6a08-0078-e5870e6a3c24	4	t	\N	f
687ae0fd-ae7b-483c-004d-1d956a9d485b	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:04:13.762756	\N	\N	执行日志	\N	\N	\N	3	Sys.ScheduledTask.Log	687ae050-ae7b-483c-004d-1d8725963b8d	5	t	\N	f
687ae050-ae7b-483c-004d-1d8725963b8d	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:01:20.451501	\N	\N	定时任务	\N	/admin/scheduled-tasks	system/scheduledTask	2		3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	10	t	\N	f
687aafb1-3dcd-6a08-0078-e5870e6a3c24	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-18 20:33:53.818229	2025-07-18 20:34:27.183337	3a172a37-55d5-ee9b-dc92-e07386eadc7c	通知管理		/admin/notifications	org/notification	2		3a13a4fe-6f74-733b-a628-6125c0325481	5	t	\N	f
3a198c3b-bf80-dce3-f433-f9f221339227	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-28 09:41:59.313	\N	\N	数据字典	\N	/admin/data-dictionaries	system/dictType	2	Sys:Dict	3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	4	t	\N	f
3a198d86-8791-5c15-2dac-dada4eeda0fd	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-04-28 15:43:17.394	\N	\N	字典项	\N	/admin/data-dictionaries/:dictType	system/dictData	2	Sys:DictData	3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	5	f	\N	f
3a132d16-df35-09cb-9f50-0a83e8290575	3a132908-ca06-34de-164e-21c96505a036	2024-06-15 16:01:03.301	2025-06-27 22:33:01.930601	3a172a37-55d5-ee9b-dc92-e07386eadc7c	用户管理		/admin/users	system/user	2		3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	1	t	\N	f
6865aa1d-4217-02ac-0070-b65d05235757	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-02 21:52:29.472722	2025-07-02 21:52:44.816966	3a172a37-55d5-ee9b-dc92-e07386eadc7c	异常日志	\N	/admin/loggings/exception	monitor/exceptionLog	2		3a174174-857e-2328-55e6-395fcffb3774	2	t	\N	f
3a174175-1893-a38e-c4a2-837cd49e79f6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-01-04 11:07:31.86	2025-07-10 22:34:55.638327	3a172a37-55d5-ee9b-dc92-e07386eadc7c	在线用户	\N	/admin/online-users	monitor/onlineUser	2		3a174174-857e-2328-55e6-395fcffb3774	1	t	\N	f
3a174174-857e-2328-55e6-395fcffb3774	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-01-04 11:06:54.207	2025-07-10 22:39:51.771442	3a172a37-55d5-ee9b-dc92-e07386eadc7c	系统监控	antd:FundOutlined	/admin	\N	1		\N	3	t	\N	f
6876c1a4-dc2a-f770-00a6-b1c17ef49fc6	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:01:24.861586	2025-07-15 21:02:56.464483	3a172a37-55d5-ee9b-dc92-e07386eadc7c	租户管理	\N	/admin/tenants	system/tenant	2		3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	8	t	\N	f
687ab0d2-3dcd-6a08-0078-e59f6c975e7a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-18 20:38:42.951706	\N	\N	我的通知	\N	/my/notifications	org/myNotification	2		3a13a4fe-6f74-733b-a628-6125c0325481	6	t	\N	f
3a138b12-93b5-e723-1539-adaeb17a2ae1	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-07-03 22:00:40.118	2025-07-02 21:53:12.229777	3a172a37-55d5-ee9b-dc92-e07386eadc7c	登录日志	\N	/admin/loggings/security	system/log/loginLog	2		3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	10	t	\N	f
3a138b13-fccd-7b4a-0bb5-435a9d9c4172	3a1356b8-6f63-a393-1f8d-4ab9dc4914f4	2024-07-03 22:02:12.559	2025-07-02 21:53:32.960656	3a172a37-55d5-ee9b-dc92-e07386eadc7c	业务日志	\N	/admin/loggings/business	system/log/businessLog	2		3a132d0c-0a70-b4c5-1ffd-1088c23ae02a	11	t	\N	f
3a13bcf2-3701-be8e-4ec8-ad5f77536101	3a13bc48-e3c9-4c0b-0cc4-b6fc4e606741	2024-07-13 14:26:20.046	2025-07-11 00:27:56.260876	3a172a37-55d5-ee9b-dc92-e07386eadc7c	职位分组		/admin/positions/groups	org/positionGroup	2		3a13a4fe-6f74-733b-a628-6125c0325481	1	t	\N	f
bcbc1c5e-c0b2-3305-7fff-3a1b6cf53342	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 18:02:16.770487	2025-07-31 14:29:26.692603	3a172a37-55d5-ee9b-dc92-e07386eadc7c	审计日志	\N	/admin/loggings/auditlog/request	log	2	\N	3a174174-857e-2328-55e6-395fcffb3774	0	t	\N	f
\.


--
-- Data for Name: sys_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_notification (id, creator_id, creation_time, last_modification_time, last_modifier_id, title, content, employee_id, is_readed, readed_time, tenant_id) FROM stdin;
68848ae9-4b6b-160c-0042-19be265da2d8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-26 07:59:37.200947	\N	\N	test	test	6869907c-9c93-beac-0062-34172a640e0e	t	2025-07-26 08:04:11.829145	\N
68890f9b-21b2-19c0-00d4-131c34ce8dfa	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-29 18:14:51.423326	\N	\N	test	\N	6869907c-9c93-beac-0062-34172a640e0e	f	0001-01-01 00:00:00	\N
\.


--
-- Data for Name: sys_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_role (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, role_name, remark, power_data_type, tenant_id, is_enabled) FROM stdin;
685ed8f3-7da6-d870-0090-fdd663a31f65	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-27 17:46:27.287301	\N	\N	t	\N	\N	test	test	0	\N	f
3a172369-28a4-e37e-b78a-8c3eaec17359	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2024-12-29 15:05:53.128	\N	\N	f	\N	\N	系统管理员	系统默认创建，拥有最高权限	0	\N	t
687047ef-1649-9660-0098-4182062f682c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-10 23:08:31.94067	2025-07-11 00:22:34.876888	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	测试	测试菜单权限	0	\N	t
\.


--
-- Data for Name: sys_role_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_role_menu (id, menu_id, role_id, tenant_id) FROM stdin;
688911d5-9894-256c-00d8-1ce708ae140d	3a13a4fe-6f74-733b-a628-6125c0325481	687047ef-1649-9660-0098-4182062f682c	\N
688911d5-9894-256c-00d8-1ce843b0927a	3a13bcf2-3701-be8e-4ec8-ad5f77536101	687047ef-1649-9660-0098-4182062f682c	\N
688911d5-9894-256c-00d8-1ce92df72255	3a13bcfd-52bb-db4a-d508-eea8536c8bdc	687047ef-1649-9660-0098-4182062f682c	\N
688911d5-9894-256c-00d8-1cea255e6073	3a174174-857e-2328-55e6-395fcffb3774	687047ef-1649-9660-0098-4182062f682c	\N
\.


--
-- Data for Name: sys_tenant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_tenant (id, creator_id, creation_time, last_modification_time, last_modifier_id, name, remark, domain) FROM stdin;
6876c329-dc2a-f770-00a6-b1e306495609	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:07:53.183795	2025-07-15 21:12:18.009625	3a172a37-55d5-ee9b-dc92-e07386eadc7c	重庆小卖部	\N	cq.market.crackerwork.cn
6876c45d-e5f2-35dc-00d1-48ee38eafd16	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:13:01.684058	2025-07-27 16:44:16.679914	3a172a37-55d5-ee9b-dc92-e07386eadc7c	湖南小卖部	\N	hn.market.crackerwork.cn
6889f9fc-c58e-60d8-0066-5ecc5acf27d0	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:54:52.868869	2025-07-30 10:57:11.522285	3a172a37-55d5-ee9b-dc92-e07386eadc7c	test	\N	\N
6889fc74-5050-4dc8-0093-d02d618ab933	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:05:24.328579	2025-07-30 11:10:39.756418	3a172a37-55d5-ee9b-dc92-e07386eadc7c	test11	\N	\N
688a019f-2e5c-a0f8-0014-50cd16894d01	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:27:27.141437	\N	\N	test111	\N	\N
688a023b-2e5c-a0f8-0014-50d6450e48fc	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 11:30:03.505863	2025-07-30 14:12:38.489644	3a172a37-55d5-ee9b-dc92-e07386eadc7c	阿萨	\N	\N
\.


--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, user_name, password, password_salt, avatar, nick_name, sex, is_enabled, tenant_id, phone) FROM stdin;
3e64db48-e302-46f7-87d8-dc3f8c4bd428	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-10 22:43:38.917621	2025-07-10 22:46:16.649351	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	tom	7ff497634388c0517d3b1c973efd9b98	V12NcTVTF84SFyIJ2pNEuw==	avatar/male.png	tom	1	t	\N	
3a172a37-55d5-ee9b-dc92-e07386eadc7c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2024-12-30 22:48:48.458	2025-06-17 19:05:09.599	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	admin	a2fa8ec90f15197c7a4e6e00525b198a	vHQZvbz+ng+B4NrSAEYl6g==	avatar/male.png	风汐	1	t	\N	
00de38c4-17bd-415f-bf1c-2e0873eb177e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-10 22:44:04.531912	2025-07-29 18:15:43.274592	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	coco	c073383f5e407b2c73495acc4e6385c8	IF4Zxy95/DEAbJIZ/NXt5g==	avatar/female.png	珂珂	2	t	\N	
6889f85b-d022-c7cc-0034-4d317230ec82	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-30 10:47:55.367404	\N	\N	f	\N	\N	admin1	f860c63e0122c1b6acb8950baa2e0416	sf3pZ7Y5+j+jWF86fnybAg==	avatar/female.png	222	2	t	\N	\N
\.


--
-- Data for Name: sys_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user_role (id, user_id, role_id, tenant_id) FROM stdin;
685f2a6f-5e26-60bc-00f7-9ead1bc87fd4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	3a172369-28a4-e37e-b78a-8c3eaec17359	\N
68705965-5ecb-c374-0046-1a565d226a73	00de38c4-17bd-415f-bf1c-2e0873eb177e	687047ef-1649-9660-0098-4182062f682c	\N
683cc8f7-ba08-3990-009e-23375861fdc5	683cc901-ba08-3990-009e-23392649a8a4	683cc8d0-ba08-3990-009e-233317cce095	\N
688911b7-9894-256c-00d8-1cd04f03f62f	3e64db48-e302-46f7-87d8-dc3f8c4bd428	687047ef-1649-9660-0098-4182062f682c	\N
688911cc-9894-256c-00d8-1cdc60749bf5	89d5a892-4153-459b-89cb-b5fa7ccfabc2	3a172369-28a4-e37e-b78a-8c3eaec17359	\N
\.


--
-- Data for Name: task_execution_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_execution_logs (id, creator_id, creation_time, task_key, status, result, node_id, execution_time, cost) FROM stdin;
6887694c-044c-9374-00c1-a7a92bccfbb7	00000000-0000-0000-0000-000000000000	2025-07-28 12:13:00.227683	NotificationJob	1	成功	\N	2025-07-28 12:13:00.03548	163
68876988-044c-9374-00c1-a7aa2ce57044	00000000-0000-0000-0000-000000000000	2025-07-28 12:14:00.024689	NotificationJob	1	成功	\N	2025-07-28 12:14:00.007342	17
688769c4-044c-9374-00c1-a7ab01097490	00000000-0000-0000-0000-000000000000	2025-07-28 12:15:00.029552	NotificationJob	1	成功	\N	2025-07-28 12:15:00.017347	12
\.


--
-- Name: published published_pkey; Type: CONSTRAINT; Schema: cap; Owner: postgres
--

ALTER TABLE ONLY cap.published
    ADD CONSTRAINT published_pkey PRIMARY KEY ("Id");


--
-- Name: received received_pkey; Type: CONSTRAINT; Schema: cap; Owner: postgres
--

ALTER TABLE ONLY cap.received
    ADD CONSTRAINT received_pkey PRIMARY KEY ("Id");


--
-- Name: api_access_log public_api_access_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_access_log
    ADD CONSTRAINT public_api_access_log_pkey PRIMARY KEY (id);


--
-- Name: audit_log public_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT public_audit_log_pkey PRIMARY KEY (id);


--
-- Name: entity_change public_entity_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_change
    ADD CONSTRAINT public_entity_change_pkey PRIMARY KEY (id);


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
-- Name: sys_dict_data public_sys_dict_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_dict_data
    ADD CONSTRAINT public_sys_dict_data_pkey PRIMARY KEY (id);


--
-- Name: sys_dict_type public_sys_dict_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_dict_type
    ADD CONSTRAINT public_sys_dict_type_pkey PRIMARY KEY (id);


--
-- Name: sys_entity_changes public_sys_entity_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_entity_changes
    ADD CONSTRAINT public_sys_entity_changes_pkey PRIMARY KEY (id);


--
-- Name: sys_login_log public_sys_login_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_login_log
    ADD CONSTRAINT public_sys_login_log_pkey PRIMARY KEY (id);


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
-- Name: sys_tenant public_sys_tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_tenant
    ADD CONSTRAINT public_sys_tenant_pkey PRIMARY KEY (id);


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
-- Name: idx_published_ExpiresAt_StatusName; Type: INDEX; Schema: cap; Owner: postgres
--

CREATE INDEX "idx_published_ExpiresAt_StatusName" ON cap.published USING btree ("ExpiresAt", "StatusName");


--
-- Name: idx_published_Version_ExpiresAt_StatusName; Type: INDEX; Schema: cap; Owner: postgres
--

CREATE INDEX "idx_published_Version_ExpiresAt_StatusName" ON cap.published USING btree ("Version", "ExpiresAt", "StatusName");


--
-- Name: idx_received_ExpiresAt_StatusName; Type: INDEX; Schema: cap; Owner: postgres
--

CREATE INDEX "idx_received_ExpiresAt_StatusName" ON cap.received USING btree ("ExpiresAt", "StatusName");


--
-- Name: idx_received_Version_ExpiresAt_StatusName; Type: INDEX; Schema: cap; Owner: postgres
--

CREATE INDEX "idx_received_Version_ExpiresAt_StatusName" ON cap.received USING btree ("Version", "ExpiresAt", "StatusName");


--
-- Name: idx_execution_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_execution_time ON public.task_execution_logs USING btree (execution_time);


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

