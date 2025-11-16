-- 迁移脚本：为 sys_organization_unit 表添加新字段
-- 执行日期：请根据实际情况填写
-- 说明：为组织机构单元表添加分类、类型、行政区域、地址、联系人、经纬度等字段

-- 添加分类字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS category integer;

COMMENT ON COLUMN public.sys_organization_unit.category IS '分类（用于机构种类）';

-- 添加类型字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS type integer;

COMMENT ON COLUMN public.sys_organization_unit.type IS '类型（值来自字典项的 Value 转换为 int）';

-- 添加所属行政区域字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS region_code character varying(12);

COMMENT ON COLUMN public.sys_organization_unit.region_code IS '所属行政区域（关联 Region.Code）';

-- 添加行政区域街道名称字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS street_name character varying(64);

COMMENT ON COLUMN public.sys_organization_unit.street_name IS '行政区域街道名称';

-- 添加地址字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS address character varying(256);

COMMENT ON COLUMN public.sys_organization_unit.address IS '地址';

-- 添加联系人字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS contact_person character varying(64);

COMMENT ON COLUMN public.sys_organization_unit.contact_person IS '联系人';

-- 添加联系电话字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS contact_phone character varying(64);

COMMENT ON COLUMN public.sys_organization_unit.contact_phone IS '联系电话';

-- 添加经度字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS longitude numeric(18,6);

COMMENT ON COLUMN public.sys_organization_unit.longitude IS '经度';

-- 添加纬度字段
ALTER TABLE public.sys_organization_unit 
ADD COLUMN IF NOT EXISTS latitude numeric(18,6);

COMMENT ON COLUMN public.sys_organization_unit.latitude IS '纬度';

