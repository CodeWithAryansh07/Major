import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/app_models.dart';
import '../services/api_service.dart';
import '../widgets/snippet_card_widget.dart';
import 'snippet_detail_screen.dart';

class SnippetsScreen extends StatefulWidget {
  const SnippetsScreen({super.key});

  @override
  State<SnippetsScreen> createState() => _SnippetsScreenState();
}

class _SnippetsScreenState extends State<SnippetsScreen> with TickerProviderStateMixin {
  final ConvexService _convexService = ConvexService();
  final TextEditingController _searchController = TextEditingController();
  
  List<CodeSnippet> _snippets = [];
  List<CodeSnippet> _filteredSnippets = [];
  bool _isLoading = true;
  String _selectedLanguage = 'all';
  String _searchQuery = '';
  String _viewMode = 'grid'; // 'grid' or 'list'
  
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadSnippets();
  }

  Future<void> _loadSnippets() async {
    setState(() {
      _isLoading = true;
    });

    // For demo purposes, create some sample snippets
    // In a real app, this would call the API
    await Future.delayed(const Duration(seconds: 2));
    
    final sampleSnippets = [
      CodeSnippet(
        id: '1',
        userId: 'user1',
        title: 'Array Manipulation in JavaScript',
        language: 'javascript',
        code: '''const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
console.log(doubled);''',
        userName: 'John Doe',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        starCount: 15,
        isStarred: false,
      ),
      CodeSnippet(
        id: '2',
        userId: 'user2',
        title: 'Python List Comprehension',
        language: 'python',
        code: '''numbers = [1, 2, 3, 4, 5]
squared = [n**2 for n in numbers]
print(squared)''',
        userName: 'Jane Smith',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        starCount: 8,
        isStarred: true,
      ),
      CodeSnippet(
        id: '3',
        userId: 'user3',
        title: 'Java Stream API Example',
        language: 'java',
        code: '''List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
List<Integer> doubled = numbers.stream()
    .map(n -> n * 2)
    .collect(Collectors.toList());''',
        userName: 'Bob Wilson',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        starCount: 23,
        isStarred: false,
      ),
    ];

    setState(() {
      _snippets = sampleSnippets;
      _filteredSnippets = sampleSnippets;
      _isLoading = false;
    });

    _animationController.forward();
  }

  void _filterSnippets() {
    setState(() {
      _filteredSnippets = _snippets.where((snippet) {
        final matchesLanguage = _selectedLanguage == 'all' || 
                               snippet.language == _selectedLanguage;
        final matchesSearch = _searchQuery.isEmpty ||
                             snippet.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                             snippet.userName.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesLanguage && matchesSearch;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterSnippets();
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _filterSnippets();
  }

  void _onViewModeChanged(String mode) {
    setState(() {
      _viewMode = mode;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _convexService.dispose();
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
            _buildHeader(),
            
            // Filters
            _buildFilters(),
            
            // Content
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundPrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.library_books,
                    size: 20,
                    color: AppColors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Community Code Library',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          ShaderMask(
            shaderCallback: (bounds) => AppColors.textGradient.createShader(bounds),
            child: Text(
              'Discover & Share Code Snippets',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Explore a curated collection of code snippets from the community',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          GlassMorphism(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: GoogleFonts.inter(color: AppColors.textSecondary),
              decoration: InputDecoration(
                hintText: 'Search snippets...',
                hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filter controls
          Row(
            children: [
              // Language filter
              Expanded(
                child: _buildLanguageFilter(),
              ),
              
              const SizedBox(width: 16),
              
              // View mode toggle
              _buildViewModeToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageFilter() {
    const languages = ['all', 'javascript', 'python', 'java', 'go', 'rust'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: languages.map((lang) {
          final isSelected = lang == _selectedLanguage;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _onLanguageChanged(lang),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? AppColors.blueAccent.withOpacity(0.2)
                    : AppColors.backgroundCard.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected 
                      ? AppColors.blueAccent
                      : AppColors.borderPrimary,
                    width: 1,
                  ),
                ),
                child: Text(
                  lang == 'all' ? 'All' : lang.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected 
                      ? AppColors.blueAccent
                      : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewModeToggle() {
    return Container(
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
          _buildViewModeButton(Icons.grid_view, 'grid'),
          _buildViewModeButton(Icons.list, 'list'),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(IconData icon, String mode) {
    final isSelected = _viewMode == mode;
    
    return GestureDetector(
      onTap: () => _onViewModeChanged(mode),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.blueAccent.withOpacity(0.2)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected 
            ? AppColors.blueAccent
            : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueAccent),
          ),
          SizedBox(height: 16),
          Text(
            'Loading snippets...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredSnippets.isEmpty) {
      return _buildEmptyState();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            )),
            child: _viewMode == 'grid' ? _buildGridView() : _buildListView(),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredSnippets.length,
      itemBuilder: (context, index) {
        return SnippetCardWidget(
          snippet: _filteredSnippets[index],
          onTap: () => _navigateToSnippetDetail(_filteredSnippets[index]),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSnippets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SnippetCardWidget(
            snippet: _filteredSnippets[index],
            isListView: true,
            onTap: () => _navigateToSnippetDetail(_filteredSnippets[index]),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.code_off,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No snippets found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToSnippetDetail(CodeSnippet snippet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SnippetDetailScreen(snippet: snippet),
      ),
    );
  }
}