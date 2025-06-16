// src/main/java/com/example/livecommerce_server/product/repository/VendorMapper.java
package com.example.livecommerce_server.product.repository;

import com.example.livecommerce_server.product.dto.VendorDTO;
import com.example.livecommerce_server.product.dto.VendorProductDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface VendorMapper {

    List<VendorDTO> findAllVendors();

    List<VendorProductDTO> findProductsByVendorId(Long vendorId);
}
