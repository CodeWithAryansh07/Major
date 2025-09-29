package com.major.server.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.index.TextIndexed;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.HashSet;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "snippets")
public class Snippet {
    
    @Id
    private String id;
    
    @NotBlank(message = "Title is required")
    @Size(min = 3, max = 100, message = "Title must be between 3 and 100 characters")
    @TextIndexed(weight = 2)
    private String title;
    
    @NotBlank(message = "Code is required")
    @Size(max = 50000, message = "Code must be less than 50000 characters")
    private String code;
    
    @NotBlank(message = "Language is required")
    @Indexed
    private String language;
    
    @Size(max = 500, message = "Description must be less than 500 characters")
    @TextIndexed
    private String description;
    
    @Builder.Default
    private Set<String> tags = new HashSet<>();
    
    @NotBlank(message = "User ID is required")
    @Indexed
    private String userId;
    
    @NotBlank(message = "Username is required")
    @Indexed
    private String userName;
    
    @Builder.Default
    private boolean isPublic = true;
    
    @Builder.Default
    private boolean isFeatured = false;
    
    @Builder.Default
    private Set<String> starredBy = new HashSet<>();
    
    @Builder.Default
    private Set<String> likedBy = new HashSet<>();
    
    @Builder.Default
    private int viewCount = 0;
    
    @Builder.Default
    private int forkCount = 0;
    
    private String originalSnippetId; // For forked snippets
    
    @CreatedDate
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    // Helper methods
    public int getStarCount() {
        return starredBy.size();
    }
    
    public int getLikeCount() {
        return likedBy.size();
    }
    
    public void starBy(String userId) {
        this.starredBy.add(userId);
    }
    
    public void unstarBy(String userId) {
        this.starredBy.remove(userId);
    }
    
    public boolean isStarredBy(String userId) {
        return this.starredBy.contains(userId);
    }
    
    public void toggleStar(String userId) {
        if (isStarredBy(userId)) {
            unstarBy(userId);
        } else {
            starBy(userId);
        }
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
    
    public void incrementViewCount() {
        this.viewCount++;
    }
    
    public void incrementForkCount() {
        this.forkCount++;
    }
    
    public void addTag(String tag) {
        this.tags.add(tag.toLowerCase());
    }
    
    public void removeTag(String tag) {
        this.tags.remove(tag.toLowerCase());
    }
}