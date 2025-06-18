package com.example.livecommerce_server.product.repository;

import com.example.livecommerce_server.product.dto.AdminProductDetailDTO;
import com.example.livecommerce_server.product.dto.DiscountedProductDTO;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductDetailUserDTO;
import com.example.livecommerce_server.product.dto.ProductListDTO;
import com.example.livecommerce_server.product.dto.UserProductListDTO;
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

}