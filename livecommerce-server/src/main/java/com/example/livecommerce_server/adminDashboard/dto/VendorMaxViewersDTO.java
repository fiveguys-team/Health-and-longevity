package com.example.livecommerce_server.adminDashboard.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VendorMaxViewersDTO {
    private String vendorName;
    private Integer maxViewers;
} 