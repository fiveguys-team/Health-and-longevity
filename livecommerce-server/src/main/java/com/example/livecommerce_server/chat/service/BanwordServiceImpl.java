package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.mapper.BanwordMapper;
import com.example.livecommerce_server.chat.vo.Banword;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 금지어 관리 서비스 구현체
 * 데이터베이스에서 금지어/허용어를 조회하여 관리합니다.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class BanwordServiceImpl implements BanwordService {


    private final BanwordMapper banwordMapper;

    /**
     * 활성화된 금지어 목록 조회
     *
     * @return 활성화된 금지어 Set (단어만)
     */
    @Override
    public Set<String> findActiveBanwords() {
        List<Banword> banwords = banwordMapper.selectActiveBanwords();

        Set<String> result = banwords.stream()
                .map(Banword::getWord)
                .collect(Collectors.toSet());

        log.info("활성화된 금지어 {}개 조회됨", result.size());
        return result;
    }


    /**
     * 활성화된 허용어 목록 조회
     *
     * @return 활성화된 허용어 Set (단어만)
     */
    @Override
    public Set<String> findActiveAllowwords() {
        List<Banword> allowwords = banwordMapper.selectActiveAllowwords();

        Set<String> result = allowwords.stream()
                .map(Banword::getWord)
                .collect(Collectors.toSet());

        log.info("활성화된 허용어 {}개 조회됨", result.size());
        return result;
    }
}
