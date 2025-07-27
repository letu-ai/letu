--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0 (Debian 14.0-1.pgdg110+1)
-- Dumped by pg_dump version 14.0 (Debian 14.0-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    path text,
    method character varying(16),
    ip character varying(32),
    request_time timestamp(6) without time zone NOT NULL,
    response_time timestamp(6) without time zone,
    duration bigint,
    user_id uuid,
    user_name character varying(32),
    request_body text,
    response_body text,
    browser character varying(512),
    query_string text,
    trace_id character varying(64),
    operate_type integer[],
    operate_name character varying(64),
    tenant_id character varying(18)
);


ALTER TABLE public.api_access_log OWNER TO postgres;

--
-- Name: exception_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exception_log (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    exception_type character varying(64),
    message text,
    stack_trace text,
    inner_exception text,
    request_path text,
    request_method character varying(16),
    user_id uuid,
    user_name character varying(16),
    ip character varying(32),
    browser character varying(512),
    trace_id character varying(64),
    is_handled boolean NOT NULL,
    handled_time timestamp(6) without time zone,
    handled_by character varying(255),
    tenant_id character varying(18)
);


ALTER TABLE public.exception_log OWNER TO postgres;

--
-- Name: log_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_record (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    type character varying(64) NOT NULL,
    sub_type character varying(512) NOT NULL,
    biz_no character varying(64) NOT NULL,
    content text NOT NULL,
    browser character varying(512),
    ip character varying(32),
    trace_id character varying(64),
    tenant_id character varying(18),
    user_id uuid,
    user_name character varying(32)
);


ALTER TABLE public.log_record OWNER TO postgres;

