package com.example.livecommerce_server.live.controller;

import com.example.livecommerce_server.live.dto.LiveChatDTO;
import com.example.livecommerce_server.live.dto.LiveDTO;
import com.example.livecommerce_server.live.dto.LiveProductDTO;
import com.example.livecommerce_server.live.dto.ProductInfo;
import com.example.livecommerce_server.live.service.LiveService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import io.openvidu.java.client.Connection;
import io.openvidu.java.client.ConnectionProperties;
import io.openvidu.java.client.OpenVidu;
import io.openvidu.java.client.OpenViduHttpException;
import io.openvidu.java.client.OpenViduJavaClientException;
import io.openvidu.java.client.Session;
import io.openvidu.java.client.SessionProperties;
import jakarta.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@CrossOrigin(
		origins = {"http://localhost:5174", "http://localhost:5173", "http://localhost:3000"},
		allowedHeaders = "*",
		methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT,
				RequestMethod.DELETE, RequestMethod.OPTIONS}
)

@Slf4j
@RestController
@RequiredArgsConstructor
public class LiveController {
	private final ObjectMapper mapper = new ObjectMapper();

	private final LiveService liveService;

	@Value("${openvidu.url}")
	private String OPENVIDU_URL;

	@Value("${openvidu.secret}")
	private String OPENVIDU_SECRET;

	private OpenVidu openvidu;

	// 활성 세션 정보를 저장하는 맵
	private final ConcurrentHashMap<String, LiveDTO> activeSessions = new ConcurrentHashMap<>();

	@PostConstruct
	public void init() {
		this.openvidu = new OpenVidu(OPENVIDU_URL, OPENVIDU_SECRET);
	}

	@Bean
	public CorsFilter corsFilter() {
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		CorsConfiguration config = new CorsConfiguration();
		config.setAllowedOrigins(Arrays.asList("http://localhost:5174", "http://localhost:5173", "http://localhost:5175", "http://localhost:3000"));
		config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
		config.setAllowedHeaders(Arrays.asList("*"));
		config.setAllowCredentials(true);
		source.registerCorsConfiguration("/**", config);
		return new CorsFilter(source);
	}

	/**
	 * 현재 활성화된 모든 세션 목록을 반환
	 */
	@GetMapping("/api/sessions")
	public ResponseEntity<List<LiveDTO>> getActiveSessions() {
		List<LiveDTO> sessions = new ArrayList<>(activeSessions.values());
		return new ResponseEntity<>(sessions, HttpStatus.OK);
	}

//	/**
//	 * @param params The Session properties
//	 * @return The Session ID
//	 */
//	@PostMapping("/api/sessions")
//	public ResponseEntity<String> initializeSession(@RequestBody(required = false) Map<String, Object> params)
//			throws OpenViduJavaClientException, OpenViduHttpException {
	//  세션 생성시 옵션(속성)을 담는 빌더 클래스 (mediaMode, customSessionId 등등)
//		SessionProperties properties = SessionProperties.fromJson(params).build();
	// 속성 정보를 바탕으로 session 객체 생성 / 내부에 sessionId 식별자 존재 / 클라이언트가 토큰 발급 시 사용
//		Session session = openvidu.createSession(properties);
//		return new ResponseEntity<>(session.getSessionId(), HttpStatus.OK);
//	}

