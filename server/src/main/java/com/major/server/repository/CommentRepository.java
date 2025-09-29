package com.major.server.repository;

import com.major.server.model.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends MongoRepository<Comment, String> {
    
    // Find comments by snippet
    List<Comment> findBySnippetId(String snippetId);
    Page<Comment> findBySnippetId(String snippetId, Pageable pageable);
    
    // Find comments by user
    List<Comment> findByUserId(String userId);
    Page<Comment> findByUserId(String userId, Pageable pageable);
    
    // Find root comments (not replies)
    @Query("{ $and: [ { 'snippetId': ?0 }, { 'parentCommentId': null } ] }")
    List<Comment> findRootCommentsBySnippetId(String snippetId);
    
    @Query("{ $and: [ { 'snippetId': ?0 }, { 'parentCommentId': null } ] }")
    Page<Comment> findRootCommentsBySnippetId(String snippetId, Pageable pageable);
    
    // Find replies to a comment
    List<Comment> findByParentCommentId(String parentCommentId);
    
    // Find comments with replies count
    @Query("{ $and: [ { 'snippetId': ?0 }, { 'parentId': null } ] }")
    List<Comment> findCommentsWithRepliesCount(String snippetId);
    
    // Search comments
    @Query("{ $and: [ " +
           "{ 'snippetId': ?0 }, " +
           "{ 'content': { $regex: ?1, $options: 'i' } } " +
           "] }")
    List<Comment> searchCommentsBySnippetAndContent(String snippetId, String searchTerm);
    
    // Find recent comments
    @Query(value = "{ 'snippetId': ?0 }", sort = "{ 'createdAt': -1 }")
    List<Comment> findRecentCommentsBySnippet(String snippetId);
    
    // Statistics
    @Query(value = "{ 'snippetId': ?0 }", count = true)
    long countBySnippetId(String snippetId);
    
    @Query(value = "{ 'userId': ?0 }", count = true)
    long countByUserId(String userId);
    
    @Query(value = "{ 'parentCommentId': ?0 }", count = true)
    long countRepliesByParentId(String parentCommentId);
    
    // Delete comments by snippet (when snippet is deleted)
    void deleteBySnippetId(String snippetId);
    
    // Delete replies when parent comment is deleted
    void deleteByParentCommentId(String parentCommentId);
}