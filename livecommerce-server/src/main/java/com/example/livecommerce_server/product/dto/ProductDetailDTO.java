package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
public class ProductDetailDTO {
    private String certNo;
    private String productId;
    private String productName;
    private String expiryDate;
    private String approvalDate;
    private String howToTake;
    private String mainFunction;
    private String precautions;
    private String storageMethod;
    private String standard;
    private String ingredients;



}
