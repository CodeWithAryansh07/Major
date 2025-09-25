# CodeCraft Mobile - Flutter Application

This is the Flutter mobile application for CodeCraft, providing a native mobile experience for the interactive code editor platform.

## 🚀 Features

### ✅ Implemented
- **Interactive Code Editor**: Multi-line code editor with syntax support
- **Code Execution**: Execute code in 8+ programming languages via Piston API
- **Snippet Management**: Browse, search, and view community code snippets
- **Language Support**: JavaScript, TypeScript, Python, Java, Go, Rust, C++, C#
- **Theme Support**: Multiple editor themes (VS Dark, GitHub Dark, Monokai, etc.)
- **Responsive Design**: Optimized for both mobile and tablet devices
- **Material Design 3**: Modern UI with glassmorphism effects
- **Real-time Features**: Live code execution and results display

### 🚧 Planned
- User authentication (Clerk integration when available)
- Offline support and caching
- Advanced code editor features (auto-completion, syntax highlighting)
- Push notifications
- Social features (user profiles, following)
- Dark/light theme toggle

## 📱 Screens

1. **Home Screen**: Interactive code editor with execution panel
2. **Snippets Screen**: Browse and search community code snippets
3. **Snippet Detail**: View individual snippets with comments
4. **Profile Screen**: User management and settings (coming soon)

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/        # App constants and configurations
│   └── theme/           # Material Design theme configuration
├── models/              # Data models
├── screens/             # Main application screens
├── services/            # API services and external integrations
├── widgets/             # Reusable UI components
└── utils/               # Utility functions
```

## 🎨 Design System

The app follows the original CodeCraft design system:
- **Colors**: Dark theme with blue/purple gradients
- **Typography**: Inter font family for UI, Fira Code for code
- **Components**: Glass morphism effects, card-based layouts
- **Animations**: Smooth transitions and micro-interactions

## 🔧 Setup & Installation

### Prerequisites
- Flutter SDK (3.9.2+)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for iOS builds)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd Major/mobile
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**:
   - Update `lib/services/api_service.dart` with your Convex URL
   - Configure authentication providers if using Clerk

4. **Run the app**:
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Install dependencies
flutter pub get

# Run on specific device
flutter run -d <device_id>

# Build for release
flutter build apk                 # Android APK
flutter build ios                 # iOS
flutter build web                 # Web (PWA)

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean build cache
flutter clean
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: SDK
- `provider` / `riverpod`: State management
- `go_router`: Navigation
- `http` / `dio`: Network requests
- `google_fonts`: Typography
- `flutter_highlight`: Code syntax highlighting

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code analysis
- `build_runner`: Code generation

## 🌐 API Integration

The app integrates with:
1. **Convex Backend**: User management, snippet storage, comments
2. **Piston API**: Code execution service
3. **Authentication**: Clerk (when available)

### API Service Structure
```dart
// User operations
ConvexService.getUser(userId)
ConvexService.syncUser(user)

// Snippet operations
ConvexService.getSnippets()
ConvexService.createSnippet(snippet)
ConvexService.starSnippet(snippetId)

// Code execution
CodeExecutionService.executeCode(language, code)
```

## 📚 Code Structure

### Models
```dart
class CodeSnippet {
  final String id;
  final String title;
  final String language;
  final String code;
  final String userName;
  // ... more properties
}
```

### Services
```dart
class ConvexService {
  Future<ApiResponse<List<CodeSnippet>>> getSnippets();
  Future<ApiResponse<String>> createSnippet(snippet);
  // ... more methods
}
```

### Widgets
- `CodeEditorWidget`: Multi-line code editor
- `OutputPanelWidget`: Execution results display
- `SnippetCardWidget`: Snippet preview cards
- `HeaderWidget`: App header with controls

## 🎨 Theming

The app supports multiple editor themes:
- VS Dark (default)
- VS Light  
- GitHub Dark
- Monokai
- Solarized Dark

Custom app theme with:
- Dark color scheme
- Blue/purple gradients
- Glass morphism effects
- Material Design 3 components

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📦 Build & Release

### Android
```bash
# Debug build
flutter build apk --debug

# Release build  
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Built with ❤️ using Flutter
