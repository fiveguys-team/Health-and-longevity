package com.example.livecommerce_server.ai.service;

import com.example.livecommerce_server.ai.dto.SurveyForm;
import com.example.livecommerce_server.ai.survey.SurveyPromptBuilder;
import com.example.livecommerce_server.product.dto.AiProduct;
import com.example.livecommerce_server.product.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AiProductRecommendationService {

    private final ChatClient chatClient;
    private final SurveyPromptBuilder surveyPromptBuilder;
    private final ProductService productService;

    public List<AiProduct> recommend(SurveyForm surveyForm) {
        String prompt = surveyPromptBuilder.buildPrompt(surveyForm, productService.getAiProducts());
        String aiResult = chatClient.prompt().user(prompt).call().content();

        List<String> productNames = new ArrayList<>();
        String[] lines = aiResult.split("\n");
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            int start = line.indexOf('[');
            int end = line.indexOf(']');
            if (start != -1 && end != -1 && end > start) {
                String name = line.substring(start + 1, end).trim();
                productNames.add(name);
            }
        }

        return productService.findAiProductsByNames(productNames);
    }
}
