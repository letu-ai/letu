import { Handle, Position, type NodeProps } from '@xyflow/react';
import type { WorkflowNode, StartNodeData } from '@/types/ai/workflow';
import { Play, Upload, FolderOpen, Cpu } from 'lucide-react';

/**
 * 开始节点组件
 */
export function StartNode({ data, selected }: NodeProps<WorkflowNode>) {
  const nodeData = data as StartNodeData;
  const directoryFileInputs = nodeData.directoryFileInputs || [];
  const uploadFileInputs = nodeData.uploadFileInputs || [];
  const requireModel = nodeData.requireModel !== false; // 默认为true
  
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-green-900/30 min-w-[200px] ${
        selected ? 'border-green-500 shadow-lg shadow-green-500/50' : 'border-green-700/50'
      }`}
    >
      <div className="flex items-center gap-2 mb-2">
        <Play className="w-4 h-4 text-green-400" />
        <div className="font-semibold text-green-300">{nodeData.name}</div>
      </div>
      
      {nodeData.description && (
        <div className="text-xs text-gray-400 mb-2">{nodeData.description}</div>
      )}
      
      {/* 显示入口配置 */}
      <div className="text-xs text-gray-400 space-y-1">
        <div className="font-medium text-gray-300 mb-1">入口配置:</div>
        {directoryFileInputs.length > 0 && (
          <div className="ml-2 flex items-center gap-1">
            <FolderOpen className="w-3 h-3" />
            <span>目录选择: {directoryFileInputs.length}个</span>
          </div>
        )}
        {uploadFileInputs.length > 0 && (
          <div className="ml-2 flex items-center gap-1">
            <Upload className="w-3 h-3" />
            <span>文件上传: {uploadFileInputs.length}个</span>
          </div>
        )}
        {requireModel && (
          <div className="ml-2 flex items-center gap-1">
            <Cpu className="w-3 h-3" />
            <span>需要选择模型</span>
          </div>
        )}
        {directoryFileInputs.length === 0 && uploadFileInputs.length === 0 && (
          <div className="ml-2 text-yellow-500">⚠️ 未配置输入项</div>
        )}
        <div className="mt-2 pt-2 border-t border-gray-700/50">
          <div className="font-medium text-gray-300 mb-1">输出变量:</div>
          {directoryFileInputs.length === 0 && uploadFileInputs.length === 0 ? (
            <div className="ml-2 text-gray-500">无</div>
          ) : (
            <>
              {directoryFileInputs.map((input) => (
                <div key={input.variableName} className="ml-2">• {input.variableName}</div>
              ))}
              {uploadFileInputs.map((input) => (
                <div key={input.variableName} className="ml-2">• {input.variableName}</div>
              ))}
            </>
          )}
        </div>
      </div>

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

