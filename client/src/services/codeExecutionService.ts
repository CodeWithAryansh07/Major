import { apiRequest } from './api';

export interface CodeExecutionRequest {
  language: string;
  version: string;
  files: Array<{
    name?: string;
    content: string;
  }>;
  stdin?: string;
  args?: string[];
  compile_timeout?: number;
  run_timeout?: number;
}

export interface CodeExecutionResult {
  language: string;
  version: string;
  run: {
    stdout: string;
    stderr: string;
    code: number;
    signal?: string;
  };
  compile?: {
    stdout: string;
    stderr: string;
    code: number;
    signal?: string;
  };
}

export const codeExecutionService = {
  executeCode: async (request: CodeExecutionRequest): Promise<CodeExecutionResult> => {
    return await apiRequest<CodeExecutionResult>('/execute', {
      method: 'POST',
      body: JSON.stringify(request),
    });
  },

  // Get supported languages
  getSupportedLanguages: async (): Promise<string[]> => {
    // This would be implemented if the backend provides language info
    // For now, return common languages
    return [
      'javascript',
      'python',
      'java',
      'cpp',
      'c',
      'csharp',
      'go',
      'rust',
      'typescript',
      'php',
      'ruby',
      'swift',
      'kotlin',
      'scala'
    ];
  }
};