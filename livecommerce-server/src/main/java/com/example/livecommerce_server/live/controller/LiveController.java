package com.example.livecommerce_server.live.controller;

import com.example.livecommerce_server.live.dto.LiveChatDTO;
import com.example.livecommerce_server.live.dto.LiveDTO;
import com.example.livecommerce_server.live.dto.LiveEndRequestDto;
import com.example.livecommerce_server.live.dto.LiveProductDTO;
import com.example.livecommerce_server.live.dto.ProductInfo;
import com.example.livecommerce_server.live.dto.VendorProductDTO;
import com.example.livecommerce_server.live.service.LiveProductService;
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
import java.time.Instant;
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
	private final LiveProductService liveProductService;

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
	 * 현재 활성화된 모든 세션 목록을 반환합니다.
	 *
	 * @return List<LiveDTO> 활성화 된 방송 리스트
	 */
	@GetMapping("/api/sessions")
	public ResponseEntity<List<LiveDTO>> getActiveSessions() {
		List<LiveDTO> sessions = new ArrayList<>(activeSessions.values());
		return new ResponseEntity<>(sessions, HttpStatus.OK);
	}

	/**
	 * 입점업체가 라이브 방송을 요청할 때 세션 생성 및 정보를 저장합니다.
	 *
	 * @param liveDTO 라이브 세션 정보
	 * @return liveChatDTO (Live_id, Session_id)
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
			liveDTO.setVendorName(liveService.findVendorName(liveDTO.getVendorId()));

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
			return ResponseEntity.ok(liveChatDTO);
		} catch (Exception e) {
			log.error("Failed to initialize session", e);
			return new ResponseEntity<>("Failed to initialize session: " + e.getMessage(),
					HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * Session 에 접속하기 위한 토큰을 발급하고 Connection 을 생성합니다.
	 *
	 * @param sessionId 접속할 sessionId
	 * @param params connection 에 설정할 정보
	 * @return 토큰
	 * @throws OpenViduJavaClientException openvidu 서버 에러
	 * @throws OpenViduHttpException openvidy Http 에러
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
	 * 세션 종료를 처리합니다.
	 *
	 * @param sessionId 종료할 세션의 ID
	 * @return 처리 결과
	 */
	@DeleteMapping("/api/sessions/{sessionId}")
	public ResponseEntity<String> closeSession(@PathVariable("sessionId") String sessionId) {
		log.info("session 종료 API 호출됨");
		try {
			// OpenVidu 서버에서 세션 찾기
			Session session = openvidu.getActiveSession(sessionId);
			log.info("sessionId: " + sessionId);
			log.info("sessionId: " + session.getSessionId());

			// 세션의 모든 연결 종료
			session.close();
			// 활성 세션 목록에서 제거
			activeSessions.remove(sessionId);
			// 라이브 종료 후 종료 시간, 상태 변경 메서드
			liveService.saveLiveInfo(sessionId);

			return new ResponseEntity<>("Session closed", HttpStatus.OK);
		} catch (OpenViduJavaClientException | OpenViduHttpException e) {
			e.printStackTrace();
			return new ResponseEntity<>("Error closing session: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * 입점업체의 보유 상품 목록을 반환합니다.
	 *
	 * @param vendorId 입점업체 ID
	 * @return 상품 리스트
	 */
	@GetMapping("/api/sessions/{vendorId}/productList")
	public ResponseEntity<List<VendorProductDTO>> productList(@PathVariable("vendorId") String vendorId) {
		List<VendorProductDTO> productList = liveProductService.findVendorProduct(vendorId);
		return new ResponseEntity<>(productList, HttpStatus.OK);
	}
}

