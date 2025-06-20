package com.example.livecommerce_server.adminDashboard.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CategoryRevenueDTO {
    private String categoryName;
    private Integer revenue;
    private Integer orderCount;
} 