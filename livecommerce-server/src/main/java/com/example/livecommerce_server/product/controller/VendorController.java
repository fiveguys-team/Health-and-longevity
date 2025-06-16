// VendorController.java
package com.example.livecommerce_server.product.controller;

import com.example.livecommerce_server.product.dto.VendorDTO;
import com.example.livecommerce_server.product.dto.VendorProductDTO;
import com.example.livecommerce_server.product.service.VendorService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/product/company")
@CrossOrigin(origins = "http://localhost:3000")
public class VendorController {

    private final VendorService vendorService;

    public VendorController(VendorService vendorService) {
        this.vendorService = vendorService;
    }

    // 전체 입점업체 목록 조회
    @GetMapping
    public List<VendorDTO> getAllVendors() {
        return vendorService.getAllVendors();
    }

    // 특정 입점업체가 등록한 상품 목록 조회
    @GetMapping("/{vendorId}/products")
    public List<VendorProductDTO> getProductsByVendorId(@PathVariable Long vendorId) {
        return vendorService.getProductsByVendorId(vendorId);
    }
}
