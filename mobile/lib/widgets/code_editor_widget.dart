import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/language_config.dart';
import '../core/theme/app_theme.dart';

class CodeEditorWidget extends StatefulWidget {
  final String language;
  final String theme;
  final String code;
  final Function(String) onCodeChanged;
  final TextEditingController? controller;

  const CodeEditorWidget({
    super.key,
    required this.language,
    required this.theme,
    required this.code,
    required this.onCodeChanged,
    this.controller,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.code);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code && widget.controller == null) {
      _controller.text = widget.code;
    }
  }

  Color _getBackgroundColor() {
    final theme = EditorThemes.getTheme(widget.theme);
    return Color(theme.backgroundColor);
  }

  Color _getForegroundColor() {
    final theme = EditorThemes.getTheme(widget.theme);
    return Color(theme.foregroundColor);
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = SupportedLanguages.getLanguage(widget.language);
    
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
                  'Code Editor',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                // Copy button
                IconButton(
                  onPressed: _copyCode,
                  icon: const Icon(Icons.copy, size: 16),
                  color: AppColors.textTertiary,
                  tooltip: 'Copy code',
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                // Language indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
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
          ),
          
          // Code editor
          Expanded(
            child: Container(
              width: double.infinity,
              color: _getBackgroundColor(),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                expands: true,
                onChanged: widget.onCodeChanged,
                style: GoogleFonts.firaCode(
                  fontSize: 14,
                  height: 1.5,
                  color: _getForegroundColor(),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Start coding...',
                ),
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          
          // Footer with line count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.borderAccent,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Lines: ${_controller.text.split('\n').length}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Chars: ${_controller.text.length}',
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
    );
  }
}