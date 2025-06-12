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
    //private String customSessionId;
    private String sessionId;
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