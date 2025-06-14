package com.example.livecommerce_server.product.controller;

import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequestDTO;
import com.example.livecommerce_server.product.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/product")
@CrossOrigin(origins = "http://localhost:3000")
public class ProductController {

    @Autowired
    private ProductService productService;

    // 1. 인증번호로 상품 상세 정보 조회 (식품안전나라 API 등)
    @GetMapping("/cert/{certNo}")
    public ResponseEntity<ProductDetailDTO> getProductDetailFromApi(@PathVariable String certNo) {
        ProductDetailDTO dto = productService.fetchProductDetailFromAPIfind(certNo);
        if (dto == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(dto);
    }

    // 2. 상품 등록 요청 (입점업체 → 관리자 승인 대기)
    @PostMapping(value = "/request", consumes = "multipart/form-data")
    public ResponseEntity<String> requestProductAdd(
            @RequestPart("product") ProductRegisterRequestDTO request,
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

    // 3. 입점업체의 상품 목록 조회
    @GetMapping("/vendor/{vendorId}/products")
    public ResponseEntity<List<ProductDTO>> getProductsByVendor(
            @PathVariable Long vendorId,
            @RequestParam(required = false) String status
    ) {
        List<ProductDTO> productList = productService.getProductsByVendor(vendorId, status);
        return ResponseEntity.ok(productList);
    }

    // 4. 특정 상품 상세 정보 조회 (상품 ID 기준)
    @GetMapping("/detail/{productId}")
    public ResponseEntity<ProductDetailDTO> getProductDetail(@PathVariable String productId) {

        ProductDetailDTO dto = productService.getProductDetailById(productId);
        if (dto == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(dto);
    }
}
