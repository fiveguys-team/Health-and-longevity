package com.example.livecommerce_server.product.service;


import com.example.livecommerce_server.product.dto.AdminProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDetailDTO;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.dto.ProductListDTO;
import com.example.livecommerce_server.product.dto.ProductRegisterRequestDTO;
import com.example.livecommerce_server.product.repository.ProductDetailMapper;
import com.example.livecommerce_server.product.repository.ProductMapper;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ProductDetailMapper productDetailMapper;

    // API를 통한 상세 정보 조회
    public ProductDetailDTO fetchProductDetailFromAPIfind(String certNo) {
        String apiUrl = "http://openapi.foodsafetykorea.go.kr/api/c019816d83cc4d60ad1b/C003/json/1/1/PRDLST_REPORT_NO=" + certNo;

        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line);
            }

            String response = result.toString().trim();

            // JSON이 아니면 에러 처리
            if (!response.startsWith("{")) {
                throw new RuntimeException("API 응답이 JSON이 아님: " + response);
            }

            JSONObject json = new JSONObject(response);

            // JSON 내부 구조 확인
            if (!json.has("C003") || !json.getJSONObject("C003").has("row")) {
                return null;
            }

            JSONArray rows = json.getJSONObject("C003").optJSONArray("row");
            if (rows == null || rows.isEmpty()) return null;

            JSONObject item = rows.getJSONObject(0);

            ProductDetailDTO dto = new ProductDetailDTO();
            dto.setCertNo(item.optString("PRDLST_REPORT_NO", ""));
            dto.setProductName(item.optString("PRDLST_NM", ""));
            dto.setExpiryDate(item.optString("POG_DAYCNT", ""));
            dto.setApprovalDate(item.optString("PRMS_DT", ""));
            dto.setHowToTake(item.optString("NTK_MTHD", ""));
            dto.setMainFunction(item.optString("PRIMARY_FNCLTY", ""));
            dto.setPrecautions(item.optString("IFTKN_ATNT_MATR_CN", ""));
            dto.setStorageMethod(item.optString("CSTDY_MTHD", ""));
            dto.setStandard(item.optString("STDR_STND", ""));
            dto.setIngredients(item.optString("RAWMTRL_NM", ""));
            return dto;

        } catch (Exception e) {
            throw new RuntimeException("API 조회 실패", e);
        }
    }

    // 저장 로직
    public void saveProductRequestadd(ProductRegisterRequestDTO request, MultipartFile imageFile) {
        ProductDTO productDto = request.getProduct();
        ProductDetailDTO detailDto = request.getProductDetail();

        // 기존 상품 확인 (중복 등록 방지 + 재등록 처리)
        AdminProductDetailDTO existing = productMapper.findAdminProductDetailByCertNo(detailDto.getCertNo());
        if (existing != null) {
            if ("REJECTED".equals(existing.getStatus())) {
                productMapper.updateStatus(existing.getProductId(), "RESUBMITTED");
                productMapper.updateProduct(productDto);
                productDetailMapper.updateProductDetail(detailDto);
                return;
            } else {
                throw new IllegalStateException("이미 등록된 상품입니다.");
            }
        }

        String ProductId = UUID.randomUUID().toString();

        // 1. 이미지 저장
        String uploadDir = System.getProperty("user.dir") + "/uploads/images";
        String fileName = UUID.randomUUID() + "_" + imageFile.getOriginalFilename();
        Path imagePath = Paths.get(uploadDir, fileName);
        try {
            Files.createDirectories(imagePath.getParent());
            imageFile.transferTo(imagePath.toFile());
        } catch (IOException e) {
            throw new RuntimeException("이미지 저장 실패", e);
        }

        // 2. product 저장 (status는 PENDING)
        ProductDTO product = new ProductDTO();
        product.setProductId(ProductId);
        product.setCategoryId(productDto.getCategoryId());
        product.setVendorId(productDto.getVendorId());
        product.setName(productDto.getName());
        product.setPrice(productDto.getPrice());
        product.setStockCount(productDto.getStockCount());
        product.setStatus("PENDING");
        product.setProductImage(fileName);
        productMapper.insertProduct(product);

        // 3. product_detail 저장
        ProductDetailDTO detail = new ProductDetailDTO();
        detail.setProductId(ProductId);
        detail.setCertNo(detailDto.getCertNo());
        detail.setProductName(detailDto.getProductName());
        detail.setExpiryDate(detailDto.getExpiryDate());
        detail.setApprovalDate(detailDto.getApprovalDate());
        detail.setHowToTake(detailDto.getHowToTake());
        detail.setMainFunction(detailDto.getMainFunction());
        detail.setPrecautions(detailDto.getPrecautions());
        detail.setStorageMethod(detailDto.getStorageMethod());
        detail.setStandard(detailDto.getStandard());
        detail.setIngredients(detailDto.getIngredients());
        productDetailMapper.insertProductDetail(detail);
    }

    @Override
    public List<ProductDTO> getProductsByVendor(Long vendorId) {
        return productMapper.findProductsByVendorId(vendorId);
    }

    @Override
    public ProductDetailDTO getProductDetailById(String productId) {
        return productDetailMapper.findDetailByProductId(productId);
    }

    @Override
    public List<ProductListDTO> getRequestedProducts() {
        return productMapper.selectRequestedProducts();
    }

    @Override
    public void approveProduct(String id) {
        productMapper.updateStatus(id, "APPROVED");
    }

    @Override
    public void rejectProduct(String id) {
        productMapper.updateStatus(id, "REJECTED");
    }

    public AdminProductDetailDTO getAdminProductDetail(String productId) {
        return productMapper.findAdminProductDetail(productId);
    }

    public List<ProductListDTO> getProductsByStatus(String status) {
        return productMapper.selectProductsByStatus(status);
    }

}
