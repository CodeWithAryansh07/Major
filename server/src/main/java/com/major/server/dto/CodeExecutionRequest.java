package com.major.server.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CodeExecutionRequest {
    
    @NotBlank(message = "Code is required")
    private String code;
    
    @NotBlank(message = "Language is required")
    private String language;
}