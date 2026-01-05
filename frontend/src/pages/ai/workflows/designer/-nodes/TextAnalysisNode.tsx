import { Handle, Position } from '@xyflow/react';
import { Brain } from 'lucide-react';
import type { TextAnalysisNodeData } from '@/types/ai/workflow';

interface TextAnalysisNodeProps {
  data: TextAnalysisNodeData;
  selected?: boolean;
}

export function TextAnalysisNode({ data, selected }: TextAnalysisNodeProps) {
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-blue-50 min-w-[180px] ${
        selected ? 'border-blue-500 shadow-lg' : 'border-blue-300'
      }`}
    >
      <Handle type="target" position={Position.Top} className="!bg-blue-500" />
      <div className="flex items-center gap-2">
        <Brain className="w-5 h-5 text-blue-600" />
        <div>
          <div className="font-medium text-blue-800">{data.name}</div>
          <div className="text-xs text-blue-600">{data.description}</div>
        </div>
      </div>
      <Handle type="source" position={Position.Bottom} className="!bg-blue-500" />
    </div>
  );
}