--
-- Name: org_employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_employee (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
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
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
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
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    group_name character varying(64) NOT NULL,
    remark character varying(512),
    parent_id uuid,
    parent_ids character varying(1024),
    sort integer NOT NULL,
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
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
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
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
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    value character varying(256) NOT NULL,
    label character varying(128) NOT NULL,
    dict_type character varying(128) NOT NULL,
    remark character varying(512),
    sort integer NOT NULL,
    is_enabled boolean NOT NULL,
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    name character varying(128) NOT NULL,
    dict_type character varying(128) NOT NULL,
    remark character varying(512),
    is_enabled boolean NOT NULL,
    tenant_id character varying(18)
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
-- Name: sys_login_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_login_log (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    user_name character varying(32) NOT NULL,
    ip character varying(32),
    address character varying(256),
    os character varying(64),
    browser character varying(512),
    operation_msg character varying(128),
    is_success boolean NOT NULL,
    session_id character varying(36),
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    title character varying(32) NOT NULL,
    icon character varying(64),
    path character varying(256),
    component character varying(256),
    menu_type integer NOT NULL,
    permission character varying(128) NOT NULL,
    parent_id uuid,
    sort integer NOT NULL,
    display boolean NOT NULL,
    tenant_id character varying(18),
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    title character varying(128) NOT NULL,
    content character varying(512),
    employee_id uuid NOT NULL,
    is_readed boolean NOT NULL,
    readed_time timestamp(6) without time zone NOT NULL,
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    is_deleted boolean NOT NULL,
    deleter_id uuid,
    deletion_time timestamp(6) without time zone,
    role_name character varying(64) NOT NULL,
    remark character varying(512),
    power_data_type integer NOT NULL,
    tenant_id character varying(18),
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
    tenant_id character varying(18)
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
    creator_id uuid NOT NULL,
    creation_time timestamp(6) without time zone NOT NULL,
    last_modification_time timestamp(6) without time zone,
    last_modifier_id uuid,
    name character varying(64) NOT NULL,
    tenant_id character varying(18) NOT NULL,
    remark character varying(512),
    domain character varying(256)
);


ALTER TABLE public.sys_tenant OWNER TO postgres;

--
-- Name: COLUMN sys_tenant.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.name IS '租户名称';


--
-- Name: COLUMN sys_tenant.tenant_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_tenant.tenant_id IS '租户标识';


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
    creator_id uuid NOT NULL,
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
    tenant_id character varying(18),
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
    tenant_id character varying(18)
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
3595776088887042141	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042141","cap-corr-id":"3595776088887042141","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:09"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T11:10:09.2716398+08:00","ResponseTime":"2025-07-27T11:10:09.3196422+08:00","Duration":48,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00226865a9ef-4217-02ac-0070-b65a7ed7d760\\u0022,\\u0022Title\\u0022:\\u0022\\u8BBF\\u95EE\\u65E5\\u5FD7\\u0022,\\u0022Icon\\u0022:null,\\u0022Path\\u0022:\\u0022/admin/loggings/access\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a174174-857e-2328-55e6-395fcffb3774\\u0022,\\u0022Sort\\u0022:3,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022monitor/apiAccessLog\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"b36a2569f564a373ac5b39e70130a9b4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:09.320038	2025-07-28 11:10:09.33191	Succeeded
3595776088887042142	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042142","cap-corr-id":"3595776088887042142","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:09"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:10:09.3753848+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"f341f4c3698af096fdfe7dceba7ce482","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:09.375588	2025-07-28 11:10:09.387429	Succeeded
3595776189596008470	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008470","cap-corr-id":"3595776189596008470","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.8248107+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"abc990ab158cca08fbf3cdc0f710984a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:43.82497	2025-07-28 16:46:43.831641	Succeeded
3595776189596008475	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008475","cap-corr-id":"3595776189596008475","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:52:48"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c","Method":"PUT","RequestTime":"2025-07-27T16:52:48.2020119+08:00","ResponseTime":"2025-07-27T16:52:48.231875+08:00","Duration":30,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022RoleName\\u0022:\\u0022\\u6D4B\\u8BD5\\u0022,\\u0022Remark\\u0022:\\u0022\\u6D4B\\u8BD5\\u83DC\\u5355\\u6743\\u9650\\u0022,\\u0022IsEnabled\\u0022:true}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u89D2\\u8272","TraceId":"3bbbf64cf7e715cbddd616be411e0891","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:52:48.232058	2025-07-28 16:52:48.242309	Succeeded
3595776189596008478	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008478","cap-corr-id":"3595776189596008478","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.782176+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0f967483acb706f1afd3f68dd545f944","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.782312	2025-07-28 16:53:47.78881	Succeeded
3595776088887042145	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042145","cap-corr-id":"3595776088887042145","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 11:10:15"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469860605226389504","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 11:10:15.460448	2025-07-28 11:10:15.472259	Succeeded
3595775912360861697	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595775912360861697","cap-corr-id":"3595775912360861697","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/26/2025 22:08:37"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469663896177217536","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-26 22:08:37.6134	2025-07-27 22:08:37.738065	Succeeded
3595776082527358977	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776082527358977","cap-corr-id":"3595776082527358977","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 08:35:05"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469821557061455872","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 08:35:06.012575	2025-07-28 08:35:06.110308	Succeeded
3595776088887042049	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042049","cap-corr-id":"3595776088887042049","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 09:37:03"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469837151425007616","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 09:37:03.670622	2025-07-28 09:37:03.699584	Succeeded
3595776088887042051	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042051","cap-corr-id":"3595776088887042051","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 10:08:28"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469845056844992512","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 10:08:28.370669	2025-07-28 10:08:28.379635	Succeeded
3595776088887042053	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042053","cap-corr-id":"3595776088887042053","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:08:35"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:08:35.4213489+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"bddd716271a1aefe2b605a40ff0248e3","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:08:35.50269	2025-07-28 10:08:35.510478	Succeeded
3595776088887042054	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042054","cap-corr-id":"3595776088887042054","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:08:35"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:08:35.5481921+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"2a7ff47ef0a166bc323de478768e149c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:08:35.548398	2025-07-28 10:08:35.554414	Succeeded
3595776088887042057	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042057","cap-corr-id":"3595776088887042057","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:00"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:10:00.8758922+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"8f2134839509239d15d4567a7cc79c7a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:00.876243	2025-07-28 10:10:00.885316	Succeeded
3595776088887042058	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042058","cap-corr-id":"3595776088887042058","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:00"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:10:00.9061482+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"55218186137516529150976ba6a90b0c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:00.906314	2025-07-28 10:10:00.917114	Succeeded
3595776088887042147	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042147","cap-corr-id":"3595776088887042147","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:26"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:10:26.8954576+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"1cf8bbc3d389c6880f5b4893a33edee7","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:26.895573	2025-07-28 11:10:26.904095	Succeeded
3595776088887042061	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042061","cap-corr-id":"3595776088887042061","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:04"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:10:04.0785965+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"54103b98cf64d9c1c4d5df3f3a806b17","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:04.08018	2025-07-28 10:10:04.088063	Succeeded
3595776088887042062	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042062","cap-corr-id":"3595776088887042062","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:04"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:10:04.1364894+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"2320b2e4776e986f904bf97c3020e3db","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:04.136625	2025-07-28 10:10:04.144822	Succeeded
3595776088887042148	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042148","cap-corr-id":"3595776088887042148","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:26"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:10:26.9417628+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"50b5c931cea0da483edd6a3da296b13f","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:26.941897	2025-07-28 11:10:26.949325	Succeeded
3595776088887042065	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042065","cap-corr-id":"3595776088887042065","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:46"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:46.0966819+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"9138761fc1131d59b3538cbe7ced6a45","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:46.09761	2025-07-28 10:10:46.105514	Succeeded
3595776088887042066	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042066","cap-corr-id":"3595776088887042066","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:46"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:46.1538317+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"321ff740e0a155165b9d3ccb4f400f5b","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:46.153958	2025-07-28 10:10:46.161908	Succeeded
3595776088887042151	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042151","cap-corr-id":"3595776088887042151","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:34"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:10:34.5089521+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"274cfb47d8b698e9ae464a5447921416","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:34.509149	2025-07-28 11:10:34.518834	Succeeded
3595776088887042069	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042069","cap-corr-id":"3595776088887042069","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:58"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:58.4708793+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"de080b1a5c0c26d095b6cf521a90b374","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:58.471047	2025-07-28 10:10:58.478681	Succeeded
3595776088887042070	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042070","cap-corr-id":"3595776088887042070","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:58"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:58.5405964+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"267786f48a29a5527d2ca81efb89db2b","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:58.540765	2025-07-28 10:10:58.547583	Succeeded
3595776088887042152	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042152","cap-corr-id":"3595776088887042152","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:34"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:10:34.5434877+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"346128b4d1ac8bb6bac2b47001c32b15","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:34.543612	2025-07-28 11:10:34.5513	Succeeded
3595776088887042073	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042073","cap-corr-id":"3595776088887042073","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:11:18"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:11:18.6523018+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"e8d9d56355f8757db6f8cd2827b12b2e","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:11:18.652662	2025-07-28 10:11:18.662665	Succeeded
3595776088887042074	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042074","cap-corr-id":"3595776088887042074","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:11:18"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:11:18.6849172+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"e1a73a24caed36e2cabb4ad27f1d1148","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:11:18.685034	2025-07-28 10:11:18.69283	Succeeded
3595776088887042155	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042155","cap-corr-id":"3595776088887042155","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:37"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T11:10:37.0093004+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"d3cd54986710c5ea6fd9fb83b2ccba95","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:37.009401	2025-07-28 11:10:37.017578	Succeeded
3595776088887042077	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042077","cap-corr-id":"3595776088887042077","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:18:07"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:18:07.0627882+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"49eabbc9c7e04ea782fe9c80c31a91b2","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:18:07.062979	2025-07-28 10:18:07.071428	Succeeded
3595776088887042079	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042079","cap-corr-id":"3595776088887042079","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:47"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:24:47.1266433+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"848fcde8a87e1d039394deed87fa8008","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:47.126886	2025-07-28 10:24:47.141086	Succeeded
3595776088887042156	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042156","cap-corr-id":"3595776088887042156","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:37"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T11:10:37.0440897+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"35bcfdc4987c51369da4154f0f55b10e","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:37.044197	2025-07-28 11:10:37.051396	Succeeded
3595776088887042080	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042080","cap-corr-id":"3595776088887042080","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:47"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:24:47.1678227+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"728502a759b02ac422919ffe4a1db6d8","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:47.168205	2025-07-28 10:24:47.177432	Succeeded
3595776189596008477	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008477","cap-corr-id":"3595776189596008477","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.7520157+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"cc6f0b646c3dad1af01d0c7d524a21a0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.752264	2025-07-28 16:53:47.760581	Succeeded
3595776088887042083	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042083","cap-corr-id":"3595776088887042083","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:54"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:24:54.0499257+08:00","ResponseTime":"2025-07-27T10:24:54.2253005+08:00","Duration":175,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Title\\u0022:\\u0022\\u7EC4\\u7EC7\\u67B6\\u6784\\u0022,\\u0022Icon\\u0022:\\u0022antd:TeamOutlined\\u0022,\\u0022Path\\u0022:\\u0022/admin\\u0022,\\u0022MenuType\\u0022:1,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:null,\\u0022Sort\\u0022:1,\\u0022Display\\u0022:true,\\u0022Component\\u0022:null,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"ebde6ea815ea6cad2306e701e697d709","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:54.245107	2025-07-28 10:24:54.257063	Succeeded
3595776189596008449	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008449","cap-corr-id":"3595776189596008449","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 15:44:59"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469929745626697728","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 15:45:00.03028	2025-07-28 15:45:00.078272	Succeeded
3595776088887042084	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042084","cap-corr-id":"3595776088887042084","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:54"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:24:54.2739311+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"7b9300fb350788a6a26848819fe34b61","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:54.274089	2025-07-28 10:24:54.283351	Succeeded
3595776088887042088	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042088","cap-corr-id":"3595776088887042088","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:25:04"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:25:04.5480614+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d9496ce2500032d29d4d4822ff89d734","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:25:04.548343	2025-07-28 10:25:04.556024	Succeeded
3595776088887042096	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042096","cap-corr-id":"3595776088887042096","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:52:46"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:52:46.408736+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"8716d68a8ea9d482609648ea9bd2d55e","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:52:46.408848	2025-07-28 10:52:46.415728	Succeeded
3595776088887042110	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042110","cap-corr-id":"3595776088887042110","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:10"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:10.6429934+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"682d9e94bf8fc65b095156837e8d94f7","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:10.643156	2025-07-28 10:54:10.650274	Succeeded
3595776088887042113	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042113","cap-corr-id":"3595776088887042113","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:32"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:32.9945034+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"2ea994cfd806f4d0eea19d9919230cb8","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:32.994607	2025-07-28 10:54:33.005145	Succeeded
3595776088887042087	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042087","cap-corr-id":"3595776088887042087","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:25:04"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:25:04.46234+08:00","ResponseTime":"2025-07-27T10:25:04.5131219+08:00","Duration":51,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361\\u0022,\\u0022Title\\u0022:\\u0022\\u804C\\u4F4D\\u7BA1\\u7406\\u0022,\\u0022Icon\\u0022:null,\\u0022Path\\u0022:\\u0022/admin/positions\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Sort\\u0022:2,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022org/position\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"7239431f0e1943ad53d7e7b4340eed02","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:25:04.51346	2025-07-28 10:25:04.524666	Succeeded
3595776088887042091	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042091","cap-corr-id":"3595776088887042091","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 10:25:15"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469849279926112256","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 10:25:15.267854	2025-07-28 10:25:15.282762	Succeeded
3595776189596008451	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008451","cap-corr-id":"3595776189596008451","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 16:37:15"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469942895910588416","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 16:37:15.012636	2025-07-28 16:37:15.029087	Succeeded
3595776088887042093	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042093","cap-corr-id":"3595776088887042093","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:46:05"},"Value":{"Path":"/api/admin/employees/68860360-adfa-4e0c-0012-a7760a0242a1","Method":"DELETE","RequestTime":"2025-07-27T10:46:05.4622646+08:00","ResponseTime":"2025-07-27T10:46:05.4991563+08:00","Duration":37,"RequestBody":"{\\u0022id\\u0022:\\u002268860360-adfa-4e0c-0012-a7760a0242a1\\u0022}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[4],"OperateName":"\\u5220\\u9664\\u5458\\u5DE5","TraceId":"5ad066caa80d686b080c8d29b60fbc82","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:46:05.502114	2025-07-28 10:46:05.51081	Succeeded
3595776088887042095	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042095","cap-corr-id":"3595776088887042095","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:52:46"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:52:46.3736904+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"82bbdc666ca8a5f063f9e05edf4498af","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:52:46.373861	2025-07-28 10:52:46.38301	Succeeded
3595776088887042100	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042100","cap-corr-id":"3595776088887042100","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:11"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:53:11.8519507+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d954bef62ce033e8f6395430323cf0e0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:11.852056	2025-07-28 10:53:11.860365	Succeeded
3595776088887042099	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042099","cap-corr-id":"3595776088887042099","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:11"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:53:11.7883932+08:00","ResponseTime":"2025-07-27T10:53:11.8249086+08:00","Duration":37,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u0022Title\\u0022:\\u0022\\u804C\\u4F4D\\u5206\\u7EC4\\u0022,\\u0022Icon\\u0022:\\u0022\\u0022,\\u0022Path\\u0022:\\u0022/admin/position/groups\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Sort\\u0022:1,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022org/positionGroup\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"6c496a0868f18e11bdddbe1d9dc8d6c5","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:11.825095	2025-07-28 10:53:11.832994	Succeeded
3595776088887042103	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042103","cap-corr-id":"3595776088887042103","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:19"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:53:19.3590386+08:00","ResponseTime":"2025-07-27T10:53:19.3959465+08:00","Duration":37,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u0022Title\\u0022:\\u0022\\u804C\\u4F4D\\u5206\\u7EC4\\u0022,\\u0022Icon\\u0022:\\u0022\\u0022,\\u0022Path\\u0022:\\u0022/admin/positions/groups\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Sort\\u0022:1,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022org/positionGroup\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"d7646796e543d2c2c889f4abcb231efd","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:19.396183	2025-07-28 10:53:19.40511	Succeeded
3595776189596008453	v1	log_record_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008453","cap-corr-id":"3595776189596008453","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:42:24"},"Value":{"Type":"\\u5B57\\u5178\\u6570\\u636E","SubType":"\\u7F16\\u8F91\\u5B57\\u5178\\u6570\\u636E","BizNo":"68602622-e22b-e780-00f8-5c9d688361b4","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u503C=1,\\u542F\\u7528=True","TraceId":"9a950cae333377316b799fb0ddd70449","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:42:24.2061492+08:00"}}	0	2025-07-27 16:42:24.220161	2025-07-28 16:42:24.25056	Succeeded
3595776088887042104	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042104","cap-corr-id":"3595776088887042104","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:19"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:53:19.4217341+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"cdbe799b98321bb6d19c5ce6e09510e4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:19.421846	2025-07-28 10:53:19.428466	Succeeded
3595776088887042107	v1	login_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042107","cap-corr-id":"3595776088887042107","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 10:53:30"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469856390101864448","TenantId":null,"CreatorId":null,"CreationTime":"0001-01-01T00:00:00","Id":"00000000-0000-0000-0000-000000000000"}}	0	2025-07-27 10:53:30.404223	2025-07-28 10:53:30.409999	Succeeded
3595776088887042109	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042109","cap-corr-id":"3595776088887042109","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:10"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:10.6124313+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"fc1bd434180f50ca249ae907097d910a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:10.612626	2025-07-28 10:54:10.620484	Succeeded
3595776088887042114	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042114","cap-corr-id":"3595776088887042114","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:33"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:33.027186+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"fba10d742e5e7355ec4d1edf5404ce7a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:33.027281	2025-07-28 10:54:33.034476	Succeeded
3595776189596008455	v1	log_record_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008455","cap-corr-id":"3595776189596008455","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:44:11"},"Value":{"Type":"\\u914D\\u7F6E\\u7BA1\\u7406","SubType":"\\u7F16\\u8F91\\u914D\\u7F6E","BizNo":"68758b9b-e6de-0d4c-0000-b9861878b283","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u952E=StorageType\\uFF0C\\u503C=1\\uFF0C\\u7EC4=System","TraceId":"fda514554eb678cf78a78392545893b4","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:44:11.2352973+08:00"}}	0	2025-07-27 16:44:11.235495	2025-07-28 16:44:11.246768	Succeeded
3595776088887042117	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042117","cap-corr-id":"3595776088887042117","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:57:01"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:57:01.8324342+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"3a527112f1d920c535736614c2690ea4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:57:01.832549	2025-07-28 10:57:01.842081	Succeeded
3595776088887042118	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042118","cap-corr-id":"3595776088887042118","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:57:01"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:57:01.865007+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"c071716b7821334cc8c73f23c7b64474","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:57:01.865172	2025-07-28 10:57:01.872821	Succeeded
3595776088887042121	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042121","cap-corr-id":"3595776088887042121","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:58:22"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:58:22.1825933+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"85a28218f2b2e80f57a884adb7eed36c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:58:22.182789	2025-07-28 10:58:22.19842	Succeeded
3595776189596008456	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008456","cap-corr-id":"3595776189596008456","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:11"},"Value":{"Path":"/api/admin/settings","Method":"PUT","RequestTime":"2025-07-27T16:44:10.9081541+08:00","ResponseTime":"2025-07-27T16:44:11.2587541+08:00","Duration":351,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u002268758b9b-e6de-0d4c-0000-b9861878b283\\u0022,\\u0022Name\\u0022:\\u0022\\u6587\\u4EF6\\u5B58\\u50A8\\u9A71\\u52A8\\u7C7B\\u578B\\u0022,\\u0022Key\\u0022:\\u0022StorageType\\u0022,\\u0022Value\\u0022:\\u00221\\u0022,\\u0022GroupKey\\u0022:\\u0022System\\u0022,\\u0022Remark\\u0022:\\u0022\\u672C\\u5730\\u670D\\u52A1\\u5668=1\\uFF0C\\u963F\\u91CC\\u4E91OSS=2\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u914D\\u7F6E","TraceId":"fda514554eb678cf78a78392545893b4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:11.341919	2025-07-28 16:44:11.355265	Succeeded
3595776088887042122	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042122","cap-corr-id":"3595776088887042122","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:58:22"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:58:22.218743+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"bf0779630692338ff7f34b8c470f87b5","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:58:22.218839	2025-07-28 10:58:22.227217	Succeeded
3595776088887042125	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042125","cap-corr-id":"3595776088887042125","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:00:16"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:00:16.4978504+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"6aa95bcb3c22352a8b76c91472af59ba","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:00:16.498185	2025-07-28 11:00:16.507059	Succeeded
3595776088887042126	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042126","cap-corr-id":"3595776088887042126","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:00:16"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:00:16.5554232+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d38e96d7bba6881e90e78413685513cc","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:00:16.555611	2025-07-28 11:00:16.564499	Succeeded
3595776189596008481	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008481","cap-corr-id":"3595776189596008481","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.2809683+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"20c035c0b3df346e568ea6708f11a0df","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:50.281925	2025-07-28 16:53:50.28931	Succeeded
3595776088887042129	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042129","cap-corr-id":"3595776088887042129","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:01:43"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:01:43.488003+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d73b4509da352404c2ccb5428ad6a5e1","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:01:43.488113	2025-07-28 11:01:43.496445	Succeeded
3595776189596008459	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008459","cap-corr-id":"3595776189596008459","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:16"},"Value":{"Path":"/api/admin/tenants","Method":"PUT","RequestTime":"2025-07-27T16:44:16.638703+08:00","ResponseTime":"2025-07-27T16:44:16.6997772+08:00","Duration":61,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00226876c45d-e5f2-35dc-00d1-48ee38eafd16\\u0022,\\u0022Name\\u0022:\\u0022\\u6E56\\u5357\\u5C0F\\u5356\\u90E8\\u0022,\\u0022TenantId\\u0022:\\u0022hn_market\\u0022,\\u0022Remark\\u0022:null,\\u0022Domain\\u0022:\\u0022hn.market.crackerwork.cn\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u79DF\\u6237","TraceId":"cdeef92f21253c78c6e7648ec7aea1f1","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:16.700028	2025-07-28 16:44:16.712615	Succeeded
3595776088887042130	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042130","cap-corr-id":"3595776088887042130","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:01:43"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:01:43.5166791+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"c001b241d228590e25ff914e83ddca12","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:01:43.517039	2025-07-28 11:01:43.525196	Succeeded
3595776189596008473	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008473","cap-corr-id":"3595776189596008473","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:51:57"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus","Method":"PUT","RequestTime":"2025-07-27T16:51:57.1929992+08:00","ResponseTime":"2025-07-27T16:51:57.3033286+08:00","Duration":110,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022RoleId\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022MenuIds\\u0022:[\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u00223a13bcfd-52bb-db4a-d508-eea8536c8bdc\\u0022,\\u00223a174174-857e-2328-55e6-395fcffb3774\\u0022]}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u5206\\u914D\\u83DC\\u5355\\u6743\\u9650","TraceId":"476c6dd70974bab96e2484ff1ed4b7fa","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:51:57.303633	2025-07-28 16:51:57.313834	Succeeded
3595776088887042133	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042133","cap-corr-id":"3595776088887042133","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:08:56"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:08:56.3071664+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"b80eeecaff64cb74dc9d26e64abc282f","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:08:56.315237	2025-07-28 11:08:56.335671	Succeeded
3595776088887042134	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042134","cap-corr-id":"3595776088887042134","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:08:56"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:08:56.4045759+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"54dc1da2c133b3b19bf062b973fd7849","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:08:56.404694	2025-07-28 11:08:56.411956	Succeeded
3595776088887042137	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042137","cap-corr-id":"3595776088887042137","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:09:35"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:09:35.4386944+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"2014afeeca7c43e6d04dc30c636efc03","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:09:35.438819	2025-07-28 11:09:35.44644	Succeeded
3595776088887042138	v1	api_access_log_event	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042138","cap-corr-id":"3595776088887042138","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:09:35"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:09:35.4730416+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"24707a96eeeff143ec56992f92397a0b","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:09:35.473178	2025-07-28 11:09:35.479994	Succeeded
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
3595776088887042143	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042141","cap-corr-id":"3595776088887042141","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:09","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T11:10:09.2716398+08:00","ResponseTime":"2025-07-27T11:10:09.3196422+08:00","Duration":48,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00226865a9ef-4217-02ac-0070-b65a7ed7d760\\u0022,\\u0022Title\\u0022:\\u0022\\u8BBF\\u95EE\\u65E5\\u5FD7\\u0022,\\u0022Icon\\u0022:null,\\u0022Path\\u0022:\\u0022/admin/loggings/access\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a174174-857e-2328-55e6-395fcffb3774\\u0022,\\u0022Sort\\u0022:3,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022monitor/apiAccessLog\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"b36a2569f564a373ac5b39e70130a9b4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:09.988831	2025-07-28 11:10:10.063663	Succeeded
3595776088887042144	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042142","cap-corr-id":"3595776088887042142","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:09","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:10:09.3753848+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"f341f4c3698af096fdfe7dceba7ce482","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:10.075137	2025-07-28 11:10:10.139702	Succeeded
3595776088887042149	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042147","cap-corr-id":"3595776088887042147","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:26","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:10:26.8954576+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"1cf8bbc3d389c6880f5b4893a33edee7","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:27.738804	2025-07-28 11:10:27.90511	Succeeded
3595776088887042150	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042148","cap-corr-id":"3595776088887042148","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:26","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:10:26.9417628+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"50b5c931cea0da483edd6a3da296b13f","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:27.912178	2025-07-28 11:10:27.987079	Succeeded
3595776088887042146	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042145","cap-corr-id":"3595776088887042145","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 11:10:15","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469860605226389504","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T11:10:16.3647039+08:00","Id":"68860918-adfa-4e0c-0012-a7aa0cd1e81d"}}	0	2025-07-27 11:10:16.349326	2025-07-28 11:10:16.371852	Succeeded
3595775912360861698	v1	login_log_event	cap.queue.letu.app.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595775912360861697","cap-corr-id":"3595775912360861697","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/26/2025 22:08:37","cap-msg-group":"cap.queue.letu.app.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469663896177217536","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-26T22:08:38.5334008+08:00","Id":"688551e6-20b6-b614-005f-da006061c039"}}	0	2025-07-26 22:08:38.456078	2025-07-27 22:08:38.55785	Succeeded
3595776082527358978	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776082527358977","cap-corr-id":"3595776082527358977","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 08:35:05","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469821557061455872","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T08:35:06.4701222+08:00","Id":"6885e4ba-b061-92cc-00b2-f6611323b89e"}}	0	2025-07-27 08:35:06.369024	2025-07-28 08:35:06.504859	Succeeded
3595776088887042050	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042049","cap-corr-id":"3595776088887042049","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 09:37:03","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469837151425007616","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T09:37:03.9980271+08:00","Id":"6885f33f-adfa-4e0c-0012-a71c6577b5ff"}}	0	2025-07-27 09:37:03.962918	2025-07-28 09:37:04.011285	Succeeded
3595776088887042052	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042051","cap-corr-id":"3595776088887042051","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 10:08:28","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469845056844992512","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T10:08:28.5101579+08:00","Id":"6885fa9c-adfa-4e0c-0012-a73c0460d575"}}	0	2025-07-27 10:08:28.490883	2025-07-28 10:08:28.517362	Succeeded
3595776088887042055	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042053","cap-corr-id":"3595776088887042053","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:08:35","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:08:35.4213489+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"bddd716271a1aefe2b605a40ff0248e3","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:08:35.806443	2025-07-28 10:08:35.944404	Succeeded
3595776088887042056	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042054","cap-corr-id":"3595776088887042054","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:08:35","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:08:35.5481921+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"2a7ff47ef0a166bc323de478768e149c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:08:35.952014	2025-07-28 10:08:36.000463	Succeeded
3595776088887042059	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042057","cap-corr-id":"3595776088887042057","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:00","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:10:00.8758922+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"8f2134839509239d15d4567a7cc79c7a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:01.749667	2025-07-28 10:10:01.783595	Succeeded
3595776088887042060	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042058","cap-corr-id":"3595776088887042058","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:00","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:10:00.9061482+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"55218186137516529150976ba6a90b0c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:01.789504	2025-07-28 10:10:01.821818	Succeeded
3595776088887042063	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042061","cap-corr-id":"3595776088887042061","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:04","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:10:04.0785965+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"54103b98cf64d9c1c4d5df3f3a806b17","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:04.904153	2025-07-28 10:10:05.016926	Succeeded
3595776088887042064	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042062","cap-corr-id":"3595776088887042062","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:04","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:10:04.1364894+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"2320b2e4776e986f904bf97c3020e3db","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:05.028242	2025-07-28 10:10:05.092887	Succeeded
3595776088887042067	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042065","cap-corr-id":"3595776088887042065","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:46","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:46.0966819+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"9138761fc1131d59b3538cbe7ced6a45","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:46.558184	2025-07-28 10:10:46.601727	Succeeded
3595776088887042068	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042066","cap-corr-id":"3595776088887042066","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:46","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:46.1538317+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"321ff740e0a155165b9d3ccb4f400f5b","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:46.608557	2025-07-28 10:10:46.642506	Succeeded
3595776088887042071	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042069","cap-corr-id":"3595776088887042069","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:58","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:58.4708793+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"de080b1a5c0c26d095b6cf521a90b374","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:58.975473	2025-07-28 10:10:59.025812	Succeeded
3595776088887042072	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042070","cap-corr-id":"3595776088887042070","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:10:58","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T10:10:58.5405964+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"267786f48a29a5527d2ca81efb89db2b","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:10:59.03471	2025-07-28 10:10:59.104277	Succeeded
3595776088887042075	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042073","cap-corr-id":"3595776088887042073","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:11:18","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:11:18.6523018+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"e8d9d56355f8757db6f8cd2827b12b2e","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:11:18.722864	2025-07-28 10:11:18.761678	Succeeded
3595776088887042076	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042074","cap-corr-id":"3595776088887042074","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:11:18","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:11:18.6849172+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"e1a73a24caed36e2cabb4ad27f1d1148","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:11:18.775936	2025-07-28 10:11:18.821618	Succeeded
3595776088887042078	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042077","cap-corr-id":"3595776088887042077","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:18:07","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:18:07.0627882+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"49eabbc9c7e04ea782fe9c80c31a91b2","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:18:07.161869	2025-07-28 10:18:07.213522	Succeeded
3595776088887042081	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042079","cap-corr-id":"3595776088887042079","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:47","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:24:47.1266433+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"848fcde8a87e1d039394deed87fa8008","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:47.794458	2025-07-28 10:24:47.862783	Succeeded
3595776088887042153	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042151","cap-corr-id":"3595776088887042151","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:34","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:10:34.5089521+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"274cfb47d8b698e9ae464a5447921416","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:35.192966	2025-07-28 11:10:35.338286	Succeeded
3595776088887042092	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042091","cap-corr-id":"3595776088887042091","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 10:25:15","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469849279926112256","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T10:25:16.2858087+08:00","Id":"6885fe8c-adfa-4e0c-0012-a7614a0dddb0"}}	0	2025-07-27 10:25:16.261293	2025-07-28 10:25:16.291471	Succeeded
3595776088887042157	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042155","cap-corr-id":"3595776088887042155","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:37","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T11:10:37.0093004+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"d3cd54986710c5ea6fd9fb83b2ccba95","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:37.599747	2025-07-28 11:10:37.668816	Succeeded
3595776189596008471	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008469","cap-corr-id":"3595776189596008469","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.7983262+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0e537e170cc04e79647d088cc722815d","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:44.644665	2025-07-28 16:46:44.719375	Succeeded
3595776189596008484	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008482","cap-corr-id":"3595776189596008482","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.3306817+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"757fac8794844e0ef0b9e162bc6bb0b6","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:51.130486	2025-07-28 16:53:51.179046	Succeeded
3595776088887042082	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042080","cap-corr-id":"3595776088887042080","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:47","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:24:47.1678227+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"728502a759b02ac422919ffe4a1db6d8","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:47.871246	2025-07-28 10:24:47.921393	Succeeded
3595776088887042154	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042152","cap-corr-id":"3595776088887042152","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:34","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:10:34.5434877+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"346128b4d1ac8bb6bac2b47001c32b15","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:35.349971	2025-07-28 11:10:35.509391	Succeeded
3595776088887042085	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042083","cap-corr-id":"3595776088887042083","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:54","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:24:54.0499257+08:00","ResponseTime":"2025-07-27T10:24:54.2253005+08:00","Duration":175,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Title\\u0022:\\u0022\\u7EC4\\u7EC7\\u67B6\\u6784\\u0022,\\u0022Icon\\u0022:\\u0022antd:TeamOutlined\\u0022,\\u0022Path\\u0022:\\u0022/admin\\u0022,\\u0022MenuType\\u0022:1,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:null,\\u0022Sort\\u0022:1,\\u0022Display\\u0022:true,\\u0022Component\\u0022:null,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"ebde6ea815ea6cad2306e701e697d709","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:55.141987	2025-07-28 10:24:55.246062	Succeeded
3595776088887042086	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042084","cap-corr-id":"3595776088887042084","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:24:54","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:24:54.2739311+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"7b9300fb350788a6a26848819fe34b61","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:24:55.258827	2025-07-28 10:24:55.381971	Succeeded
3595776088887042158	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042156","cap-corr-id":"3595776088887042156","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:10:37","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T11:10:37.0440897+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"35bcfdc4987c51369da4154f0f55b10e","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:10:37.67771	2025-07-28 11:10:37.803028	Succeeded
3595776088887042089	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042087","cap-corr-id":"3595776088887042087","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:25:04","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:25:04.46234+08:00","ResponseTime":"2025-07-27T10:25:04.5131219+08:00","Duration":51,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13bdaf-34ea-bf3c-c7eb-1d1cfd91d361\\u0022,\\u0022Title\\u0022:\\u0022\\u804C\\u4F4D\\u7BA1\\u7406\\u0022,\\u0022Icon\\u0022:null,\\u0022Path\\u0022:\\u0022/admin/positions\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Sort\\u0022:2,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022org/position\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"7239431f0e1943ad53d7e7b4340eed02","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:25:04.652564	2025-07-28 10:25:04.711943	Succeeded
3595776189596008450	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008449","cap-corr-id":"3595776189596008449","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 15:44:59","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469929745626697728","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T15:45:00.6357359+08:00","Id":"6886497c-83c0-4b38-0034-fa222d8e3040"}}	0	2025-07-27 15:45:00.415885	2025-07-28 15:45:00.762168	Succeeded
3595776088887042090	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042088","cap-corr-id":"3595776088887042088","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:25:04","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:25:04.5480614+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d9496ce2500032d29d4d4822ff89d734","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:25:04.719371	2025-07-28 10:25:04.790326	Succeeded
3595776189596008476	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008475","cap-corr-id":"3595776189596008475","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:52:48","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c","Method":"PUT","RequestTime":"2025-07-27T16:52:48.2020119+08:00","ResponseTime":"2025-07-27T16:52:48.231875+08:00","Duration":30,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022RoleName\\u0022:\\u0022\\u6D4B\\u8BD5\\u0022,\\u0022Remark\\u0022:\\u0022\\u6D4B\\u8BD5\\u83DC\\u5355\\u6743\\u9650\\u0022,\\u0022IsEnabled\\u0022:true}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u89D2\\u8272","TraceId":"3bbbf64cf7e715cbddd616be411e0891","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:52:48.976244	2025-07-28 16:52:49.052017	Succeeded
3595776088887042094	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042093","cap-corr-id":"3595776088887042093","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:46:05","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/employees/68860360-adfa-4e0c-0012-a7760a0242a1","Method":"DELETE","RequestTime":"2025-07-27T10:46:05.4622646+08:00","ResponseTime":"2025-07-27T10:46:05.4991563+08:00","Duration":37,"RequestBody":"{\\u0022id\\u0022:\\u002268860360-adfa-4e0c-0012-a7760a0242a1\\u0022}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[4],"OperateName":"\\u5220\\u9664\\u5458\\u5DE5","TraceId":"5ad066caa80d686b080c8d29b60fbc82","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:46:06.417653	2025-07-28 10:46:06.498182	Succeeded
3595776088887042097	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042095","cap-corr-id":"3595776088887042095","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:52:46","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:52:46.3736904+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"82bbdc666ca8a5f063f9e05edf4498af","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:52:46.435768	2025-07-28 10:52:46.48023	Succeeded
3595776189596008452	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008451","cap-corr-id":"3595776189596008451","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 16:37:15","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469942895910588416","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T16:37:15.8035406+08:00","Id":"688655bb-83c0-4b38-0034-fa577ee5667e"}}	0	2025-07-27 16:37:15.775088	2025-07-28 16:37:15.812973	Succeeded
3595776088887042098	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042096","cap-corr-id":"3595776088887042096","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:52:46","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:52:46.408736+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"8716d68a8ea9d482609648ea9bd2d55e","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:52:46.48811	2025-07-28 10:52:46.530993	Succeeded
3595776088887042101	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042099","cap-corr-id":"3595776088887042099","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:11","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:53:11.7883932+08:00","ResponseTime":"2025-07-27T10:53:11.8249086+08:00","Duration":37,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u0022Title\\u0022:\\u0022\\u804C\\u4F4D\\u5206\\u7EC4\\u0022,\\u0022Icon\\u0022:\\u0022\\u0022,\\u0022Path\\u0022:\\u0022/admin/position/groups\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Sort\\u0022:1,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022org/positionGroup\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"6c496a0868f18e11bdddbe1d9dc8d6c5","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:12.492138	2025-07-28 10:53:12.544345	Succeeded
3595776088887042102	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042100","cap-corr-id":"3595776088887042100","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:11","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:53:11.8519507+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d954bef62ce033e8f6395430323cf0e0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:12.552208	2025-07-28 10:53:12.594748	Succeeded
3595776189596008454	v1	log_record_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008453","cap-corr-id":"3595776189596008453","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:42:24","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Type":"\\u5B57\\u5178\\u6570\\u636E","SubType":"\\u7F16\\u8F91\\u5B57\\u5178\\u6570\\u636E","BizNo":"68602622-e22b-e780-00f8-5c9d688361b4","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u503C=1,\\u542F\\u7528=True","TraceId":"9a950cae333377316b799fb0ddd70449","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:42:24.2061492+08:00"}}	0	2025-07-27 16:42:24.776111	2025-07-28 16:42:24.861752	Succeeded
3595776189596008474	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008473","cap-corr-id":"3595776189596008473","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:51:57","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/roles/687047ef-1649-9660-0098-4182062f682c/menus","Method":"PUT","RequestTime":"2025-07-27T16:51:57.1929992+08:00","ResponseTime":"2025-07-27T16:51:57.3033286+08:00","Duration":110,"RequestBody":"{\\u0022id\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022dto\\u0022:{\\u0022RoleId\\u0022:\\u0022687047ef-1649-9660-0098-4182062f682c\\u0022,\\u0022MenuIds\\u0022:[\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u00223a13bcfd-52bb-db4a-d508-eea8536c8bdc\\u0022,\\u00223a174174-857e-2328-55e6-395fcffb3774\\u0022]}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u5206\\u914D\\u83DC\\u5355\\u6743\\u9650","TraceId":"476c6dd70974bab96e2484ff1ed4b7fa","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:51:58.12355	2025-07-28 16:51:58.191724	Succeeded
3595776189596008487	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008485","cap-corr-id":"3595776189596008485","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:58","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T16:53:58.4262333+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"3a6a52bf8e08dc56e0c553afdcc98ea0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:59.439494	2025-07-28 16:53:59.487728	Succeeded
3595776189596008488	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008486","cap-corr-id":"3595776189596008486","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:58","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T16:53:58.4885647+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"b0f61adaac14abadfdd20057b88074f6","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:59.497603	2025-07-28 16:53:59.550038	Succeeded
3595776088887042105	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042103","cap-corr-id":"3595776088887042103","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:19","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"PUT","RequestTime":"2025-07-27T10:53:19.3590386+08:00","ResponseTime":"2025-07-27T10:53:19.3959465+08:00","Duration":37,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00223a13bcf2-3701-be8e-4ec8-ad5f77536101\\u0022,\\u0022Title\\u0022:\\u0022\\u804C\\u4F4D\\u5206\\u7EC4\\u0022,\\u0022Icon\\u0022:\\u0022\\u0022,\\u0022Path\\u0022:\\u0022/admin/positions/groups\\u0022,\\u0022MenuType\\u0022:2,\\u0022Permission\\u0022:null,\\u0022ParentId\\u0022:\\u00223a13a4fe-6f74-733b-a628-6125c0325481\\u0022,\\u0022Sort\\u0022:1,\\u0022Display\\u0022:true,\\u0022Component\\u0022:\\u0022org/positionGroup\\u0022,\\u0022IsExternal\\u0022:false}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u83DC\\u5355","TraceId":"d7646796e543d2c2c889f4abcb231efd","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:19.891504	2025-07-28 10:53:19.926902	Succeeded
3595776189596008457	v1	log_record_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008455","cap-corr-id":"3595776189596008455","cap-corr-seq":"0","cap-msg-name":"log_record_event","cap-msg-type":"LogRecordMessage","cap-senttime":"07/27/2025 16:44:11","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Type":"\\u914D\\u7F6E\\u7BA1\\u7406","SubType":"\\u7F16\\u8F91\\u914D\\u7F6E","BizNo":"68758b9b-e6de-0d4c-0000-b9861878b283","Content":"\\u7F16\\u8F91\\u540E\\uFF1A\\u952E=StorageType\\uFF0C\\u503C=1\\uFF0C\\u7EC4=System","TraceId":"fda514554eb678cf78a78392545893b4","SanitizeKeys":null,"Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null,"CreationTime":"2025-07-27T16:44:11.2352973+08:00"}}	0	2025-07-27 16:44:11.622217	2025-07-28 16:44:11.754318	Succeeded
3595776088887042106	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042104","cap-corr-id":"3595776088887042104","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:53:19","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:53:19.4217341+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"cdbe799b98321bb6d19c5ce6e09510e4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:53:19.933525	2025-07-28 10:53:19.963378	Succeeded
3595776088887042108	v1	login_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042107","cap-corr-id":"3595776088887042107","cap-corr-seq":"0","cap-msg-name":"login_log_event","cap-msg-type":"SecurityLog","cap-senttime":"07/27/2025 10:53:30","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"UserName":"admin","Ip":"::1","Address":null,"Browser":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","OperationMsg":"\\u767B\\u5F55\\u6210\\u529F","IsSuccess":true,"SessionId":"4469856390101864448","TenantId":null,"CreatorId":null,"CreationTime":"2025-07-27T10:53:31.368839+08:00","Id":"6886052b-adfa-4e0c-0012-a786167b5339"}}	0	2025-07-27 10:53:31.348237	2025-07-28 10:53:31.373706	Succeeded
3595776189596008479	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008477","cap-corr-id":"3595776189596008477","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.7520157+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"cc6f0b646c3dad1af01d0c7d524a21a0","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.826366	2025-07-28 16:53:47.876009	Succeeded
3595776189596008480	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008478","cap-corr-id":"3595776189596008478","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:47","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:53:47.782176+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"0f967483acb706f1afd3f68dd545f944","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:47.884244	2025-07-28 16:53:47.929256	Succeeded
3595776189596008458	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008456","cap-corr-id":"3595776189596008456","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:11","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/settings","Method":"PUT","RequestTime":"2025-07-27T16:44:10.9081541+08:00","ResponseTime":"2025-07-27T16:44:11.2587541+08:00","Duration":351,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u002268758b9b-e6de-0d4c-0000-b9861878b283\\u0022,\\u0022Name\\u0022:\\u0022\\u6587\\u4EF6\\u5B58\\u50A8\\u9A71\\u52A8\\u7C7B\\u578B\\u0022,\\u0022Key\\u0022:\\u0022StorageType\\u0022,\\u0022Value\\u0022:\\u00221\\u0022,\\u0022GroupKey\\u0022:\\u0022System\\u0022,\\u0022Remark\\u0022:\\u0022\\u672C\\u5730\\u670D\\u52A1\\u5668=1\\uFF0C\\u963F\\u91CC\\u4E91OSS=2\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u914D\\u7F6E","TraceId":"fda514554eb678cf78a78392545893b4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:11.788432	2025-07-28 16:44:11.974333	Succeeded
3595776088887042111	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042109","cap-corr-id":"3595776088887042109","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:10","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:10.6124313+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"fc1bd434180f50ca249ae907097d910a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:11.651848	2025-07-28 10:54:11.70412	Succeeded
3595776088887042112	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042110","cap-corr-id":"3595776088887042110","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:10","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:10.6429934+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"682d9e94bf8fc65b095156837e8d94f7","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:11.711253	2025-07-28 10:54:11.749106	Succeeded
3595776088887042115	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042113","cap-corr-id":"3595776088887042113","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:32","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:32.9945034+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"2ea994cfd806f4d0eea19d9919230cb8","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:33.496329	2025-07-28 10:54:33.547717	Succeeded
3595776088887042116	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042114","cap-corr-id":"3595776088887042114","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:54:33","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T10:54:33.027186+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"fba10d742e5e7355ec4d1edf5404ce7a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:54:33.554578	2025-07-28 10:54:33.601001	Succeeded
3595776088887042119	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042117","cap-corr-id":"3595776088887042117","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:57:01","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:57:01.8324342+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"3a527112f1d920c535736614c2690ea4","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:57:02.345247	2025-07-28 10:57:02.479185	Succeeded
3595776088887042120	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042118","cap-corr-id":"3595776088887042118","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:57:01","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:57:01.865007+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"c071716b7821334cc8c73f23c7b64474","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:57:02.487461	2025-07-28 10:57:02.567506	Succeeded
3595776189596008460	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008459","cap-corr-id":"3595776189596008459","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:44:16","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/tenants","Method":"PUT","RequestTime":"2025-07-27T16:44:16.638703+08:00","ResponseTime":"2025-07-27T16:44:16.6997772+08:00","Duration":61,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Id\\u0022:\\u00226876c45d-e5f2-35dc-00d1-48ee38eafd16\\u0022,\\u0022Name\\u0022:\\u0022\\u6E56\\u5357\\u5C0F\\u5356\\u90E8\\u0022,\\u0022TenantId\\u0022:\\u0022hn_market\\u0022,\\u0022Remark\\u0022:null,\\u0022Domain\\u0022:\\u0022hn.market.crackerwork.cn\\u0022}}","ResponseBody":"{\\u0022Value\\u0022:{\\u0022Code\\u0022:\\u00220\\u0022,\\u0022Message\\u0022:null,\\u0022Data\\u0022:true},\\u0022Formatters\\u0022:[],\\u0022ContentTypes\\u0022:[],\\u0022DeclaredType\\u0022:\\u0022Letu.Shared.Models.AppResponse\\u00601[[System.Boolean, System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], Letu.Shared, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null\\u0022,\\u0022StatusCode\\u0022:null}","QueryString":"","OperateType":[3],"OperateName":"\\u4FEE\\u6539\\u79DF\\u6237","TraceId":"cdeef92f21253c78c6e7648ec7aea1f1","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:44:17.170458	2025-07-28 16:44:17.269763	Succeeded
3595776088887042123	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042121","cap-corr-id":"3595776088887042121","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:58:22","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:58:22.1825933+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"85a28218f2b2e80f57a884adb7eed36c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:58:22.46524	2025-07-28 10:58:22.539525	Succeeded
3595776189596008472	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008470","cap-corr-id":"3595776189596008470","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:43","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:43.8248107+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"abc990ab158cca08fbf3cdc0f710984a","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:44.729255	2025-07-28 16:46:44.777569	Succeeded
3595776088887042124	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042122","cap-corr-id":"3595776088887042122","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 10:58:22","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T10:58:22.218743+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"bf0779630692338ff7f34b8c470f87b5","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 10:58:22.551849	2025-07-28 10:58:22.663384	Succeeded
3595776189596008483	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008481","cap-corr-id":"3595776189596008481","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:53:50","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T16:53:50.2809683+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"20c035c0b3df346e568ea6708f11a0df","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:53:51.031446	2025-07-28 16:53:51.120681	Succeeded
3595776088887042127	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042125","cap-corr-id":"3595776088887042125","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:00:16","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:00:16.4978504+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"6aa95bcb3c22352a8b76c91472af59ba","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:00:17.497017	2025-07-28 11:00:17.582518	Succeeded
3595776088887042128	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042126","cap-corr-id":"3595776088887042126","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:00:16","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:00:16.5554232+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d38e96d7bba6881e90e78413685513cc","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:00:17.590281	2025-07-28 11:00:17.692553	Succeeded
3595776189596008463	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008461","cap-corr-id":"3595776189596008461","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:29","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:29.8009887+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"c3c991571f397d82e8dab27272eb6dbd","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:29.930071	2025-07-28 16:46:29.978027	Succeeded
3595776088887042131	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042129","cap-corr-id":"3595776088887042129","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:01:43","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:01:43.488003+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"d73b4509da352404c2ccb5428ad6a5e1","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:01:43.668905	2025-07-28 11:01:43.7311	Succeeded
3595776088887042132	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042130","cap-corr-id":"3595776088887042130","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:01:43","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:01:43.5166791+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"c001b241d228590e25ff914e83ddca12","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:01:43.738177	2025-07-28 11:01:43.791685	Succeeded
3595776189596008464	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008462","cap-corr-id":"3595776189596008462","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:29","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:29.8514407+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"f04cb8808073002ff26522e74452e2fb","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:29.984019	2025-07-28 16:46:30.019526	Succeeded
3595776088887042135	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042133","cap-corr-id":"3595776088887042133","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:08:56","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:08:56.3071664+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"b80eeecaff64cb74dc9d26e64abc282f","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:08:57.256414	2025-07-28 11:08:57.352493	Succeeded
3595776189596008467	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008465","cap-corr-id":"3595776189596008465","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:39","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:39.0120788+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"1ee9b3aca7f96e0a260fb120749e7a5c","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:39.331911	2025-07-28 16:46:39.395403	Succeeded
3595776088887042136	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042134","cap-corr-id":"3595776088887042134","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:08:56","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/online-users","Method":"GET","RequestTime":"2025-07-27T11:08:56.4045759+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":"\\u5728\\u7EBF\\u7528\\u6237\\u5217\\u8868","TraceId":"54dc1da2c133b3b19bf062b973fd7849","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:08:57.365582	2025-07-28 11:08:57.453838	Succeeded
3595776088887042139	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042137","cap-corr-id":"3595776088887042137","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:09:35","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:09:35.4386944+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"2014afeeca7c43e6d04dc30c636efc03","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:09:35.591673	2025-07-28 11:09:35.767081	Succeeded
3595776189596008468	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776189596008466","cap-corr-id":"3595776189596008466","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 16:46:39","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/users","Method":"GET","RequestTime":"2025-07-27T16:46:39.0435411+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022UserName\\u0022:null,\\u0022PageSize\\u0022:10,\\u0022Current\\u0022:1}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":null,"OperateName":"\\u7528\\u6237\\u5206\\u9875\\u5217\\u8868","TraceId":"aeb3709aba8fb3f1d959f0cdae992711","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 16:46:39.414995	2025-07-28 16:46:39.470469	Succeeded
3595776088887042140	v1	api_access_log_event	cap.queue.letu.server.v1	{"Headers":{"cap-callback-name":null,"cap-msg-id":"3595776088887042138","cap-corr-id":"3595776088887042138","cap-corr-seq":"0","cap-msg-name":"api_access_log_event","cap-msg-type":"ApiAccessLogMessage","cap-senttime":"07/27/2025 11:09:35","cap-msg-group":"cap.queue.letu.server.v1","cap-exec-instance-id":"FCCA-ThinkBook"},"Value":{"Path":"/api/admin/menus","Method":"GET","RequestTime":"2025-07-27T11:09:35.4730416+08:00","ResponseTime":null,"Duration":null,"RequestBody":"{\\u0022dto\\u0022:{\\u0022Title\\u0022:null,\\u0022Path\\u0022:null}}","ResponseBody":null,"QueryString":"?current=1\\u0026pageSize=10","OperateType":[2],"OperateName":null,"TraceId":"24707a96eeeff143ec56992f92397a0b","Ip":"::1","UserAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0","UserId":"3a172a37-55d5-ee9b-dc92-e07386eadc7c","UserName":"admin","TenantId":null}}	0	2025-07-27 11:09:35.774876	2025-07-28 11:09:35.929785	Succeeded
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
\.


