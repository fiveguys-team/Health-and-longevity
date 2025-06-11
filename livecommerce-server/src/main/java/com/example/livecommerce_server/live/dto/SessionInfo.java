package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SessionInfo {
    private String sessionId;
    private String title;
    private String announcement;
    private String thumbnailUrl;
    private String products;
    private Integer discountRate;
    private String startTime;
    private String vendorId;
} 