package com.example.livecommerce_server.product.service;

import com.example.livecommerce_server.product.dto.AdminProductDetailDTO;
import com.example.livecommerce_server.product.dto.DiscountedProductDTO;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDetailUserDTO;
import com.example.livecommerce_server.product.dto.ProductListDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequestDTO;
import com.example.livecommerce_server.product.dto.UserProductListDTO;
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
    List<UserProductListDTO> getUserApprovedProducts();
    List<UserProductListDTO> getUserProductsFiltered(String status, String category);
    ProductDetailUserDTO getProductDetailForUser(String id);
    List<ProductDTO> getPagedProducts(String category, String status, int page, int size);
    int countProducts(String category, String status);
    List<DiscountedProductDTO> getDiscountedProducts();
    List<UserProductListDTO> getUserProductsByCategoryAndStatus(String category, String status, int size, int offset);

}
