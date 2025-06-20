package com.example.livecommerce_server.common.config;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class NcpS3Config {

    @Value("${ncp.object-storage.access-key}")
    private String accessKey;

    @Value("${ncp.object-storage.secret-key}")
    private String secretKey;

    @Value("${ncp.object-storage.region}")
    private String region;

    @Value("${ncp.object-storage.endpoint}")
    private String endpoint;

    @Bean
    public AmazonS3 amazonS3() {
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);

        return AmazonS3ClientBuilder.standard()
                .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endpoint, region))
                .withPathStyleAccessEnabled(true) // ✅ 네이버 필수!
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .build();
    }
}
