import { apiRequest } from './api';

export interface Comment {
  id?: string;
  content: string;
  snippetId: string;
  userId?: string;
  parentCommentId?: string;
  createdAt?: string;
  updatedAt?: string;
}

export const commentService = {
  // Create a comment
  createComment: async (comment: Omit<Comment, 'id' | 'userId' | 'createdAt' | 'updatedAt'>): Promise<Comment> => {
    return await apiRequest<Comment>('/comments', {
      method: 'POST',
      body: JSON.stringify(comment),
    });
  },

  // Get comments for a snippet
  getCommentsBySnippet: async (snippetId: string): Promise<Comment[]> => {
    return await apiRequest<Comment[]>(`/comments/snippet/${snippetId}`, { method: 'GET' }, false);
  },

  // Reply to a comment
  replyToComment: async (commentId: string, reply: Omit<Comment, 'id' | 'userId' | 'parentCommentId' | 'createdAt' | 'updatedAt'>): Promise<Comment> => {
    return await apiRequest<Comment>(`/comments/${commentId}/reply`, {
      method: 'POST',
      body: JSON.stringify(reply),
    });
  },

  // Get replies to a comment
  getReplies: async (commentId: string): Promise<Comment[]> => {
    return await apiRequest<Comment[]>(`/comments/${commentId}/replies`, { method: 'GET' }, false);
  },

  // Delete a comment
  deleteComment: async (commentId: string): Promise<void> => {
    return await apiRequest<void>(`/comments/${commentId}`, { method: 'DELETE' });
  }
};