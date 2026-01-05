import { Handle, Position, type NodeProps } from '@xyflow/react';
import type { WorkflowNode, UserInputNodeData } from '@/types/ai/workflow';
import { MessageSquare } from 'lucide-react';

/**
 * 用户输入节点组件
 */
export function UserInputNode({ data, selected }: NodeProps<WorkflowNode>) {
  const nodeData = data as UserInputNodeData;
  
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-purple-900/30 min-w-[200px] ${
        selected ? 'border-purple-500 shadow-lg shadow-purple-500/50' : 'border-purple-700/50'
      }`}
    >
      <Handle 
        type="target" 
        position={Position.Left} 
        className="!w-6 !h-6 !bg-purple-500 hover:!bg-purple-400 hover:!shadow-lg transition-all cursor-crosshair !border-2 !border-gray-800 !shadow-md"
        style={{ 
          borderRadius: '50%',
        }}
      />
      
      <div className="flex items-center gap-2 mb-2">
        <MessageSquare className="w-4 h-4 text-purple-400" />
        <div className="font-semibold text-purple-300">{nodeData.name}</div>
      </div>
      
      {nodeData.description && (
        <div className="text-xs text-gray-400 mb-2">{nodeData.description}</div>
      )}
      
      {nodeData.prompt && (
        <div className="text-xs text-gray-300 bg-gray-800/50 p-2 rounded border border-gray-700 max-w-[250px]">
          <div className="font-medium mb-1">提示用户:</div>
          <div className="line-clamp-2">{nodeData.prompt}</div>
        </div>
      )}

      <Handle 
        type="source" 
        position={Position.Right} 
        className="!w-6 !h-6 !bg-purple-500 hover:!bg-purple-400 hover:!shadow-lg transition-all cursor-crosshair !border-2 !border-gray-800 !shadow-md"
        style={{ 
          borderRadius: '50%',
        }}
      />
    </div>
  );
}

