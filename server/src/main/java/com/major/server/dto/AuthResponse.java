package com.major.server.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {
    
    private String token;
    
    @Builder.Default
    private String tokenType = "Bearer";
    
    private Long expiresIn; // seconds
    private UserResponse user;
}