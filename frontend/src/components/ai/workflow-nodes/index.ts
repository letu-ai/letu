import { StartNode } from './StartNode';
import { TextAnalysisNode } from './TextAnalysisNode';
import { UserInputNode } from './UserInputNode';
import { FileSelectNode } from './FileSelectNode';
import type { NodeTypes } from '@xyflow/react';

/**
 * 节点类型映射
 * 用于React Flow的nodeTypes prop
 */
export const nodeTypes = {
  start: StartNode,
  'text-analysis': TextAnalysisNode,
  'user-input': UserInputNode,
  'file-select': FileSelectNode,
} as NodeTypes;

export { StartNode, TextAnalysisNode, UserInputNode, FileSelectNode };

