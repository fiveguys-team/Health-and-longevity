package com.example.livecommerce_server.live.mapper;

import static org.junit.jupiter.api.Assertions.*;

import com.example.livecommerce_server.live.vo.LiveProductVO;
import com.example.livecommerce_server.live.vo.VendorProductVO;
import java.util.ArrayList;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Slf4j
@Transactional
@ActiveProfiles("test")
class LiveProductMapperTest {

	@Autowired(required = false)
	private LiveProductMapper liveProductMapper;

	@Test
	@DisplayName("라이브 상품 정보를 저장하는 메서드")
	void insertLiveProduct() {

		List<LiveProductVO> list = new ArrayList<>();

		LiveProductVO vo1 = LiveProductVO.builder()
				.live_id("cccccccc-cccc-cccc-cccc-cccccccccccc")
				.product_id("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
				.discountRate(10)
				.build();

		LiveProductVO vo2 = LiveProductVO.builder()
				.live_id("cccccccc-cccc-cccc-cccc-cccccccccccc")
				.product_id("bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")
				.discountRate(20)
				.build();

		LiveProductVO vo3 = LiveProductVO.builder()
				.live_id("cccccccc-cccc-cccc-cccc-cccccccccccc")
				.product_id("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
				.discountRate(10)
				.build();
		list.add(vo1);
		list.add(vo2);
		list.add(vo3);

		liveProductMapper.insertLiveProduct(list);
	}

	@Test
	@DisplayName("입점업체 상품 리스트를 반환하는 메서드 ")
	void selectVendorProduct() {
		// when
		List<VendorProductVO> list = liveProductMapper.selectVendorProduct("1");

		list.forEach(System.out::println);
		list.forEach(vo -> log.info("list = {}", vo));



	}

}