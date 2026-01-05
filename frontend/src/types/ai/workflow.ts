import type { Node, Edge } from '@xyflow/react';

// ==================== 节点数据类型 ====================

// 基础节点数据接口
export interface BaseNodeData {
  name: string;
  description: string;
  [key: string]: unknown; // 索引签名，用于兼容 React Flow 的 Node 类型
}

// 目录文件选择输入配置
export interface DirectoryFileInput {
  variableName: string;  // 输出变量名
  label: string;         // 显示名称
  directoryId?: string;  // 目录ID
  directoryName?: string; // 目录名称（用于显示）
}

// 文件上传输入配置
export interface UploadFileInput {
  variableName: string;  // 输出变量名
  label: string;         // 显示名称
  accept?: string;       // 接受的文件类型（如 '.pdf', '.pdf,.docx'）
}

// 开始节点数据
export interface StartNodeData extends BaseNodeData {
  type: 'start';
  directoryFileInputs?: DirectoryFileInput[];  // 从目录选择文件配置（0~3个）
  uploadFileInputs?: UploadFileInput[];       // 文件上传配置（0~2个）
  requireModel?: boolean;                     // 是否需要选择模型（默认true）
}

// 文本分析节点数据
export interface TextAnalysisNodeData extends BaseNodeData {
  type: 'text-analysis';
  systemPrompt: string;      // 系统提示词，可包含 {{变量名}} 占位符
  inputVariables: string[];  // 引用的输入变量名列表
}

// 等待用户输入节点数据
export interface UserInputNodeData extends BaseNodeData {
  type: 'user-input';
  prompt?: string;      // 提示用户输入的文本，可包含 {{变量名}} 占位符
}

// 文件选择节点数据
export interface FileSelectNodeData extends BaseNodeData {
  type: 'file-select';
  mode: 'file' | 'directory';  // 工作模式：直接选择文件 或 从目录选择
  fileId?: string;             // 设计时选择的文件ID（mode='file'时使用）
  directoryId?: string;         // 选择的目录ID（mode='directory'时使用）
  directoryName?: string;      // 选择的目录名称（mode='directory'时使用，用于显示）
  prompt?: string;             // 提示用户选择文件的文本（mode='directory'时使用，可包含 {{变量名}} 占位符）
}

// 节点数据联合类型
export type WorkflowNodeData = StartNodeData | TextAnalysisNodeData | UserInputNodeData | FileSelectNodeData;

// 节点类型
export type WorkflowNodeType = 'start' | 'text-analysis' | 'user-input' | 'file-select';

// React Flow 节点类型
export type WorkflowNode = Node<WorkflowNodeData>;

// ==================== 变量系统 ====================

// 变量类型
export type VariableType = 'file' | 'text';

// 变量定义
export interface Variable {
  name: string;           // 变量名（通常是节点名称）
  type: VariableType;     // 变量类型
  nodeId: string;         // 来源节点ID
  nodeType: WorkflowNodeType; // 来源节点类型
  description: string;    // 变量描述
}

// 变量上下文（执行时的变量存储）
export interface VariableContext {
  [varName: string]: any;
}

// ==================== 流程数据结构 ====================

// React Flow 完整数据
export interface FlowData {
  nodes: WorkflowNode[];
  edges: Edge[];
  viewport?: {
    x: number;
    y: number;
    zoom: number;
  };
}

