package com.example.livecommerce_server.vendor.dto;

import com.example.livecommerce_server.vendor.common.Status;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VendorUpdateDto {
    public String userId;
    public String name;
    public String address;
    public Status status;
}
