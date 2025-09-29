package com.major.server.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "code_executions")
public class CodeExecution {
    
    @Id
    private String id;
    
    @NotBlank(message = "Code is required")
    private String code;
    
    @NotBlank(message = "Language is required")
    @Indexed
    private String language;
    
    private String userId; // Optional, for logged-in users
    
    private String output;
    private String error;
    
    @NotNull
    @Builder.Default
    private ExecutionStatus status = ExecutionStatus.PENDING;
    
    @Builder.Default
    private Long executionTime = 0L; // in milliseconds
    
    @Builder.Default
    private Long memoryUsage = 0L; // in bytes
    
    private String pistonVersion;
    private String pistonLanguage;
    
    @CreatedDate
    private LocalDateTime executedAt;
    
    // Enums
    public enum ExecutionStatus {
        PENDING,
        RUNNING,
        SUCCESS,
        ERROR,
        TIMEOUT,
        MEMORY_LIMIT_EXCEEDED
    }
    
    // Helper methods
    public boolean isSuccessful() {
        return this.status == ExecutionStatus.SUCCESS;
    }
    
    public boolean hasError() {
        return this.status == ExecutionStatus.ERROR;
    }
    
    public boolean isCompleted() {
        return this.status == ExecutionStatus.SUCCESS || 
               this.status == ExecutionStatus.ERROR ||
               this.status == ExecutionStatus.TIMEOUT ||
               this.status == ExecutionStatus.MEMORY_LIMIT_EXCEEDED;
    }
    
    public void markAsSuccess(String output, Long executionTime, Long memoryUsage) {
        this.status = ExecutionStatus.SUCCESS;
        this.output = output;
        this.executionTime = executionTime;
        this.memoryUsage = memoryUsage;
    }
    
    public void markAsError(String error) {
        this.status = ExecutionStatus.ERROR;
        this.error = error;
    }
    
    public void markAsTimeout() {
        this.status = ExecutionStatus.TIMEOUT;
        this.error = "Code execution timed out";
    }
}