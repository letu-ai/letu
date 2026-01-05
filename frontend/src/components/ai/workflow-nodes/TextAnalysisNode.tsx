import { Handle, Position, type NodeProps } from '@xyflow/react';
import type { WorkflowNode, TextAnalysisNodeData } from '@/types/ai/workflow';
import { Brain } from 'lucide-react';

/**
 * 文本分析节点组件
 */
export function TextAnalysisNode({ data, selected }: NodeProps<WorkflowNode>) {
  const nodeData = data as TextAnalysisNodeData;
  
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-blue-900/30 min-w-[200px] ${
        selected ? 'border-blue-500 shadow-lg shadow-blue-500/50' : 'border-blue-700/50'
      }`}
    >
      <Handle 
        type="target" 
        position={Position.Left} 
        className="!w-6 !h-6 !bg-blue-500 hover:!bg-blue-400 hover:!shadow-lg transition-all cursor-crosshair !border-2 !border-gray-800 !shadow-md"
        style={{ 
          borderRadius: '50%',
        }}
      />
      
      <div className="flex items-center gap-2 mb-2">
        <Brain className="w-4 h-4 text-blue-400" />
        <div className="font-semibold text-blue-300">{nodeData.name}</div>
      </div>
      
      {nodeData.description && (
        <div className="text-xs text-gray-400 mb-2">{nodeData.description}</div>
      )}
      
      {nodeData.inputVariables && nodeData.inputVariables.length > 0 && (
        <div className="text-xs text-gray-400 space-y-1 mb-2">
          <div>输入变量:</div>
          {nodeData.inputVariables.map((varName) => (
            <div key={varName} className="ml-2">• {varName}</div>
          ))}
        </div>
      )}
      
      {nodeData.systemPrompt && (
        <div className="text-xs text-gray-300 bg-gray-800/50 p-2 rounded border border-gray-700 max-w-[250px]">
          <div className="font-medium mb-1">提示词:</div>
          <div className="line-clamp-2">{nodeData.systemPrompt}</div>
        </div>
      )}

      <Handle 
        type="source" 
        position={Position.Right} 
        className="!w-6 !h-6 !bg-blue-500 hover:!bg-blue-400 hover:!shadow-lg transition-all cursor-crosshair !border-2 !border-gray-800 !shadow-md"
        style={{ 
          borderRadius: '50%',
        }}
      />
    </div>
  );
}

