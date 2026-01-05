import { Handle, Position } from '@xyflow/react';
import { FileSearch } from 'lucide-react';
import type { FileSelectNodeData } from '@/types/ai/workflow';

interface FileSelectNodeProps {
  data: FileSelectNodeData;
  selected?: boolean;
}

export function FileSelectNode({ data, selected }: FileSelectNodeProps) {
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-orange-50 min-w-[180px] ${
        selected ? 'border-orange-500 shadow-lg' : 'border-orange-300'
      }`}
    >
      <Handle type="target" position={Position.Top} className="!bg-orange-500" />
      <div className="flex items-center gap-2">
        <FileSearch className="w-5 h-5 text-orange-600" />
        <div>
          <div className="font-medium text-orange-800">{data.name}</div>
          <div className="text-xs text-orange-600">{data.description}</div>
        </div>
      </div>
      <Handle type="source" position={Position.Bottom} className="!bg-orange-500" />
    </div>
  );
}
