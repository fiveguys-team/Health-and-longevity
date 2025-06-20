package com.example.livecommerce_server.storage.controller;

import com.example.livecommerce_server.storage.service.S3UploadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class FileUploadController {

    private final S3UploadService s3UploadService;

    @PostMapping("/upload")
    public ResponseEntity<String> uploadFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam("userId") String userId
    ) {
        String uploadedUrl = s3UploadService.upload(file, userId);
        return ResponseEntity.ok(uploadedUrl);
    }
}
