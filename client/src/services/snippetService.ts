import { apiRequest } from './api';

export interface Snippet {
  id?: string;
  title: string;
  code: string;
  language: string;
  description?: string;
  tags?: string[];
  isPublic: boolean;
  userId?: string;
  stars?: string[];
  createdAt?: string;
  updatedAt?: string;
}

export interface PageResponse<T> {
  content: T[];
  pageable: {
    pageNumber: number;
    pageSize: number;
    sort: {
      sorted: boolean;
      ascending: boolean;
    };
  };
  totalElements: number;
  totalPages: number;
  last: boolean;
  first: boolean;
  numberOfElements: number;
  size: number;
  number: number;
  sort: {
    sorted: boolean;
    ascending: boolean;
  };
}

export const snippetService = {
  // Get public snippets with pagination
  getPublicSnippets: async (
    page: number = 0,
    size: number = 20,
    sortBy: string = 'createdAt',
    sortDir: string = 'desc'
  ): Promise<PageResponse<Snippet>> => {
    return await apiRequest<PageResponse<Snippet>>(
      `/snippets/public?page=${page}&size=${size}&sortBy=${sortBy}&sortDir=${sortDir}`,
      { method: 'GET' },
      false
    );
  },

  // Search snippets
  searchSnippets: async (
    query: string,
    page: number = 0,
    size: number = 20
  ): Promise<PageResponse<Snippet>> => {
    return await apiRequest<PageResponse<Snippet>>(
      `/snippets/search?q=${encodeURIComponent(query)}&page=${page}&size=${size}`,
      { method: 'GET' },
      false
    );
  },

  // Get snippet by ID
  getSnippet: async (id: string): Promise<Snippet> => {
    return await apiRequest<Snippet>(`/snippets/${id}`, { method: 'GET' }, false);
  },

  // Get user's snippets (requires auth)
  getMySnippets: async (): Promise<Snippet[]> => {
    return await apiRequest<Snippet[]>('/snippets/my', { method: 'GET' });
  },

  // Get starred snippets (requires auth)
  getStarredSnippets: async (): Promise<Snippet[]> => {
    return await apiRequest<Snippet[]>('/snippets/starred', { method: 'GET' });
  },

  // Create snippet (requires auth)
  createSnippet: async (snippet: Omit<Snippet, 'id' | 'userId' | 'createdAt' | 'updatedAt'>): Promise<Snippet> => {
    return await apiRequest<Snippet>('/snippets', {
      method: 'POST',
      body: JSON.stringify(snippet),
    });
  },

  // Update snippet (requires auth)
  updateSnippet: async (id: string, snippet: Partial<Snippet>): Promise<Snippet> => {
    return await apiRequest<Snippet>(`/snippets/${id}`, {
      method: 'PUT',
      body: JSON.stringify(snippet),
    });
  },

  // Delete snippet (requires auth)
  deleteSnippet: async (id: string): Promise<void> => {
    return await apiRequest<void>(`/snippets/${id}`, { method: 'DELETE' });
  },

  // Toggle star (requires auth)
  toggleStar: async (id: string): Promise<Snippet> => {
    return await apiRequest<Snippet>(`/snippets/${id}/star`, { method: 'POST' });
  }
};