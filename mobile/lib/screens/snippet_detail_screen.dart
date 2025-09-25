import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/language_config.dart';
import '../core/theme/app_theme.dart';
import '../models/app_models.dart';

class SnippetDetailScreen extends StatefulWidget {
  final CodeSnippet snippet;

  const SnippetDetailScreen({
    super.key,
    required this.snippet,
  });

  @override
  State<SnippetDetailScreen> createState() => _SnippetDetailScreenState();
}

class _SnippetDetailScreenState extends State<SnippetDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<SnippetComment> _comments = [];
  bool _isStarred = false;
  int _starCount = 0;

  @override
  void initState() {
    super.initState();
    _isStarred = widget.snippet.isStarred;
    _starCount = widget.snippet.starCount;
    _loadComments();
  }

  void _loadComments() {
    // Sample comments - in real app, load from API
    _comments = [
      SnippetComment(
        id: '1',
        snippetId: widget.snippet.id,
        userId: 'user1',
        userName: 'Alice Johnson',
        content: 'Great example! This really helped me understand the concept.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SnippetComment(
        id: '2',
        snippetId: widget.snippet.id,
        userId: 'user2',
        userName: 'Bob Smith',
        content: 'Clean and efficient code. Thanks for sharing!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.snippet.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleStar() {
    setState(() {
      _isStarred = !_isStarred;
      _starCount += _isStarred ? 1 : -1;
    });
    
    // TODO: Call API to star/unstar snippet
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    
    final comment = SnippetComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      snippetId: widget.snippet.id,
      userId: 'current-user',
      userName: 'Current User',
      content: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _comments.insert(0, comment);
      _commentController.clear();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = SupportedLanguages.getLanguage(widget.snippet.language);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.backgroundSecondary.withOpacity(0.9),
            elevation: 0,
            pinned: true,
            expandedHeight: 120,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              color: AppColors.textSecondary,
            ),
            actions: [
              IconButton(
                onPressed: _copyCode,
                icon: const Icon(Icons.copy),
                color: AppColors.textSecondary,
                tooltip: 'Copy code',
              ),
              IconButton(
                onPressed: _toggleStar,
                icon: Icon(_isStarred ? Icons.star : Icons.star_outline),
                color: _isStarred ? AppColors.amberAccent : AppColors.textSecondary,
                tooltip: _isStarred ? 'Unstar' : 'Star',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.snippet.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Snippet info
                  _buildSnippetInfo(language),
                  const SizedBox(height: 16),
                  
                  // Code block
                  _buildCodeBlock(),
                  const SizedBox(height: 24),
                  
                  // Comments section
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnippetInfo(LanguageConfig language) {
    return GlassMorphism(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.blueAccent.withOpacity(0.2),
                  child: Text(
                    widget.snippet.userName.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snippet.userName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (widget.snippet.createdAt != null)
                        Text(
                          _formatDate(widget.snippet.createdAt!),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Language tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.blueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    language.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Stats
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: AppColors.amberAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_starCount stars',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.comment,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_comments.length} comments',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBlock() {
    return GlassMorphism(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderAccent,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Source Code',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _copyCode,
                  icon: const Icon(Icons.copy, size: 16),
                  color: AppColors.textTertiary,
                  tooltip: 'Copy code',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          
          // Code content
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 400),
            color: AppColors.monacoBackground,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.snippet.code,
                style: GoogleFonts.firaCode(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.monacoForeground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments (${_comments.length})',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        // Add comment
        GlassMorphism(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  style: GoogleFonts.inter(color: AppColors.textSecondary),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.borderPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _addComment,
                      child: const Text('Add Comment'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Comments list
        ..._comments.map((comment) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCommentCard(comment),
        )).toList(),
        
        if (_comments.isEmpty)
          GlassMorphism(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.comment,
                      size: 48,
                      color: AppColors.textMuted.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No comments yet',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to share your thoughts!',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textMuted.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentCard(SnippetComment comment) {
    return GlassMorphism(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.purpleAccent.withOpacity(0.2),
                  child: Text(
                    comment.userName.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (comment.createdAt != null)
                        Text(
                          _formatDate(comment.createdAt!),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              comment.content,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}