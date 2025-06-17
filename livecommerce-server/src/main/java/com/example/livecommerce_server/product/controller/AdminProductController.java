package com.example.livecommerce_server.product.controller;

import com.example.livecommerce_server.product.dto.AdminProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductListDTO;
import com.example.livecommerce_server.product.service.ProductService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin/products")
@CrossOrigin(origins = "http://localhost:3000")
public class AdminProductController {

    private final ProductService productService;

    public AdminProductController(ProductService productService) {
        this.productService = productService;
    }


    // 상품 승인
    @PostMapping("/approve/{id}")
    public ResponseEntity<String> approveProduct(@PathVariable String id) {
        productService.approveProduct(id);
        return ResponseEntity.ok("상품 승인 완료");
    }

    // 상품 반려
    @PostMapping("/reject/{id}")
    public ResponseEntity<String> rejectProduct(@PathVariable String id) {
        productService.rejectProduct(id);
        return ResponseEntity.ok("상품 반려 완료");
    }

    @GetMapping("/detail/{id}")
    public AdminProductDetailDTO getAdminProductDetail(@PathVariable String id) {
        return productService.getAdminProductDetail(id);
    }

    @GetMapping
    public List<ProductListDTO> getProducts(@RequestParam(required = false) String status) {
        if (status == null || status.isBlank()) {
            return productService.getRequestedProducts(); // 전체
        }
        return productService.getProductsByStatus(status);
    }

}
