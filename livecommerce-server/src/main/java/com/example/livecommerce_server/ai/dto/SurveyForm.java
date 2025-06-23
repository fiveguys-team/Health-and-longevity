package com.example.livecommerce_server.ai.dto;

import lombok.Data;

import java.util.Map;

@Data
public class SurveyForm {
    private String gender;
    private int age;
    private String interest;
    private String form;
    private String allergy;

    public Map<String, Object> toMap() {
        return Map.of(
                "gender", gender,
                "age", age,
                "interest", interest,
                "form", form,
                "allergy", allergy
        );
    }
}
