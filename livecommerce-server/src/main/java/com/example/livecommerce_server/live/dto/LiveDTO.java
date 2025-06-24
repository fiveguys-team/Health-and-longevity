package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;
import com.fasterxml.jackson.annotation.JsonIgnore;



@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveDTO {
    private String liveId;      // 라이브 방송 고유 ID
    private String sessionId;   // OpenVidu 세션 ID
    private String title;
    private String announcement;
    @JsonIgnore
    private MultipartFile thumbnailFile; // 업로드용
    private String thumbnail;        // S3 URL 저장용 (DB 컬럼명과 동일하게)
    private String products;  // JSON string of products
    private Integer discountRate;
    private String startTime;
    private String vendorId;
    private String category;
    private String vendorName;
} 