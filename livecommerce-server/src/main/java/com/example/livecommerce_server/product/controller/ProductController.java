package com.example.livecommerce_server.product.controller;

import com.example.livecommerce_server.product.dto.DiscountedProductDTO;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDetailUserDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequestDTO;
import com.example.livecommerce_server.product.dto.UserProductListDTO;
import com.example.livecommerce_server.product.service.ProductService;
import java.util.HashMap;
import java.util.Map;
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

    @GetMapping("/vendor/{vendorId}/products")
    public ResponseEntity<List<ProductDTO>> getProductsByVendor(
            @PathVariable Long vendorId,
            @RequestParam(required = false) String status
    ) {
        // 👇 빈 문자열이면 null로 변환 (전체 조회용)
        if (status != null && status.trim().isEmpty()) {
            status = null;
        }

        List<ProductDTO> productList = productService.getProductsByVendor(vendorId, status);
        return ResponseEntity.ok(productList);
    }

    // 4. 특정 상품 상세 정보 조회 (상품 ID 기준)
    @GetMapping("/detail/{productId}")
    public ResponseEntity<?> getProductDetail(@PathVariable String productId) {
        ProductDetailUserDTO dto = productService.getProductDetailForUser(productId);
        if (dto == null) {
            return ResponseEntity.status(404).body("해당 상품을 찾을 수 없습니다."); // 혹은 notFound().build();
        }
        return ResponseEntity.ok(dto);
    }

    @GetMapping("/products")
    public ResponseEntity<Map<String, Object>> getPagedProducts(
            @RequestParam String status,
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "9") int size
    ) {
        List<ProductDTO> products = productService.getPagedProducts(category, status, page, size);
        int totalCount = productService.countProducts(category, status);

        Map<String, Object> response = new HashMap<>();
        response.put("products", products);
        response.put("totalCount", totalCount);

        return ResponseEntity.ok(response);
    }


    @GetMapping("/products/discounted")
    public ResponseEntity<List<DiscountedProductDTO>> getDiscountedProducts() {
        List<DiscountedProductDTO> list = productService.getDiscountedProducts();
        return ResponseEntity.ok(list);
    }


    @GetMapping("/products/user")
    public ResponseEntity<List<UserProductListDTO>> getUserProducts(
            @RequestParam String category,
            @RequestParam String status,
            @RequestParam int page,
            @RequestParam int size
    ) {
        int offset = (page - 1) * size;
        List<UserProductListDTO> products = productService.getUserProductsByCategoryAndStatus(category, status, size, offset);
        return ResponseEntity.ok(products);
    }


}
