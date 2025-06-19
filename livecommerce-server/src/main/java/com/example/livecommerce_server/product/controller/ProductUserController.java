package com.example.livecommerce_server.product.controller;

import com.example.livecommerce_server.product.dto.ProductDetailUserDTO;
import com.example.livecommerce_server.product.dto.UserProductListDTO;
import com.example.livecommerce_server.product.service.ProductService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

// ProductUserController.java
@RestController
@RequestMapping("/products")
@CrossOrigin(origins = "http://localhost:3000")
public class ProductUserController {

    private final ProductService productService;

    public ProductUserController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public List<UserProductListDTO> getUserProducts(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String category
    ) {
        return productService.getUserProductsFiltered(status, category);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductDetailUserDTO> getProductDetail(@PathVariable String id) {
        ProductDetailUserDTO dto = productService.getProductDetailForUser(id);
        if (dto == null) {
            return ResponseEntity.notFound().build(); // 404
        }
        return ResponseEntity.ok(dto);
    }

}