--
-- Data for Name: exception_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exception_log (id, creator_id, creation_time, exception_type, message, stack_trace, inner_exception, request_path, request_method, user_id, user_name, ip, browser, trace_id, is_handled, handled_time, handled_by, tenant_id) FROM stdin;
\.


--
-- Data for Name: log_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_record (id, creator_id, creation_time, type, sub_type, biz_no, content, browser, ip, trace_id, tenant_id, user_id, user_name) FROM stdin;
688656f0-83c0-4b38-0034-fa5d0e9d12bd	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:42:24.206149	字典数据	编辑字典数据	68602622-e22b-e780-00f8-5c9d688361b4	编辑后：值=1,启用=True	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	::1	9a950cae333377316b799fb0ddd70449	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin
6886575b-83c0-4b38-0034-fa60788c715a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-27 16:44:11.235297	配置管理	编辑配置	68758b9b-e6de-0d4c-0000-b9861878b283	编辑后：键=StorageType，值=1，组=System	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0	::1	fda514554eb678cf78a78392545893b4	\N	3a172a37-55d5-ee9b-dc92-e07386eadc7c	admin
\.


--
-- Data for Name: org_employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_employee (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, code, name, sex, phone, id_no, front_id_no_url, back_id_no_url, birthday, address, email, in_time, out_time, status, user_id, dept_id, position_id, tenant_id) FROM stdin;
6869907c-9c93-beac-0062-34172a640e0e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-05 20:52:12.138175	2025-07-05 21:45:13.910127	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	001	tom	1	18211114444	\N	\N	\N	\N	\N	\N	0001-01-01 00:00:00	\N	1	\N	6861a4ed-de18-91c8-009e-ef9b36642c3c	\N	\N
\.


