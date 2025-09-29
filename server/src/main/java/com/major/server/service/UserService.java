package com.major.server.service;

import com.major.server.dto.UserResponse;
import com.major.server.model.User;
import com.major.server.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .authorities("USER")
                .build();
    }

    @Transactional
    public User createUser(String name, String username, String email, String password) {
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already exists");
        }
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username already exists");
        }

        User user = User.builder()
                .firstName(name) // Use firstName for now
                .username(username)
                .email(email)
                .password(passwordEncoder.encode(password))
                .build();

        return userRepository.save(user);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findById(String id) {
        return userRepository.findById(id);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public List<UserResponse> searchUsers(String searchTerm) {
        List<User> users = userRepository.findByUsernameOrNameContainingIgnoreCase(searchTerm);
        return users.stream()
                .map(this::convertToUserResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public User updateProfile(String userId, String name, String bio, String avatarUrl) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (name != null && !name.trim().isEmpty()) {
            user.setFirstName(name.trim()); // Use firstName for now
        }
        if (bio != null) {
            user.setBio(bio.trim());
        }
        if (avatarUrl != null) {
            user.setProfilePicture(avatarUrl.trim()); // Use profilePicture
        }
        
        return userRepository.save(user);
    }

    @Transactional
    public void deleteUser(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        user.setDeletedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    public UserResponse convertToUserResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .name(user.getFirstName()) // Use firstName
                .username(user.getUsername())
                .email(user.getEmail())
                .avatarUrl(user.getProfilePicture()) // Use profilePicture
                .bio(user.getBio())
                .starredSnippets(user.getStarredSnippets())
                .createdAt(user.getCreatedAt())
                .build();
    }

    public long getTotalUsersCount() {
        return userRepository.countAllUsers();
    }

    public long getActiveUsersCount() {
        return userRepository.countActiveUsers();
    }
}