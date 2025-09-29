"use client";

import { useParams } from "react-router-dom";
import SnippetLoadingSkeleton from "../components/SnippetLoadingSkeleton";
import NavigationHeader from "../components/NavigationHeader";
import { Clock, Code, MessageSquare, User } from "lucide-react";
import { Editor } from "@monaco-editor/react";
import { defineMonacoThemes, LANGUAGE_CONFIG } from "../constants";
import CopyButton from "../components/CopyButton";
import Comments from "../components/Comments";
import { useState, useEffect } from "react";
import { snippetService, type Snippet } from "../services";
import toast from "react-hot-toast";

function SnippetDetailPage() {
    const { id } = useParams<{ id: string }>();
    const [snippet, setSnippet] = useState<Snippet | undefined>(undefined);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        if (id) {
            loadSnippet(id);
        }
    }, [id]);

    const loadSnippet = async (snippetId: string) => {
        try {
            setIsLoading(true);
            const data = await snippetService.getSnippet(snippetId);
            setSnippet(data);
        } catch (error) {
            toast.error('Failed to load snippet');
            setSnippet(undefined);
        } finally {
            setIsLoading(false);
        }
    };

    if (isLoading) return <SnippetLoadingSkeleton />;
    
    if (!snippet) {
        return (
            <div className="min-h-screen bg-[#0a0a0f]">
                <NavigationHeader />
                <div className="max-w-[90rem] mx-auto px-4 py-12 text-center">
                    <h1 className="text-2xl font-bold text-white mb-4">Snippet not found</h1>
                    <p className="text-gray-400">The snippet you're looking for doesn't exist or has been removed.</p>
                </div>
            </div>
        );
    }

    const formatDate = (dateString?: string) => {
        if (!dateString) return 'Unknown date';
        return new Date(dateString).toLocaleDateString();
    };

    return (
        <div className="min-h-screen bg-[#0a0a0f]">
            <NavigationHeader />

            <main className="max-w-[90rem] mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8 lg:py-12">
                <div className="max-w-[1200px] mx-auto">
                    {/* Header */}
                    <div className="bg-[#121218] border border-[#ffffff0a] rounded-2xl p-6 sm:p-8 mb-6 backdrop-blur-xl">
                        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
                            <div className="flex items-center gap-4">
                                <div className="flex items-center justify-center size-12 rounded-xl bg-[#ffffff08] p-2.5">
                                    <img
                                        src={`/${snippet.language}.png`}
                                        alt={`${snippet.language} logo`}
                                        className="w-full h-full object-contain"
                                    />
                                </div>
                                <div>
                                    <h1 className="text-xl sm:text-2xl font-semibold text-white mb-2">
                                        {snippet.title}
                                    </h1>
                                    <div className="flex flex-wrap items-center gap-x-4 gap-y-2 text-sm">
                                        <div className="flex items-center gap-2 text-[#8b8b8d]">
                                            <User className="w-4 h-4" />
                                            <span>{snippet.userId || 'Unknown user'}</span>
                                        </div>
                                        <div className="flex items-center gap-2 text-[#8b8b8d]">
                                            <Clock className="w-4 h-4" />
                                            <span>{formatDate(snippet.createdAt)}</span>
                                        </div>
                                        <div className="flex items-center gap-2 text-[#8b8b8d]">
                                            <MessageSquare className="w-4 h-4" />
                                            <span>Comments</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div className="inline-flex items-center px-3 py-1.5 bg-[#ffffff08] text-[#808086] rounded-lg text-sm font-medium">
                                {snippet.language}
                            </div>
                        </div>
                    </div>

                    {/* Description */}
                    {snippet.description && (
                        <div className="bg-[#121218] border border-[#ffffff0a] rounded-2xl p-6 mb-6">
                            <h2 className="text-lg font-semibold text-white mb-3">Description</h2>
                            <p className="text-gray-300">{snippet.description}</p>
                        </div>
                    )}

                    {/* Code Editor */}
                    <div className="mb-8 rounded-2xl overflow-hidden border border-[#ffffff0a] bg-[#121218]">
                        <div className="flex items-center justify-between px-4 sm:px-6 py-4 border-b border-[#ffffff0a]">
                            <div className="flex items-center gap-2 text-[#808086]">
                                <Code className="w-4 h-4" />
                                <span className="text-sm font-medium">Source Code</span>
                            </div>
                            <CopyButton code={snippet.code} />
                        </div>
                        <Editor
                            height="600px"
                            language={LANGUAGE_CONFIG[snippet.language]?.monacoLanguage || snippet.language}
                            value={snippet.code}
                            theme="vs-dark"
                            beforeMount={defineMonacoThemes}
                            options={{
                                minimap: { enabled: false },
                                fontSize: 16,
                                readOnly: true,
                                automaticLayout: true,
                                scrollBeyondLastLine: false,
                                padding: { top: 16 },
                                renderWhitespace: "selection",
                                fontFamily: '"Fira Code", "Cascadia Code", Consolas, monospace',
                                fontLigatures: true,
                            }}
                        />
                    </div>

                    <Comments snippetId={snippet.id || ''} />
                </div>
            </main>
        </div>
    );
}

export default SnippetDetailPage;