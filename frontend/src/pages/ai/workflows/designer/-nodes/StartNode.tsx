import { Handle, Position } from '@xyflow/react';
import { PlayCircle } from 'lucide-react';
import type { StartNodeData } from '@/types/ai/workflow';

interface StartNodeProps {
  data: StartNodeData;
  selected?: boolean;
}

export function StartNode({ data, selected }: StartNodeProps) {
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-green-50 min-w-[180px] ${
        selected ? 'border-green-500 shadow-lg' : 'border-green-300'
      }`}
    >
      <div className="flex items-center gap-2">
        <PlayCircle className="w-5 h-5 text-green-600" />
        <div>
          <div className="font-medium text-green-800">{data.name}</div>
          <div className="text-xs text-green-600">{data.description}</div>
        </div>
      </div>
      <Handle type="source" position={Position.Bottom} className="!bg-green-500" />
    </div>
  );
}
