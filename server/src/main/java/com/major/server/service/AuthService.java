package com.major.server.service;

import com.major.server.dto.AuthRequest;
import com.major.server.dto.AuthResponse;
import com.major.server.dto.RegisterRequest;
import com.major.server.dto.UserResponse;
import com.major.server.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserService userService;
    private final JwtService jwtService;
    private final AuthenticationProvider authenticationProvider;

    public AuthResponse register(RegisterRequest request) {
        User user = userService.createUser(
                request.getName(),
                request.getUsername(),
                request.getEmail(),
                request.getPassword()
        );

        UserDetails userDetails = userService.loadUserByUsername(user.getEmail());
        String jwtToken = jwtService.generateToken(userDetails);
        
        UserResponse userResponse = userService.convertToUserResponse(user);

        return AuthResponse.builder()
                .token(jwtToken)
                .tokenType("Bearer")
                .expiresIn(jwtService.getExpirationTime() / 1000) // Convert to seconds
                .user(userResponse)
                .build();
    }

    public AuthResponse authenticate(AuthRequest request) {
        authenticationProvider.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        User user = userService.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserDetails userDetails = userService.loadUserByUsername(user.getEmail());
        String jwtToken = jwtService.generateToken(userDetails);
        
        UserResponse userResponse = userService.convertToUserResponse(user);

        return AuthResponse.builder()
                .token(jwtToken)
                .tokenType("Bearer")
                .expiresIn(jwtService.getExpirationTime() / 1000) // Convert to seconds
                .user(userResponse)
                .build();
    }
}