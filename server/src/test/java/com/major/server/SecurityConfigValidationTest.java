package com.major.server;

import org.junit.jupiter.api.Test;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.mock.web.MockHttpServletRequest;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test to validate security configuration patterns without full Spring context
 */
public class SecurityConfigValidationTest {

    @Test
    public void testAuthEndpointPatterns() {
        // Test auth patterns
        AntPathRequestMatcher authPattern = new AntPathRequestMatcher("/api/auth/**");
        AntPathRequestMatcher registerPattern = new AntPathRequestMatcher("/api/auth/register");
        AntPathRequestMatcher loginPattern = new AntPathRequestMatcher("/api/auth/login");
        
        MockHttpServletRequest registerRequest = new MockHttpServletRequest("POST", "/api/auth/register");
        registerRequest.setServletPath("/api/auth/register");
        MockHttpServletRequest loginRequest = new MockHttpServletRequest("POST", "/api/auth/login");
        loginRequest.setServletPath("/api/auth/login");
        
        // Debug: print what we're testing
        System.out.println("Testing auth patterns:");
        System.out.println("Register request servlet path: " + registerRequest.getServletPath());
        System.out.println("Register request URI: " + registerRequest.getRequestURI());
        System.out.println("Register request path info: " + registerRequest.getPathInfo());
        
        assertTrue(authPattern.matches(registerRequest), "Auth pattern should match register endpoint");
        assertTrue(authPattern.matches(loginRequest), "Auth pattern should match login endpoint");
        assertTrue(registerPattern.matches(registerRequest), "Register pattern should match register endpoint");
        assertTrue(loginPattern.matches(loginRequest), "Login pattern should match login endpoint");
    }

    @Test
    public void testExecuteEndpointPatterns() {
        AntPathRequestMatcher executePattern = new AntPathRequestMatcher("/api/execute");
        AntPathRequestMatcher executeWildcardPattern = new AntPathRequestMatcher("/api/execute/**");
        
        MockHttpServletRequest executeRequest = new MockHttpServletRequest("POST", "/api/execute");
        MockHttpServletRequest executeHistoryRequest = new MockHttpServletRequest("GET", "/api/execute/history");
        
        // Debug: print what we're testing
        System.out.println("Testing execute patterns:");
        System.out.println("Execute request path: " + executeRequest.getServletPath());
        System.out.println("Execute pattern matches execute: " + executePattern.matches(executeRequest));
        
        assertTrue(executePattern.matches(executeRequest), "Execute pattern should match execute endpoint");
        assertTrue(executeWildcardPattern.matches(executeHistoryRequest), "Execute wildcard pattern should match history endpoint");
    }

    @Test
    public void testSnippetEndpointPatterns() {
        AntPathRequestMatcher snippetWildcardPattern = new AntPathRequestMatcher("/api/snippets/**");
        AntPathRequestMatcher publicPattern = new AntPathRequestMatcher("/api/snippets/public");
        AntPathRequestMatcher searchPattern = new AntPathRequestMatcher("/api/snippets/search");
        
        MockHttpServletRequest individualSnippetRequest = new MockHttpServletRequest("GET", "/api/snippets/abc123");
        MockHttpServletRequest publicRequest = new MockHttpServletRequest("GET", "/api/snippets/public");
        MockHttpServletRequest searchRequest = new MockHttpServletRequest("GET", "/api/snippets/search");
        
        // Debug: print what we're testing
        System.out.println("Testing snippet patterns:");
        System.out.println("Individual snippet request path: " + individualSnippetRequest.getServletPath());
        System.out.println("Snippet wildcard pattern matches individual: " + snippetWildcardPattern.matches(individualSnippetRequest));
        
        assertTrue(snippetWildcardPattern.matches(individualSnippetRequest), "Snippet wildcard pattern should match individual snippet");
        assertTrue(snippetWildcardPattern.matches(publicRequest), "Snippet wildcard pattern should match public endpoint");
        assertTrue(snippetWildcardPattern.matches(searchRequest), "Snippet wildcard pattern should match search endpoint");
        assertTrue(publicPattern.matches(publicRequest), "Public pattern should match public endpoint");
        assertTrue(searchPattern.matches(searchRequest), "Search pattern should match search endpoint");
    }

    @Test
    public void testHealthEndpointPattern() {
        AntPathRequestMatcher healthPattern = new AntPathRequestMatcher("/api/health");
        
        MockHttpServletRequest healthRequest = new MockHttpServletRequest("GET", "/api/health");
        
        // Debug: print what we're testing
        System.out.println("Testing health pattern:");
        System.out.println("Health request path: " + healthRequest.getServletPath());
        System.out.println("Health pattern matches health: " + healthPattern.matches(healthRequest));
        
        assertTrue(healthPattern.matches(healthRequest), "Health pattern should match health endpoint");
    }
}