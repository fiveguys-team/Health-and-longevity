package com.example.livecommerce_server.live.service;

import com.example.livecommerce_server.live.dto.VendorProductDTO;
import java.util.List;

public interface LiveProductService {

	List<VendorProductDTO> findVendorProduct(String vendorId);

}
