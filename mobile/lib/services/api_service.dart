import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

/// Convex API service for backend integration
/// Note: This is a simplified implementation. In a real app, you'd use
/// Convex's official Dart client when available.
class ConvexService {
  static const String _baseUrl = 'YOUR_CONVEX_URL_HERE'; // Replace with actual Convex URL
  
  final http.Client _client = http.Client();
  
  // Headers for authenticated requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    // Add authentication headers here when implementing auth
    // 'Authorization': 'Bearer $token',
  };

  /// User operations
  Future<ApiResponse<User?>> getUser(String userId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/users:getUser'),
        headers: _headers,
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data == null) {
          return ApiResponse.success(null);
        }
        return ApiResponse.success(User.fromJson(data));
      } else {
        return ApiResponse.error('Failed to fetch user');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<void>> syncUser({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/users:syncUser'),
        headers: _headers,
        body: jsonEncode({
          'userId': userId,
          'email': email,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to sync user');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Snippet operations
  Future<ApiResponse<List<CodeSnippet>>> getSnippets() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:getSnippets'),
        headers: _headers,
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final snippets = data.map((json) => CodeSnippet.fromJson(json)).toList();
        return ApiResponse.success(snippets);
      } else {
        return ApiResponse.error('Failed to fetch snippets');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<CodeSnippet>> getSnippetById(String snippetId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:getSnippetById'),
        headers: _headers,
        body: jsonEncode({'snippetId': snippetId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(CodeSnippet.fromJson(data));
      } else {
        return ApiResponse.error('Failed to fetch snippet');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<String>> createSnippet({
    required String title,
    required String language,
    required String code,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:createSnippet'),
        headers: _headers,
        body: jsonEncode({
          'title': title,
          'language': language,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data as String);
      } else {
        return ApiResponse.error('Failed to create snippet');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<void>> deleteSnippet(String snippetId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:deleteSnippet'),
        headers: _headers,
        body: jsonEncode({'snippetId': snippetId}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to delete snippet');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<void>> starSnippet(String snippetId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:starSnippet'),
        headers: _headers,
        body: jsonEncode({'snippetId': snippetId}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to star snippet');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<bool>> isSnippetStarred(String snippetId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:isSnippetStarred'),
        headers: _headers,
        body: jsonEncode({'snippetId': snippetId}),
      );

      if (response.statusCode == 200) {
        final bool isStarred = jsonDecode(response.body) as bool;
        return ApiResponse.success(isStarred);
      } else {
        return ApiResponse.error('Failed to check star status');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<int>> getSnippetStarCount(String snippetId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:getSnippetStarCount'),
        headers: _headers,
        body: jsonEncode({'snippetId': snippetId}),
      );

      if (response.statusCode == 200) {
        final int count = jsonDecode(response.body) as int;
        return ApiResponse.success(count);
      } else {
        return ApiResponse.error('Failed to get star count');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Comment operations
  Future<ApiResponse<List<SnippetComment>>> getComments(String snippetId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:getComments'),
        headers: _headers,
        body: jsonEncode({'snippetId': snippetId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final comments = data.map((json) => SnippetComment.fromJson(json)).toList();
        return ApiResponse.success(comments);
      } else {
        return ApiResponse.error('Failed to fetch comments');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<String>> addComment({
    required String snippetId,
    required String content,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:addComment'),
        headers: _headers,
        body: jsonEncode({
          'snippetId': snippetId,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data as String);
      } else {
        return ApiResponse.error('Failed to add comment');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<void>> deleteComment(String commentId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/snippets:deleteComment'),
        headers: _headers,
        body: jsonEncode({'commentId': commentId}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error('Failed to delete comment');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Code execution service using Piston API
class CodeExecutionService {
  static const String _pistonUrl = 'https://emkc.org/api/v2/piston';
  final http.Client _client = http.Client();

  Future<ApiResponse<CodeExecution>> executeCode({
    required String language,
    required String version,
    required String code,
    List<String>? args,
    String? stdin,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_pistonUrl/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': language,
          'version': version,
          'files': [
            {
              'content': code,
            }
          ],
          'args': args ?? [],
          'stdin': stdin ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final run = data['run'];
        
        final execution = CodeExecution(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'current-user', // Replace with actual user ID
          language: language,
          code: code,
          output: run['stdout']?.toString(),
          error: run['stderr']?.toString(),
          createdAt: DateTime.now(),
        );

        return ApiResponse.success(execution);
      } else {
        return ApiResponse.error('Failed to execute code');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getAvailableLanguages() async {
    try {
      final response = await _client.get(
        Uri.parse('$_pistonUrl/runtimes'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return ApiResponse.success(data.cast<Map<String, dynamic>>());
      } else {
        return ApiResponse.error('Failed to fetch languages');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}