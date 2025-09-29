const BASE_URL = 'http://localhost:8080/api';

// Get JWT token from localStorage
const getAuthToken = (): string | null => {
  return localStorage.getItem('token');
};

// Common headers
const getHeaders = (includeAuth: boolean = true) => {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  };
  
  if (includeAuth) {
    const token = getAuthToken();
    if (token) {
      headers.Authorization = `Bearer ${token}`;
    }
  }
  
  return headers;
};

// Generic API request handler
const apiRequest = async <T>(
  endpoint: string,
  options: RequestInit = {},
  includeAuth: boolean = true
): Promise<T> => {
  const url = `${BASE_URL}${endpoint}`;
  const config: RequestInit = {
    ...options,
    headers: {
      ...getHeaders(includeAuth),
      ...options.headers,
    },
  };

  const response = await fetch(url, config);

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`HTTP ${response.status}: ${errorMessage}`);
  }

  // Handle empty responses (like DELETE operations)
  if (response.status === 204 || response.headers.get('content-length') === '0') {
    return {} as T;
  }

  return response.json();
};

export { apiRequest, getAuthToken, BASE_URL };