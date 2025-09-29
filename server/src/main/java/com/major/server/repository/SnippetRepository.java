package com.major.server.repository;

import com.major.server.model.Snippet;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SnippetRepository extends MongoRepository<Snippet, String> {
    
    // Find by user
    List<Snippet> findByUserId(String userId);
    Page<Snippet> findByUserId(String userId, Pageable pageable);
    
    // Find public snippets
    @Query("{ 'isPublic': true }")
    List<Snippet> findPublicSnippets();
    
    @Query("{ 'isPublic': true }")
    Page<Snippet> findPublicSnippets(Pageable pageable);
    
    // Find by language
    List<Snippet> findByLanguage(String language);
    Page<Snippet> findByLanguageAndIsPublic(String language, boolean isPublic, Pageable pageable);
    
    // Search snippets
    @Query("{ $and: [ " +
           "{ 'isPublic': true }, " +
           "{ $or: [ " +
           "{ 'title': { $regex: ?0, $options: 'i' } }, " +
           "{ 'description': { $regex: ?0, $options: 'i' } }, " +
           "{ 'tags': { $in: [?0] } } " +
           "] } ] }")
    Page<Snippet> searchPublicSnippets(String searchTerm, Pageable pageable);
    
    // Find by tags
    @Query("{ 'tags': { $in: ?0 } }")
    List<Snippet> findByTagsIn(List<String> tags);
    
    @Query("{ $and: [ { 'isPublic': true }, { 'tags': { $in: ?0 } } ] }")
    Page<Snippet> findPublicSnippetsByTagsIn(List<String> tags, Pageable pageable);
    
    // Find starred snippets by user
    @Query("{ 'starredBy': ?0 }")
    List<Snippet> findSnippetsStarredByUser(String userId);
    
    @Query("{ 'starredBy': ?0 }")
    Page<Snippet> findSnippetsStarredByUser(String userId, Pageable pageable);
    
    // Find recent snippets
    @Query("{ $and: [ { 'isPublic': true }, { 'createdAt': { $gte: ?0 } } ] }")
    List<Snippet> findRecentPublicSnippets(LocalDateTime since);
    
    // Popular snippets (by star count)
    @Query(value = "{ 'isPublic': true }", sort = "{ 'starCount': -1 }")
    Page<Snippet> findPopularSnippets(Pageable pageable);
    
    // Statistics
    @Query(value = "{ 'userId': ?0 }", count = true)
    long countByUserId(String userId);
    
    @Query(value = "{ 'isPublic': true }", count = true)
    long countPublicSnippets();
    
    @Query(value = "{ 'language': ?0 }", count = true)
    long countByLanguage(String language);
    
    // Aggregation for trending snippets (created in last week with high star count)
    @Query("{ $and: [ " +
           "{ 'isPublic': true }, " +
           "{ 'createdAt': { $gte: ?0 } }, " +
           "{ 'starCount': { $gte: ?1 } } " +
           "] }")
    List<Snippet> findTrendingSnippets(LocalDateTime since, int minStars);
}