package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
public class ProductRegisterRequest {
    private ProductDTO product;
    private ProductDetailDTO productDetail;
    private MultipartFile productImage;

}
