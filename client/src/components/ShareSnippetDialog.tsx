"use client";
import { useState } from "react";
import { X, Copy, CheckCircle, Share, Save } from "lucide-react";
import { useCodeEditorStore } from "../store/useCodeEditorStore";
import { useAuth } from "../contexts/AuthContext";
import { snippetService } from "../services/snippetService";
import toast from "react-hot-toast";

interface ShareSnippetDialogProps {
    onClose: () => void;
    onSnippetSaved?: (snippetId: string) => void;
}

function ShareSnippetDialog({ onClose, onSnippetSaved }: ShareSnippetDialogProps) {
    const [isCopied, setIsCopied] = useState(false);
    const [isSaving, setIsSaving] = useState(false);
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [isPublic, setIsPublic] = useState(true);
    const [tags, setTags] = useState("");
    const { getCode, language } = useCodeEditorStore();
    const { isAuthenticated } = useAuth();

    const handleCopyCode = async () => {
        const code = getCode();
        if (!code) {
            toast.error("No code to copy!");
            return;
        }

        try {
            await navigator.clipboard.writeText(code);
            setIsCopied(true);
            toast.success("Code copied to clipboard!");
            setTimeout(() => setIsCopied(false), 2000);
        } catch (error) {
            toast.error("Failed to copy code");
        }
    };

    const handleSaveSnippet = async () => {
        const code = getCode();
        if (!code) {
            toast.error("No code to save!");
            return;
        }

        if (!title.trim()) {
            toast.error("Please enter a title for your snippet!");
            return;
        }

        if (!isAuthenticated) {
            toast.error("Please sign in to save snippets!");
            return;
        }

        try {
            setIsSaving(true);
            const tagsArray = tags
                .split(',')
                .map(tag => tag.trim())
                .filter(tag => tag.length > 0);

            const snippet = await snippetService.createSnippet({
                title: title.trim(),
                code: code,
                language: language,
                description: description.trim() || undefined,
                tags: tagsArray.length > 0 ? tagsArray : undefined,
                isPublic: isPublic
            });

            toast.success("Snippet saved successfully!");
            onSnippetSaved?.(snippet.id || '');
            onClose();
        } catch (error) {
            console.error('Error saving snippet:', error);
            toast.error("Failed to save snippet. Please try again.");
        } finally {
            setIsSaving(false);
        }
    };

    return (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <div className="bg-[#1e1e2e] rounded-xl border border-white/10 p-6 w-full max-w-md max-h-[90vh] overflow-y-auto">
                <div className="flex items-center justify-between mb-4">
                    <h3 className="text-lg font-semibold text-white">Share Code</h3>
                    <button
                        onClick={onClose}
                        className="p-2 hover:bg-white/5 rounded-lg transition-colors"
                    >
                        <X className="w-5 h-5 text-gray-400" />
                    </button>
                </div>

                <div className="space-y-4">
                    <p className="text-sm text-gray-400">
                        Copy your {language} code or save it as a snippet.
                    </p>

                    <button
                        onClick={handleCopyCode}
                        className="flex items-center gap-2 w-full px-4 py-2 bg-blue-500/10 hover:bg-blue-500/20 
                                 text-blue-400 rounded-lg border border-blue-500/20 hover:border-blue-500/40 
                                 transition-all duration-200"
                    >
                        {isCopied ? (
                            <>
                                <CheckCircle className="w-4 h-4" />
                                <span>Copied!</span>
                            </>
                        ) : (
                            <>
                                <Copy className="w-4 h-4" />
                                <span>Copy Code</span>
                            </>
                        )}
                    </button>

                    {isAuthenticated && (
                        <>
                            <div className="border-t border-white/10 pt-4">
                                <h4 className="text-sm font-medium text-white mb-3 flex items-center gap-2">
                                    <Save className="w-4 h-4" />
                                    Save as Snippet
                                </h4>

                                <div className="space-y-3">
                                    <input
                                        type="text"
                                        placeholder="Enter a title..."
                                        value={title}
                                        onChange={(e) => setTitle(e.target.value)}
                                        className="w-full px-3 py-2 bg-[#262637] text-white placeholder:text-gray-500 
                                                 border border-white/10 rounded-lg focus:outline-none focus:ring-2 
                                                 focus:ring-blue-500/50"
                                    />

                                    <textarea
                                        placeholder="Description (optional)..."
                                        value={description}
                                        onChange={(e) => setDescription(e.target.value)}
                                        rows={2}
                                        className="w-full px-3 py-2 bg-[#262637] text-white placeholder:text-gray-500 
                                                 border border-white/10 rounded-lg focus:outline-none focus:ring-2 
                                                 focus:ring-blue-500/50 resize-none"
                                    />

                                    <input
                                        type="text"
                                        placeholder="Tags (comma separated)..."
                                        value={tags}
                                        onChange={(e) => setTags(e.target.value)}
                                        className="w-full px-3 py-2 bg-[#262637] text-white placeholder:text-gray-500 
                                                 border border-white/10 rounded-lg focus:outline-none focus:ring-2 
                                                 focus:ring-blue-500/50"
                                    />

                                    <label className="flex items-center gap-2 text-sm text-gray-400">
                                        <input
                                            type="checkbox"
                                            checked={isPublic}
                                            onChange={(e) => setIsPublic(e.target.checked)}
                                            className="w-4 h-4 text-blue-500 bg-[#262637] border border-white/10 
                                                     rounded focus:ring-blue-500/50"
                                        />
                                        Make this snippet public
                                    </label>
                                </div>

                                <button
                                    onClick={handleSaveSnippet}
                                    disabled={isSaving || !title.trim()}
                                    className="flex items-center gap-2 w-full px-4 py-2 mt-4 bg-green-500/10 
                                             hover:bg-green-500/20 text-green-400 rounded-lg border 
                                             border-green-500/20 hover:border-green-500/40 transition-all 
                                             duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    <Share className="w-4 h-4" />
                                    <span>{isSaving ? "Saving..." : "Save Snippet"}</span>
                                </button>
                            </div>
                        </>
                    )}

                    {!isAuthenticated && (
                        <div className="border-t border-white/10 pt-4">
                            <p className="text-sm text-gray-400 mb-3">
                                Sign in to save and share your code snippets with the community.
                            </p>
                            <button
                                onClick={() => {
                                    onClose();
                                    // Navigate to login - this could be improved with React Router
                                    window.location.href = '/login';
                                }}
                                className="w-full px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white 
                                         rounded-lg transition-colors"
                            >
                                Sign In
                            </button>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}

export default ShareSnippetDialog;