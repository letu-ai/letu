import type { WorkflowNode, FileSelectNodeData } from '@/types/ai/workflow';
import { Handle, Position, type NodeProps } from '@xyflow/react';
import { File } from 'lucide-react';

/**
 * 文件选择节点组件
 */
export function FileSelectNode({ data, selected }: NodeProps<WorkflowNode>) {
  const nodeData = data as FileSelectNodeData;
  const mode = nodeData.mode || 'file';
  
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-green-900/30 min-w-[200px] ${
        selected ? 'border-green-500 shadow-lg shadow-green-500/50' : 'border-green-700/50'
      }`}
    >
      <Handle 
        type="target" 
        position={Position.Left} 
        className="!w-6 !h-6 !bg-green-500 hover:!bg-green-400 hover:!shadow-lg transition-all cursor-crosshair !border-2 !border-gray-800 !shadow-md"
        style={{ 
          borderRadius: '50%',
        }}
      />
      
      <div className="flex items-center gap-2 mb-2">
        <File className="w-4 h-4 text-green-400" />
        <div className="font-semibold text-green-300">{nodeData.name || '文件选择'}</div>
      </div>
      
      {nodeData.description && (
        <div className="text-xs text-gray-400 mb-2">{nodeData.description}</div>
      )}
      
      <div className="text-xs text-gray-400 mb-2">
        <div className="font-medium">模式: {mode === 'file' ? '直接选择文件' : '从目录选择'}</div>
        {mode === 'file' && nodeData.fileId && (
          <div className="ml-2 mt-1 text-gray-300">文件ID: {nodeData.fileId}</div>
        )}
        {mode === 'directory' && nodeData.directoryId && (
          <div className="ml-2 mt-1 text-gray-300">目录: {nodeData.directoryName || nodeData.directoryId}</div>
        )}
      </div>
      
      {nodeData.prompt && mode === 'directory' && (
        <div className="text-xs text-gray-300 bg-gray-800/50 p-2 rounded border border-gray-700 max-w-[250px]">
          <div className="font-medium mb-1">提示用户:</div>
          <div className="line-clamp-2">{nodeData.prompt}</div>
        </div>
      )}

      <Handle 
        type="source" 
        position={Position.Right} 
        className="!w-6 !h-6 !bg-green-500 hover:!bg-green-400 hover:!shadow-lg transition-all cursor-crosshair !border-2 !border-gray-800 !shadow-md"
        style={{ 
          borderRadius: '50%',
        }}
      />
    </div>
  );
}

