package com.example.livecommerce_server.product.repository;

import com.example.livecommerce_server.product.dto.*;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ProductMapper {
    void insertProduct(ProductDTO product);

    void updateProduct(ProductDTO product); //

    List<ProductDTO> findProductsByVendorId(Long vendorId);
    List<ProductDTO> findProductsByProductId(@Param("productIds")List<String> productIds);

    List<ProductListDTO> selectRequestedProducts();

    void updateStatus(@Param("id") String id, @Param("status") String status);

    AdminProductDetailDTO findAdminProductDetail(String productId);

    List<ProductListDTO> selectProductsByStatus(@Param("status") String status); //  상태별 목록 조회 추가
    AdminProductDetailDTO findAdminProductDetailByCertNo(@Param("certNo") String certNo);
    List<ProductDTO> findProductsByVendorIdAndStatus(@Param("vendorId") Long vendorId, @Param("status") String status);
    List<UserProductListDTO> selectUserApprovedProducts();
    List<UserProductListDTO> selectUserApprovedProductsFiltered(@Param("status") String status, @Param("category") String category);
    ProductDetailUserDTO selectProductDetailUserById(String id);
    List<ProductDTO> findProductsByCategoryAndStatus(
            @Param("category") String category,
            @Param("status") String status,
            @Param("size") int size,
            @Param("offset") int offset
    );

    int countProductsByCategoryAndStatus(
            @Param("category") String category,
            @Param("status") String status
    );

    List<DiscountedProductDTO> findAllDiscountedProducts();
    List<UserProductListDTO> findUserProductsByCategoryAndStatus(
            @Param("category") String category,
            @Param("status") String status,
            @Param("size") int size,
            @Param("offset") int offset
    );

    ProductDTO findProductById(@Param("productId") String productId);

    List<AiProduct> selectAiProduct();
    List<AiProduct> selectAiProductsByNames(@Param("names") List<String> names);
    List<MainPageProduct> selectMainPageProducts();
}