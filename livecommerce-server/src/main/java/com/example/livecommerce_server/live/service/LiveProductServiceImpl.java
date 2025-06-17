package com.example.livecommerce_server.live.service;

import com.example.livecommerce_server.live.dto.VendorProductDTO;
import com.example.livecommerce_server.live.mapper.LiveProductMapper;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LiveProductServiceImpl implements LiveProductService{

	private final LiveProductMapper liveProductMapper;

	/**
	 * 입점업체 상품 정보 리스트 반환
	 * @param vendorId
	 * @return
	 */
	@Override
	public List<VendorProductDTO> findVendorProduct(String vendorId) {
		return liveProductMapper.selectVendorProduct(vendorId)
				.stream()
				.map(vo -> VendorProductDTO.builder()
						.productId(vo.getProductId())
						.name(vo.getName())
						.price(vo.getPrice())
						.stock(vo.getStock())
						.image(vo.getImage())
						.build()).toList();
	}
}
