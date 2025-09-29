package com.major.server.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    
    private String id;
    private String name;
    private String username;
    private String email;
    private String avatarUrl;
    private String bio;
    private Set<String> starredSnippets;
    private LocalDateTime createdAt;
}