--
-- Data for Name: org_position; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_position (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, code, name, level, status, description, group_id, tenant_id) FROM stdin;
686a9bac-aad5-2c54-003c-a0450445a76f	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-06 15:52:12.404982	\N	\N	f	\N	\N	001	前端开发工程师	1	1	\N	685f2f1d-7ef6-c114-0022-88b738cf5c1c	\N
\.


--
-- Data for Name: org_position_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_position_group (id, creator_id, creation_time, last_modification_time, last_modifier_id, group_name, remark, parent_id, parent_ids, sort, tenant_id) FROM stdin;
685f2f1d-7ef6-c114-0022-88b738cf5c1c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-27 23:54:05.887842	\N	\N	前端	\N	685f2cd3-7ef6-c114-0022-88b50a861368	685f2cd3-7ef6-c114-0022-88b50a861368	0	\N
685f2cd3-7ef6-c114-0022-88b50a861368	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-27 23:44:19.081278	2025-06-28 15:57:31.895397	3a172a37-55d5-ee9b-dc92-e07386eadc7c	软件	软件研发岗位	\N	\N	1	\N
\.


--
-- Data for Name: scheduled_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_tasks (id, creator_id, creation_time, last_modification_time, last_modifier_id, task_key, task_description, cron_expression, is_active) FROM stdin;
687ae246-5252-956c-0036-60534c5f630a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-19 00:09:42.631289	\N	\N	NotificationJob	通知定时提醒	0 0/1 * * * ?	t
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
6861a4ed-de18-91c8-009e-ef9b36642c3c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-29 20:41:17.23825	2025-07-14 22:01:12.096261	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	root	风汐科技有限公司	1	\N	1	6869907c-9c93-beac-0062-34172a640e0e	\N	\N	6861a543-de18-91c8-009e-ef9c48eee11a	6861a4ed-de18-91c8-009e-ef9b36642c3c,6861a543-de18-91c8-009e-ef9c48eee11a	3	\N
6861a543-de18-91c8-009e-ef9c48eee11a	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-06-29 20:42:43.252466	2025-06-29 20:52:55.936051	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	IT-01	研发部	1		1	6869907c-9c93-beac-0062-34172a640e0e	crackerwork@outlook.com	18211112222	\N	6861a4ed-de18-91c8-009e-ef9b36642c3c	2	\N
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
\.


