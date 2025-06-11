package com.example.livecommerce_server.product.repository;

import com.example.livecommerce_server.product.dto.ProductDTO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper {
    void insertProduct(ProductDTO product);
    List<ProductDTO> findProductsByVendorId(Long vendorId);
}