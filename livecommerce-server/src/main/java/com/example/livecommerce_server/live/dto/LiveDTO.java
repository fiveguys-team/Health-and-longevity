package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;



@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveDTO {
    private String liveId;      // 라이브 방송 고유 ID
    private String sessionId;   // OpenVidu 세션 ID
    private String title;
    private String announcement;
    //private MultipartFile thumbnail;
    private String products;  // JSON string of products
    private Integer discountRate;
    private String startTime;
    private String vendorId;
    private String category;
    private String vendorName;
} 