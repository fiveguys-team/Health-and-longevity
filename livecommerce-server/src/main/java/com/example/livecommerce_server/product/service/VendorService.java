// src/main/java/com/example/livecommerce_server/product/service/VendorService.java
package com.example.livecommerce_server.product.service;

import com.example.livecommerce_server.product.dto.VendorDTO;
import com.example.livecommerce_server.product.dto.ProductVendorDTO;

import java.util.List;

public interface VendorService {

    // 모든 업체 목록 조회
    List<VendorDTO> getAllVendors();

    // 특정 업체 ID에 대한 상품 목록 조회
    List<ProductVendorDTO> getProductsByVendorId(Long vendorId);
}
