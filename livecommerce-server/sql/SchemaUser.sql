-- livecommerce_db 데이터베이스 생성
CREATE DATABASE livecommerce_db;

-- 사용자 'wms_user' 생성 (localhost에서만 접근 가능)
CREATE USER 'live_user'@'%' IDENTIFIED BY 'live1234';

-- 'wms_user'에게 'wms_db'에 대한 모든 권한 부여
GRANT ALL PRIVILEGES ON livecommerce_db.* TO 'live_user'@'%';

-- 변경 사항 즉시 적용 (MySQL의 권한 테이블 갱신)
FLUSH PRIVILEGES;


-- 공통 DB 정보 (MySQL)
--
-- DB 이름: livecommerce
-- 사용자 계정: liveuser
-- 비밀번호: live1234
--
-- 접속 URL (Spring Boot):
-- jdbc:mysql://localhost:3306/livecommerce?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Seoul
--
--  꼭 MySQL Workbench에 접속해서 테스트해볼 것!
--  DB 및 사용자 계정은 공통으로 사용!