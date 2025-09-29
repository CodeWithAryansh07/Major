package com.major.server.service;

import com.major.server.model.Comment;
import com.major.server.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;

    @Transactional
    public Comment save(Comment comment) {
        return commentRepository.save(comment);
    }

    public Optional<Comment> findById(String id) {
        return commentRepository.findById(id);
    }

    public List<Comment> findBySnippetId(String snippetId) {
        return commentRepository.findBySnippetId(snippetId);
    }

    public List<Comment> findByUserId(String userId) {
        return commentRepository.findByUserId(userId);
    }

    public List<Comment> findRepliesByParentId(String parentCommentId) {
        return commentRepository.findByParentCommentId(parentCommentId);
    }

    @Transactional
    public void deleteComment(String commentId, String userId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("Comment not found"));
        
        // Check ownership
        if (!comment.getUserId().equals(userId)) {
            throw new RuntimeException("Not authorized to delete this comment");
        }
        
        commentRepository.deleteById(commentId);
    }

    public long getCommentCountBySnippet(String snippetId) {
        return commentRepository.countBySnippetId(snippetId);
    }

    public long getCommentCountByUser(String userId) {
        return commentRepository.countByUserId(userId);
    }
}