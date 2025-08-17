import { Badge, Checkbox, Col, Divider, List, Menu, Modal, Row } from 'antd';
import type { MenuProps } from 'antd';
import type { CheckboxChangeEvent } from 'antd/es/checkbox';
import React, { forwardRef, useImperativeHandle, useState } from 'react';
import { getRolePermissions, updateRolePermissions, type RoleListDto, type PermissionDto, type UpdatePermissionDto } from './service';
import useApp from 'antd/es/app/useApp';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps { }

export interface PermissionModalRef {
  openModal: (row: RoleListDto) => void; // 定义 ref 的类型
}

interface GroupItem {
  name: string;
  displayName: string;
  isAllPermissionsGranted: boolean;
  grantedCount: number;
}

const countGrantedPermission = (permissions: PermissionDto[]): number => {
  let count = 0;
  permissions.forEach(p => {
    if (p.isGranted) count++;
  });
  return count;
};

const mapToGroupMenuItem = (groups: GroupItem[] | undefined) => {
  return groups?.map(g => {
    let label;
    if (g.grantedCount === 0) {
      label = g.displayName;
    } else if (g.isAllPermissionsGranted) {
      label = (
        <div className='flex justify-between items-center'>
          <strong>{g.displayName}</strong>
          <Badge count="ALL" color="green" />
        </div>
      );
    } else {
      label = (
        <div className='flex justify-between items-center'>
          <strong>{g.displayName}</strong>
          <Badge count={g.grantedCount} color="cyan" />
        </div>
      );
    }
    return {
      key: g.name,
      label,
    };
  });
};

