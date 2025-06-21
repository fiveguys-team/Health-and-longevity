package com.example.livecommerce_server.member.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VendorRegistrationDto {
   Long userId;
   String businessNumber;
   String permitNumber;
}
