/// User model matching Convex schema
class User {
  final String id;
  final String userId; // clerkId
  final String email;
  final String name;
  final bool isPro;
  final DateTime? proSince;
  final String? lemonSqueezyCustomerId;
  final String? lemonSqueezyOrderId;

  const User({
    required this.id,
    required this.userId,
    required this.email,
    required this.name,
    required this.isPro,
    this.proSince,
    this.lemonSqueezyCustomerId,
    this.lemonSqueezyOrderId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isPro: json['isPro'] as bool,
      proSince: json['proSince'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['proSince'] as int)
          : null,
      lemonSqueezyCustomerId: json['lemonSqueezyCustomerId'] as String?,
      lemonSqueezyOrderId: json['lemonSqueezyOrderId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'email': email,
      'name': name,
      'isPro': isPro,
      'proSince': proSince?.millisecondsSinceEpoch,
      'lemonSqueezyCustomerId': lemonSqueezyCustomerId,
      'lemonSqueezyOrderId': lemonSqueezyOrderId,
    };
  }
}

/// Code snippet model matching Convex schema
class CodeSnippet {
  final String id;
  final String userId;
  final String title;
  final String language;
  final String code;
  final String userName;
  final DateTime? createdAt;
  final int starCount;
  final bool isStarred;

  const CodeSnippet({
    required this.id,
    required this.userId,
    required this.title,
    required this.language,
    required this.code,
    required this.userName,
    this.createdAt,
    this.starCount = 0,
    this.isStarred = false,
  });

  factory CodeSnippet.fromJson(Map<String, dynamic> json) {
    return CodeSnippet(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      language: json['language'] as String,
      code: json['code'] as String,
      userName: json['userName'] as String,
      createdAt: json['_creationTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['_creationTime'] as int)
          : null,
      starCount: json['starCount'] as int? ?? 0,
      isStarred: json['isStarred'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'language': language,
      'code': code,
      'userName': userName,
      '_creationTime': createdAt?.millisecondsSinceEpoch,
    };
  }

  CodeSnippet copyWith({
    String? id,
    String? userId,
    String? title,
    String? language,
    String? code,
    String? userName,
    DateTime? createdAt,
    int? starCount,
    bool? isStarred,
  }) {
    return CodeSnippet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      language: language ?? this.language,
      code: code ?? this.code,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      starCount: starCount ?? this.starCount,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

/// Comment model matching Convex schema
class SnippetComment {
  final String id;
  final String snippetId;
  final String userId;
  final String userName;
  final String content;
  final DateTime? createdAt;

  const SnippetComment({
    required this.id,
    required this.snippetId,
    required this.userId,
    required this.userName,
    required this.content,
    this.createdAt,
  });

  factory SnippetComment.fromJson(Map<String, dynamic> json) {
    return SnippetComment(
      id: json['_id'] as String,
      snippetId: json['snippetId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      content: json['content'] as String,
      createdAt: json['_creationTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['_creationTime'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'snippetId': snippetId,
      'userId': userId,
      'userName': userName,
      'content': content,
      '_creationTime': createdAt?.millisecondsSinceEpoch,
    };
  }
}

/// Code execution result model
class CodeExecution {
  final String id;
  final String userId;
  final String language;
  final String code;
  final String? output;
  final String? error;
  final DateTime? createdAt;

  const CodeExecution({
    required this.id,
    required this.userId,
    required this.language,
    required this.code,
    this.output,
    this.error,
    this.createdAt,
  });

  factory CodeExecution.fromJson(Map<String, dynamic> json) {
    return CodeExecution(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      language: json['language'] as String,
      code: json['code'] as String,
      output: json['output'] as String?,
      error: json['error'] as String?,
      createdAt: json['_creationTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['_creationTime'] as int)
          : null,
    );
  }

  bool get hasError => error != null && error!.isNotEmpty;
  bool get hasOutput => output != null && output!.isNotEmpty;
}

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? message;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.message,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String error, {String? message}) {
    return ApiResponse(
      success: false,
      error: error,
      message: message,
    );
  }
}