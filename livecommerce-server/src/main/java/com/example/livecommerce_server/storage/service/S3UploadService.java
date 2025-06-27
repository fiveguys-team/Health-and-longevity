package com.example.livecommerce_server.storage.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import javax.imageio.ImageIO;
import lombok.RequiredArgsConstructor;
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class S3UploadService {

    private final AmazonS3 amazonS3;

    @Value("${ncp.object-storage.bucket-name}")
    private String bucket;

    public String upload(MultipartFile file, String userId) {
        String originalFilename = file.getOriginalFilename();
        String filename = System.currentTimeMillis() + "_" + originalFilename;
        String key = "users/" + userId + "/images/" + filename;

        try {
            // 1. MultipartFile → BufferedImage
            BufferedImage originalImage = ImageIO.read(file.getInputStream());

            // 2. 리사이징된 이미지 → ByteArrayOutputStream
            ByteArrayOutputStream os = new ByteArrayOutputStream();
            Thumbnails.of(originalImage)
                    .size(300, 300) // 원하는 사이즈
                    .outputFormat("jpg") // 확장자 통일 (원하는 포맷 사용 가능)
                    .toOutputStream(os);

            byte[] imageBytes = os.toByteArray();
            InputStream resizedInputStream = new ByteArrayInputStream(imageBytes);

            // 3. 메타데이터 설정
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(imageBytes.length);
            metadata.setContentType("image/jpeg"); // 변경한 포맷에 맞게 지정

            // 4. S3 업로드
            amazonS3.putObject(
                    new PutObjectRequest(bucket, key, resizedInputStream, metadata)
                            .withCannedAcl(CannedAccessControlList.PublicRead)
            );

            return "https://" + bucket + ".kr.object.ncloudstorage.com/" + key;

        } catch (IOException e) {
            throw new RuntimeException("파일 업로드 실패", e);
        }
    }
}