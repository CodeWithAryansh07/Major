"use client";

import NavigationHeader from "../components/NavigationHeader";
import SnippetsPageSkeleton from "../components/SnippetsPageSkeleton";
import SnippetCard from "../components/SnippetCard";
import { AnimatePresence, motion } from "framer-motion";
import { BookOpen, Code, Grid, Layers, Search, Tag, X } from "lucide-react";
import { useState, useEffect } from "react";
import { snippetService, type PageResponse, type Snippet as BackendSnippet } from "../services/snippetService";
import type { Snippet } from "../types";

// Mock data - expanded to match original
const mockSnippets: Snippet[] = [
    {
        _id: "1",
        title: "Array Map and Filter Demo",
        language: "javascript",
        code: `const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Filter even numbers and double them
const evenDoubled = numbers
  .filter(n => n % 2 === 0)
  .map(n => n * 2);

console.log('Even numbers doubled:', evenDoubled);
// Output: [4, 8, 12, 16, 20]

// Chain multiple operations
const result = numbers
  .filter(n => n > 5)
  .map(n => n ** 2)
  .reduce((sum, n) => sum + n, 0);

console.log('Sum of squares > 5:', result);`,
        userId: "user-1",
        userName: "Alex Chen",
        _creationTime: Date.now() - 86400000,
    },
    {
        _id: "2",
        title: "Python Data Analysis Basics",
        language: "python",
        code: `import pandas as pd
import numpy as np

# Create sample data
data = {
    'name': ['Alice', 'Bob', 'Charlie', 'Diana'],
    'age': [25, 30, 35, 28],
    'salary': [50000, 60000, 70000, 55000]
}

df = pd.DataFrame(data)

# Basic statistics
print("Dataset Info:")
print(df.describe())

# Filter and sort
high_earners = df[df['salary'] > 55000].sort_values('salary', ascending=False)
print("\\nHigh earners:")
print(high_earners)`,
        userId: "user-2",
        userName: "Sarah Johnson",
        _creationTime: Date.now() - 172800000,
    },
    {
        _id: "3",
        title: "Java Stream API Example",
        language: "java",
        code: `import java.util.*;
import java.util.stream.*;

public class StreamExample {
    public static void main(String[] args) {
        List<String> words = Arrays.asList(
            "hello", "world", "java", "streams", "are", "powerful"
        );
        
        // Filter, map, and collect
        List<String> result = words.stream()
            .filter(word -> word.length() > 4)
            .map(String::toUpperCase)
            .sorted()
            .collect(Collectors.toList());
            
        System.out.println("Filtered words: " + result);
        
        // Count operations
        long count = words.stream()
            .filter(word -> word.startsWith("h"))
            .count();
            
        System.out.println("Words starting with 'h': " + count);
    }
}`,
        userId: "user-3",
        userName: "Mike Rodriguez",
        _creationTime: Date.now() - 259200000,
    },
    {
        _id: "4",
        title: "Go Concurrent Web Scraper",
        language: "go",
        code: `package main

import (
    "fmt"
    "net/http"
    "sync"
    "time"
)

func fetchURL(url string, wg *sync.WaitGroup, results chan<- string) {
    defer wg.Done()
    
    start := time.Now()
    resp, err := http.Get(url)
    if err != nil {
        results <- fmt.Sprintf("Error fetching %s: %v", url, err)
        return
    }
    defer resp.Body.Close()
    
    duration := time.Since(start)
    results <- fmt.Sprintf("%s - Status: %d, Time: %v", 
        url, resp.StatusCode, duration)
}

func main() {
    urls := []string{
        "https://httpbin.org/delay/1",
        "https://httpbin.org/delay/2",
        "https://httpbin.org/delay/3",
    }
    
    var wg sync.WaitGroup
    results := make(chan string, len(urls))
    
    for _, url := range urls {
        wg.Add(1)
        go fetchURL(url, &wg, results)
    }
    
    wg.Wait()
    close(results)
    
    for result := range results {
        fmt.Println(result)
    }
}`,
        userId: "user-4",
        userName: "Emma Davis",
        _creationTime: Date.now() - 345600000,
    },
    {
        _id: "5",
        title: "Rust Error Handling Pattern",
        language: "rust",
        code: `use std::fs::File;
use std::io::{self, Read};
use std::num::ParseIntError;

#[derive(Debug)]
enum AppError {
    Io(io::Error),
    Parse(ParseIntError),
    Custom(String),
}

impl From<io::Error> for AppError {
    fn from(error: io::Error) -> Self {
        AppError::Io(error)
    }
}

impl From<ParseIntError> for AppError {
    fn from(error: ParseIntError) -> Self {
        AppError::Parse(error)
    }
}

fn read_and_parse_file(path: &str) -> Result<Vec<i32>, AppError> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    
    let numbers: Result<Vec<i32>, _> = contents
        .lines()
        .map(|line| line.trim().parse::<i32>())
        .collect();
    
    Ok(numbers?)
}

fn main() {
    match read_and_parse_file("numbers.txt") {
        Ok(numbers) => println!("Numbers: {:?}", numbers),
        Err(e) => eprintln!("Error: {:?}", e),
    }
}`,
        userId: "user-5",
        userName: "David Kim",
        _creationTime: Date.now() - 432000000,
    },
    {
        _id: "6",
        title: "TypeScript Generic Utilities",
        language: "typescript",
        code: `// Generic utility types and functions
interface User {
  id: number;
  name: string;
  email: string;
  age?: number;
}

// Pick only certain properties
type UserPreview = Pick<User, 'id' | 'name'>;

// Make all properties optional
type PartialUser = Partial<User>;

// Generic function with constraints
function updateEntity<T extends { id: number }>(
  entity: T,
  updates: Partial<Omit<T, 'id'>>
): T {
  return { ...entity, ...updates };
}

// Usage examples
const user: User = {
  id: 1,
  name: "John Doe",
  email: "john@example.com",
  age: 30
};

const userPreview: UserPreview = {
  id: user.id,
  name: user.name
};

const updatedUser = updateEntity(user, {
  name: "John Smith",
  age: 31
});

console.log("Updated user:", updatedUser);

// Generic array utility
function groupBy<T, K extends keyof T>(
  array: T[],
  key: K
): Record<string, T[]> {
  return array.reduce((groups, item) => {
    const groupKey = String(item[key]);
    groups[groupKey] = groups[groupKey] || [];
    groups[groupKey].push(item);
    return groups;
  }, {} as Record<string, T[]>);
}`,
        userId: "user-1",
        userName: "Alex Chen",
        _creationTime: Date.now() - 518400000,
    },
];

