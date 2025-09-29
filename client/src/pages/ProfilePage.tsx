"use client";
import { useState, useEffect } from "react";
import NavigationHeader from "../components/NavigationHeader";
import ProfileHeader from "../components/ProfileHeader";
import ProfileHeaderSkeleton from "../components/ProfileHeaderSkeleton";
import { ChevronRight, Clock, Code, ListVideo, Loader2, Star, User } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Link } from "react-router-dom";
import StarButton from "../components/StarButton";
import ProfileCodeBlock from "../components/ProfileCodeBlock";
import { useAuth } from "../contexts/AuthContext";

const TABS = [
    {
        id: "executions",
        label: "Code Executions",
        icon: ListVideo,
    },
    {
        id: "starred",
        label: "Starred Snippets",
        icon: Star,
    },
];

// Mock data
const mockUser = {
    id: "user-1",
    name: "Alex Chen",
    email: "alex.chen@example.com",
    imageUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face"
};

const mockUserData = {
    _id: "user-data-1",
    _creationTime: Date.now() - 86400000 * 30, // 30 days ago
    name: "Alex Chen",
    userId: "user-1",
    email: "alex.chen@example.com",
    isPro: true,
    proSince: Date.now() - 86400000 * 15, // Pro for 15 days
};

const mockUserStats = {
    totalExecutions: 127,
    languagesCount: 6,
    languages: ["javascript", "python", "java", "go", "rust", "typescript"],
    last24Hours: 8,
    favoriteLanguage: "JavaScript",
    languageStats: {
        javascript: 45,
        python: 32,
        java: 20,
        go: 15,
        rust: 10,
        typescript: 5
    },
    mostStarredLanguage: "Python"
};

const mockExecutions = [
    {
        _id: "exec-1",
        _creationTime: Date.now() - 3600000, // 1 hour ago
        language: "javascript",
        code: `const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
console.log(doubled);

// More complex example
const users = [
  { name: 'Alice', age: 25 },
  { name: 'Bob', age: 30 }
];

const names = users
  .filter(user => user.age > 26)
  .map(user => user.name);
  
console.log('Users over 26:', names);`,
        output: "[2, 4, 6, 8, 10]\nUsers over 26: ['Bob']",
        error: null
    },
    {
        _id: "exec-2", 
        _creationTime: Date.now() - 7200000, // 2 hours ago
        language: "python",
        code: `import pandas as pd
import numpy as np

# Create sample data
data = {'A': [1, 2, 3], 'B': [4, 5, 6]}
df = pd.DataFrame(data)
print(df)

# Some calculations
result = df.sum()
print("Column sums:", result)`,
        output: "   A  B\n0  1  4\n1  2  5\n2  3  6\nColumn sums: A    6\nB   15\ndtype: int64",
        error: null
    },
    {
        _id: "exec-3",
        _creationTime: Date.now() - 10800000, // 3 hours ago
        language: "java",
        code: `public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        
        int[] numbers = {1, 2, 3, 4, 5};
        int sum = 0;
        
        for (int num : numbers) {
            sum += num;
        }
        
        System.out.println("Sum: " + sum);
    }
}`,
        error: "Compilation error: class HelloWorld is public, should be declared in a file named HelloWorld.java",
        output: null
    }
];

const mockStarredSnippets = [
    {
        _id: "1",
        title: "Array Map and Filter Demo", 
        language: "javascript",
        code: `const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
console.log(doubled);`,
        _creationTime: Date.now() - 86400000
    },
    {
        _id: "2",
        title: "Python Data Analysis",
        language: "python", 
        code: `import pandas as pd
df = pd.read_csv('data.csv')
print(df.head())`,
        _creationTime: Date.now() - 172800000
    },
    {
        _id: "5",
        title: "Rust Error Handling",
        language: "rust",
        code: `fn main() {
    let result = divide(10, 2);
    match result {
        Ok(value) => println!("Result: {}", value),
        Err(e) => println!("Error: {}", e),
    }
}`,
        _creationTime: Date.now() - 432000000
    }
];

