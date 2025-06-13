package com.example.livecommerce_server.chat.mapper;

import com.example.livecommerce_server.chat.vo.Banword;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 금지어 관련 데이터베이스 접근을 위한 Mapper
 * BANWORD_M 테이블과 연동됩니다.
 */
@Mapper
public interface BanwordMapper {

    /**
     * 활성화된 금지어 목록 조회
     * type_cd = '금칙어' AND use_yn = true 조건으로 조회
     *
     * @return 활성화된 금지어 리스트
     */
    List<Banword> selectActiveBanwords();

    /**
     * 활성화된 허용어 목록 조회
     * type_cd = '허용어' AND use_yn = true 조건으로 조회
     *
     * @return 활성화된 허용어 리스트
     */
    List<Banword> selectActiveAllowwords();

}
