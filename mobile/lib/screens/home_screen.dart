import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/language_config.dart';
import '../widgets/code_editor_widget.dart';
import '../widgets/output_panel_widget.dart';
import '../widgets/header_widget.dart';
import '../services/api_service.dart';
import '../models/app_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'javascript';
  String _selectedTheme = 'vs-dark';
  String _code = '';
  CodeExecution? _lastExecution;
  bool _isExecuting = false;
  
  final CodeExecutionService _executionService = CodeExecutionService();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDefaultCode();
  }

  void _loadDefaultCode() {
    final config = SupportedLanguages.getLanguage(_selectedLanguage);
    _code = config.defaultCode;
    _codeController.text = _code;
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
      _loadDefaultCode();
    });
  }

  void _onThemeChanged(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
  }

  void _onCodeChanged(String code) {
    _code = code;
  }

  Future<void> _executeCode() async {
    if (_code.trim().isEmpty) return;

    setState(() {
      _isExecuting = true;
    });

    final config = SupportedLanguages.getLanguage(_selectedLanguage);
    final response = await _executionService.executeCode(
      language: config.pistonLanguage,
      version: config.pistonVersion,
      code: _code,
    );

    setState(() {
      _isExecuting = false;
      if (response.success && response.data != null) {
        _lastExecution = response.data;
      } else {
        // Handle error
        _showErrorSnackBar(response.error ?? 'Unknown error occurred');
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _executionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HeaderWidget(
              selectedLanguage: _selectedLanguage,
              selectedTheme: _selectedTheme,
              onLanguageChanged: _onLanguageChanged,
              onThemeChanged: _onThemeChanged,
              onExecuteCode: _executeCode,
              isExecuting: _isExecuting,
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use single column layout for mobile
                    if (constraints.maxWidth < 768) {
                      return Column(
                        children: [
                          // Code Editor
                          Expanded(
                            flex: 3,
                            child: CodeEditorWidget(
                              language: _selectedLanguage,
                              theme: _selectedTheme,
                              code: _code,
                              onCodeChanged: _onCodeChanged,
                              controller: _codeController,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Output Panel
                          Expanded(
                            flex: 2,
                            child: OutputPanelWidget(
                              execution: _lastExecution,
                              isExecuting: _isExecuting,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Side-by-side layout for tablets
                      return Row(
                        children: [
                          // Code Editor
                          Expanded(
                            child: CodeEditorWidget(
                              language: _selectedLanguage,
                              theme: _selectedTheme,
                              code: _code,
                              onCodeChanged: _onCodeChanged,
                              controller: _codeController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Output Panel
                          Expanded(
                            child: OutputPanelWidget(
                              execution: _lastExecution,
                              isExecuting: _isExecuting,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}