	/**
	 * @param
	 * @return sessionId
	 */
	@PostMapping("/api/sessions")
	public ResponseEntity<?> initializeSession(@ModelAttribute LiveDTO liveDTO) {
		try {

			// OpenVidu 세션 생성
			Map<String, Object> params = new HashMap<>();
			// 세션 ID
			String sessionId = UUID.randomUUID().toString();
			params.put("customSessionId", sessionId);

			log.info("상품:"+liveDTO.getProducts());

			SessionProperties properties = SessionProperties.fromJson(params).build();
			Session session = openvidu.createSession(properties);

			liveDTO.setSessionId(sessionId);

			List<ProductInfo> prodList = mapper.readValue(
					liveDTO.getProducts(),
					new TypeReference<>() {
					}
			);

//
			// 썸네일 파일 처리
//			if (liveDTO.getThumbnail() != null && !liveDTO.getThumbnail().isEmpty()) {
//				// 실제 프로덕션에서는 파일 저장 서비스를 통해 S3 등에 저장하고 URL을 받아와야 함
//				// 임시로 파일명만 저장
//				String thumbnailFileName = liveDTO.getThumbnail().getOriginalFilename();
//				sessionInfo.setThumbnailUrl(thumbnailFileName);
//			}

			//activeSessions.put(liveDTO.getCustomSessionId(), sessionInfo);
			activeSessions.put(sessionId, liveDTO);

			// 라이브 테이블 정보 저장
			LiveChatDTO liveChatDTO = liveService.addLiveInfo(liveDTO);

			List<LiveProductDTO> liveProducts = prodList.stream()
					.map(m -> {
						LiveProductDTO dto = new LiveProductDTO();
						dto.setLiveId(liveChatDTO.getLiveId());
						dto.setProductId(m.getId());                // id 필드만 꺼내서 productId에
						dto.setDiscountRate(liveDTO.getDiscountRate());
						return dto;
					})
					.toList();

			// 라이브 상품 정보 저장
			liveService.addLiveProduct(liveProducts);

			log.info("sessionId" + session.getSessionId());
			log.info("라이브1111111111" + liveChatDTO.getLiveId());
			log.info("sessionId1111111111111111122222222" + liveChatDTO.getSessionId());
			return ResponseEntity.ok(liveChatDTO);
		} catch (Exception e) {
			log.error("Failed to initialize session", e);
			return new ResponseEntity<>("Failed to initialize session: " + e.getMessage(),
					HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * @param sessionId connection을 생성할 sessionId
	 * @param params    connection 속성
	 * @return connection 인증된 Token 반환
	 */
	@PostMapping("/api/sessions/{sessionId}/connections")
	public ResponseEntity<String> createConnection(@PathVariable("sessionId") String sessionId,
			@RequestBody(required = false) Map<String, Object> params)
			throws OpenViduJavaClientException, OpenViduHttpException {
		Session session = openvidu.getActiveSession(sessionId);
		if (session == null) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		ConnectionProperties properties = ConnectionProperties.fromJson(params).build();
		Connection connection = session.createConnection(properties);
		return new ResponseEntity<>(connection.getToken(), HttpStatus.OK);
	}

	/**
	 * 세션 종료 처리
	 * @param sessionId 종료할 세션의 ID
	 * @return 처리 결과
	 */
	@DeleteMapping("/api/sessions/{sessionId}")
	public ResponseEntity<String> closeSession(@PathVariable("sessionId") String sessionId) {
		try {
			// OpenVidu 서버에서 세션 찾기
			Session session = openvidu.getActiveSession(sessionId);
			if (session != null) {
				// 세션의 모든 연결 종료
				session.close();
				// 활성 세션 목록에서 제거
				activeSessions.remove(sessionId);
				return new ResponseEntity<>("Session closed", HttpStatus.OK);
			} else {
				return new ResponseEntity<>("Session not found", HttpStatus.NOT_FOUND);
			}
		} catch (OpenViduJavaClientException | OpenViduHttpException e) {
			e.printStackTrace();
			return new ResponseEntity<>("Error closing session: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * 입점업체의 보유 상품 목록
	 * @param vendorId
	 * @return 상품 리스트
	 */
	@GetMapping("/api/sessions/{vendorId}/productList")
	public ResponseEntity<List<ProductInfo>> productList(@PathVariable("vendorId") String vendorId) {
		List<ProductInfo> list = new ArrayList<>();
		ProductInfo productInfo1 = ProductInfo.builder()
				.id("1")
				.name("상품1")
				.price(1000)
				.build();

		ProductInfo productInfo2 = ProductInfo.builder()
				.id("2")
				.name("상품2")
				.price(2000)
				.build();
		ProductInfo productInfo3 = ProductInfo.builder()
				.id("3")
				.name("상품3")
				.price(3000)
				.build();
		list.add(productInfo1);
		list.add(productInfo2);
		list.add(productInfo3);

		return new ResponseEntity<>(list, HttpStatus.OK);
	}
}

