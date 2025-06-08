package com.example.livecommerce_server.live.controller;

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
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
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
@RestController
@Slf4j
public class LiveController {

	@Value("${OPENVIDU_URL}")
	private String OPENVIDU_URL;

	@Value("${OPENVIDU_SECRET}")
	private String OPENVIDU_SECRET;

	private OpenVidu openvidu;

	// 활성 세션 정보를 저장하는 맵
	private final ConcurrentHashMap<String, SessionInfo> activeSessions = new ConcurrentHashMap<>();

	@PostConstruct
	public void init() {
		this.openvidu = new OpenVidu(OPENVIDU_URL, OPENVIDU_SECRET);
	}

	@Bean
	public CorsFilter corsFilter() {
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		CorsConfiguration config = new CorsConfiguration();
		config.setAllowedOrigins(Arrays.asList("http://localhost:5174", "http://localhost:5173", "http://localhost:5175"));
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
	public ResponseEntity<List<SessionInfo>> getActiveSessions() {
		List<SessionInfo> sessions = new ArrayList<>(activeSessions.values());
		return new ResponseEntity<>(sessions, HttpStatus.OK);
	}

	/**
	 * @param params The Session properties
	 * @return The Session ID
	 */
	@PostMapping("/api/sessions")
	public ResponseEntity<String> initializeSession(@RequestBody(required = false) Map<String, Object> params)
			throws OpenViduJavaClientException, OpenViduHttpException {
		SessionProperties properties = SessionProperties.fromJson(params).build();
		Session session = openvidu.createSession(properties);

		// 세션 정보 저장
		if (params != null && params.containsKey("customSessionId")) {
			String sessionId = params.get("customSessionId").toString();
			SessionInfo sessionInfo = new SessionInfo();
			sessionInfo.setId(sessionId);
			if (params.containsKey("clientData")) {
				Map<String, Object> clientData = (Map<String, Object>) params.get("clientData");
				sessionInfo.setTitle((String) clientData.get("title"));
				sessionInfo.setProductInfo((Map<String, Object>) clientData.get("productInfo"));
			}
			activeSessions.put(sessionId, sessionInfo);
		}

		return new ResponseEntity<>(session.getSessionId(), HttpStatus.OK);
	}

	/**
	 * @param sessionId The Session in which to create the Connection
	 * @param params    The Connection properties
	 * @return The Token associated to the Connection
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
}

// 세션 정보를 담는 클래스
@Setter
@Getter
class SessionInfo {
	private String id;
	private String title;
	private Map<String, Object> productInfo;
}