--
-- Data for Name: sys_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_notification (id, creator_id, creation_time, last_modification_time, last_modifier_id, title, content, employee_id, is_readed, readed_time, tenant_id) FROM stdin;
68848ae9-4b6b-160c-0042-19be265da2d8	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-26 07:59:37.200947	\N	\N	test	test	6869907c-9c93-beac-0062-34172a640e0e	t	2025-07-26 08:04:11.829145	\N
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
6886592d-83c0-4b38-0034-fa704938f77c	3a13a4fe-6f74-733b-a628-6125c0325481	687047ef-1649-9660-0098-4182062f682c	\N
6886592d-83c0-4b38-0034-fa7114d7817d	3a13bcf2-3701-be8e-4ec8-ad5f77536101	687047ef-1649-9660-0098-4182062f682c	\N
6886592d-83c0-4b38-0034-fa72249a3908	3a13bcfd-52bb-db4a-d508-eea8536c8bdc	687047ef-1649-9660-0098-4182062f682c	\N
6886592d-83c0-4b38-0034-fa733325cb6a	3a174174-857e-2328-55e6-395fcffb3774	687047ef-1649-9660-0098-4182062f682c	\N
\.


--
-- Data for Name: sys_tenant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_tenant (id, creator_id, creation_time, last_modification_time, last_modifier_id, name, tenant_id, remark, domain) FROM stdin;
6876c329-dc2a-f770-00a6-b1e306495609	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:07:53.183795	2025-07-15 21:12:18.009625	3a172a37-55d5-ee9b-dc92-e07386eadc7c	重庆小卖部	cq_market	\N	cq.market.crackerwork.cn
6876c45d-e5f2-35dc-00d1-48ee38eafd16	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-15 21:13:01.684058	2025-07-27 16:44:16.679914	3a172a37-55d5-ee9b-dc92-e07386eadc7c	湖南小卖部	hn_market	\N	hn.market.crackerwork.cn
\.


