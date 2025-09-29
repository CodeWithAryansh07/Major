package com.major.server.controller;

import com.major.server.dto.CodeExecutionRequest;
import com.major.server.model.CodeExecution;
import com.major.server.service.CodeExecutionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/execute")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CodeExecutionController {

    private final CodeExecutionService codeExecutionService;

    @PostMapping
    public Mono<ResponseEntity<CodeExecution>> executeCode(@Valid @RequestBody CodeExecutionRequest request) {
        // Get user ID if authenticated, otherwise null for anonymous execution
        String userId = getCurrentUserId();
        
        return codeExecutionService.executeCode(request, userId)
                .map(ResponseEntity::ok)
                .onErrorReturn(ResponseEntity.internalServerError().build());
    }

    @GetMapping("/history")
    public ResponseEntity<List<CodeExecution>> getExecutionHistory() {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }
        
        List<CodeExecution> history = codeExecutionService.getExecutionHistory(userId);
        return ResponseEntity.ok(history);
    }

    @GetMapping("/{executionId}")
    public ResponseEntity<CodeExecution> getExecution(@PathVariable String executionId) {
        try {
            CodeExecution execution = codeExecutionService.getExecution(executionId);
            return ResponseEntity.ok(execution);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    private String getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && 
            !"anonymousUser".equals(authentication.getPrincipal())) {
            // You would need to get the user ID from the UserDetails or token
            // For now, returning the username (email) as userId
            return authentication.getName();
        }
        return null;
    }
}