package com.major.server.repository;

import com.major.server.model.CodeExecution;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface CodeExecutionRepository extends MongoRepository<CodeExecution, String> {
    
    // Find executions by user
    List<CodeExecution> findByUserId(String userId);
    Page<CodeExecution> findByUserId(String userId, Pageable pageable);
    
    // Find executions by language
    List<CodeExecution> findByLanguage(String language);
    Page<CodeExecution> findByLanguage(String language, Pageable pageable);
    
    // Find executions by status
    List<CodeExecution> findByStatus(CodeExecution.ExecutionStatus status);
    
    // Find successful executions
    @Query("{ 'status': 'SUCCESS' }")
    List<CodeExecution> findSuccessfulExecutions();
    
    // Find failed executions
    @Query("{ $or: [ { 'status': 'ERROR' }, { 'status': 'TIMEOUT' }, { 'status': 'MEMORY_LIMIT_EXCEEDED' } ] }")
    List<CodeExecution> findFailedExecutions();
    
    // Find recent executions
    @Query("{ 'executedAt': { $gte: ?0 } }")
    List<CodeExecution> findRecentExecutions(LocalDateTime since);
    
    // Find executions by user and language
    @Query("{ $and: [ { 'userId': ?0 }, { 'language': ?1 } ] }")
    List<CodeExecution> findByUserIdAndLanguage(String userId, String language);
    
    // Find executions with execution time range
    @Query("{ $and: [ { 'executionTime': { $gte: ?0 } }, { 'executionTime': { $lte: ?1 } } ] }")
    List<CodeExecution> findByExecutionTimeBetween(Long minTime, Long maxTime);
    
    // Statistics
    @Query(value = "{ 'userId': ?0 }", count = true)
    long countByUserId(String userId);
    
    @Query(value = "{ 'language': ?0 }", count = true)
    long countByLanguage(String language);
    
    @Query(value = "{ 'status': ?0 }", count = true)
    long countByStatus(CodeExecution.ExecutionStatus status);
    
    @Query(value = "{ 'executedAt': { $gte: ?0, $lte: ?1 } }", count = true)
    long countExecutionsBetweenDates(LocalDateTime start, LocalDateTime end);
    
    // Aggregation for average execution time by language
    @Query("{ 'language': ?0 }")
    List<CodeExecution> findExecutionsByLanguageForStats(String language);
    
    // Clean up old executions (older than specified date)
    void deleteByExecutedAtBefore(LocalDateTime date);
}