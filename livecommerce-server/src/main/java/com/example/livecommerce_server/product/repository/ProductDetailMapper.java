package com.example.livecommerce_server.product.repository;

import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ProductDetailMapper {
    void insertProductDetail(ProductDetailDTO detail);

    void updateProductDetail(ProductDetailDTO detail); // ← 추가

    ProductDetailDTO findDetailByProductId(String productId);

    ProductDetailDTO findByCertNo(@Param("certNo") String certNo); // ← cert_no 중복 체크
}
