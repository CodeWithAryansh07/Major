import { MessageSquare, Loader2 } from "lucide-react";
import { useState, useEffect } from "react";
import Comment from "./Comment";
import CommentForm from "./CommentForm";
import { useAuth } from "../contexts/AuthContext";
import { commentService } from "../services/commentService";
import type { Comment as CommentType } from "../services/commentService";

// Mock comments data as fallback
const mockComments: CommentType[] = [
    {
        id: "comment-1",
        content: "Great snippet! This is exactly what I was looking for. The explanation is clear and the code is well-structured.",
        userId: "user-2",
        snippetId: "1",
        createdAt: new Date(Date.now() - 86400000).toISOString(),
        updatedAt: new Date(Date.now() - 86400000).toISOString(),
    },
    {
        id: "comment-2", 
        content: `Thanks for sharing this. I modified it slightly for my use case:

\`\`\`javascript
const numbers = [1, 2, 3, 4, 5];
const result = numbers
  .filter(n => n % 2 === 0)
  .map(n => n * 3); // changed multiplier
console.log(result);
\`\`\`

Works perfectly!`,
        userId: "user-3",
        snippetId: "1", 
        createdAt: new Date(Date.now() - 43200000).toISOString(),
        updatedAt: new Date(Date.now() - 43200000).toISOString(),
    },
];

function Comments({ snippetId }: { snippetId: string }) {
    const [comments, setComments] = useState<CommentType[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string>('');
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [deletingCommentId, setDeletingCommentId] = useState<string | null>(null);
    const { isAuthenticated, user } = useAuth();

    useEffect(() => {
        loadComments();
    }, [snippetId]);

    const loadComments = async () => {
        try {
            setLoading(true);
            setError('');
            const response = await commentService.getCommentsBySnippet(snippetId);
            setComments(response);
        } catch (err) {
            console.error('Error loading comments:', err);
            setError('Failed to load comments');
            // Fallback to mock data
            setComments(mockComments.filter(comment => comment.snippetId === snippetId));
        } finally {
            setLoading(false);
        }
    };

    const handleSubmitComment = async (content: string) => {
        if (!isAuthenticated) {
            setError('Please sign in to comment');
            return;
        }

        setIsSubmitting(true);
        setError('');

        try {
            const newComment = await commentService.createComment({
                snippetId,
                content,
            });

            // Add the new comment to the list
            setComments(prev => [newComment, ...prev]);
        } catch (err) {
            console.error('Error adding comment:', err);
            setError('Failed to add comment. Please try again.');
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDeleteComment = async (commentId: string) => {
        if (!isAuthenticated) {
            setError('Please sign in to delete comments');
            return;
        }

        setDeletingCommentId(commentId);
        setError('');

        try {
            await commentService.deleteComment(commentId);
            setComments(prev => prev.filter(comment => comment.id !== commentId));
        } catch (err) {
            console.error('Error deleting comment:', err);
            setError('Failed to delete comment. Please try again.');
        } finally {
            setDeletingCommentId(null);
        }
    };

    if (loading) {
        return (
            <div className="bg-[#121218] border border-[#ffffff0a] rounded-2xl overflow-hidden">
                <div className="px-6 sm:px-8 py-6 border-b border-[#ffffff0a]">
                    <h2 className="text-lg font-semibold text-white flex items-center gap-2">
                        <MessageSquare className="w-5 h-5" />
                        Discussion
                    </h2>
                </div>
                <div className="p-6 sm:p-8 flex items-center justify-center">
                    <Loader2 className="w-6 h-6 animate-spin text-gray-400" />
                    <span className="ml-2 text-gray-400">Loading comments...</span>
                </div>
            </div>
        );
    }

    return (
        <div className="bg-[#121218] border border-[#ffffff0a] rounded-2xl overflow-hidden">
            <div className="px-6 sm:px-8 py-6 border-b border-[#ffffff0a]">
                <h2 className="text-lg font-semibold text-white flex items-center gap-2">
                    <MessageSquare className="w-5 h-5" />
                    Discussion ({comments.length})
                </h2>
            </div>

            <div className="p-6 sm:p-8">
                {error && (
                    <div className="mb-4 p-3 bg-red-900/20 border border-red-700 rounded-lg">
                        <p className="text-red-300 text-sm">{error}</p>
                        <button
                            onClick={loadComments}
                            className="mt-2 text-red-200 underline hover:no-underline text-sm"
                        >
                            Retry
                        </button>
                    </div>
                )}

                <CommentForm 
                    onSubmit={handleSubmitComment} 
                    isSubmitting={isSubmitting}
                    isAuthenticated={isAuthenticated}
                />

                <div className="space-y-6">
                    {comments.map((comment) => (
                        <Comment
                            key={comment.id}
                            comment={{
                                _id: comment.id,
                                content: comment.content,
                                userName: 'User', // Backend doesn't provide username currently
                                userId: comment.userId,
                                snippetId: comment.snippetId,
                                _creationTime: new Date(comment.createdAt || Date.now()).getTime(),
                            }}
                            onDelete={handleDeleteComment}
                            isDeleting={deletingCommentId === comment.id}
                            currentUserId={user?.id || ''}
                        />
                    ))}
                    
                    {comments.length === 0 && !loading && (
                        <div className="text-center py-8">
                            <MessageSquare className="w-12 h-12 text-gray-600 mx-auto mb-3" />
                            <p className="text-gray-400">No comments yet.</p>
                            <p className="text-gray-500 text-sm">Be the first to start the discussion!</p>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}

export default Comments;