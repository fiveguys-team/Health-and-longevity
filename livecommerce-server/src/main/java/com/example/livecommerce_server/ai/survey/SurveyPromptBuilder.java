package com.example.livecommerce_server.ai.survey;

import com.example.livecommerce_server.ai.dto.SurveyForm;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.stereotype.Component;

@Component
public class SurveyPromptBuilder {

    public String buildPrompt(SurveyForm surveyForm) {
        String template = """
                사용자의 건강기능식품 선호 설문 결과가 다음과 같습니다:
                - 성별: {gender}
                - 연령: {age}
                - 주요 관심 건강 분야: {interest}
                - 복용 선호 형태: {form}
                - 알러지 성분: {allergy}
                
                이 사용자가 우리 회사의 건강기능식품 제품 중에서 구매하면 좋을 상품을 4개 추천해주세요.
                출력 형식은 아래와 같이 해주세요:
                [제품명] - [효능] - [추천이유]
                """;
        PromptTemplate promptTemplate = new PromptTemplate(template);
        return promptTemplate.render(surveyForm.toMap());
    }
}
