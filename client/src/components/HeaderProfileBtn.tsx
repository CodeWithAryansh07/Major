"use client";
import { User, LogOut } from "lucide-react";
import { Link } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";
import { useState } from "react";

function HeaderProfileBtn() {
    const { user, isAuthenticated, logout } = useAuth();
    const [showDropdown, setShowDropdown] = useState(false);

    if (!isAuthenticated) {
        return (
            <Link
                to="/login"
                className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
            >
                <User className="w-4 h-4" />
                <span className="text-sm font-medium">Sign In</span>
            </Link>
        );
    }

    const handleLogout = () => {
        logout();
        setShowDropdown(false);
    };

    return (
        <div className="relative">
            <button
                onClick={() => setShowDropdown(!showDropdown)}
                className="flex items-center gap-2 px-3 py-2 bg-[#1e1e2e] rounded-lg ring-1 ring-white/5 hover:ring-white/10 transition-all"
            >
                <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center text-white text-sm font-medium">
                    {user?.username?.[0]?.toUpperCase() || 'U'}
                </div>
                <span className="text-sm text-gray-300">{user?.username || 'User'}</span>
            </button>

            {showDropdown && (
                <div className="absolute right-0 top-full mt-2 w-48 bg-[#1e1e2e] rounded-lg border border-white/10 shadow-lg z-50">
                    <div className="p-2">
                        <Link
                            to="/profile"
                            onClick={() => setShowDropdown(false)}
                            className="flex items-center gap-2 px-3 py-2 text-gray-300 hover:text-white hover:bg-white/5 rounded-lg transition-colors"
                        >
                            <User className="w-4 h-4" />
                            <span className="text-sm">Profile</span>
                        </Link>
                        <button
                            onClick={handleLogout}
                            className="flex items-center gap-2 w-full px-3 py-2 text-gray-300 hover:text-white hover:bg-white/5 rounded-lg transition-colors"
                        >
                            <LogOut className="w-4 h-4" />
                            <span className="text-sm">Sign Out</span>
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}

export default HeaderProfileBtn;