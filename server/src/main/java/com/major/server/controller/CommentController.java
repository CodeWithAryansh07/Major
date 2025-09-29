package com.major.server.controller;

import com.major.server.model.Comment;
import com.major.server.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CommentController {

    private final CommentService commentService;

    @PostMapping
    public ResponseEntity<Comment> createComment(@Valid @RequestBody Comment comment) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        comment.setUserId(userId);
        Comment savedComment = commentService.save(comment);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedComment);
    }

    @GetMapping("/snippet/{snippetId}")
    public ResponseEntity<List<Comment>> getCommentsBySnippet(@PathVariable String snippetId) {
        List<Comment> comments = commentService.findBySnippetId(snippetId);
        return ResponseEntity.ok(comments);
    }

    @PostMapping("/{commentId}/reply")
    public ResponseEntity<Comment> replyToComment(@PathVariable String commentId, 
                                                 @Valid @RequestBody Comment reply) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        reply.setUserId(userId);
        reply.setParentCommentId(commentId);
        Comment savedReply = commentService.save(reply);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedReply);
    }

    @GetMapping("/{commentId}/replies")
    public ResponseEntity<List<Comment>> getReplies(@PathVariable String commentId) {
        List<Comment> replies = commentService.findRepliesByParentId(commentId);
        return ResponseEntity.ok(replies);
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> deleteComment(@PathVariable String commentId) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            commentService.deleteComment(commentId, userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    private String getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && 
            !"anonymousUser".equals(authentication.getPrincipal())) {
            return authentication.getName(); // This should be the email
        }
        return null;
    }
}