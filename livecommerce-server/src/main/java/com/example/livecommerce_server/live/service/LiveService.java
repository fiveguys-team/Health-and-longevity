package com.example.livecommerce_server.live.service;

import com.example.livecommerce_server.live.dto.LiveChatDTO;
import com.example.livecommerce_server.live.dto.LiveDTO;
import com.example.livecommerce_server.live.dto.LiveProductDTO;
import java.util.List;
import org.springframework.stereotype.Service;


public interface LiveService {
	LiveChatDTO addLiveInfo(LiveDTO liveDTO);

	void addLiveProduct(List<LiveProductDTO> liveProductList);
}