--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user (id, creator_id, creation_time, last_modification_time, last_modifier_id, is_deleted, deleter_id, deletion_time, user_name, password, password_salt, avatar, nick_name, sex, is_enabled, tenant_id, phone) FROM stdin;
00de38c4-17bd-415f-bf1c-2e0873eb177e	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-10 22:44:04.531912	\N	\N	f	\N	\N	coco	e145745caac61f1b499a3cc677ef7591	NsKMV/B5UAKe8IvGoP8kAg==	avatar/female.png	珂珂	2	t	\N	
3e64db48-e302-46f7-87d8-dc3f8c4bd428	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2025-07-10 22:43:38.917621	2025-07-10 22:46:16.649351	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	tom	7ff497634388c0517d3b1c973efd9b98	V12NcTVTF84SFyIJ2pNEuw==	avatar/male.png	tom	1	t	\N	
3a172a37-55d5-ee9b-dc92-e07386eadc7c	3a172a37-55d5-ee9b-dc92-e07386eadc7c	2024-12-30 22:48:48.458	2025-06-17 19:05:09.599	3a172a37-55d5-ee9b-dc92-e07386eadc7c	f	\N	\N	admin	a2fa8ec90f15197c7a4e6e00525b198a	vHQZvbz+ng+B4NrSAEYl6g==	avatar/male.png	风汐	1	t	001	
\.


--
-- Data for Name: sys_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user_role (id, user_id, role_id, tenant_id) FROM stdin;
683cc8f7-ba08-3990-009e-23375861fdc5	683cc901-ba08-3990-009e-23392649a8a4	683cc8d0-ba08-3990-009e-233317cce095	
685f2a6f-5e26-60bc-00f7-9ead1bc87fd4	3a172a37-55d5-ee9b-dc92-e07386eadc7c	3a172369-28a4-e37e-b78a-8c3eaec17359	\N
68705965-5ecb-c374-0046-1a565d226a73	00de38c4-17bd-415f-bf1c-2e0873eb177e	687047ef-1649-9660-0098-4182062f682c	\N
\.


--
-- Data for Name: task_execution_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_execution_logs (id, creator_id, creation_time, task_key, status, result, node_id, execution_time, cost) FROM stdin;
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
-- Name: uk_tenant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uk_tenant_id ON public.sys_tenant USING btree (tenant_id);


--
-- PostgreSQL database dump complete
--

