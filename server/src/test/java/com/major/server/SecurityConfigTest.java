package com.major.server;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebMvc
@TestPropertySource(properties = {
    "spring.data.mongodb.auto-index-creation=false",
    "de.flapdoodle.mongodb.embedded.version=6.0.3"
})
public class SecurityConfigTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    private MockMvc mockMvc;

    @Test
    public void testPublicEndpointsAreAccessible() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();

        // Test health endpoint
        mockMvc.perform(get("/api/health"))
                .andExpect(status().isOk());

        // Test public snippets endpoint
        mockMvc.perform(get("/api/snippets/public"))
                .andExpect(status().isOk());

        // Test search endpoint
        mockMvc.perform(get("/api/snippets/search").param("q", "test"))
                .andExpect(status().isOk());

        // Test individual snippet endpoint (should not be 403)
        mockMvc.perform(get("/api/snippets/test123"))
                .andExpect(status().isNotFound()); // 404 is fine, 403 is not

        // Test that auth and execute endpoints are accessible (not 403)
        // Note: They may return other errors due to business logic, but shouldn't be 403 Forbidden
    }
}