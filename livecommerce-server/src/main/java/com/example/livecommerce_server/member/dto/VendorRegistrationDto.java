package com.example.livecommerce_server.member.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VendorRegistrationDto {
   @JsonProperty("userId")
   Long userId;
   @JsonProperty("name")
   String name;
   @JsonProperty("address")
   String address;
   @JsonProperty("businessNumber")
   String businessNumber;
   @JsonProperty("permitNumber")
   String permitNumber;
   @JsonProperty("vendorImg")
   String vendorImg;
   @JsonProperty("bImg")
   String bImg;
   @JsonProperty("pImg")
   String pImg;
}
