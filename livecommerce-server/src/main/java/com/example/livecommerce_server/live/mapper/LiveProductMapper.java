package com.example.livecommerce_server.live.mapper;

import com.example.livecommerce_server.live.dto.VendorProductDTO;
import com.example.livecommerce_server.live.vo.LiveProductVO;
import com.example.livecommerce_server.live.vo.VendorProductVO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface LiveProductMapper {

	/**
	 * 라이브 방송 중 할인 적용된 판매 상품 리스트를 저장한다.
	 * @param list
	 */
	void insertLiveProduct(@Param("list")List<LiveProductVO> list);

	/**
	 * vendorId를 통해 판매할 수 있는 상품 리스트를 반환한다.
	 * @param vendorId 입점업체 ID
	 * @return 입점업체의 상품 리스트
	 */
	List<VendorProductVO> selectVendorProduct(String vendorId);
}
