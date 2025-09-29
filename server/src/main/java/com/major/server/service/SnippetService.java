package com.major.server.service;

import com.major.server.model.Snippet;
import com.major.server.repository.SnippetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SnippetService {

    private final SnippetRepository snippetRepository;

    @Transactional
    public Snippet createSnippet(String title, String code, String language, String userId) {
        Snippet snippet = Snippet.builder()
                .title(title)
                .code(code)
                .language(language)
                .userId(userId)
                .build();
        
        return snippetRepository.save(snippet);
    }

    @Transactional
    public Snippet save(Snippet snippet) {
        return snippetRepository.save(snippet);
    }

    public Optional<Snippet> findById(String id) {
        return snippetRepository.findById(id);
    }

    public List<Snippet> findByUserId(String userId) {
        return snippetRepository.findByUserId(userId);
    }

    public Page<Snippet> findPublicSnippets(Pageable pageable) {
        return snippetRepository.findPublicSnippets(pageable);
    }

    public Page<Snippet> searchPublicSnippets(String searchTerm, Pageable pageable) {
        return snippetRepository.searchPublicSnippets(searchTerm, pageable);
    }

    public List<Snippet> findByLanguage(String language) {
        return snippetRepository.findByLanguage(language);
    }

    public List<Snippet> findSnippetsStarredByUser(String userId) {
        return snippetRepository.findSnippetsStarredByUser(userId);
    }

    @Transactional
    public Snippet updateSnippet(String id, String title, String code, String description, 
                                List<String> tags, boolean isPublic) {
        Snippet snippet = snippetRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Snippet not found"));
        
        if (title != null) {
            snippet.setTitle(title);
        }
        if (code != null) {
            snippet.setCode(code);
        }
        if (description != null) {
            snippet.setDescription(description);
        }
        if (tags != null) {
            snippet.setTags(new HashSet<>(tags));
        }
        snippet.setPublic(isPublic);
        
        return snippetRepository.save(snippet);
    }

    @Transactional
    public Snippet updateSnippet(String id, Snippet updatedSnippet, String userId) {
        Snippet existingSnippet = snippetRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Snippet not found"));
        
        // Check ownership
        if (!existingSnippet.getUserId().equals(userId)) {
            throw new RuntimeException("Not authorized to update this snippet");
        }
        
        // Update fields
        if (updatedSnippet.getTitle() != null) {
            existingSnippet.setTitle(updatedSnippet.getTitle());
        }
        if (updatedSnippet.getCode() != null) {
            existingSnippet.setCode(updatedSnippet.getCode());
        }
        if (updatedSnippet.getDescription() != null) {
            existingSnippet.setDescription(updatedSnippet.getDescription());
        }
        if (updatedSnippet.getLanguage() != null) {
            existingSnippet.setLanguage(updatedSnippet.getLanguage());
        }
        if (updatedSnippet.getTags() != null) {
            existingSnippet.setTags(updatedSnippet.getTags());
        }
        existingSnippet.setPublic(updatedSnippet.isPublic());
        
        return snippetRepository.save(existingSnippet);
    }

    @Transactional
    public void deleteSnippet(String id) {
        snippetRepository.deleteById(id);
    }

    @Transactional
    public void deleteSnippet(String id, String userId) {
        Snippet snippet = snippetRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Snippet not found"));
        
        // Check ownership
        if (!snippet.getUserId().equals(userId)) {
            throw new RuntimeException("Not authorized to delete this snippet");
        }
        
        snippetRepository.deleteById(id);
    }

    @Transactional
    public Snippet toggleStar(String snippetId, String userId) {
        Snippet snippet = snippetRepository.findById(snippetId)
                .orElseThrow(() -> new RuntimeException("Snippet not found"));
        
        snippet.toggleStar(userId);
        return snippetRepository.save(snippet);
    }

    public long getSnippetCountByUser(String userId) {
        return snippetRepository.countByUserId(userId);
    }

    public long getPublicSnippetCount() {
        return snippetRepository.countPublicSnippets();
    }

    public Page<Snippet> findPopularSnippets(Pageable pageable) {
        return snippetRepository.findPopularSnippets(pageable);
    }
}