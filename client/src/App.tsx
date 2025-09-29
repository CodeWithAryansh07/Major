import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import { AuthProvider } from './contexts/AuthContext';
import HomePage from './pages/HomePage';
import PricingPage from './pages/PricingPage';
import ProfilePage from './pages/ProfilePage';
import SnippetsPage from './pages/SnippetsPage';
import SnippetDetailPage from './pages/SnippetDetailPage';
import LoginPage from './pages/LoginPage';

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-900 to-gray-800">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/pricing" element={<PricingPage />} />
            <Route path="/profile" element={<ProfilePage />} />
            <Route path="/snippets" element={<SnippetsPage />} />
            <Route path="/snippets/:id" element={<SnippetDetailPage />} />
            <Route path="/login" element={<LoginPage />} />
          </Routes>
          
          <Toaster 
            position="bottom-right"
            toastOptions={{
              style: {
                background: '#1e1e2e',
                color: '#fff',
                border: '1px solid rgba(255, 255, 255, 0.1)',
              },
            }}
          />
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;