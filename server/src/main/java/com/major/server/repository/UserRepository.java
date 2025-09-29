package com.major.server.repository;

import com.major.server.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    
    // Authentication
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    
    // Profile queries
    Optional<User> findByUsername(String username);
    boolean existsByUsername(String username);
    
    // Search users
    @Query("{ $or: [ " +
           "{ 'username': { $regex: ?0, $options: 'i' } }, " +
           "{ 'name': { $regex: ?0, $options: 'i' } } " +
           "] }")
    List<User> findByUsernameOrNameContainingIgnoreCase(String searchTerm);
    
    // Active users (not deleted)
    @Query("{ 'deletedAt': null }")
    List<User> findActiveUsers();
    
    // Users by creation date
    @Query("{ 'createdAt': { $gte: ?0, $lte: ?1 } }")
    List<User> findByCreatedAtBetween(java.time.LocalDateTime start, java.time.LocalDateTime end);
    
    // Statistics
    @Query(value = "{}", count = true)
    long countAllUsers();
    
    @Query(value = "{ 'deletedAt': null }", count = true)
    long countActiveUsers();
}