function SnippetsPage() {
    const [snippets, setSnippets] = useState<Snippet[] | undefined>(undefined);
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedLanguage, setSelectedLanguage] = useState<string | null>(null);
    const [view, setView] = useState<"grid" | "list">("grid");
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string>('');
    const [page, setPage] = useState(0);
    const [hasMore, setHasMore] = useState(true);

    // Load snippets from backend
    const loadSnippets = async () => {
        try {
            setLoading(page === 0);
            setError('');
            
            const response: PageResponse<BackendSnippet> = await snippetService.getPublicSnippets(page, 12);
            
            // Map backend Snippet to frontend Snippet format
            const mappedSnippets: Snippet[] = response.content.map((snippet: BackendSnippet) => ({
                _id: snippet.id || 'unknown',
                title: snippet.title,
                language: snippet.language,
                code: snippet.code,
                userId: snippet.userId || 'unknown',
                userName: 'Unknown User', // Backend doesn't return userName, would need to fetch user details
                _creationTime: snippet.createdAt ? new Date(snippet.createdAt).getTime() : Date.now(),
            }));
            
            if (page === 0) {
                setSnippets(mappedSnippets);
            } else {
                setSnippets(prev => prev ? [...prev, ...mappedSnippets] : mappedSnippets);
            }
            
            setHasMore(!response.last);
        } catch (err) {
            console.error('Error loading snippets:', err);
            setError('Failed to load snippets. Please try again.');
            // Fallback to mock data on error
            if (page === 0) {
                setSnippets(mockSnippets);
            }
        } finally {
            setLoading(false);
        }
    };

    const handleSearch = async () => {
        try {
            setLoading(true);
            setError('');
            
            const response: PageResponse<BackendSnippet> = await snippetService.searchSnippets(searchQuery, 0, 50);
            
            // Map backend Snippet to frontend Snippet format
            const mappedSnippets: Snippet[] = response.content.map((snippet: BackendSnippet) => ({
                _id: snippet.id || 'unknown',
                title: snippet.title,
                language: snippet.language,
                code: snippet.code,
                userId: snippet.userId || 'unknown',
                userName: 'Unknown User', // Backend doesn't return userName
                _creationTime: snippet.createdAt ? new Date(snippet.createdAt).getTime() : Date.now(),
            }));
            
            setSnippets(mappedSnippets);
            setHasMore(false); // Search doesn't support pagination for now
        } catch (err) {
            console.error('Error searching snippets:', err);
            setError('Failed to search snippets. Please try again.');
            // Filter mock data on search error
            const filtered = mockSnippets.filter((snippet) =>
                snippet.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                snippet.language.toLowerCase().includes(searchQuery.toLowerCase())
            );
            setSnippets(filtered);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadSnippets();
    }, [page]); // loadSnippets will be recreated on each render, but that's okay for now

    // Handle search query changes
    useEffect(() => {
        if (searchQuery.trim()) {
            handleSearch();
        } else {
            setPage(0);
            loadSnippets();
        }
    }, [searchQuery]); // handleSearch and loadSnippets will be recreated, but that's okay for now

    // Simulate loading for now - will be replaced with real loading state
    useEffect(() => {
        if (snippets === undefined && !loading) {
            const timer = setTimeout(() => {
                if (snippets === undefined) {
                    setSnippets(mockSnippets);
                }
            }, 1000);
            return () => clearTimeout(timer);
        }
    }, [snippets, loading]);

    // Loading state
    if (snippets === undefined && loading) {
        return (
            <div className="min-h-screen">
                <NavigationHeader />
                <SnippetsPageSkeleton />
            </div>
        );
    }

    const languages = [...new Set((snippets || []).map((s) => s.language))];
    const popularLanguages = languages.slice(0, 5);

    const filteredSnippets = (snippets || []).filter((snippet) => {
        const matchesSearch = !searchQuery.trim() ||
            snippet.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
            snippet.language.toLowerCase().includes(searchQuery.toLowerCase()) ||
            snippet.userName.toLowerCase().includes(searchQuery.toLowerCase());

        const matchesLanguage = !selectedLanguage || snippet.language === selectedLanguage;

        return matchesSearch && matchesLanguage;
    });

    return (
        <div className="min-h-screen bg-[#0a0a0f]">
            <NavigationHeader />

            <div className="relative max-w-7xl mx-auto px-4 py-12">
                {/* Hero */}
                <div className="text-center max-w-3xl mx-auto mb-16">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-gradient-to-r
                            from-blue-500/10 to-purple-500/10 text-sm text-gray-400 mb-6"
                    >
                        <BookOpen className="w-4 h-4" />
                        Community Code Library
                    </motion.div>
                    <motion.h1
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.1 }}
                        className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-gray-100 to-gray-300 text-transparent bg-clip-text mb-6"
                    >
                        Discover & Share Code Snippets
                    </motion.h1>
                    <motion.p
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ delay: 0.2 }}
                        className="text-lg text-gray-400 mb-8"
                    >
                        Explore a curated collection of code snippets from the community
                    </motion.p>
                </div>

                {/* Filters Section */}
                <div className="relative max-w-5xl mx-auto mb-12 space-y-6">
                    {/* Search */}
                    <div className="relative group">
                        <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-purple-500/20 rounded-xl blur-xl opacity-0 group-hover:opacity-100 transition-all duration-500" />
                        <div className="relative flex items-center">
                            <Search className="absolute left-4 w-5 h-5 text-gray-400" />
                            <input
                                type="text"
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                placeholder="Search snippets by title, language, or author..."
                                className="w-full pl-12 pr-4 py-4 bg-[#1e1e2e]/80 hover:bg-[#1e1e2e] text-white
                                rounded-xl border border-[#313244] hover:border-[#414155] transition-all duration-200
                                placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500/50"
                            />
                        </div>
                    </div>

                    {/* Filters Bar */}
                    <div className="flex flex-wrap items-center gap-4">
                        <div className="flex items-center gap-2 px-4 py-2 bg-[#1e1e2e] rounded-lg ring-1 ring-gray-800">
                            <Tag className="w-4 h-4 text-gray-400" />
                            <span className="text-sm text-gray-400">Languages:</span>
                        </div>

                        {popularLanguages.map((lang) => (
                            <button
                                key={lang}
                                onClick={() => setSelectedLanguage(lang === selectedLanguage ? null : lang)}
                                className={`
                    group relative px-3 py-1.5 rounded-lg transition-all duration-200
                    ${selectedLanguage === lang
                                        ? "text-blue-400 bg-blue-500/10 ring-2 ring-blue-500/50"
                                        : "text-gray-400 hover:text-gray-300 bg-[#1e1e2e] hover:bg-[#262637] ring-1 ring-gray-800"
                                    }
                  `}
                            >
                                <div className="flex items-center gap-2">
                                    <img src={`/${lang}.png`} alt={lang} className="w-4 h-4 object-contain" />
                                    <span className="text-sm">{lang}</span>
                                </div>
                            </button>
                        ))}

                        {selectedLanguage && (
                            <button
                                onClick={() => setSelectedLanguage(null)}
                                className="flex items-center gap-1 px-2 py-1 text-xs text-gray-400 hover:text-gray-300 transition-colors"
                            >
                                <X className="w-3 h-3" />
                                Clear
                            </button>
                        )}

                        <div className="ml-auto flex items-center gap-3">
                            <span className="text-sm text-gray-500">
                                {filteredSnippets.length} snippets found
                            </span>

                            {/* View Toggle */}
                            <div className="flex items-center gap-1 p-1 bg-[#1e1e2e] rounded-lg ring-1 ring-gray-800">
                                <button
                                    onClick={() => setView("grid")}
                                    title="Grid view"
                                    className={`p-2 rounded-md transition-all ${view === "grid"
                                            ? "bg-blue-500/20 text-blue-400"
                                            : "text-gray-400 hover:text-gray-300 hover:bg-[#262637]"
                                        }`}
                                >
                                    <Grid className="w-4 h-4" />
                                </button>
                                <button
                                    onClick={() => setView("list")}
                                    title="List view"
                                    className={`p-2 rounded-md transition-all ${view === "list"
                                            ? "bg-blue-500/20 text-blue-400"
                                            : "text-gray-400 hover:text-gray-300 hover:bg-[#262637]"
                                        }`}
                                >
                                    <Layers className="w-4 h-4" />
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Error Display */}
                {error && (
                    <div className="max-w-5xl mx-auto mb-6 p-4 bg-red-900/20 border border-red-700 rounded-lg">
                        <p className="text-red-300">{error}</p>
                        <button
                            onClick={() => {
                                setError('');
                                setPage(0);
                                loadSnippets();
                            }}
                            className="mt-2 px-3 py-1 bg-red-700 hover:bg-red-600 text-white text-sm rounded transition-colors"
                        >
                            Retry
                        </button>
                    </div>
                )}

                {/* Snippets Grid */}
                <motion.div
                    className={`grid gap-6 ${view === "grid"
                            ? "grid-cols-1 md:grid-cols-2 lg:grid-cols-3"
                            : "grid-cols-1 max-w-3xl mx-auto"
                        }`}
                    layout
                >
                    <AnimatePresence mode="popLayout">
                        {filteredSnippets.map((snippet) => (
                            <SnippetCard key={snippet._id} snippet={snippet} />
                        ))}
                    </AnimatePresence>
                </motion.div>

                {/* edge case: empty state */}
                {filteredSnippets.length === 0 && (
                    <motion.div
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        className="relative max-w-md mx-auto mt-20 p-8 rounded-2xl overflow-hidden"
                    >
                        <div className="text-center">
                            <div
                                className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br 
                from-blue-500/10 to-purple-500/10 ring-1 ring-white/10 mb-6"
                            >
                                <Code className="w-8 h-8 text-gray-400" />
                            </div>
                            <h3 className="text-xl font-medium text-white mb-3">No snippets found</h3>
                            <p className="text-gray-400 mb-6">
                                {searchQuery || selectedLanguage
                                    ? "Try adjusting your search query or filters"
                                    : "Be the first to share a code snippet with the community"}
                            </p>

                            {(searchQuery || selectedLanguage) && (
                                <button
                                    onClick={() => {
                                        setSearchQuery("");
                                        setSelectedLanguage(null);
                                    }}
                                    className="inline-flex items-center gap-2 px-4 py-2 bg-[#262637] text-gray-300 hover:text-white rounded-lg 
                    transition-colors"
                                >
                                    <X className="w-4 h-4" />
                                    Clear all filters
                                </button>
                            )}
                        </div>
                    </motion.div>
                )}

                {/* Load More Button */}
                {hasMore && snippets && snippets.length > 0 && !searchQuery.trim() && (
                    <div className="text-center mt-8">
                        <button
                            onClick={() => setPage(prev => prev + 1)}
                            disabled={loading}
                            className="px-6 py-3 bg-[#1e1e2e] hover:bg-[#262637] text-white rounded-lg transition-colors disabled:opacity-50 ring-1 ring-gray-800"
                        >
                            {loading ? 'Loading...' : 'Load More'}
                        </button>
                    </div>
                )}
            </div>
        </div>
    );
}
export default SnippetsPage;