const PermissionForm = forwardRef<PermissionModalRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [currentRow, setCurrentRow] = useState<RoleListDto>();
  const [groupItems, setGroupItems] = useState<GroupItem[]>();
  const [selectedGroup, setSelectedGroup] = useState<GroupItem>();
  const [permissionItems, setPermissionItems] = useState<PermissionDto[]>([]);
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row: RoleListDto) => {
    setCurrentRow(row);
    setIsOpenModal(true);
    loadPermissions(row.name);
  };

  const loadPermissions = async (roleId: string) => {
    try {
      setLoading(true);
      const permissions = await getRolePermissions(roleId);
      const allItems: PermissionDto[] = [];
      const allGroups: GroupItem[] = [];

      permissions.groups.forEach(g => {
        const grantedCount = countGrantedPermission(g.permissions);

        allGroups.push({
          name: g.name,
          displayName: g.displayName,
          grantedCount,
          isAllPermissionsGranted: grantedCount === g.permissions.length
        });

        g.permissions.forEach(p => {
          allItems.push({
            name: p.name,
            displayName: p.displayName,
            isGranted: p.isGranted,
            parentName: p.parentName
          });
        });
      });

      setPermissionItems(allItems);
      setGroupItems(allGroups);

      if (allGroups.length > 0) {
        setSelectedGroup(allGroups[0]);
      }
    } catch (error) {
      message.error('加载权限列表失败');
    } finally {
      setLoading(false);
    }
  };

  // 监听权限变更，更新groupItems的计数
  React.useEffect(() => {
    if (permissionItems.length > 0 && groupItems && groupItems.length > 0) {
      const updatedGroups = groupItems.map(group => {
        const groupPermissions = permissionItems.filter(p => p.name.startsWith(group.name));
        const grantedCount = countGrantedPermission(groupPermissions);
        return {
          ...group,
          grantedCount,
          isAllPermissionsGranted: grantedCount === groupPermissions.length
        };
      });

      setGroupItems(updatedGroups);

      // 更新当前选中的组
      if (selectedGroup) {
        const updatedSelectedGroup = updatedGroups.find(g => g.name === selectedGroup.name);
        if (updatedSelectedGroup) {
          setSelectedGroup(updatedSelectedGroup);
        }
      }
    }
  }, [permissionItems]);

  const getGroupPermissions = (groupName?: string): PermissionDto[] | undefined => {
    if (groupName) {
      return permissionItems.filter(p =>
        p.name.startsWith(groupName) &&
        (p.parentName === null || !permissionItems.some(parent => parent.name === p.parentName))
      );
    }
  };

  const getChildPermissions = (parentName?: string): PermissionDto[] | undefined => {
    if (parentName) {
      return permissionItems.filter(p => p.parentName === parentName);
    }
  };

  const isAllGranted = (groupName?: string): boolean | undefined => {
    if (groupName) {
      return permissionItems
        .filter(p => p.name.startsWith(groupName))
        .every(p => p.isGranted);
    }
  };

  const handleGroupClick: MenuProps["onClick"] = (e) => {
    setSelectedGroup(groupItems?.find(g => g.name === e.key));
  };

  const handleGrantAll = (e: CheckboxChangeEvent) => {
    const groupName = e.target.name;
    if (!groupName) return;

    const newPermissions = [...permissionItems];
    newPermissions.forEach(p => {
      if (p.name.startsWith(groupName)) {
        p.isGranted = e.target.checked;
      }
    });

    setPermissionItems(newPermissions);
  };

  const handlePermissionChange = (e: CheckboxChangeEvent) => {
    const name = e.target.name;
    if (!name) return;

    const index = permissionItems.findIndex(p => p.name === name);
    if (index === -1) return;

    permissionItems[index] = {
      ...permissionItems[index],
      isGranted: e.target.checked
    };
    const newPermissions = [...permissionItems];
    setPermissionItems(newPermissions);
  };

  const onCancel = () => {
    setIsOpenModal(false);
    setPermissionItems([]);
    setGroupItems([]);
    setSelectedGroup(undefined);
  };

  const onOk = async () => {
    if (!currentRow) return;

    try {
      setLoading(true);
      const data: UpdatePermissionDto[] = permissionItems.map(p => ({
        name: p.name,
        isGranted: p.isGranted
      }));

      await updateRolePermissions(currentRow.name, data);
      message.success('权限更新成功');
      setIsOpenModal(false);
    } catch (error) {
      message.error('权限更新失败');
    } finally {
      setLoading(false);
    }
  };

  const groupMenuItems = mapToGroupMenuItem(groupItems);
  const groupPermissions = getGroupPermissions(selectedGroup?.name);

  return (
    <Modal
      title={`编辑 "${currentRow?.name}" 的权限`}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
      width={900}
      confirmLoading={loading}
      okText="确认"
      cancelText="取消"
      destroyOnClose
    >
      <Row gutter={16} style={{ minHeight: '400px' }}>
        <Col span={8}>
          <div style={{ border: '1px solid #d9d9d9', borderRadius: '6px', padding: '16px' }}>
            <div style={{ fontWeight: 'bold', marginBottom: '16px', borderBottom: '1px solid #f0f0f0', paddingBottom: '8px' }}>
              权限组
            </div>
            <Menu
              mode="vertical"
              items={groupMenuItems}
              onClick={handleGroupClick}
              selectedKeys={selectedGroup?.name === undefined ? undefined : [selectedGroup?.name]}
              style={{ border: 'none' }}
            />
          </div>
        </Col>
        <Col span={16}>
          <div style={{ border: '1px solid #d9d9d9', borderRadius: '6px', padding: '16px' }}>
            <div style={{ fontWeight: 'bold', marginBottom: '16px', borderBottom: '1px solid #f0f0f0', paddingBottom: '8px' }}>
              权限
            </div>
            <Checkbox
              name={selectedGroup?.name}
              checked={isAllGranted(selectedGroup?.name)}
              onChange={handleGrantAll}
            >
              全选
            </Checkbox>
            <Divider />
            <List
              itemLayout="vertical"
              dataSource={groupPermissions}
              renderItem={(item) => {
                const childPermissions = getChildPermissions(item.name);
                return (
                  <List.Item>
                    <Checkbox
                      key={item.name}
                      name={item.name}
                      title={item.name}
                      checked={item.isGranted}
                      onChange={handlePermissionChange}
                    >
                      {item.displayName}
                    </Checkbox>
                    {childPermissions && childPermissions.length > 0 && (
                      <div style={{ paddingLeft: '32px', paddingTop: '8px' }}>
                        <List
                          grid={{ gutter: 16, column: 4 }}
                          dataSource={childPermissions}
                          renderItem={(child) => (
                            <List.Item>
                              <Checkbox
                                key={child.name}
                                title={child.name}
                                name={child.name}
                                checked={child.isGranted}
                                onChange={handlePermissionChange}
                              >
                                {child.displayName}
                              </Checkbox>
                            </List.Item>
                          )}
                        />
                      </div>
                    )}
                  </List.Item>
                );
              }}
            />
          </div>
        </Col>
      </Row>
    </Modal>
  );
});

export default PermissionForm;
