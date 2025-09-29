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

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.HashSet;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "users")
public class User {
    
    @Id
    private String id;
    
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 20, message = "Username must be between 3 and 20 characters")
    @Indexed(unique = true)
    private String username;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    @Indexed(unique = true)
    private String email;
    
    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;
    
    @Builder.Default
    private Set<String> roles = new HashSet<>();
    
    @Builder.Default
    private boolean isPro = false;
    
    @Builder.Default
    private boolean isActive = true;
    
    private String profilePicture;
    
    private String firstName;
    private String lastName;
    private String bio;
    private String location;
    private String website;
    private String githubUsername;
    private String twitterUsername;
    private String linkedinUsername;
    
    @Builder.Default
    private Set<String> starredSnippets = new HashSet<>();
    
    @Builder.Default
    private Set<String> favoriteLanguages = new HashSet<>();
    
    @CreatedDate
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    private LocalDateTime deletedAt;
    
    // Helper methods
    public void addRole(String role) {
        this.roles.add(role);
    }
    
    public void removeRole(String role) {
        this.roles.remove(role);
    }
    
    public void starSnippet(String snippetId) {
        this.starredSnippets.add(snippetId);
    }
    
    public void unstarSnippet(String snippetId) {
        this.starredSnippets.remove(snippetId);
    }
    
    public boolean hasStarredSnippet(String snippetId) {
        return this.starredSnippets.contains(snippetId);
    }
}