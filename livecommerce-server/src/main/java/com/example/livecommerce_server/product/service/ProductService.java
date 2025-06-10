package com.example.livecommerce_server.product.service;

import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequest;
import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public interface ProductService {
    ProductDetailDTO fetchProductDetailFromAPIfind(String certNo);
    void saveProductRequestadd(ProductRegisterRequest request, MultipartFile imageFile);
    List<ProductDTO> getProductsByVendor(Long vendorId);
    ProductDetailDTO getProductDetailById(String productId);

}
