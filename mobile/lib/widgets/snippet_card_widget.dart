import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/language_config.dart';
import '../core/theme/app_theme.dart';
import '../models/app_models.dart';

class SnippetCardWidget extends StatelessWidget {
  final CodeSnippet snippet;
  final bool isListView;
  final VoidCallback onTap;

  const SnippetCardWidget({
    super.key,
    required this.snippet,
    this.isListView = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassMorphism(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and star
              Row(
                children: [
                  Expanded(
                    child: Text(
                      snippet.title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStarButton(),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Language and user info
              Row(
                children: [
                  _buildLanguageTag(),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.person,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      snippet.userName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Code preview
              if (!isListView) ...[
                Expanded(
                  child: _buildCodePreview(),
                ),
                const SizedBox(height: 12),
              ] else ...[
                _buildCodePreview(),
                const SizedBox(height: 12),
              ],
              
              // Footer with stats and time
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 14,
                    color: AppColors.amberAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    snippet.starCount.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (snippet.createdAt != null)
                    Text(
                      _formatDate(snippet.createdAt!),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTag() {
    final language = SupportedLanguages.getLanguage(snippet.language);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blueAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        language.label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildStarButton() {
    return GestureDetector(
      onTap: _onStarPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: snippet.isStarred 
            ? AppColors.amberAccent.withOpacity(0.2)
            : AppColors.backgroundCard.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: snippet.isStarred 
              ? AppColors.amberAccent
              : AppColors.borderPrimary,
            width: 1,
          ),
        ),
        child: Icon(
          snippet.isStarred ? Icons.star : Icons.star_outline,
          size: 16,
          color: snippet.isStarred 
            ? AppColors.amberAccent
            : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildCodePreview() {
    // Show first few lines of code
    final lines = snippet.code.split('\n');
    final previewLines = lines.take(isListView ? 3 : 6).join('\n');
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.monacoBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code header
          Row(
            children: [
              Icon(
                Icons.code,
                size: 12,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                'Preview',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _copyCode,
                child: Icon(
                  Icons.copy,
                  size: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Code content
          Text(
            previewLines,
            style: GoogleFonts.firaCode(
              fontSize: 11,
              height: 1.4,
              color: AppColors.monacoForeground,
            ),
            maxLines: isListView ? 3 : 6,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Show more indicator
          if (lines.length > (isListView ? 3 : 6))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '... +${lines.length - (isListView ? 3 : 6)} more lines',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textMuted.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onStarPressed() {
    // TODO: Implement star functionality
    // This would typically call the API to star/unstar the snippet
    print('Star pressed for snippet: ${snippet.id}');
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: snippet.code));
    // TODO: Show snackbar confirmation
    print('Code copied to clipboard');
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