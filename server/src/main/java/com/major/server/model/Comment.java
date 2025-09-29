package com.major.server.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.HashSet;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "comments")
public class Comment {
    
    @Id
    private String id;
    
    @NotBlank(message = "Content is required")
    @Size(min = 1, max = 2000, message = "Comment must be between 1 and 2000 characters")
    private String content;
    
    @NotBlank(message = "Snippet ID is required")
    @Indexed
    private String snippetId;
    
    @NotBlank(message = "User ID is required")
    @Indexed
    private String userId;
    
    @NotBlank(message = "Username is required")
    private String userName;
    
    private String parentCommentId; // For nested comments
    
    @Builder.Default
    private Set<String> likedBy = new HashSet<>();
    
    @Builder.Default
    private boolean isEdited = false;
    
    @CreatedDate
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    // Helper methods
    public int getLikeCount() {
        return likedBy.size();
    }
    
    public void likeBy(String userId) {
        this.likedBy.add(userId);
    }
    
    public void unlikeBy(String userId) {
        this.likedBy.remove(userId);
    }
    
    public boolean isLikedBy(String userId) {
        return this.likedBy.contains(userId);
    }
    
    public boolean isReply() {
        return this.parentCommentId != null && !this.parentCommentId.isEmpty();
    }
    
    public void markAsEdited() {
        this.isEdited = true;
        this.updatedAt = LocalDateTime.now();
    }
}