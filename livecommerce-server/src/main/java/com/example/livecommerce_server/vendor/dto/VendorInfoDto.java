package com.example.livecommerce_server.vendor.dto;

import com.example.livecommerce_server.vendor.common.Status;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VendorInfoDto {
    public String userId;
    public String name;
    public String email;
    public String businessNumber;
    public String permitNumber;
    public Status status;
}
