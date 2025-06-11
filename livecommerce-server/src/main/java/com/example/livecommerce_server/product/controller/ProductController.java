package com.example.livecommerce_server.product.controller;

import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequest;
import com.example.livecommerce_server.product.service.ProductService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/product")
@CrossOrigin(origins = "http://localhost:3000")
public class ProductController {

    @Autowired
    private ProductService productService;

    // 인증번호로 상품 정보 조회 (API 호출)
    @GetMapping("/cert/{certNo}")
    public ResponseEntity<ProductDetailDTO> getProductDetailList(@PathVariable String certNo) {
        ProductDetailDTO dto = productService.fetchProductDetailFromAPIfind(certNo);
        if (dto == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(dto);
    }

    // 상품 등록 요청 (입점업체 -> 관리자 승인 대기 상태)
    @PostMapping(value = "/request", consumes = "multipart/form-data")
    public ResponseEntity<String> requestProductAdd(
            @RequestPart("product") ProductRegisterRequest request,
            @RequestPart("image") MultipartFile imageFile
    ) {

        try {
            productService.saveProductRequestadd(request, imageFile);
            return ResponseEntity.ok("상품 등록 요청이 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("상품 등록 요청 실패: " + e.getMessage());
        }
    }

    @GetMapping("/vendor/{vendorId}/products")
    public ResponseEntity<List<ProductDTO>> getProducts(@PathVariable Long vendorId) {
        return ResponseEntity.ok(productService.getProductsByVendor(vendorId));
    }

    @GetMapping("/product/detail/{productId}")
    public ResponseEntity<ProductDetailDTO> getProductDetail(@PathVariable String productId) {
        return ResponseEntity.ok(productService.getProductDetailById(productId));
    }



}
