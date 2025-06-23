package com.example.livecommerce_server.ai.service;

import com.example.livecommerce_server.ai.dto.SurveyForm;
import com.example.livecommerce_server.ai.survey.SurveyPromptBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AiProductRecommendationService {

    private final ChatClient chatClient;
    private final SurveyPromptBuilder surveyPromptBuilder;

    public String recommend(SurveyForm surveyForm) {
        String prompt = surveyPromptBuilder.buildPrompt(surveyForm);
        return chatClient.prompt()
                .user(prompt)
                .call()
                .content();
    }
}
