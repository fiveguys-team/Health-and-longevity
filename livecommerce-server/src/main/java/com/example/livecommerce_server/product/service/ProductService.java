package com.example.livecommerce_server.product.service;

import com.example.livecommerce_server.product.dto.*;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public interface ProductService {
    ProductDetailDTO fetchProductDetailFromAPIfind(String certNo);
    void saveProductRequestadd(ProductRegisterRequestDTO request);
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
    ProductDTO getProductById(String productId);
    List<AiProduct> getAiProducts();
    List<AiProduct> findAiProductsByNames(List<String> names);
    List<MainPageProduct> getMainPageProducts();
}