function ProfilePage() {
    const { isAuthenticated, user } = useAuth();
    const [activeTab, setActiveTab] = useState<"executions" | "starred">("executions");
    const [isLoaded, setIsLoaded] = useState(false);
    const [userStats, setUserStats] = useState<typeof mockUserStats | undefined>(undefined);
    const [userData, setUserData] = useState<typeof mockUserData | undefined>(undefined);
    const [executions, setExecutions] = useState<typeof mockExecutions>([]);
    const [starredSnippets, setStarredSnippets] = useState<typeof mockStarredSnippets>([]);
    const [isLoadingExecutions, setIsLoadingExecutions] = useState(false);

    useEffect(() => {
        if (isAuthenticated && user) {
            // Simulate data loading with real user data
            const timer = setTimeout(() => {
                // Use real user data when available, fallback to mock
                const realUserData = {
                    ...mockUserData,
                    name: user.username || user.email || 'User',
                    email: user.email || '',
                    userId: user.id || 'unknown',
                };
                
                setUserStats(mockUserStats);
                setUserData(realUserData);
                setExecutions(mockExecutions);
                setStarredSnippets(mockStarredSnippets);
                setIsLoaded(true);
            }, 1000);

            return () => clearTimeout(timer);
        }
    }, [isAuthenticated, user]);

    const handleLoadMore = () => {
        setIsLoadingExecutions(true);
        // Simulate loading more executions
        setTimeout(() => {
            setIsLoadingExecutions(false);
        }, 1000);
    };

    // Show login prompt if not authenticated
    if (!isAuthenticated) {
        return (
            <div className="min-h-screen bg-[#0a0a0f]">
                <NavigationHeader />
                <div className="flex flex-col items-center justify-center min-h-[calc(100vh-80px)] px-4">
                    <div className="text-center max-w-md">
                        <div className="w-24 h-24 bg-gradient-to-br from-blue-500/10 to-purple-500/10 
                                        rounded-full flex items-center justify-center mx-auto mb-6">
                            <User className="w-12 h-12 text-gray-400" />
                        </div>
                        <h2 className="text-2xl font-bold text-white mb-4">
                            Sign in to view your profile
                        </h2>
                        <p className="text-gray-400 mb-6">
                            Access your code executions, starred snippets, and more.
                        </p>
                        <Link
                            to="/login"
                            className="inline-flex items-center gap-2 px-6 py-3 bg-blue-600 
                                     hover:bg-blue-700 text-white rounded-lg transition-colors"
                        >
                            <User className="w-4 h-4" />
                            Sign In
                        </Link>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[#0a0a0f]">
            <NavigationHeader />

            <div className="max-w-7xl mx-auto px-4 py-12">
                {userStats && userData && isLoaded && (
                    <ProfileHeader userStats={userStats} userData={userData} user={mockUser} />
                )}

                {(!userStats || !isLoaded) && <ProfileHeaderSkeleton />}

                <div
                    className="bg-gradient-to-br from-[#12121a] to-[#1a1a2e] rounded-3xl shadow-2xl 
        shadow-black/50 border border-gray-800/50 backdrop-blur-xl overflow-hidden"
                >
                    <div className="border-b border-gray-800/50">
                        <div className="flex space-x-1 p-4">
                            {TABS.map((tab) => (
                                <button
                                    key={tab.id}
                                    onClick={() => setActiveTab(tab.id as "executions" | "starred")}
                                    className={`group flex items-center gap-2 px-6 py-2.5 rounded-lg transition-all duration-200 relative overflow-hidden ${activeTab === tab.id ? "text-blue-400" : "text-gray-400 hover:text-gray-300"
                                        }`}
                                >
                                    {activeTab === tab.id && (
                                        <motion.div
                                            layoutId="activeTab"
                                            className="absolute inset-0 bg-blue-500/10 rounded-lg"
                                            transition={{
                                                type: "spring",
                                                bounce: 0.2,
                                                duration: 0.6,
                                            }}
                                        />
                                    )}
                                    <tab.icon className="w-4 h-4 relative z-10" />
                                    <span className="text-sm font-medium relative z-10">{tab.label}</span>
                                </button>
                            ))}
                        </div>
                    </div>

                    <AnimatePresence mode="wait">
                        <motion.div
                            key={activeTab}
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            exit={{ opacity: 0, y: -10 }}
                            transition={{ duration: 0.2 }}
                            className="p-6"
                        >
                            {activeTab === "executions" && (
                                <div className="space-y-6">
                                    {executions?.map((execution) => (
                                        <div
                                            key={execution._id}
                                            className="group rounded-xl overflow-hidden transition-all duration-300 hover:border-blue-500/50 hover:shadow-md hover:shadow-blue-500/50"
                                        >
                                            <div className="flex items-center justify-between p-4 bg-black/30 border border-gray-800/50 rounded-t-xl">
                                                <div className="flex items-center gap-4">
                                                    <div className="relative">
                                                        <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 rounded-lg blur opacity-20 group-hover:opacity-30 transition-opacity" />
                                                        <img
                                                            src={"/images/" + execution.language + ".png"}
                                                            alt=""
                                                            className="rounded-lg relative z-10 object-cover w-10 h-10"
                                                        />
                                                    </div>
                                                    <div className="space-y-1">
                                                        <div className="flex items-center gap-2">
                                                            <span className="text-sm font-medium text-white">
                                                                {execution.language.toUpperCase()}
                                                            </span>
                                                            <span className="text-xs text-gray-400">•</span>
                                                            <span className="text-xs text-gray-400">
                                                                {new Date(execution._creationTime).toLocaleString()}
                                                            </span>
                                                        </div>
                                                        <div className="flex items-center gap-2">
                                                            <span
                                                                className={`text-xs px-2 py-0.5 rounded-full ${execution.error
                                                                        ? "bg-red-500/10 text-red-400"
                                                                        : "bg-green-500/10 text-green-400"
                                                                    }`}
                                                            >
                                                                {execution.error ? "Error" : "Success"}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div className="p-4 bg-black/20 rounded-b-xl border border-t-0 border-gray-800/50">
                                                <ProfileCodeBlock code={execution.code} language={execution.language} />

                                                {(execution.output || execution.error) && (
                                                    <div className="mt-4 p-4 rounded-lg bg-black/40">
                                                        <h4 className="text-sm font-medium text-gray-400 mb-2">Output</h4>
                                                        <pre
                                                            className={`text-sm ${execution.error ? "text-red-400" : "text-green-400"
                                                                }`}
                                                        >
                                                            {execution.error || execution.output}
                                                        </pre>
                                                    </div>
                                                )}
                                            </div>
                                        </div>
                                    ))}

                                    {isLoadingExecutions ? (
                                        <div className="text-center py-12">
                                            <Loader2 className="w-12 h-12 text-gray-600 mx-auto mb-4 animate-spin" />
                                            <h3 className="text-lg font-medium text-gray-400 mb-2">
                                                Loading code executions...
                                            </h3>
                                        </div>
                                    ) : (
                                        executions.length === 0 && (
                                            <div className="text-center py-12">
                                                <Code className="w-12 h-12 text-gray-600 mx-auto mb-4" />
                                                <h3 className="text-lg font-medium text-gray-400 mb-2">
                                                    No code executions yet
                                                </h3>
                                                <p className="text-gray-500">Start coding to see your execution history!</p>
                                            </div>
                                        )
                                    )}

                                    {/* Load More Button */}
                                    {executions.length > 0 && (
                                        <div className="flex justify-center mt-8">
                                            <button
                                                onClick={handleLoadMore}
                                                className="px-6 py-3 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg flex items-center gap-2 
                        transition-colors"
                                            >
                                                Load More
                                                <ChevronRight className="w-4 h-4" />
                                            </button>
                                        </div>
                                    )}
                                </div>
                            )}
                            {activeTab === "starred" && (
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    {starredSnippets?.map((snippet) => (
                                        <div key={snippet._id} className="group relative">
                                            <Link to={`/snippets/${snippet._id}`}>
                                                <div
                                                    className="bg-black/20 rounded-xl border border-gray-800/50 hover:border-gray-700/50 
                                                    transition-all duration-300 overflow-hidden h-full group-hover:transform
                                                group-hover:scale-[1.02]"
                                                >
                                                    <div className="p-6">
                                                        <div className="flex items-center justify-between mb-4">
                                                            <div className="flex items-center gap-3">
                                                                <div className="relative">
                                                                    <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 rounded-lg blur opacity-20 group-hover:opacity-30 transition-opacity" />
                                                                    <img
                                                                        src={`/images/${snippet.language}.png`}
                                                                        alt={`${snippet.language} logo`}
                                                                        className="relative z-10 w-10 h-10"
                                                                    />
                                                                </div>
                                                                <span className="px-3 py-1 bg-blue-500/10 text-blue-400 rounded-lg text-sm">
                                                                    {snippet.language}
                                                                </span>
                                                            </div>
                                                            <div
                                                                className="absolute top-6 right-6 z-10"
                                                                onClick={(e) => e.preventDefault()}
                                                            >
                                                                <StarButton snippetId={snippet._id} />
                                                            </div>
                                                        </div>
                                                        <h2 className="text-xl font-semibold text-white mb-3 line-clamp-1 group-hover:text-blue-400 transition-colors">
                                                            {snippet.title}
                                                        </h2>
                                                        <div className="flex items-center justify-between text-sm text-gray-400">
                                                            <div className="flex items-center gap-2">
                                                                <Clock className="w-4 h-4" />
                                                                <span>{new Date(snippet._creationTime).toLocaleDateString()}</span>
                                                            </div>
                                                            <ChevronRight className="w-4 h-4 transform group-hover:translate-x-1 transition-transform" />
                                                        </div>
                                                    </div>
                                                    <div className="px-6 pb-6">
                                                        <div className="bg-black/30 rounded-lg p-4 overflow-hidden">
                                                            <pre className="text-sm text-gray-300 font-mono line-clamp-3">
                                                                {snippet.code}
                                                            </pre>
                                                        </div>
                                                    </div>
                                                </div>
                                            </Link>
                                        </div>
                                    ))}

                                    {(!starredSnippets || starredSnippets.length === 0) && (
                                        <div className="col-span-full text-center py-12">
                                            <Star className="w-12 h-12 text-gray-600 mx-auto mb-4" />
                                            <h3 className="text-lg font-medium text-gray-400 mb-2">
                                                No starred snippets yet
                                            </h3>
                                            <p className="text-gray-500">
                                                Start exploring and star the snippets you find useful!
                                            </p>
                                        </div>
                                    )}
                                </div>
                            )}
                        </motion.div>
                    </AnimatePresence>
                </div>
            </div>
        </div>
    );
}

export default ProfilePage;