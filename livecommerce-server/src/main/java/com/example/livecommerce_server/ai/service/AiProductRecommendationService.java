package com.example.livecommerce_server.ai.service;

import com.example.livecommerce_server.ai.dto.SurveyForm;
import com.example.livecommerce_server.ai.survey.SurveyPromptBuilder;
import com.example.livecommerce_server.product.dto.AiProduct;
import com.example.livecommerce_server.product.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class AiProductRecommendationService {

    private final ChatClient chatClient;
    private final SurveyPromptBuilder surveyPromptBuilder;
    private final ProductService productService;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String CACHE_KEY_PREFIX = "rec:";

//    public List<AiProduct> recommend(SurveyForm surveyForm) {
//        String prompt = surveyPromptBuilder.buildPrompt(surveyForm, productService.getAiProducts());
//        String aiResult = chatClient.prompt().user(prompt).call().content();
//
//        List<String> productNames = new ArrayList<>();
//        String[] lines = aiResult.split("\n");
//        for (String line : lines) {
//            if (line.trim().isEmpty()) continue;
//            int start = line.indexOf('[');
//            int end = line.indexOf(']');
//            if (start != -1 && end != -1 && end > start) {
//                String name = line.substring(start + 1, end).trim();
//                productNames.add(name);
//            }
//        }
//
//        return productService.findAiProductsByNames(productNames);
//    }

    public List<AiProduct> recommend(SurveyForm surveyForm) {
        // 1. 설문 데이터 기반 유니크 키 생성 (연령대는 10대 단위로 범주화)
        String cacheKey = String.format("%s%s:%d:%s:%s:%s",
                CACHE_KEY_PREFIX, surveyForm.getGender(), (surveyForm.getAge()/10)*10,
                surveyForm.getInterest(), surveyForm.getForm(), surveyForm.getAllergy());

        // 2. Redis 캐시 확인
        try {
            List<AiProduct> cachedData = (List<AiProduct>) redisTemplate.opsForValue().get(cacheKey);
            if (cachedData != null) {
                log.info("🚀 [Cache Hit] AI 호출 없이 추천 결과를 반환합니다. Key: {}", cacheKey);
                return cachedData;
            }
        } catch (Exception e) {
            log.warn("Redis 조회 실패(무시하고 AI 호출 진행): {}", e.getMessage());
        }

        // 3. 캐시 미스 시 기존 AI 추천 로직 수행 [cite: 22, 24]
        log.info("☁️ [Cache Miss] AI 모델에게 추천을 요청합니다.");
        String prompt = surveyPromptBuilder.buildPrompt(surveyForm, productService.getAiProducts());
        String aiResult = chatClient.prompt().user(prompt).call().content();

        List<String> productNames = parseAiResult(aiResult);
        List<AiProduct> recommendedProducts = productService.findAiProductsByNames(productNames);

        // 4. 결과를 Redis에 저장 (TTL: 24시간)
        if (!recommendedProducts.isEmpty()) {
            redisTemplate.opsForValue().set(cacheKey, recommendedProducts, 24, TimeUnit.HOURS);
            log.info("💾 추천 결과를 Redis에 저장했습니다. (Key: {})", cacheKey);
        }

        return recommendedProducts;
    }

    private List<String> parseAiResult(String aiResult) {
        List<String> names = new ArrayList<>();
        for (String line : aiResult.split("\n")) {
            if (line.contains("[") && line.contains("]")) {
                names.add(line.substring(line.indexOf("[") + 1, line.indexOf("]")).trim());
            }
        }
        return names;
    }
}
