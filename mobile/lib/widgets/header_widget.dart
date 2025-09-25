import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/language_config.dart';
import '../core/theme/app_theme.dart';

class HeaderWidget extends StatelessWidget {
  final String selectedLanguage;
  final String selectedTheme;
  final Function(String) onLanguageChanged;
  final Function(String) onThemeChanged;
  final VoidCallback onExecuteCode;
  final bool isExecuting;

  const HeaderWidget({
    super.key,
    required this.selectedLanguage,
    required this.selectedTheme,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onExecuteCode,
    this.isExecuting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.borderAccent,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Top row with logo and run button
          Row(
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderAccent.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 24,
                  color: AppColors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.textGradient.createShader(bounds),
                    child: Text(
                      'CodeCraft',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Interactive Code Editor',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.blueAccent.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Run button
              ElevatedButton.icon(
                onPressed: isExecuting ? null : onExecuteCode,
                icon: isExecuting 
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textPrimary,
                        ),
                      ),
                    )
                  : const Icon(Icons.play_arrow, size: 18),
                label: Text(
                  isExecuting ? 'Running...' : 'Run',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueAccent,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Controls row
          Row(
            children: [
              // Language selector
              Expanded(
                child: _LanguageSelector(
                  selectedLanguage: selectedLanguage,
                  onLanguageChanged: onLanguageChanged,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Theme selector
              Expanded(
                child: _ThemeSelector(
                  selectedTheme: selectedTheme,
                  onThemeChanged: onThemeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const _LanguageSelector({
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguageBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.code,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                SupportedLanguages.getLanguage(selectedLanguage).label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Language',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              ...SupportedLanguages.availableLanguages.map((langId) {
                final lang = SupportedLanguages.getLanguage(langId);
                final isSelected = langId == selectedLanguage;
                
                return ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? AppColors.blueAccent.withOpacity(0.2)
                        : AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                          ? AppColors.blueAccent
                          : AppColors.borderPrimary,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.code,
                      size: 16,
                      color: isSelected
                        ? AppColors.blueAccent
                        : AppColors.textSecondary,
                    ),
                  ),
                  title: Text(
                    lang.label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: isSelected
                        ? AppColors.blueAccent
                        : AppColors.textSecondary,
                      fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: AppColors.blueAccent,
                        size: 20,
                      )
                    : null,
                  onTap: () {
                    onLanguageChanged(langId);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const _ThemeSelector({
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showThemeBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.palette,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                EditorThemes.getTheme(selectedTheme).label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Theme',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              ...EditorThemes.themes.map((theme) {
                final isSelected = theme.id == selectedTheme;
                
                return ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(theme.backgroundColor),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                          ? AppColors.blueAccent
                          : AppColors.borderPrimary,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                  ),
                  title: Text(
                    theme.label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: isSelected
                        ? AppColors.blueAccent
                        : AppColors.textSecondary,
                      fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: AppColors.blueAccent,
                        size: 20,
                      )
                    : null,
                  onTap: () {
                    onThemeChanged(theme.id);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}