import { PlayCircle, Brain, MessageSquare, FileSearch } from 'lucide-react';

interface NodePanelProps {
  onAddNode: (type: string) => void;
}

const nodeTypes = [
  {
    type: 'text-analysis',
    label: '文本分析',
    description: '使用AI分析文本',
    icon: Brain,
    color: 'bg-blue-100 text-blue-600 hover:bg-blue-200',
  },
  {
    type: 'user-input',
    label: '用户输入',
    description: '等待用户输入',
    icon: MessageSquare,
    color: 'bg-purple-100 text-purple-600 hover:bg-purple-200',
  },
  {
    type: 'file-select',
    label: '文件选择',
    description: '选择文件',
    icon: FileSearch,
    color: 'bg-orange-100 text-orange-600 hover:bg-orange-200',
  },
];

export function NodePanel({ onAddNode }: NodePanelProps) {
  const onDragStart = (event: React.DragEvent, nodeType: string) => {
    event.dataTransfer.setData('application/reactflow', nodeType);
    event.dataTransfer.effectAllowed = 'move';
  };

  return (
    <div className="w-64 bg-card border-r border-border p-4 overflow-y-auto">
      <h3 className="text-sm font-semibold text-foreground mb-4">节点类型</h3>
      
      {/* 开始节点（不可拖拽，已存在） */}
      <div className="mb-4">
        <div className="text-xs text-muted-foreground mb-2">流程控制</div>
        <div className="p-3 rounded-lg bg-green-100 text-green-600 opacity-50 cursor-not-allowed">
          <div className="flex items-center gap-2">
            <PlayCircle className="w-4 h-4" />
            <span className="text-sm font-medium">开始</span>
          </div>
          <div className="text-xs mt-1 opacity-70">每个流程只能有一个</div>
        </div>
      </div>

      {/* 可添加的节点 */}
      <div>
        <div className="text-xs text-muted-foreground mb-2">拖拽添加节点</div>
        <div className="space-y-2">
          {nodeTypes.map((node) => {
            const Icon = node.icon;
            return (
              <div
                key={node.type}
                draggable
                onDragStart={(e) => onDragStart(e, node.type)}
                onClick={() => onAddNode(node.type)}
                className={`p-3 rounded-lg cursor-grab active:cursor-grabbing transition-colors ${node.color}`}
              >
                <div className="flex items-center gap-2">
                  <Icon className="w-4 h-4" />
                  <span className="text-sm font-medium">{node.label}</span>
                </div>
                <div className="text-xs mt-1 opacity-70">{node.description}</div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
