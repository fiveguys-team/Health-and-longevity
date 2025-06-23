package com.example.livecommerce_server.ai.controller;

import com.example.livecommerce_server.ai.dto.SurveyForm;
import com.example.livecommerce_server.ai.service.AiProductRecommendationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class AiProductRecommendationController {

    private final AiProductRecommendationService aiProductRecommendationService;

    @PostMapping("/recommendations")
    public String recommend(@RequestBody SurveyForm surveyForm) {
        return aiProductRecommendationService.recommend(surveyForm);
    }
}
