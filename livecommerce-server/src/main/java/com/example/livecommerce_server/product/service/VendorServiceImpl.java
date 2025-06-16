// src/main/java/com/example/livecommerce_server/product/service/VendorServiceImpl.java
package com.example.livecommerce_server.product.service;

import com.example.livecommerce_server.product.dto.VendorDTO;
import com.example.livecommerce_server.product.dto.VendorProductDTO;
import com.example.livecommerce_server.product.repository.VendorMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VendorServiceImpl implements VendorService {

    private final VendorMapper vendorMapper;

    public VendorServiceImpl(VendorMapper vendorMapper) {
        this.vendorMapper = vendorMapper;
    }

    @Override
    public List<VendorDTO> getAllVendors() {
        return vendorMapper.findAllVendors();
    }

    @Override
    public List<VendorProductDTO> getProductsByVendorId(Long vendorId) {
        return vendorMapper.findProductsByVendorId(vendorId);
    }
}
