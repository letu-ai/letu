import { Handle, Position } from '@xyflow/react';
import { MessageSquare } from 'lucide-react';
import type { UserInputNodeData } from '@/types/ai/workflow';

interface UserInputNodeProps {
  data: UserInputNodeData;
  selected?: boolean;
}

export function UserInputNode({ data, selected }: UserInputNodeProps) {
  return (
    <div
      className={`px-4 py-3 rounded-lg border-2 bg-purple-50 min-w-[180px] ${
        selected ? 'border-purple-500 shadow-lg' : 'border-purple-300'
      }`}
    >
      <Handle type="target" position={Position.Top} className="!bg-purple-500" />
      <div className="flex items-center gap-2">
        <MessageSquare className="w-5 h-5 text-purple-600" />
        <div>
          <div className="font-medium text-purple-800">{data.name}</div>
          <div className="text-xs text-purple-600">{data.description}</div>
        </div>
      </div>
      <Handle type="source" position={Position.Bottom} className="!bg-purple-500" />
    </div>
  );
}
