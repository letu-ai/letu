import { Input, Button } from 'antd';
import { DeleteOutlined } from '@ant-design/icons';
import type { WorkflowNode, WorkflowNodeData } from '@/types/ai/workflow';

const { TextArea } = Input;

interface PropertyPanelProps {
  selectedNode: WorkflowNode | null;
  onUpdateNode: (nodeId: string, data: Partial<WorkflowNodeData>) => void;
  onDeleteNode: (nodeId: string) => void;
}

export function PropertyPanel({ selectedNode, onUpdateNode, onDeleteNode }: PropertyPanelProps) {
  if (!selectedNode) {
    return (
      <div className="w-80 bg-card border-l border-border p-4">
        <div className="text-sm text-muted-foreground text-center py-8">
          选择一个节点以编辑其属性
        </div>
      </div>
    );
  }

  const { data } = selectedNode;

  return (
    <div className="w-80 bg-card border-l border-border p-4 overflow-y-auto">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-sm font-semibold text-foreground">节点属性</h3>
        {data.type !== 'start' && (
          <Button
            type="text"
            danger
            size="small"
            icon={<DeleteOutlined />}
            onClick={() => onDeleteNode(selectedNode.id)}
          >
            删除
          </Button>
        )}
      </div>

      <div className="space-y-4">
        {/* 通用属性 */}
        <div>
          <label className="block text-xs text-muted-foreground mb-1">节点名称</label>
          <Input
            value={data.name}
            onChange={(e) => onUpdateNode(selectedNode.id, { name: e.target.value })}
            placeholder="输入节点名称"
          />
        </div>

        <div>
          <label className="block text-xs text-muted-foreground mb-1">描述</label>
          <Input
            value={data.description}
            onChange={(e) => onUpdateNode(selectedNode.id, { description: e.target.value })}
            placeholder="输入描述"
          />
        </div>

        {/* 文本分析节点属性 */}
        {data.type === 'text-analysis' && (
          <div>
            <label className="block text-xs text-muted-foreground mb-1">系统提示词</label>
            <TextArea
              value={data.systemPrompt}
              onChange={(e) => onUpdateNode(selectedNode.id, { systemPrompt: e.target.value })}
              placeholder="输入系统提示词，可使用 {{变量名}} 引用变量"
              rows={4}
            />
          </div>
        )}

        {/* 用户输入节点属性 */}
        {data.type === 'user-input' && (
          <div>
            <label className="block text-xs text-muted-foreground mb-1">提示文本</label>
            <TextArea
              value={data.prompt || ''}
              onChange={(e) => onUpdateNode(selectedNode.id, { prompt: e.target.value })}
              placeholder="提示用户输入的文本"
              rows={3}
            />
          </div>
        )}

        {/* 文件选择节点属性 */}
        {data.type === 'file-select' && (
          <>
            <div>
              <label className="block text-xs text-muted-foreground mb-1">工作模式</label>
              <div className="flex gap-2">
                <Button
                  type={data.mode === 'file' ? 'primary' : 'default'}
                  size="small"
                  onClick={() => onUpdateNode(selectedNode.id, { mode: 'file' })}
                >
                  选择文件
                </Button>
                <Button
                  type={data.mode === 'directory' ? 'primary' : 'default'}
                  size="small"
                  onClick={() => onUpdateNode(selectedNode.id, { mode: 'directory' })}
                >
                  从目录选
                </Button>
              </div>
            </div>
            {data.mode === 'directory' && (
              <div>
                <label className="block text-xs text-muted-foreground mb-1">提示文本</label>
                <TextArea
                  value={data.prompt || ''}
                  onChange={(e) => onUpdateNode(selectedNode.id, { prompt: e.target.value })}
                  placeholder="提示用户选择文件的文本"
                  rows={2}
                />
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}
