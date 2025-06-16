package com.example.livecommerce_server.product.service;

import com.example.livecommerce_server.product.dto.AdminProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDetailUserDTO;
import com.example.livecommerce_server.product.dto.ProductListDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequestDTO;
import com.example.livecommerce_server.product.dto.UserProductDTO;
import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public interface ProductService {
    ProductDetailDTO fetchProductDetailFromAPIfind(String certNo);
    void saveProductRequestadd(ProductRegisterRequestDTO request, MultipartFile imageFile);
    public List<ProductDTO> getProductsByVendor(Long vendorId, String status);
    ProductDetailDTO getProductDetailById(String productId);
    List<ProductListDTO> getRequestedProducts();
    void approveProduct(String id);
    void rejectProduct(String id);
    AdminProductDetailDTO getAdminProductDetail(String productId);

    List<ProductListDTO> getProductsByStatus(String status);
    List<UserProductDTO> getUserApprovedProducts();
    List<UserProductDTO> getUserProductsFiltered(String status, String category);
    ProductDetailUserDTO getProductDetailForUser(String id);
}
