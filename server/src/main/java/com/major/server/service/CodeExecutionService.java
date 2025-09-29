package com.major.server.service;

import com.major.server.dto.CodeExecutionRequest;
import com.major.server.model.CodeExecution;
import com.major.server.repository.CodeExecutionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class CodeExecutionService {

    private final CodeExecutionRepository codeExecutionRepository;
    private final WebClient.Builder webClientBuilder;

    @Value("${app.piston.api.url}")
    private String pistonApiUrl;

    @Value("${app.piston.api.timeout:10000}")
    private int timeoutMs;

    public Mono<CodeExecution> executeCode(CodeExecutionRequest request, String userId) {
        CodeExecution execution = CodeExecution.builder()
                .code(request.getCode())
                .language(request.getLanguage())
                .userId(userId)
                .status(CodeExecution.ExecutionStatus.PENDING)
                .executedAt(LocalDateTime.now())
                .build();

        // Save initial execution record
        execution = codeExecutionRepository.save(execution);
        final CodeExecution savedExecution = execution;

        return callPistonApi(request)
                .map(response -> {
                    updateExecutionWithResponse(savedExecution, response);
                    return codeExecutionRepository.save(savedExecution);
                })
                .onErrorResume(error -> {
                    log.error("Error executing code: ", error);
                    savedExecution.markAsError("Error executing code: " + error.getMessage());
                    return Mono.just(codeExecutionRepository.save(savedExecution));
                });
    }

    private Mono<Map<String, Object>> callPistonApi(CodeExecutionRequest request) {
        WebClient webClient = webClientBuilder
                .baseUrl(pistonApiUrl)
                .build();

        Map<String, Object> pistonRequest = Map.of(
                "language", mapLanguageToPiston(request.getLanguage()),
                "version", "*", // Use latest version
                "files", List.of(Map.of(
                        "content", request.getCode()
                ))
        );

        return webClient
                .post()
                .uri("/execute")
                .bodyValue(pistonRequest)
                .retrieve()
                .bodyToMono(Map.class)
                .map(rawMap -> (Map<String, Object>) rawMap)
                .timeout(java.time.Duration.ofMillis(timeoutMs))
                .onErrorMap(WebClientResponseException.class, ex -> 
                    new RuntimeException("Piston API error: " + ex.getResponseBodyAsString(), ex))
                .onErrorMap(java.util.concurrent.TimeoutException.class, ex ->
                    new RuntimeException("Code execution timed out", ex));
    }

    private void updateExecutionWithResponse(CodeExecution execution, Map<String, Object> response) {
        try {
            Map<String, Object> run = (Map<String, Object>) response.get("run");
            
            if (run != null) {
                String stdout = (String) run.get("stdout");
                String stderr = (String) run.get("stderr");
                Integer code = (Integer) run.get("code");

                execution.setOutput(stdout != null ? stdout : "");
                execution.setError(stderr != null ? stderr : "");

                if (code != null && code == 0) {
                    execution.setStatus(CodeExecution.ExecutionStatus.SUCCESS);
                } else {
                    execution.setStatus(CodeExecution.ExecutionStatus.ERROR);
                }
            }

            // Extract Piston metadata
            String language = (String) response.get("language");
            String version = (String) response.get("version");
            
            execution.setPistonLanguage(language);
            execution.setPistonVersion(version);

        } catch (Exception e) {
            log.error("Error parsing Piston response", e);
            execution.markAsError("Error parsing execution response");
        }
    }

    private String mapLanguageToPiston(String language) {
        return switch (language.toLowerCase()) {
            case "javascript", "js" -> "javascript";
            case "typescript", "ts" -> "typescript";
            case "python", "py" -> "python";
            case "java" -> "java";
            case "cpp", "c++" -> "cpp";
            case "c" -> "c";
            case "csharp", "c#" -> "csharp";
            case "go" -> "go";
            case "rust" -> "rust";
            case "php" -> "php";
            case "ruby" -> "ruby";
            case "swift" -> "swift";
            case "kotlin" -> "kotlin";
            case "scala" -> "scala";
            case "bash", "sh" -> "bash";
            default -> language.toLowerCase();
        };
    }

    public List<CodeExecution> getExecutionHistory(String userId) {
        return codeExecutionRepository.findByUserId(userId);
    }

    public CodeExecution getExecution(String executionId) {
        return codeExecutionRepository.findById(executionId)
                .orElseThrow(() -> new RuntimeException("Execution not found"));
    }

    // Statistics methods
    public long getExecutionCountByLanguage(String language) {
        return codeExecutionRepository.countByLanguage(language);
    }

    public long getUserExecutionCount(String userId) {
        return codeExecutionRepository.countByUserId(userId);
    }
}