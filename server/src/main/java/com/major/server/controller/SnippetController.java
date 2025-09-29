package com.major.server.controller;

import com.major.server.model.Snippet;
import com.major.server.service.SnippetService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/snippets")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class SnippetController {

    private final SnippetService snippetService;

    @GetMapping("/public")
    public ResponseEntity<Page<Snippet>> getPublicSnippets(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        
        Sort sort = sortDir.equalsIgnoreCase("asc") ? 
                Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
        
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<Snippet> snippets = snippetService.findPublicSnippets(pageable);
        
        return ResponseEntity.ok(snippets);
    }

    @GetMapping("/search")
    public ResponseEntity<Page<Snippet>> searchSnippets(
            @RequestParam String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<Snippet> snippets = snippetService.searchPublicSnippets(q, pageable);
        
        return ResponseEntity.ok(snippets);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Snippet> getSnippet(@PathVariable String id) {
        return snippetService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/my")
    public ResponseEntity<List<Snippet>> getMySnippets() {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }
        
        List<Snippet> snippets = snippetService.findByUserId(userId);
        return ResponseEntity.ok(snippets);
    }

    @GetMapping("/starred")
    public ResponseEntity<List<Snippet>> getStarredSnippets() {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }
        
        List<Snippet> snippets = snippetService.findSnippetsStarredByUser(userId);
        return ResponseEntity.ok(snippets);
    }

    @PostMapping("/{id}/star")
    public ResponseEntity<Snippet> toggleStar(@PathVariable String id) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }
        
        try {
            Snippet snippet = snippetService.toggleStar(id, userId);
            return ResponseEntity.ok(snippet);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // CRUD Operations
    @PostMapping
    public ResponseEntity<Snippet> createSnippet(@Valid @RequestBody Snippet snippet) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        snippet.setUserId(userId);
        Snippet savedSnippet = snippetService.save(snippet);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedSnippet);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Snippet> updateSnippet(@PathVariable String id, @Valid @RequestBody Snippet snippet) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            Snippet updatedSnippet = snippetService.updateSnippet(id, snippet, userId);
            return ResponseEntity.ok(updatedSnippet);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSnippet(@PathVariable String id) {
        String userId = getCurrentUserId();
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            snippetService.deleteSnippet(id, userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    private String getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && 
            !"anonymousUser".equals(authentication.getPrincipal())) {
            return authentication.getName(); // This should be the email
        }
        return null;
    }
}