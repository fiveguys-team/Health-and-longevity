package com.example.livecommerce_server.service.service;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;
import com.example.livecommerce_server.service.mapper.ServiceMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ServiceServiceImpl implements ServiceService {

    private final ServiceMapper serviceMapper;

    @Override
    public void addServiceRequest(ServiceRequestDTO requestDTO) {
        // UUID 생성
        requestDTO.setServiceId(UUID.randomUUID().toString());
        requestDTO.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        requestDTO.setUpdateAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        // service_status는 MyBatis XML에서 'REQ'로 처리함
        serviceMapper.insertServiceRequest(requestDTO);
    }


    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

}