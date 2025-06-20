package com.example.livecommerce_server.storage.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
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
        String filename = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        String key = "users/" + userId + "/images/" + filename;

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(file.getContentType());

        try {
            amazonS3.putObject(
                    new PutObjectRequest(bucket, key, file.getInputStream(), metadata)
                            .withCannedAcl(CannedAccessControlList.PublicRead) // ✅ 여기!
            );
        } catch (IOException e) {
            throw new RuntimeException("파일 업로드 실패", e);
        }

        return "https://" + bucket + ".kr.object.ncloudstorage.com/" + key;
    }
}
