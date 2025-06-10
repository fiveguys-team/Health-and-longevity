package com.example.livecommerce_server.product.repository;

import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductDetailMapper {
    void insertProductDetail(ProductDetailDTO detail);
    ProductDetailDTO findDetailByProductId(String productId);
}
