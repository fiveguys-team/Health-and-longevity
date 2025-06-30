-- ========================================================
-- 1) DROP TABLE statements (맨 위로 모아둠)
-- ========================================================
SET FOREIGN_KEY_CHECKS=0;

-- 1. 자식 테이블들 먼저 제거
DROP TABLE IF EXISTS `SERVICE_M`;            -- 참조: ORDER_ITEM_D
DROP TABLE IF EXISTS `REVIEW`;               -- 참조: ORDER_ITEM_D
DROP TABLE IF EXISTS `CHAT_REPORT_D`;        -- 참조: CHAT_MESSAGE_D, USER_M
DROP TABLE IF EXISTS `CHAT_PARTICIPANT_D`;   -- 참조: CHAT_ROOM_M, USER_M
DROP TABLE IF EXISTS `CHAT_MESSAGE_D`;       -- 참조: CHAT_ROOM_M, USER_M
DROP TABLE IF EXISTS `CHATBOT_LOG_D`;        -- 참조: USER_M
DROP TABLE IF EXISTS `LIVE_PRODUCT_J`;       -- 참조: LIVE_M, PRODUCT
DROP TABLE IF EXISTS `PRODUCT_DETAIL`;       -- 참조: PRODUCT
DROP TABLE IF EXISTS `CART_ITEM_D`;          -- 참조: CART_M, PRODUCT
DROP TABLE IF EXISTS `STOCK_LOG`;            -- 참조: PRODUCT
DROP TABLE IF EXISTS `ORDER_ITEM_D`;         -- 참조: ORDERS_M, PRODUCT
DROP TABLE IF EXISTS `LIVE_DASHBOARD_D`;     -- 참조: LIVE_M
DROP TABLE IF EXISTS `LIVE_VIEWER_LOG`;      -- 참조: LIVE_M
DROP TABLE IF EXISTS `CART_M`;               -- 참조: USER_M
DROP TABLE IF EXISTS `CHAT_ROOM_M`;          -- 참조: LIVE_M

-- 2. 이제 중간 단계 테이블 제거
DROP TABLE IF EXISTS `ORDERS_M`;             -- 참조: PAYMENT_D, USER_M
DROP TABLE IF EXISTS `PRODUCT`;              -- 참조: CATEGORY, VENDOR_M
DROP TABLE IF EXISTS `LIVE_M`;               -- 참조: VENDOR_M
DROP TABLE IF EXISTS `VENDOR_M`;             -- 참조: USER_M

-- 3. 끝으로 루트 테이블들 제거,
DROP TABLE IF EXISTS `PAYMENT_D`;
DROP TABLE IF EXISTS `USER_M`;
DROP TABLE IF EXISTS `CATEGORY`;

DROP TABLE IF EXISTS `BANWORD_M`;

-- ========================================================
-- 2) CREATE TABLE statements
-- ========================================================
CREATE TABLE `CHAT_ROOM_M` (
                               `room_id` BIGINT NOT NULL AUTO_INCREMENT,
                               `participants_cnt` INT NULL,
                               `created_at` DATETIME NULL,
                               `updated_at` DATETIME NULL,
                               `live_id` CHAR(36) NOT NULL,
                               PRIMARY KEY (`room_id`)
);

CREATE TABLE `USER_M` (
                          `user_id`        BIGINT NOT NULL AUTO_INCREMENT,
                          `email`          VARCHAR(256) UNIQUE NULL,
                          `password`       VARCHAR(256)     NULL,
                          `name`           VARCHAR(256)     NULL,
                          `interest`       VARCHAR(256)     NULL,
                          `social_id`    VARCHAR(256)     NULL,
                          `social_type`       ENUM('KAKAO', 'GOOGLE') NULL,
                          `role`           ENUM('USER','VENDOR','ADMIN') default 'USER',
                          `email_verified` BOOLEAN          NULL,
                          PRIMARY KEY (`user_id`)
);

CREATE TABLE `PAYMENT_D` (
                             `payments_id`        CHAR(36) NOT NULL,
                             `payment_method`     CHAR(4)  NULL,
                             `payment_Key`        VARCHAR(256) NULL,
                             `payment_payload`    JSON     NULL,
                             `paid_at`            CHAR(16) NULL,
                             `created_at`         CHAR(16) NULL,
                             `payment_status_code` CHAR(4) NULL
);

CREATE TABLE `CHAT_REPORT_D` (
                                 `report_id` BIGINT NOT NULL AUTO_INCREMENT,
                                 `reason_nm` VARCHAR(100) NULL,
                                 `status_cd` ENUM('미처리','제재됨','해제됨') NULL,
                                 `reported_at` DATETIME NULL,
                                 `processed_at` DATETIME NULL,
                                 `message_id` BIGINT NOT NULL,
                                 `user_id` BIGINT NOT NULL,
                                 PRIMARY KEY (`report_id`)
);

CREATE TABLE `SERVICE_M` (
                             `service_id`    CHAR(36)   NOT NULL,
                             `order_item_id` CHAR(36)   NOT NULL,
                             `service_code`  CHAR(4)    NULL,
                             `reason`        VARCHAR(100) NULL,
                             `img`           VARCHAR(255) NULL,
                             `status_code`   CHAR(4)    NULL,
                             `refund_amount` INT        NULL,
                             `update_at`     CHAR(16)   NULL,
                             `created_at`    CHAR(16)   NULL
);

CREATE TABLE `REVIEW` (
                          `review_id` BIGINT NOT NULL AUTO_INCREMENT,
                          `order_item_id` CHAR(36) NOT NULL,
                          `rating` INTEGER NULL,
                          `feedback_choice` TINYINT NULL,
                          `content` VARCHAR(256) NULL,
                          `created_at` CHAR(16) NULL,
                          PRIMARY KEY (`review_id`)
);

CREATE TABLE `ORDERS_M` (
                            `order_id`         CHAR(36)     NOT NULL COMMENT '주문UUID',
                            `payments_id`      CHAR(36)     NOT NULL COMMENT '결제UUID',
                            `user_id`          BIGINT       NOT NULL COMMENT '유저UUID',
                            `order_status_code` CHAR(4)     NULL     COMMENT '해당 주문의 상태 (0: 배송준비중, 1: 출고준비중, 2: 배송중, 3: 배송완료)',
                            `discount_amount`  INT          NULL     COMMENT '해당 상품의 할인율에 기반한 할인 금액',
                            `order_date`       CHAR(16)     NULL     COMMENT '해당 주문 정보 생성 시간 (YYYY-MM-DD HH:MM:SS)',
                            `total_amount`     INT          NULL     COMMENT '상품금액 * 수량 * (100 - 할인율) / 100',
                            `shipping_req`     VARCHAR(256) NULL     COMMENT '유저가 입력한 배송요청사항',
                            `created_at`       CHAR(16)     NULL     COMMENT '해당 주문 상세 정보 생성 시간 (YYYY-MM-DD HH:MM:SS)',
                            `postal_code`      VARCHAR(256) NULL     COMMENT '주문자의 우편번호',
                            `basic_address`    VARCHAR(256) NULL     COMMENT '주문자의 기본주소(도로명주소)',
                            `detail_address`   VARCHAR(256) NULL     COMMENT '주문자의 상세주소',
                            PRIMARY KEY (`order_id`)

);

CREATE TABLE `VENDOR_M` (
                            `vendor_id` BIGINT NOT NULL AUTO_INCREMENT,
                            `user_id` BIGINT NOT NULL,
                            `name` VARCHAR(256) NULL,
                            `address` VARCHAR(256) NULL,
                            `business_number` VARCHAR(256) NOT NULL,
                            `permit_number` VARCHAR(256) NOT NULL,
                            `status` ENUM('PENDING','APPROVED','REJECTED') default 'PENDING',
                            `vendor_img` LONGTEXT NOT NULL,
                            `b_img` LONGTEXT NOT NULL,
                            `p_img` LONGTEXT NOT NULL,
                            PRIMARY KEY (`vendor_id`)
);

CREATE TABLE `CHAT_PARTICIPANT_D` (
                                      `participant_id` BIGINT NOT NULL AUTO_INCREMENT,
                                      `banned_yn` BOOLEAN NULL,
                                      `created_at` DATETIME NULL,
                                      `room_id` BIGINT NOT NULL,
                                      `user_id` BIGINT NOT NULL,
                                      PRIMARY KEY (`participant_id`)
);

CREATE TABLE `LIVE_DASHBOARD_D` (
                                    `liveDashboard_id` CHAR(36) NOT NULL,
                                    `live_id`          CHAR(36) NOT NULL,
                                    `total_viewers`    INTEGER NULL,
                                    `max_concurrent_viewers` INTEGER NULL,
                                    `average_watch_duration` INTEGER NULL,
                                    `purchase_ratio`      INTEGER NULL,
                                    `total_orders`     INTEGER NULL,
                                    `total_reve`       BIGINT  NULL,
                                    `purchase_rate`    INTEGER NULL
);

CREATE TABLE `LIVE_VIEWER_LOG` (
                                   `viewer_log_id`   BIGINT NOT NULL AUTO_INCREMENT,
                                   `live_id`         CHAR(36) NOT NULL,
                                   `user_id`         VARCHAR(256) NULL,
                                   `join_at`         VARCHAR(256) NULL,
                                   `leave_at`        VARCHAR(256) NULL,
                                   `is_anonymous`    BOOLEAN,
                                   PRIMARY KEY (`viewer_log_id`)
);

CREATE TABLE `CHAT_MESSAGE_D` (
                                  `message_id` BIGINT NOT NULL AUTO_INCREMENT,
                                  `content` TEXT NULL,
                                  `created_at` DATETIME NULL,
                                  `user_id` BIGINT NOT NULL,
                                  `room_id` BIGINT NOT NULL,
                                  PRIMARY KEY (`message_id`)
);

CREATE TABLE `BANWORD_M` (
                             `word_id` BIGINT NOT NULL AUTO_INCREMENT ,
                             `word` VARCHAR(100) NOT NULL ,
                             `type_cd` ENUM('금칙어', '허용어') NOT NULL ,
                             `category_nm` VARCHAR(50) NULL ,
                             `use_yn` BOOLEAN DEFAULT TRUE ,
                             `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP ,
                             PRIMARY KEY (`word_id`)
);


CREATE TABLE `CHATBOT_LOG_D` (
                                 `log_id` BIGINT NOT NULL AUTO_INCREMENT,
                                 `question` TEXT NULL,
                                 `answer` TEXT NULL,
                                 `created_at` DATETIME NULL,
                                 `user_id` BIGINT NOT NULL,
                                 PRIMARY KEY (`log_id`)
);

CREATE TABLE `CART_M` (
                          `cart_id`    CHAR(36) NOT NULL,
                          `created_at` CHAR(16) NULL,
                          `user_id`    BIGINT   NOT NULL
);

CREATE TABLE `LIVE_M` (
                          `live_id`      CHAR(36) NOT NULL,
                          `vendor_id`    BIGINT   NOT NULL,
                          `session_id`   VARCHAR(256) NULL,
                          `title`        VARCHAR(256) NULL,
                          `start_at`     VARCHAR(256) NULL,
                          `end_cd`       VARCHAR(256) NULL,
                          `thumnail`     VARCHAR(256) NULL,
                          `status_cd`    ENUM('ON','OFF') NULL,
                          `announcement` TEXT     NULL,
                          `category`     VARCHAR(256) NULL
);

CREATE TABLE `PRODUCT` (
                           `product_id`    CHAR(36) NOT NULL,
                           `category_id`   BIGINT   NOT NULL,
                           `vendor_id`     BIGINT   NOT NULL,
                           `name`          VARCHAR(256) NULL,
                           `price`         INT      NULL,
                           `stock_count`   INT      NULL,
                           `status`        ENUM('PENDING','APPROVED','REJECTED','RESUBMITTED') NULL,
                           `product_image` LONGTEXT NULL
);

CREATE TABLE `STOCK_LOG` (
                             `stock_log_id` BIGINT NOT NULL AUTO_INCREMENT,
                             `product_id` CHAR(36) NOT NULL,
                             `change_type` ENUM('SALE','RESTOCK','CANCEL','ADJUST') NULL,
                             `count_change` INT NULL,
                             `changed_at` CHAR(16) NULL,
                             PRIMARY KEY (`stock_log_id`)
);

CREATE TABLE `CATEGORY` (
                            `category_id` BIGINT NOT NULL AUTO_INCREMENT,
                            `name` VARCHAR(256) NULL,
                            PRIMARY KEY (`category_id`)
);


CREATE TABLE `ORDER_ITEM_D` (
                                `order_item_id` CHAR(36) NOT NULL,
                                `order_id`      CHAR(36) NOT NULL,
                                `product_id`    CHAR(36) NOT NULL,
                                `quantity`      INT      NULL,
                                `created_at`    CHAR(16) NULL,
                                `paid_amount`   INT      NULL
);

CREATE TABLE `CART_ITEM_D` (
                               `cart_item_id` CHAR(36) NOT NULL,
                               `cart_id`      CHAR(36) NOT NULL,
                               `product_id`   CHAR(36) NOT NULL,
                               `quantity`     INT      NULL,
                               `created_at`   CHAR(16) NULL
);

CREATE TABLE `LIVE_PRODUCT_J` (
                                  `live_product_id` BIGINT NOT NULL AUTO_INCREMENT,
                                  `live_id` CHAR(36) NOT NULL,
                                  `product_id` CHAR(36) NOT NULL,
                                  `discountRate` BIGINT NULL,
                                  PRIMARY KEY (`live_product_id`)
);


CREATE TABLE `PRODUCT_DETAIL` (
                                  `cert_no` BIGINT NOT NULL,
                                  `product_id` CHAR(36) NOT NULL,
                                  `expiry_date` VARCHAR(256) NULL,
                                  `approval_date` VARCHAR(256) NULL,
                                  `how_to_take` VARCHAR(256) NULL,
                                  `main_function` VARCHAR(1000) NULL,
                                  `precautions` VARCHAR(256) NULL,
                                  `storage_method` VARCHAR(256) NULL,
                                  `standard` VARCHAR(1000) NULL,
                                  `ingredients` VARCHAR(1000) NULL,
                                  `product_name` VARCHAR(256) NULL,
                                  PRIMARY KEY (`cert_no`)
);


ALTER TABLE `PAYMENT_D`
    ADD CONSTRAINT `PK_PAYMENT_D` PRIMARY KEY (`payments_id`);

ALTER TABLE `SERVICE_M`
    ADD CONSTRAINT `PK_SERVICE_M` PRIMARY KEY (`service_id`);



ALTER TABLE `LIVE_DASHBOARD_D`
    ADD CONSTRAINT `PK_LIVE_DASHBOARD_D` PRIMARY KEY (`liveDashboard_id`);

ALTER TABLE `CART_M`
    ADD CONSTRAINT `PK_CART_M` PRIMARY KEY (`cart_id`);

ALTER TABLE `LIVE_M`
    ADD CONSTRAINT `PK_LIVE_M` PRIMARY KEY (`live_id`);

ALTER TABLE `PRODUCT`
    ADD CONSTRAINT `PK_PRODUCT` PRIMARY KEY (`product_id`);

ALTER TABLE `ORDER_ITEM_D`
    ADD CONSTRAINT `PK_ORDER_ITEM_D` PRIMARY KEY (`order_item_id`);

ALTER TABLE `CART_ITEM_D`
    ADD CONSTRAINT `PK_CART_ITEM_D` PRIMARY KEY (`cart_item_id`);

-- ========================================================
-- 4) FOREIGN KEY constraints
-- ========================================================
ALTER TABLE `CHAT_ROOM_M`
    ADD CONSTRAINT `FK_LIVE_M_TO_CHAT_ROOM_M_1`
        FOREIGN KEY (`live_id`) REFERENCES `LIVE_M` (`live_id`);

ALTER TABLE `CHAT_REPORT_D`
    ADD CONSTRAINT `FK_CHAT_MESSAGE_D_TO_CHAT_REPORT_D_1`
        FOREIGN KEY (`message_id`) REFERENCES `CHAT_MESSAGE_D` (`message_id`),
    ADD CONSTRAINT `FK_USER_M_TO_CHAT_REPORT_D_1`
        FOREIGN KEY (`user_id`)     REFERENCES `USER_M`        (`user_id`);

ALTER TABLE `SERVICE_M`
    ADD CONSTRAINT `FK_ORDER_ITEM_D_TO_SERVICE_M_1`
        FOREIGN KEY (`order_item_id`) REFERENCES `ORDER_ITEM_D` (`order_item_id`);

ALTER TABLE `REVIEW`
    ADD CONSTRAINT `FK_ORDER_ITEM_D_TO_REVIEW_1`
        FOREIGN KEY (`order_item_id`) REFERENCES `ORDER_ITEM_D` (`order_item_id`);

ALTER TABLE `ORDERS_M`
    ADD CONSTRAINT `FK_PAYMENT_D_TO_ORDERS_M_1`
        FOREIGN KEY (`payments_id`) REFERENCES `PAYMENT_D` (`payments_id`),
    ADD CONSTRAINT `FK_USER_M_TO_ORDERS_M_1`
        FOREIGN KEY (`user_id`)      REFERENCES `USER_M`    (`user_id`);

ALTER TABLE `VENDOR_M`
    ADD CONSTRAINT `FK_USER_M_TO_VENDOR_M_1`
        FOREIGN KEY (`user_id`)      REFERENCES `USER_M`    (`user_id`);

ALTER TABLE `CHAT_PARTICIPANT_D`
    ADD CONSTRAINT `FK_CHAT_ROOM_M_TO_CHAT_PARTICIPANT_D_1`
        FOREIGN KEY (`room_id`)     REFERENCES `CHAT_ROOM_M` (`room_id`),
    ADD CONSTRAINT `FK_USER_M_TO_CHAT_PARTICIPANT_D_1`
        FOREIGN KEY (`user_id`)     REFERENCES `USER_M`      (`user_id`);

ALTER TABLE `LIVE_DASHBOARD_D`
    ADD CONSTRAINT `FK_LIVE_M_TO_LIVE_DASHBOARD_D_1`
        FOREIGN KEY (`live_id`)     REFERENCES `LIVE_M`      (`live_id`);

ALTER TABLE `LIVE_VIEWER_LOG`
    ADD CONSTRAINT `FK_LIVE_M_TO_LIVE_VIEWER_LOG_1`
        FOREIGN KEY (`live_id`)     REFERENCES `LIVE_M`      (`live_id`);

ALTER TABLE `CHAT_MESSAGE_D`
    ADD CONSTRAINT `FK_USER_M_TO_CHAT_MESSAGE_D_1`
        FOREIGN KEY (`user_id`)     REFERENCES `USER_M`      (`user_id`),
    ADD CONSTRAINT `FK_CHAT_ROOM_M_TO_CHAT_MESSAGE_D_1`
        FOREIGN KEY (`room_id`)     REFERENCES `CHAT_ROOM_M` (`room_id`);

ALTER TABLE `CHATBOT_LOG_D`
    ADD CONSTRAINT `FK_USER_M_TO_CHATBOT_LOG_D_1`
        FOREIGN KEY (`user_id`)     REFERENCES `USER_M`      (`user_id`);

ALTER TABLE `CART_M`
    ADD CONSTRAINT `FK_USER_M_TO_CART_M_1`
        FOREIGN KEY (`user_id`)     REFERENCES `USER_M`      (`user_id`);

ALTER TABLE `LIVE_M`
    ADD CONSTRAINT `FK_VENDOR_M_TO_LIVE_M_1`
        FOREIGN KEY (`vendor_id`)   REFERENCES `VENDOR_M`    (`vendor_id`);

ALTER TABLE `PRODUCT`
    ADD CONSTRAINT `FK_CATEGORY_TO_PRODUCT_1`
        FOREIGN KEY (`category_id`) REFERENCES `CATEGORY`    (`category_id`),
    ADD CONSTRAINT `FK_VENDOR_M_TO_PRODUCT_1`
        FOREIGN KEY (`vendor_id`)   REFERENCES `VENDOR_M`    (`vendor_id`);

ALTER TABLE `STOCK_LOG`
    ADD CONSTRAINT `FK_PRODUCT_TO_STOCK_LOG_1`
        FOREIGN KEY (`product_id`)  REFERENCES `PRODUCT`     (`product_id`);

ALTER TABLE `ORDER_ITEM_D`
    ADD CONSTRAINT `FK_ORDERS_M_TO_ORDER_ITEM_D_1`
        FOREIGN KEY (`order_id`)    REFERENCES `ORDERS_M`    (`order_id`),
    ADD CONSTRAINT `FK_PRODUCT_TO_ORDER_ITEM_D_1`
        FOREIGN KEY (`product_id`)  REFERENCES `PRODUCT`     (`product_id`);

ALTER TABLE `CART_ITEM_D`
    ADD CONSTRAINT `FK_CART_M_TO_CART_ITEM_D_1`
        FOREIGN KEY (`cart_id`)     REFERENCES `CART_M`      (`cart_id`),
    ADD CONSTRAINT `FK_PRODUCT_TO_CART_ITEM_D_1`
        FOREIGN KEY (`product_id`)  REFERENCES `PRODUCT`     (`product_id`);

ALTER TABLE `LIVE_PRODUCT_J`
    ADD CONSTRAINT `FK_LIVE_M_TO_LIVE_PRODUCT_J_1`
        FOREIGN KEY (`live_id`)     REFERENCES `LIVE_M`      (`live_id`),
    ADD CONSTRAINT `FK_PRODUCT_TO_LIVE_PRODUCT_J_1`
        FOREIGN KEY (`product_id`)  REFERENCES `PRODUCT`     (`product_id`);

ALTER TABLE `PRODUCT_DETAIL`
    ADD CONSTRAINT `FK_PRODUCT_TO_PRODUCT_DETAIL_1`
        FOREIGN KEY (`product_id`)  REFERENCES `PRODUCT`     (`product_id`);

-- 상품 데이터 더미

-- 유저 더미
INSERT INTO USER_M (email, password, name, role) VALUES ('admin@test.com', '{noop}password123', '관리자', 'ADMIN');
insert into USER_M (email, password, name, role) values ('vendor1@test.com', '{noop}password123', '강지욱', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendor2@test.com', '{noop}password123', '이윤주', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendo3@test.com', '{noop}password123', '장호영', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendo4@test.com', '{noop}password123', '김미성', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendo5@test.com', '{noop}password123', '김중호', 'VENDOR');

-- 입점업체 더미
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (2, '오펠라헬스케어코리아', '서울특별시 서초구', 1728801879, 20110099003, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%98%A4%ED%8E%A0%EB%9D%BC.jpg', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (3, '브리드케어', '서울특별시 강남구', 5088802515, 20230141301, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EB%B8%8C%EB%A6%AC%EB%93%9C%EC%BC%80%EC%96%B4.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (4, '네츄럴헬스코리아', '서울특별시 강남구', 2088601927, 20200105633, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EB%84%A4%EC%B8%84%EB%9F%B4%ED%97%AC%EC%8A%A4%EC%BD%94%EB%A6%AC%EC%95%84.jpg', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (5, '미성뉴트리션', '서울특별시 강남구', 8748102863, 20240144484, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EB%AF%B8%EC%84%B1.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (6, '영메디케어', '경기도 하남시', 4454900895, 20250525654, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/users/7/images/%EC%98%81%EB%A9%94%EB%94%94inc.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');

-- 카테고리
INSERT INTO CATEGORY (name) VALUES
                                ( '혈압'),
                                ('눈'),
                                ('뼈/관절/연결성분'),
                                ('장건강'),
                                ('영양보충');




-- 2) PAYMENT_D (루트 테이블)
INSERT INTO `PAYMENT_D` (`payments_id`,`payment_method`,`payment_Key`,`payment_payload`,`paid_at`,`created_at`,`payment_status_code`) VALUES
                                                                                                                                          ('335c2ce6-1bd2-422f-82ad-b2498676a087', '간편결제', 'tgen_20250618170145zLh91', '{"vat": 3182, "card": {"amount": 35000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "3f9d4ca1-5d10-4ba4-9629-ec999f0bc3ef", "orderName": "고려홍삼정 스틱", "approvedAt": "2025-06-18T17:02:03+09:00", "paymentKey": "tgen_20250618170145zLh91", "receiptUrl": null, "totalAmount": 35000, "suppliedAmount": 31818, "easyPayProvider": null}', '20250618170203', '20250618170145', 'DONE'),
                                                                                                                                          ('651ef69b-845d-4464-a961-d586f079e1e9', '간편결제', 'tgen_20250618163924nPxo4', '{"vat": 17455, "card": {"amount": 192000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "9289b837-7ee1-41d6-809a-400a98652c43", "orderName": "고려홍삼정 스틱", "approvedAt": "2025-06-18T16:39:39+09:00", "paymentKey": "tgen_20250618163924nPxo4", "receiptUrl": null, "totalAmount": 192000, "suppliedAmount": 174545, "easyPayProvider": null}', '20250618163939', '20250618163924', 'DONE'),
                                                                                                                                          ('57b29a0d-3b7c-47e3-afa6-209a05777763', '간편결제', 'tgen_20250618163825lPdO0', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "00355546-5a8a-4290-955d-efc01a328ab2", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:38:39+09:00", "paymentKey": "tgen_20250618163825lPdO0", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618163839', '20250618163824', 'DONE'),
                                                                                                                                          ('d70dfec4-5fb3-4834-851c-f2729efc8a20', '간편결제', 'tgen_20250618163648nPht7', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "61517d4a-1ef5-4e93-ac2e-ca409d955eaf", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:37:02+09:00", "paymentKey": "tgen_20250618163648nPht7", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618163702', '20250618163647', 'DONE'),
                                                                                                                                          ('d098b6b3-cb71-41a5-9162-10fe9eef5168', '간편결제', 'tgen_20250618162909nOuc2', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "efb4d6ad-9f6f-4077-91af-6d43f895d515", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:29:24+09:00", "paymentKey": "tgen_20250618162909nOuc2", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618162924', '20250618162909', 'DONE'),
                                                                                                                                          ('2a6e887a-7fa6-482a-ab74-1a8765f0ecdc', '간편결제', 'tgen_20250618162805zI3i0', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "18aed960-4288-41ad-9a03-50baa4805d8a", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:28:19+09:00", "paymentKey": "tgen_20250618162805zI3i0", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618162819', '20250618162804', 'DONE'),
                                                                                                                                          ('d1ed414f-a911-4e12-bdb5-1f38b72191c3', '간편결제', 'tgen_20250618162557unJS6', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "6455d250-1454-4236-bdb1-3d5affc59989", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:26:12+09:00", "paymentKey": "tgen_20250618162557unJS6", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618162612', '20250618162556', 'DONE'),
                                                                                                                                          ('7b06cefc-36de-450a-9c31-d70bcd894362', '간편결제', 'tgen_20250618162314s8H53', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "8b5fca93-4c12-4101-8992-fc68dbde8c9b", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:23:31+09:00", "paymentKey": "tgen_20250618162314s8H53", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618162331', '20250618162313', 'DONE'),
                                                                                                                                          ('b0656eed-d317-4ced-b704-83856b97170b', '간편결제', 'tgen_20250618161958paxq2', '{"vat": 28182, "card": {"amount": 310000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "9bea8986-c048-44ed-8563-3faf29d81677", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T16:20:17+09:00", "paymentKey": "tgen_20250618161958paxq2", "receiptUrl": null, "totalAmount": 310000, "suppliedAmount": 281818, "easyPayProvider": null}', '20250618162017', '20250618161957', 'DONE'),
                                                                                                                                          ('a5af6113-5870-4c18-a0da-1f33978d10f5', '간편결제', 'tgen_20250618155018nKrN7', '{"vat": 37455, "card": {"amount": 412000, "number": "433028**********", "cardType": "신용", "approveNo": "00168055", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "be8374a2-dafb-4b4b-84f6-f379f2f3bf32", "orderName": "루테인 눈건강 외 1건", "approvedAt": "2025-06-18T15:50:35+09:00", "paymentKey": "tgen_20250618155018nKrN7", "receiptUrl": null, "totalAmount": 412000, "suppliedAmount": 374545, "easyPayProvider": null}', '20250618155035', '20250618155017', 'DONE');



INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, 1, '가바트리플', 25000, 15, 'APPROVED', 'https://cdn.011st.com/11dims/resize/248/11src/product/7923738502/B.jpg?784082730'
         );

INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             '20070017035202',
             'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546',
             '제조일로부터 24개월',
             '20110207',
             '1일 2회 1회 1캡슐을 물과 함께 섭취',
             '[L-글루타민산 유래 GABA 함유 분말]“혈압이 높은 사람에게 도움을 줄 수 있습니다. (기타기능Ⅱ)” '
                 '[감마리놀렌산함유유지 제품]①혈중 콜레스테롤 개선·혈행개선에 도움을 줄 수 있음 '
                 '②월경전 변화에 의한 불편한 상태 개선에 도움을 줄 수 있음 '
                 '③면역과민반응에 의한 피부상태 개선에 도움을 줄 수 있음 '
                 '[아연]①정상적인 면역기능에 필요②정상적인 세포분열에 필요',
             '[L-글루타민산 유래 GABA 함유 분말]① 임산부와 수유기 여성, 어린이는 섭취에 주의하시기 바람 '
                 '1) 알레르기 체질이신 경우 성분을 확인하신 후 섭취하십시오.',
             '',
             '1) 성상: 미황색 내용물을 함유한 적갈색의 연질캡슐 2) 대장균군: 음성 3) 붕해도: 20분 이내 '
                 '4) 감마아미노부틸산(GABA): 20mg/1,400mg의 80~120% 5) 감마리놀렌산: 240mg/1,400mg의 80~120% '
                 '6) 아연: 6mg/1,400mg의 80~150% 7) 납(mg/kg): 1.0이하 8) 총비소(mg/kg): 1.0이하 '
                 '9) 카드뮴(mg/kg): 0.5이하 10) 총수은(mg/kg): 0.5이하 11) 잔류용매(mg/kg) : 5.0이하',
             '산화아연,보라지 종자유지(Oil),L-글루타민산 유래 GABA 함유 분말,코치닐추출색소 혼합제제(코치닐 추출색소 60%, 치자황색소 25%, 치자청색소 15%),'
                 '글리세린,에틸바닐린,D-소르비톨액,젤라틴,땅콩유지(Oil),레티닐 팔미트산염유지(Oil),비타민 B2,비타민 E,중쇄지방산(MCFA) 함유 유지,'
                 '옥수수 전분분말(가루, 과립),자당분말(가루, 과립),아라비아검분말(가루, 과립),비타민 D3,비타민 D3 혼합제제분말(가루, 과립),비타민 E,'
                 'L-트립토판,레티닐 팔미트산염 혼합제제유지(Oil),L-발린,L-이소로이신,L-히스티딘,팔라티노스,L-라이신염산염,L-메티오닌,L-로이신,'
                 'L-페닐알라닌,아미노산혼합(아미노믹스)분말(가루, 과립),효소처리루틴,대두유,D-α-토코페롤,D-알파-토코페롤 혼합제제,정제어유,마늘유지(Oil),대두레시틴,밀납',
             '가바트리플'
         );
INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, 1, '알로에아보레센스', 25000, 15, 'APPROVED', 'https://m.dulyaloe.com/web/product/big/202307/6b4e56038f1029819a65d54747e9a28f.jpg'
         );

INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, approval_date, expiry_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             '20040020007894', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', '20110216', '제조일로부터 24개월',
             '1일 3회, 1회 2캡슐을 물과 함께 섭취하십시오.', '[알로에전잎 제품] 배변활동 원활에 도움을 줄 수 있음', '다른 치료나 약물 복용중인 경우 전문의와 상의하시고 임산부는 섭취 시 주의하십시오. 특이체질, 알레르기 체질인 경우 성분을 확인하신 후 섭취하십시오. 용기 안의 실리카겔(방습제)은 드시지 마십시오.',
             '직사광선을 받지 않는 서늘한 곳에서 유통 보관하시오.', '성상 : 갈색의 내용물의 함유한 녹색의 경질캡슐 안트라퀴논계화합물(무수바바로인으로서) : 표시량 80~120%(표시량 : 20 mg / 2,580mg) 대장균군 : 음성 붕해시험 : 적합(20분 이내)', '알로에 전잎(알로에아보레센스분말),젤라틴,정제수,이산화티타늄,식용색소황색제4호,식용색소청색제1호,빙초산,자당지방산에스테르,결정셀룰로오스,스테아린산마그네슘,이산화규소,치커리추출물(추출액)분말(분말 추출물),민들레(전체)추출물(추출액)분말(분말 추출물),푸룬농축액(농축물)분말,프락토올리고당,병풀추출물(추출액)분말(분말 추출물)(고투콜라),알로에 베라농축액(농축물)분말(알로에 베라 겔)', '알로에아보레센스'
         );

-- 상품 기본 정보
INSERT INTO PRODUCT (product_id, category_id, vendor_id, name, price, stock_count, status, product_image)
VALUES ('64b56eed-5f4c-4061-9c70-192261b418b5', 2, 1, '행복한 한컵 락티움', 12000, 25, 'APPROVED', 'https://m.optihealth.co.kr/web/product/extra/big/202304/9bb48480c2da5ab58cad237feff910f9.jpg' );

-- 상품 상세 정보
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take,
    main_function, precautions, storage_method, standard,
    ingredients, product_name
)
VALUES (
           20040020003145, '64b56eed-5f4c-4061-9c70-192261b418b5', '제조일로부터 12개월', '20110311', '1일 1회, 1회에 1포(80ml)을 섭취하십시오.',
           '[유단백가수분해물(락티움)]스트레스로 인한 긴장을 완화하는데 도움을 줄 수 있음(기타기능II)', '[유단백가수분해물(락티움)]① 임산부, 수유여성 및 12세 이하 어린이는 섭취에 주의하여야 합니다.② 우유 및 유제품에 대하여 알레르기를 나타내는 사람은 섭취에 주의하여야 합니다. -원료 성분에 의한 침전물이 생길수 있으나 변질에 의한 것이 아니니 안심하고 섭취하십시오. -포 개봉시 주의하시기 바라며, 전자레인지를 사용 하실때에는 다른 용기에 옮겨 데우십시오. -특정 성분에 민감한 체질인 분은 원료 성분을 확인 후 섭취하시기 바랍니다.', '-고온다습, 직사광선을 피하여 서능한 곳에 보관하십시오. -개봉 후에는 냉장보관 하시는 것이 좋습니다.', '① 성상 : 연황색의 액상제품으로 이미, 이취가 없음 ② αs1-casein(f91-100)(mg/g) :표시량(3mg/80ml)의 80~120% ③ 납(mg/kg) : 1.0이하 ④ 총비소(mg/kg) : 3.0이하 ⑤ 카드뮴(mg/kg) : 0.1이하 ⑥ 총수은(mg/kg) : 0.1이하 ⑦ 대장균군 : 음성이어야 한다 ⑧ 세균수(/ml) : 1ml당 100이하',
           '유단백가수분해물(락티움)(αs1-casein(f91-100)(mg/g)),환원철,비타민 D3 혼합제제(수크로오스36%, 옥수수전분27%, 아라비아검22%, 야자유10.6975%, 제삼인산칼슘0.5%, 비타민D30.275%, 디엘-알파-토코페롤0.0275%, 정제수3.5%),비타민 B2,바닐린,정제수,프로필렌글리콜,생선콜라겐펩타이드,프로테아제(세균성),니코틴산아미드,판토텐산칼슘,비타민 B12 혼합제제(비타민B120.11%, 말토덱스트린94%, 구연산삼나트륨0.97%, 구연산0.71%, 물4.21%)0.1%, 비타민B1염산염0.08%, 비타민B20.075%, 엽산0.015%, 비오틴0.004%),비타민 E 혼합제제(디엘-알파-토코페롤 아세테이트54%, 유당36%, 식용카제인7%, 제삼인삼칼슘1.5%, 글리세린지방산에스테르1.1%, 수산화나트륨0.4%),산화아연,분말비타민 A(수크로오스36%, 옥수수전분27%, 아라비아검20%, 비타민A Acetate13%, 디엘-알파-토코페롤1.1%, 제삼인삼칼슘0.5%, 정제수3.4%),비타민 B6 염산염,비타민 B1염산염,엽산,비오틴,구연산,바나나향,정제수,결정과당,바나나 퓨레,말토덱스트린,펙틴,배농축액(농축물),팔라티노스,비타민 무기질혼합제제,제이인산칼슘,비타민 C,바나나향1(키베이스향1(초산이소아밀38%, 낙산이소아밀22%, 초산에틸14%, 벤질알콜8%, 이소길초산이소아밀6%, 유게놀4%, 낙산3%, 아세트알데히드5%)13.5%, 낙산에틸0.5%, 초산이소아밀3.5%, 바닐린0.5%,식용주정,구연산삼나트륨', '행복한 한컵 락티움'
       );
-- Product Table (더미 데이터)
INSERT INTO PRODUCT (product_id, category_id, vendor_id, name, price, stock_count, status, product_image)
VALUES ('ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, 1, '홍삼타브렛', 20000, 50, 'APPROVED', 'data:image/jpeg;base64,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s24Ndj8GHsnKXvidTfVZ8P52y2r5SxoiLaUBERAEREAXyF9RAeHUwdQD2rC/A0z7A91vktlFxxT3R1No0HbJZwLh7/3WB+yOT/EKWRVujB8ElOXcgn7MfyB9/wC6wOwLhc0vAT8lZEUHho8EurIq/mwLERGkjTxUVvFhHVQxjGlxzaATwV8LQdV5bTA0AHYof0vuSVa3BR9mbjF0Oruyj8Dbn3nQe6Vbtm7Ko0BlpU2t5mOke06lbqK+FKMNiudSUtzW2lh/OUalOJzseyO80iPivyLWomm8gFwc0xxDgRbtBX7DXMPKH5MBinuxOGgVTdzD0cx5tdoD1G3WFNoinY5PszffHUoAxLnAcKgFQeLhm+Ks2D8qeJFn0aL+zMw/MqobV3ZxOGdlrU3M77SAew6H3FaYoOGrFB00+CWdnTaflOBu/A/7ax+RprOPKdh9Tg6l9em0/suXte7rXw35qPSR1zOoN8pGHggYOrczd7dVgreU1gu3AT3q0fJhXN21COa8vqE81zpDOi+V/KfX/l4Wiw6SS59uVsqgNqb97QeL4gUxypta34mXfFV0l3AFeW4WrUcGhhJOg1J7BxUlTXYZ9D03El7s9So57vxPcXHxJX6Q8lJnZtIxEl5HZmIn4Ll+5nklxFdzamMBpUhfKbPcOQb7PaY7Cu84TDMpsbTptDWNAa1o0AFgFNRs7kXK6sZkRFIiEREAREQBERAEREAREQBERAEREAREQBERAealMOEEAjkbjwULi90MDUu7B0pPFrch8WwpxEBT6/k12e7Sk9vZUf8A3ErRq+SfBHSpiG9jqZ/VTKvyIDng8keE/wDPifGj/wDks9LyUYEauru7XtH6WBXxEBVML5OtnM/+Nm773u+BdHwU/gNlUKAijQp0x/oY1vjAutxEAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREB//2Q==');

-- Product Detail Table
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             8406784402430241303, 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', '2년', '20110325', '1일 2회, 1회 3정씩 음용수와 함께 섭취하거나 씹어서 섭취',
             '[홍삼제품]①면역력증진②피로개선③혈소판응집억제를통한혈액흐름에도움④기억력개선⑤항산화에도움을줄수있음', '알러지 등 특이체질이신 분은 제품성분을 확인후 섭취여부를 결정 어린이의 경우 보호자의 지도하에 섭취 의약품(당뇨치료제, 혈액항응고제)복용 시 섭취에 주의', '', '1.성상:고유의 색택과 향미를 가지며 이미, 이취가 없어야 함. 2.진세노사이드 Rb1,Rg1 및 Rg3의 합:표시량(5.8mg/900mg)의 80%이상 3.대장균군:음성 4.붕해도: 붕해시험에 적합하여야 한다.', '홍삼분말(가루, 과립)', '홍삼타브렛'
         );
-- Product Table (더미 데이터)
INSERT INTO PRODUCT (product_id, category_id, vendor_id, name, price, stock_count, status, product_image)
VALUES ('4dd8e072-ca61-4292-9498-36d0b05d1a19', 5, 1, '천지인 키즐홍짱 홍삼액', 25000, 30, 'APPROVED', 'data:image/jpeg;base64,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');

-- Product Detail Table
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             18866061144, '4dd8e072-ca61-4292-9498-36d0b05d1a19', '제조일로부터 24개월', '20110331', '1일 1회, 1회 1포(15ml)씩 섭취하십시오.',
             '[홍삼제품]①면역력 증진②피로개선③혈소판 응집 억제를 통한 혈액흐름④기억력 개선⑤항산화에 도움을 줄 수 있음', '① 알러지 등 특이체질의 경우 과민반응이 우려될 수 있으니 성분을 확인하신 후 섭취하십시오. ② 임산부와 수유부는 섭취를 피하는 것이 좋습니다. ③ 의약품(당뇨치료제, 혈액항응고제) 복용 시 분은 의사와 상의하시기 바랍니다. ④ 천연물 성분에 의한 침전물이 생기는 경우가 있으나 안심하고 잘 흔들어 섭취하십시오. ⑤ 제품의 개봉 또는 섭취 시 포장재에 의해 다칠 우려가 있으니 주의하십시오. ⑥ 제품 개봉 후 변질될 수 있으므로 바로 섭취하십시오.', '습기와 직사광선을 피하여 실온에 보관.', '① 성상 : 갈색의 액상 ② 진세노사이드 Rg1과 Rb1 및 Rg3의 합 : 표시량(5.5mg/15mL)의 80% 이상 ③ 세균수 : 1ml당 100 이하 ④ 대장균군 : 음성', '홍삼농축액(농축물),시클로덱스트린시럽,액상프락토올리고당(고형분기준 55%),정제수,아미노산혼합(아미노믹스),L-페닐알라닌,L-로이신,벌꿀,요구르트향(천연),칡농축액(농축물),천궁농축액(농축물),녹용농축액(농축물),비타민 A 혼합제제,비타민 B6 염산염,비타민 B2,비타민 D3 혼합제제,효소처리스테비아,블루베리농축액(농축물),니코틴산아미드,판토텐산칼슘,비타민 B1염산염,엽산,비오틴,비타민 B12,당귀농축액(농축물),블루베리농축액(농축물)분말,덱스트린,L-메티오닌,L-라이신,팔라티노스,L-히스티딘,L-발린,L-이소로이신,L-트레오닌,L-트립토판,가시오갈피(줄기)농축액(농축물),비타믹스,비타민 C,팔라티노스,비타민 E 혼합제제', '천지인 키즐홍짱 홍삼액'
         );
INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '087a9785-4ca6-4cc1-b75f-0887ff416791', 5, 2, 'Silver plus propolis', 18000, 50, 'APPROVED', 'https://lh3.googleusercontent.com/proxy/r_tjMA6vxTqoLfFoQguGf2TN6Om2sbDLjutHtjeAI7vyh3bmM0h8qeM2Yk_cUZ60zaABmrq-Y0voS3Z2pvIV3hkzVnsWRuJWP3mlJ5rjYdOrqRWc7ObFYojgkTPQ9Yv4stFecjmfvtge2FaOnn1pxKNOoH5YQ_ZlBXKAMYwolNiqd2SSMbcVUWX_dthoxvgN2Uxo9tL121CQRKESteMLqAuai6sBUnYwPNUbgIeZKD3ezJJ-IjWEspVJXH07VLCF'
         );

INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             2004001902921, '087a9785-4ca6-4cc1-b75f-0887ff416791', '제조일로부터 24개월', '20110404',
             '1일 2회, 1회 1캡슐을 물 100mL이상과 함께 음용',
             '항산화 작용에 도움을 줄 수 있음',
             '프로폴리스에 알레르기를 나타내는 사람은 섭취에 주의',
             '직사광선을 피하여 실온 보관, 유통',
             '① 성상: 암갈색의 농축 액상을 내용물로 함유한 경질캡슐 ② 총 플라보노이드: 표시량(40.2mg/670mg)의 80~120% ③ 파라(ρ)-쿠마르산: 확인 ④ 계피산: 확인 ⑤ 납(mg/Kg): 5.0이하 ⑥ 디에틸렌글리콜: 불검출 ⑦ 테트라싸이클린(mg/Kg): 불검출 ⑧ 클로르테트라싸이클린(mg/Kg): 불검출 ⑨ 대장균군: 음성 ⑩ 붕해시험: 적합',
             '프로폴리스추출물,젤라틴,정제수',
             'Silver plus propolis'
         );


-- PRODUCT 테이블에 데이터 삽입
INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, 2, '종근당건강멀티비타민포우먼', 20000, 50, 'APPROVED', 'https://sitem.ssgcdn.com/06/82/95/item/1000552958206_i1_750.jpg'
         );

-- PRODUCT_DETAIL 테이블에 데이터 삽입
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             2004001706253, '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', '24개월', '20110131', '1일 1회, 1회 1정씩 씹어서 섭취하십시오.', '[비타민A]①어두운 곳에서 시각 적응을 위해 필요②피부와 점막을 형성하고 기능을 유지하는데 필요③상피세포의 성장과 발달에 필요 [비타민E]①유해산소로부터 세포를 보호하는데 필요 [비타민B1]①탄수화물과 에너지 대사에 필요 [비타민B2]①체내 에너지 생성에 필요 [나이아신]①체내 에너지 생성에 필요 [비타민B6]①단백질 및 아미노산 이용에 필요②혈액의 호모시스테인 수준을 정상으로 유지하는데 필요 [엽산]①세포와 혈액생성에 필요②태아 신경관의 정상 발달에 필요③혈액의 호모시스테인 수준을 정상으로 유지하는데 필요 [비타민C]①결합조직 형성과 기능유지에 필요②철의 흡수에 필요③유해산소로부터 세포를 보호하는데 필요',
             '1) 알레르기 체질이신분은 성분을 확인 후 섭취하여 주십시오. 2) 섭취량 및 섭취방법을 확인하시고 섭취하여 주십시오. 3) 유통기한이 경과된 제품은 섭취하지 않도록 주의 바랍니다. 4) 개봉 후 공기가 들어가지 않도록 뚜껑을 꼭 닫아 보관하십시오.', '고온, 직사광선, 습기를 피해 서늘하고 통풍이 잘 되는 곳에 보관하십시오.', '① 성상 : 노란색의 원형정제로 이미,이취가 없어야 한다. ② 비타민A : 표시량(350μgRE/1,200mg)의 80~150% ③ 비타민E : 표시량(6㎎α-TE/1,200mg)의 80~150% ④ 비타민B1 : 표시량(0.7mg/1,200mg)의 80~180% ⑤ 비타민B2 : 표시량(0.96mg/1,200mg)의 80~180% ⑥ 나이아신 : 표시량(9.75mgNE/1,200mg)의 80~150% ⑦ 비타민B6 : 표시량(1.28mg/1,200mg)의 80~150% ⑧ 엽산 : 표시량(212.5μg/1,200mg)의 80~150% ⑨ 비타민C : 표시량(80mg/1,200mg)의 80~150% ⑩ 대장균군 : 음성', '분말비타민 A,비타민 E 혼합제제,비타민 B1염산염,비타민 B2,나이아신,비타민 B6 염산염,엽산,비타민 C,석류농축액농축액(농축물)분말,덱스트린,석류농축액농축액(농축물),아스파탐(페닐알라닌 함유),콜라겐,글리세린,프로필렌글리콜,치자황색소,치커리(뿌리)추출물(추출액)분말(분말 추출물),치자황색소,정제수,결정(분말)포도당,유당혼합,덱스트린,유당,D-소르비톨,석류향분말(가루, 과립),정제수,물엿,변성전분,석류향,그레나딘향유지(Oil),스테아린산마그네슘,석류향,정제수,프로필렌글리콜,글리세린,식용주정,벤즈알데히드,에틸 말톨,캐롯유지(Oil),러비지유지(Oil),위스키향,딸기향,체리향,복숭아향', '종근당건강멀티비타민포우먼'
         );

INSERT INTO PRODUCT (product_id, name, status, stock_count, price, category_id, vendor_id, product_image)
VALUES ('590b598b-3577-4f43-8e36-6ed31866b8c9', '미라클', 'APPROVED', 100, 10000, 1, 2, 'data:image/jpeg;base64,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');

-- PRODUCT_DETAIL 테이블 삽입문
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take,
    main_function, precautions, storage_method, standard,
    ingredients, product_name
) VALUES (
             20040020028166, '590b598b-3577-4f43-8e36-6ed31866b8c9', '24개월', '20110201', '1일 2회, 1회당 1포(5g)씩 물과 함께 섭취하십시오.',
             '[가르시니아캄보지아추출물]①탄수화물이 지방으로 합성되는 것을 억제하여 체지방 감소에 도움을 줌', '-알레르기등 특이체질의 경우에는 성분을 확인하신 후 섭취 -제품의 개봉 또는 섭취시 포장재에 의해 상처를 입을수 있으니 주의', '직사광선을 피하여 서늘한 곳에 보관하십시오.', '성상:갈색의 환제 총 Hydroxycitric acid : 450mg/5g 의 80~120% 납(mg/kg) : 1.0 이하 카드뮴(mg/kg) : 0.5 이하 총수은(mg/kg) : 0.4 이하 총비소(mg/kg) : 1.0 이하 대장균군:음성 붕해도:120분 이내',
             '가르시니아캄보지아 추출물분말(가루, 과립),차전자피분말(가루, 과립),치커리(잎(엽),뿌리)분말(가루, 과립),창출(뿌리),알로에 전잎분말(가루, 과립),퉁퉁마디(잎(엽)),완두,결명자,내복자,율무(알곡),진피,후추,산화마그네슘', '미라클'
         );

INSERT INTO PRODUCT (
    product_id,
    category_id,
    vendor_id,
    name,
    price,
    stock_count,
    status,
    product_image
) VALUES (
             'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367',
             5,
             2,
             '천백정',
             32000,
             10,
             'APPROVED',
             'https://www.ilyosisa.co.kr/data/photos/201511/89322_35004_4113.jpg'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no,
    product_id,
    expiry_date,
    approval_date,
    how_to_take,
    main_function,
    precautions,
    storage_method,
    standard,
    ingredients,
    product_name
) VALUES (
             2004002003742,
             'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367',
             '제조일로부터 2년',
             '20110323',
             '1일 1회 약 8g을 50~100ml의 온수나 냉수에 잘 용해해서 섭취한다.',
             '[홍삼제품]①면역력 증진②피로회복③혈소판 응집 억제를 통한 혈액흐름에 도움④기억력 개선에 도움을 줄 수 있음⑤항산화에 도움을 줄 수 있음',
             '1) 제품개봉시 또는 보관시 유리파손에 의해 상처를 입을수 있으니 주의를 요망한다. 2) 알레르기 등 특이체질의 경우에는 원료 성분을 확인 하신 후 섭취하시오. 3) 의약품(당뇨치료제,혈액응고제제)복용시 섭취에 주의 하십시오.',
             '제조일로부터 2년',
             '1) 성상 : 갈색의 유동성 액체 2) 진세노사이드 Rg1, Rb1 및 Rg3의 합 : 표시량(5.28mg/8g)의 80%이상 3) 대장균군 : 음성 4) 세균수 : 3,000/ml 이하',
             '홍삼, 6년근,갈색설탕,화살나무(어린 잎),한련(새순(어린순, 새싹)),토사자(씨),측백나무(잎(엽)),병풀,반디나물(어린 잎),천마(뿌리),찔레나무(새순(어린순, 새싹)),산돌배나무(열매),약쑥,약모밀,애기우산나물,섬쑥부쟁이,생강나무(어린 잎),쇠무릅,수영(잎(엽)),머루,망초(새순(어린순, 새싹)),마가목,두릅(새순(어린순, 새싹)),돼지감자,독활,도라지,각시둥굴레(어린 잎),두충나무(수피),더덕,당귀,닭의장풀(새순(어린순, 새싹)),달맞이꽃(씨),단삼,다래,천궁(뿌리),취,퉁퉁마디(잎(엽)),참나무(열매),사상자(열매),사철쑥,복령,잣,인동(잎(엽)),오갈피나무(잎(엽)),으아리,엉겅퀴(새순(어린순, 새싹)),수리취,쇠비름(새순(어린순, 새싹)),쇠뜨기,솔잎,삽주(뿌리),마,산조인,산딸기,산사나무(열매),엄나무(어린 잎),얼룩조릿대,잔대,참느릅나무(나무껍질),운지버섯(자실체),익모초,오리나무(잎(엽)),오디,우산나물,영지버섯,식물혼합농축액(발효)발효 농축액,황기(뿌리),헛개나무(열매),하수오(덩이뿌리),칡(꽃),번행초(잎(엽)),배초향,민박쥐나물(새순(어린순, 새싹)),신선초,맥문동,질경이(어린 잎),짚신나물(어린 잎),진득찰(새순(어린순, 새싹)),진달래(꽃),지치,작약(뿌리),줄풀(어린 잎),제비꽃(새순(어린순, 새싹)),뽕나무(잎(엽)),병꽃풀(새순(어린순, 새싹)),별꽃(새순(어린순, 새싹)),복분자딸기(열매),방아풀,민들레(어린 잎),모시풀,며느리배꼽(새순(어린순, 새싹)),다닥냉이,노박덩굴(어린 잎),나무딸기(열매),꿀풀(새순(어린순, 새싹)),갈퀴덩굴(새순(어린순, 새싹)),국화,구기자나무(잎(엽)),곰취,고욤나무(열매),고비,고로쇠나무수액,개암나무(열매),구절초,감나무(잎(엽)),가죽나무(어린 잎),산양삼(장뇌삼)',
             '천백정'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, 2, '유한m 오메가-3 비거파워', 18000, 10, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take,
    main_function, precautions, storage_method, standard, ingredients, product_name
) VALUES (
             20070017035215, 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', '제조일로부터 24개월', '20110405',
             '1일 2회 1회 1캡슐을 물과 함께 섭취',
             '[EPA 및 DHA 함유 유지]①혈중 중성지질 개선·혈행 개선에 도움을 줄 수 있음',
             '1) 특이체질, 알러지 체질인 경우에는 의사와 상담 후 섭취 여부를 결정하십시오.',
             '',
             '1) 성상: 투명 노란색의 내용물을 함유한 투명 연질캡슐 2) 대장균군: 음성 3) 붕해도: 20분 이내 4) EPA + DHA: 500mg/2,000mg의 80~120% 5) 납(mg/kg): 3.0이하 6) 카드뮴(mg/kg): 1.0이하 7) 총수은(mg/kg): 0.5이하',
             '정제어유,하프물범(단, 하프물범신제외),에틸바닐린,D-소르비톨액,글리세린,젤라틴,대두유,마늘유지(Oil),D-알파-토코페롤 혼합제제,D-α-토코페롤,대두유',
             '유한m 오메가-3 비거파워'
         );

INSERT INTO PRODUCT (
    product_id, name, category_id, vendor_id, price, stock_count, status, product_image
) VALUES (
             '2cc10b17-802e-466f-a89e-8ef0e39b62e6', '큐자임', 1, 3, 40000, 0, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             20040016037148, '2cc10b17-802e-466f-a89e-8ef0e39b62e6', '2년', '20110321',
             '1일 1회, 1회 2캡슐(1000mg)의 제품을 충분한 물과 함께 섭취하십시오.',
             '①항산화에 도움을 줄 수 있음 ②혈압이 높은 사람에게 도움을 줄 수 있음',
             '특이체질, 알레르기 체질의 경우는 성분을 확인하시고 섭취하여 주시기 바랍니다.',
             '',
             '1. 성상 : 갈색의 내용물을 함유한 투명한 경질캡슐제품으로 이미, 이취가 없음 2. 코엔자임Q10함량 : 표시량(90mg/1,000mg)의 80~120% 3. 납(mg/kg) : 1.0 이하 4. 총 비소(mg/kg) : 1.0 이하 5. 카드뮴(mg/kg) : 1.0 이하 6. 총수은(mg/kg) : 1.0 이하 7. 대장균군 : 음성 8. 헥산(mg/kg) : 5.0 이하 9. 초산에틸(mg/kg) : 50.0 이하 10. 붕해도 : 적합',
             '코엔자임Q10 추출물,자당지방산에스테르,카라기난,정제수,히드록시프로필메틸셀룰로오스,펙틴,염화마그네슘,피로인산칼륨,빙초산,미강추출분말,미강추출분말,구연산,쌀겨,덱스트린,진피추출분말,덱스트린,진피추출농축액분말,포도껍질추출물분말,소나무껍질추출물분말,스테아린산마그네슘,녹차추출물분말,이산화규소,포도씨추출물분말,토마토추출물,d-α-토코페롤,L-아스코르빈산나트륨,정제수,설탕,덱스트린,젤라틴(돼지),토마토추출물,비타민 E,비타민 E(DL-알파-토코페릴초산염),변성전분(옥테닐호박산나트륨전분),말토덱스트린,이산화규소',
             '큐자임'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '53ec9f01-4fcb-4d3b-a8b3-dce02f24334d', 4, 3, '메가프리미엄골드', 26000, 0, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             20040015083497,
             '53ec9f01-4fcb-4d3b-a8b3-dce02f24334d',
             '제조일로부터 24개월',
             '20110421',
             '1일 2회, 1회 2캡슐을 충분한 물과 함께 섭취.',
             '[감마리놀렌산함유유지 제품]①콜레스테롤 개선②혈행개선 [셀레늄(또는 셀렌)]①유해산소로부터 세포를 보호하는데 필요',
             '알레르기 체질이신 경우 성분을 확인 한 후 섭취하시기 바랍니다.',
             '고온다습한 곳이나 직사광선을 피하여 서늘한 곳에 보관',
             '(1)성상: 황색의 내용물을 함유한 갈색의 연질캡슐제품으로 이미, 이취가 없다. (2)감마리놀렌산: 표시량(286mg/2000mg)의80~120% (3)셀레늄: 표시량(20ug/2000mg)의 80~150% (4)대장균군: 음성 (5)붕해시험: 적합',
             '보라지 종자유지(Oil),건조효모분말(가루, 과립)(식용건조효모),젤라틴,글리세린,D-소르비톨액,식용색소황색제5호,이산화티타늄,식용색소적색제40호,에틸바닐린,식용색소청색제1호,포도씨유 ,홍화유,대두레시틴(대두레시틴 97.6%, 올레인산 2.4%),밀납,팜유(정제팜유),석류농축액(농축물)분말(석류농축액(고형분 30%) 85%, 덱스트린 15%),대두(배아, 호분층)추출물(추출액)분말(분말 추출물),사상자추출물(추출액)분말(분말 추출물)(사상자추출고형분 30%, 덱스트린 70%),구기자추출물(추출액)분말(분말 추출물)(구기자추출고형분 30%, 덱스트린 70%),녹차추출물(추출액)분말(분말 추출물),비타민 C(L-Ascorbic acid),D-알파-토코페롤 혼합제제(D-알파-토코페롤 72%, 대두유 28%),비타민 B1염산염,비타민 B2(Riboflavin),비타민 B6 염산염',
             '메가프리미엄골드'
         );
-- PRODUCT 테이블 INSERT
INSERT INTO PRODUCT (
    product_id,
    category_id,
    vendor_id,
    name,
    price,
    stock_count,
    status,
    product_image
) VALUES (
             '3e3f2a8d-4b17-4995-9672-7a4378fd7cd4',
             4,
             3,
             '홍삼농축액',
             30000,
             10,
             'APPROVED',
             'data:image/jpeg;base64,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'
         );

-- PRODUCT_DETAIL 테이블 INSERT
INSERT INTO PRODUCT_DETAIL (
    cert_no,
    product_id,
    expiry_date,
    approval_date,
    how_to_take,
    main_function,
    precautions,
    storage_method,
    standard,
    ingredients,
    product_name
) VALUES (
             201000200701,
             '3e3f2a8d-4b17-4995-9672-7a4378fd7cd4',
             '제조일로부터 2년',
             '20110208',
             '1) 최종제품 : 1일 1회, 1회 1g을 그대로 섭취하거나 냉온수에 타서 섭취 2) 원료성 제품 : 해당 없음',
             '[홍삼제품]①면역력 증진②피로회복③혈소판 응집 억제를 통한 혈액흐름에 도움④기억력 개선에 도움을 줄 수 있음⑤항산화에 도움을 줄 수 있음',
             '특정 또는 특이체질 등 알러지체질의 경우 성분을 확인한 후 섭취한다. 의약품(당뇨치료제, 혈액항응고제) 복용 시 섭취에 주의하시기 바랍니다.',
             '직사광선을 피한 서늘한 곳에 보관',
             '1. 성상 : 점조성을 가진 암갈색의 액상 2. 진세노사이드 Rg1+ Rb1+Rg3의 합 : 표시량(6mg/g)의 80% 이상이어야 한다. (가) 원료성 제품 : 표시량(6㎎/g) 이상 (나) 최종제품 : 표시량(6㎎/g)의 80% 이상 3. 세균수 : 1㎖당 3,000 이하 4. 대장균군 : 음성',
             '홍삼농축액(농축물)',
             '홍삼농축액'
         );

INSERT INTO PRODUCT (
    product_id, name, category_id, vendor_id, price, stock_count, status, product_image
) VALUES (
             '49cfce26-8e6b-4293-8e2d-3cf23d113243', '면역력을 증진시키는 엔케이캡슐', 4, 3, 11000, 0, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             20040015083484,
             '49cfce26-8e6b-4293-8e2d-3cf23d113243',
             '제조일로부터 24개월',
             '20110209',
             '1일 1회, 1회 2캡슐을 충분한 물과 함께 섭취.',
             '[홍삼제품]①면역력 증진에 도움을 줄 수 있음②피로개선에 도움을 줄 수 있음③혈소판 응집 억제를 통한 혈액흐름에 도움을 줄 수 있음④기억력 개선에 도움을 줄 수 있음⑤항산화에 도움을 줄 수 있음',
             '1)특정 또는 특이체질 등 알러지 체질의 경우 성분을 확인한 후 섭취 2)의약품(당뇨치료제, 혈액항응고제) 복용시 섭취에 주의',
             '고온다습한 곳이나 직사광선을 피하여 서늘한 곳에 보관',
             '① 성상: 연한 갈색의 내용물을 함유한 투명경질캡슐 제품으로 이미, 이취가 없다. ② 진세노사이드 Rg1과 Rb1 및 Rg3의 합: 표시량(3.8mg/640mg)의 80% 이상 ③ 대장균군 : 음성 ④ 붕해시험 :적합',
             '홍삼농축액(농축물)분말,젤라틴,빙초산,자당지방산에스테르,정제수,결정셀룰로오스,아로니아농축액(농축물)분말(아로니아농축고형분{아로니아농축액(65brix) 99%,갈락토올리고당 1%} 30%,덱스트린70%),식물혼합농축액(농축물)분말(식물혼합추출분말{소나무잎 7.2%, 엄나무 7.2%, 감잎 6.64%, 인진쑥 4.8%, 작약 4.8%, 당귀 4.8%, 황기 4.8%, 산약 4.8%, 천궁 4.8%, 진피 4.8%, 치자 3.6%, 지황 3.6%, 꿀풀 3.6%, 형 ,황기농축액(농축물)분말(황기농축액 90%, 덱스트린 10%),스테아린산마그네슘',
             '면역력을 증진시키는 엔케이캡슐'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '0a213d25-9404-43b1-b4a4-8702c51b3e94', 1, 3, '닥터맘튼튼메론맛', 11000, 16, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '200400200021335', '0a213d25-9404-43b1-b4a4-8702c51b3e94', '제조일로부터 2년.', '20130624', '1일 1회, 1회 2스푼(25g)을 물 또는 우유 25ml에 충분히 녹인 후 섭취하십시오. 또는 녹인 내용물을 냉동실에 넣고 약 3시간이 지나면 아이스크림이 되어 더욱 맛있습니다. 1일 1회, 1회 1포(25g)를 물 또는 우유 25ml에 충분히 녹인 후 섭취하십시오. 또는 녹인 내용물을 냉동실에 넣고 약 3시간이 지나면 아이스크림이 되어 더욱 맛있습니다.', '[아연]①정상적인 면역기능에 필요②정상적인 세포분열에 필요',
             '섭취 시 위장장애, 소화불량의 증상이 있을 경우 섭취를 중단하십시오. 개인의 신체 상태에 따라 이상 증상이 생길 경우 섭취를 중단하십시오. 섭취 전 제품에 이상이 있는 경우 섭취를 금하십시오. 특정 원료 성분에 알레르기 체질은 원료 성분을 확인 후 섭취하십시오.', '수분 및 열에 의해 영향을 받을 수 있으므로 직사광선을 피해 서늘한 곳에 보관하십시오. 어린이 손에 닿지 않는 곳에 보관하십시오.', '백색의 분말.', '1) 성상 : 고유의 색택과 향미를 가지고 이미, 이취가 없어야 한다. 2) 아연 : 표시량(3.6mg/25g)의 80~150% 3) 대장균군 : 음성', '구아바 추출물(추출액)분말(분말 추출물)(잎(아연 4% 이상)),덱스트린,당류 혼합분말...(가루, 과립)(포도당시럽 40%, 팜유 20%, 유화제 18%, 코코넛오일 17%, 유당 0.3%...)'
         );


INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '8fbe80f4-d999-4903-a3ef-2371e449e77c', 1, 4, '프림로즈', 17000, 14, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '2004001703173', '8fbe80f4-d999-4903-a3ef-2371e449e77c', '24개월', '20110210',
             '1일 2회, 1회 2캡슐씩 물과 함께 드십시오.',
             '[감마리놀렌산함유유지 제품]①혈중 콜레스테롤 개선·혈행개선에 도움을 줄 수 있음 ② 월경전 변화에 의한 불편한 상태 개선에 도움을 줄 수 있음 ③ 면역과민반응에 의한 피부상태 개선에 도움을 줄 수 있음',
             '임신, 수유 또는 질병으로 치료중이시거나 알레르기, 특이체질이신 분은 본 제품의 원료를 확인하시고 섭취 전에 전문가와 상담하시기 바랍니다. 영·유아·어린이는 섭취 전 의사와 상담한 후 섭취할 것',
             '',
             '1. 성상 : 이미, 이취가 없고 고유의 향미가 있는 갈색의 내용물을 함유한 초코렛색의 연질캡슐2. 감마리놀렌산 : 표시량(120mg/1000mg)의 80~120% 3. 붕해시험 : 20분이내 4. 대장균군: 음성',
             '달맞이꽃종자유,보라지종자유,젤라틴,글리세린,D-소르비톨액,카카오색소,식물혼합추출물분말,식물혼합추출농축액,당귀,작약,감초,천궁,계피,덱스트린,대두배아추출물분말,밀납,대두(발아)발효 추출물 분말,대두(발아)발효 추출물(추출액),덱스트린,세이지추출물분말,세이지추출물,덱스트린,석류농축액(농축물)분말,석류농축액(농축물),덱스트린,대두레시틴,D-α-토코페롤,d-α-토코페롤,해바라기유',
             '프림로즈'
         );
INSERT INTO PRODUCT (product_id, category_id, vendor_id, name, price, stock_count, status, product_image) VALUES
    ('f296d746-f8de-406b-91d4-84be19b8bcbd', 1, 4, '엽산600㎍', 15000, 15, 'APPROVED', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAPDg8ODxEQEA0NDQ8PDw8QDg8PDQ0PFREWFhURFhUYHSggGBolGxUVITEhJSkrLi46Fx8zODUtNygtOisBCgoKDg0OFxAQGi0lHR0tLys3LSstKy8tLS0vLS0tLy0tLS0tLS0tLi0tLS0tLSstLS0rLTIuLS0tLSs3Ky4vLf/AABEIAOAA4AMBEQACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAAAQMCBAUGB//EAEgQAAEDAgIFBwcJBQcFAAAAAAEAAgMEERIhBRMxQVEGByJhcZGxMlJygZKhwRQjQkRigrLC0UNzg+HwJTSUorPD0xUkM4Sj/8QAGgEBAQEBAQEBAAAAAAAAAAAAAAECAwUEBv/EADsRAQABAwEGAwQJAgYDAQAAAAABAgMRBAUSITFBUZGh0WFxgfATFSJCU5KxweE0UiQyM0Ni8SOi0hT/2gAMAwEAAhEDEQA/APuKAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgglBGIIGIIJxBAxBAxBAugYggXCBdAuglAQEBAQEBAQEBAQEBAQEBBXM4i1resX+KCpsp32PZl+qKnXdXvQNcOBQTrhwKBrR1oGsHX7kE6wIMS5vD3II6HDZ1IuZTdnd1FE4hcz+roHQ/q6CAGcfeUMq5osXkyvj9DVm/tNKkxnq3TVEc4ifH1UmmlBOGqdY7nxxOt2HJTdnus10z92PNtQ3DQHPxu3uOFpPqGS1DEzEzwhZiHH3ohf7XggZ8UDPj7kDpcfd/NAu7iO5Dg063SIiy8uQ7GA2t1uP0QoYY6Iq5JXPxluQaQGtsG7cs8z/WxCXTVQQEFVRsHag11WkICCVEAqCCVBBQQqCghAQSggoIKKgoIQLIFkBBVUVMceHWPYzWODGY3tbjf5rb7T1KTiObVNFVWd2JnHZENWx5IY7GGhpLm3MfSFwA4ZE2sbDc4HeEjBVRVTz/nwcqQdN/7x/ijLq6BGcnY34qpLsIggIPLc4ekJqeljkgkMTzUtaXNax12lj8rOBG0DuWapxD09lWbd69NNynMY9vs7PBt5ZaQH7e/bDAfyrG9Pd707K0k/c859WY5caQH7SI9sDPhZXelj6o0vafFkOXukONOe2nPwem9KTsbS/wDLx/hmOcCu4Up/gSf8ib0p9SaXvV4x/wDKxvOHWb4qU/cmH+4m9LM7D0/91XjHosbzi1O+CnPYZR8Sm9LM7Cs/31eSwc482+lhPZPIPylXfZnYNv8AEnwj1ZDnIk30jPVVO/4032Z2DT+LP5f5Wt5yONIfVUg/7ab/ALGJ2DPS5/6/ysHOPHvpZPVMw/AJvsTsKv8AEjwlkOceDfTVHqfCfim+n1Fd/vp8/Rm3nGpt8FUPVAfzpvs/Ud7pXT5+ixvOHR746ofw4T4SJvwzOxNR3p8Z9Fg5f0O8VA7YQfByu/DM7G1Ps8Vg5eaP8+YdtNL8Am/DE7H1faPzQyHLnRx/bPHbTVHwam/CTsjV/wBsfmp9WbeWmjj9Zt2wVI8WJvQzOy9XH3POn1Wjlbo8/Woh2iRvi1Xehmdm6qP9ufJmOU+jz9cp/XKB4pvQz9X6r8OrwWt5QUJ2VdL/AIiIfFN6O7E6PUxzt1eEqayaknLHCsjY+MSND4amnDiyQAPZ0rixwtzFiLZEKTierVFN63nNuZz3ienLt6LdFwU1Ox0cEkYjdIZA3XxuDLtaMLc/JAaLDckYjk53qrtyreric+6XI0ppiGBz7uD3l7yI4yHOPSO07Gjt96TMQluxXXyjh3lu8htISVD6lz7BobEGMb5LQS/fvOzPwUpnLeotU24piHrlt8ogIPI854/7BvVUxeDh8Vmrk9fYs/4n4S+Vlc36piQgxsgWRWUURccItexJJIa0NAuSScgEZqqimMyMiLnBjRic52FoaQcRJsLHYhVVFMb08IQ9hBscjkdoIsQCCCMiCCDcIsTExmGNkAbCRsaLk7gL2zO7NCeE4S9pBIIIIJBBFiCNoI3IkTExmGNlFEBBCAqIsghBCAghBi5o4BDKoxN81vcFF3p7uvoWIGNouGgGQknINGtdc+9WIeBq6sXKp58X0rm8jwmptexEJaSLEjp5271ul5GrnMUvZrb4xAQeU5yx/Z56p4T/AJrfFZq5PV2N/VR7pfKSub9YxKCEBBlHU6u4BAxlpdmWlzGkksuD5JuL+iEYrppnE1dP1nrx6x0bIrJJHF8cTSWxuA1FNjDA8WL3YWnFcB1sXE22K4lwqotWo3LleM8ftVYzjpzjHwWQ6Si8qWOEkBpZcdOdwbYNc45G5OIk7ha2y0wlWnucIt1Tx8Ij2R5REe/LD5bAAAaaPYB/5HZkNA35k7TmSMxlkhNuvOPpePwz8/OWUekGgTFzC6aV+NruhhYWlurNrbR091sxlwhVp6pmiKasU0xjrx7sZZqYiwgkabEY9e5zibgA2Jte1zvubbrg1Yt6iPvx7sfP/TUnLS9xY0tjLjgaSXFrdwJ3lR9FEVRTG9OZV2Rosgg8VRbUU7o3FrwA4GxAIPD9R3rMTEuVu9Rczu9FJWnQRUEIIsgghBiQgghB1tCA4G2biPzlt+E609L+uKPA1eN+rM44vpPN8P7zc4j81c7r9PILdLydV917BbfGICDy/OQP7Nk6pYP9RqzVyepsf+qp90/o+TOXN+tYlBCAg9LSaQfQ6KhqqYsjnqq2aOoqHMa8tbGX6uLpbAQ0H1utYm63yjg8O5Zp1WurtXZnFMcI8P8At67Q+j421bKmOkkhfWaO1ssrXuFNHI8xl0OrtYOJAdfqPFa6vGu3q6rX0c15imeEdffnt8Xl+bLRomZVueGmN1NFTNc4AjWvaSQL7wMB+8Fmnq9TbV2Im1THOOP6I5I0s0ujdK0rWl0+GJuqxAfPDE17cyADdlvUkcpXaF23GqsXumInPsy5OhNCOqK5tHKHRlhkdUNBGsYyPymgi4uSWtyP0r7lIji9DV66Lem+mt8d7hHr5L6HQr6nSMFPNTmjinxuEbWBhFPGHOI1guZH+S1ziSelfLJXGZ4vknV0WdLVXbub1fCOMzwmfZPTnhVDHFWU1bLDBHDLRsbUwCEOaJqVznAxSAk4nhrQce254Kc4lZuXNJXamuuaqa44544n2eLfl0RTR10Wi3sJe+NkctYJJRMyrfGXtcxmLBqx0RhLTfFtyzuIzhyjUamqzVqor5T/AJemPmXmpYnMe+N9scUj4322Y2OLXW6rgrE8Je3auRcoprjrGW9orUA4ptp8gEAjLtyG/M8AuNVymJxKXYuTH2WekItZPhYHOllDWxMGB2MkZDZ677rFcZmd/wCzzYiYot71U4iG7Qck55YTIw08xdIGN1NRjbGWlwku4NsSDhyF+Oe/6Z3scObz7u06cxFMzGOeY+f2cGqppInmOVhje3a1w94O8dYWnqW7lNymKqZzCpV0QggoMSghB1tDkCNt77H5A2v84cj1JDwNVEzcqx3fSeb1121By8qIWAsAAHWC3Q8nVxiaYevW3xiAg83zhi+jJ+p8B/8AsxSrk9LZM41VPx/SXyMrk/XsSggogivTcg3SvmmpmSNax8Bn1ckLJoHvjc1uJzSQQek3MH6Od7C26Xh7ZopiKLkx7Pb6OjycpNIvrzUyzQF8kEge8yx1MP0LMbFHI0gC2R3Z3uTdWM5fFqruk+gi3apnMT1jE+PHwecp/lUmjY3xuijpdGSR3bG58c5qHFuGocMJD3dMZ3ttyU6PQppsUajcuUzVVdjhM4xienf54OnDppk9JpczfJ4qippKduFrww1krRKHSBhPlHoght93FInOXzXNHVZ1FmImaqYntyjPJy+S9ZHT1JMjtVHNS1FMZBsgMuEtkNtgDmC53XvuUpl6O07FVyzG5Gd2c4djk9piLR8FFFI+KR7K+WWQQSMnZS0z4XRk4oyRm8h+EZ2vldWPsxEPM1Onr1d25ct0zEYjnGMz2c+ijGj6XSA1kT31EDaOhDJo5dezE69R0SbMDSw3Ns7jba7lEu1yf/3V2aKYn7P+bhPCe3k6srRUaVh0m0gUDhDVTTucAymdFFhfC/g8OYwW34sthVxxy4Rc+i0lelq/1M4iO+ccXn6fV1NTUTS4gyWaSYMblKBJNiHVk11u0hc6p4vV/wDJp7FuinnEdeSqSjaxkj3Oya2rwtDX4S6KKR9icPRILGZE55rhXaiqZku6yujGI7eePbycqOZggnkjmvO4QRTBhOGNkpluwOAs4ODIwbXF7t355pt7tOer5buo+lubvTOePXHzwZ0E0lPBVU7XPjlrY6cMjY5zXgRzB7mvDfJc9pDQDc52NsQvunMRMdZfNcimuqmqeMRnj6d4ifgr0YXah0e2KBzZGXyMZk6Lmgbg4tuRxb23tuej7tNO5ej/AJZj34jMT891q6PUEGKogqCEHV0UPm2fe/EUeFqP9Sr3vpXN4Pm5/TZ+ErpQ8jWTxh65bfGICDz3L4X0ZU9WqPdKxSrk+/Zc/wCLo+ekvkBXJ+xYlBCAg3tC6Vko5tfE1jnGJ8RbIHFha4tJ2EZ9Ae9WJw+XV6SnU0RRM4xOW/ozlGylkE0Oj6RkoaWBzHzR9E7RbMbkiYjo+O7sy5cp3a79Ux7Yz+7V0RphsFNPSSU7aiGqdG54+UyU7mlgbYAtaTtaDtCsVOmo0FVy5RcprxNERHLPL4sKmoo3RvEdJLFKWnA//qEkrGPtk4tc3MX3JmOzdFrWxVGbsTHX7McvBpwBhDsZLT0cBDS4DJ17j2R61h9lc1xMbsZWSRRYujJ0C1xBLXAh2xoNxxIJy2A70Yiu7u8aePvBSRC3zzBicQTbIWa83PaQ3PPyt5yRJvXOP2J4DqCDG351huCS/A0uaQ5oA2/aPd2plIvXMZ3OMMHNfCQWvbd4cLxvxdEFps7qvY+rqRuJpuxiaZ4d4a7jclx8pweCbC5D2lru8OI9aNzTTNO7PJnT1Ekbi9skri5pa9jqicskYdrT0rg8HDMGxCr5LugsV0zimInvEfPg50sdMCSRWQjO7BFDV9I72y44yQOtoIudq5fRw+CunUUcJpz7Y4eWGZqNY5rY4tXEzCXyObgnqpGtLWySNDi1pAc4Wad5JzOXSOHJ00Wnu7+/X8I7NlV7CEEFQQgxQdfRJtGw/ZI77j4pLwdROKqp9svpnIF5dHUPdm50wJ3fRXWl4t/lT7nqlp84gIOFy4F9G1X7sHue0qVcn3bN/qrfvfHSFyfsmKBZBCAgiyCUEFAQEEKCECyCEBBBCoIIQFBBQQgxIQdXRg+aj9Fp991Xgamneqqj2vpnN5/d5f31rXuQMDbC+9dKXj6iJiaYns9WtPmEBBTWQMkjeyRrXsc2zmOAc1w4EHajVFdVFUVUziY6w4MnJegP1WEeiHM/CQpuw+yNoaqP9yf1a0nIzR7v2Dh6NRUD8ybkOkbV1cff8qfRS7kLQnY2ZvZUPP4rqbkOkbY1XWY8I/ZS/m/pDskqW/fiPixNyG421qI500+E+qh3N3BuqKj7zYT4AJuN/Xl3rRT5+ql/N2Po1Th6VOD4PCm57W425PW35/w13c3cu6qjPbTvH5ym46xtyjrbn80eip/N9U7pqc9utb+Uqbktxtuz1oq8vVQ/kHXDYaU/xpB4xpuS3G2dN1irwj1Uv5E14/ZxO9Gdnxspuy3G19LPWfBryckdID6s53oy05/Om7PZ0jaekn7/AJVeih/JquG2km9Qa78JKm7LcbQ0s8rkef7wok0LVt20tT/h5T4BMS6Rq9PPK5T4w130Uw2wVA7aaYeLUw3F61PKun80eqp0bm+U1zfSa5viFG4qieUx4qTMzzm+0Eb3KuyQ4HYR3hUxKURFkRBUEKqgojraFhfIIo4xie5gy3Ab3E7gOKPB1NUU1VTPLL6tyUpmwQFgOJ2su92zE7CMwNw4LrEYeHduTcqy7YlVck6xBkHIIk2HsQaqqoRRAQEBAQEEICAgIIREgnie9DCcR4nvQxDBzQdoB7WgqLHDk15NHwO8qGB3pQxnxCbsdnSL1yOVU+MtV/J+iO2jpT/60QPuCm7HZ1jW6mOVyr80qXcltHn6pCPRaW+BTdhqNoar8SVEnI3R7ttPb0Z6hvg9Tch0jamrj7/lHoodyE0edjJR2VMp8SU3Ibja+r7x+WGvJzfUR2Pqm9ksZ/EwpuQ3G2dRHOKZ+E/tKumo4KCLAzIEhpkkcDJJa9gSBwByAA70iMPPvX671W9X/Dq6IrTq7kEFxBItsJaMky5OmyrVMLm1KqNunkuiNghBVqG9ftFBGoHF3u/RBGo+0e5qCNQfOHs/zVDUu4t7iPigx1Tvs+0R8EXKNW/zR6nfyUMowu8w97P1VMlj5ru4HwKGUX6new/9EEF46x2tcPggxMrfOb3gIJEjTsc0/eCDIBBNkEIIRRBCAgIMUHkdLEEtBFyH4mt4uzt3bVmRsaODmtsTck3PaVB04gSqNqOMojfpWqo3EBAQRZAsgWQLIIsgWQLIFkBAQQWA7QD2gIMDTs8xnshBj8mZ5o9WXggfJm8D7b/1QR8mbxd7RPiqINN9p/8AkPwQR8nPnn1tagag+cPY/mggwO4t9kj4oMTA/wCx3u/RFy5beT93l73gu3AA2aOGamDLdi0YxqYMtllKAiLmwhBY1tkGSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICD//2Q==');
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '2004001706256', 'f296d746-f8de-406b-91d4-84be19b8bcbd', '24개월', '20110224',
             '1일 1회, 1회 1포(2g)를 물과 함께 섭취하십시오.',
             '[엽산]①세포와 혈액생성에 필요②태아 신경관의 정상 발달에 필요③혈액의 호모시스테인 수준을 정상으로 유지하는데 필요',
             '1) 본 제품은 섭취자의 신체상태에 따라 반응에 차이가 있을 수 있습니다. 2) 알레르기 체질이신 분은 섭취전에 반드시 원료명을 확인 후 섭취하십시오. 3) 유통기한이 경과된 제품은 섭취하지 마시기 바랍니다. 4) 분말 제품의 특성상 드실 때 목에 걸리지 않도록 주의하시기 바랍니다. 5) 본 제품은 임신부의 영양보급을 목적으로 한 제품으로, 임신부 이외의 일반인이나 어린이들이 섭취하는 경우 영양과잉의 우려가 있습니다.',
             '',
             '① 성상 : 분홍색의 분말로 이미,이취가 없어야 한다. ② 엽산 : 표시량(600㎍/2,000mg)의 80~150% ③ 대장균군 : 음성',
             '엽산,비타민 B2(함량100%),비타민 B1염산염(함량78%),비타민 B6 염산염(함량82%),자주색고구마색소,프로필렌글리콜,정제수,자주색고구마색소,결정(분말)포도당,D-소르비톨,석류 과즙농축액(농축물)분말,덱스트린,석류 과즙농축액(농축물),구연산,DL-사과산,비타민 C(함량100%),석류향분말(가루, 과립),정제수,물엿,변성전분,석류향유지(Oil),그레나딘향유지(Oil),스테아린산마그네슘',
             '엽산600㎍'
         );
INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'd1fd3ad7-90b2-46cf-b0f7-40a90ffac168', 2, 4, '관절애디메틸설폰', 13000, 6, 'APPROVED', 'data:image/jpeg;base64,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'
         );
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             20040020028169, 'd1fd3ad7-90b2-46cf-b0f7-40a90ffac168', '24개월', '20110310',
             '1일 2회, 1회 2캡슐을 물과 함께 섭취하십시오.',
             '[Opti-MSM(2008-12)]관절건강에 도움이 될 수 있습니다. (기타기능II)',
             '[Opti-MSM(2008-12)]①본 제품은 관절건강에 도움을 줄 수 있으나 치료의 목적으로 사용될 수 없습니다.',
             '고온, 다습하거나 직사광선을 피하고 서늘한곳에 보관',
             '성상: 황갈색의 분말이 든 미황색의 경질캡셀 디메틸설폰:표시량(784mg/g)의80~120% 납(mg/kg):1.0이하 비소(mg/kg):1.0이하 카드뮴(mg/kg):1.0이하 총수은(mg/kg):1.0이하 대장균군:음성 붕해도:20분이내',
             'Opti-MSM,빙초산,이산화티타늄,식용색소황색제4호,정제수,자당지방산에스테르,젤라틴,상어(연골, 뼈)추출물(추출액)분말(분말 추출물),해조분말,식물혼합농축액,모과,울금(뿌리(줄기)),쇠무릅(뿌리)(우슬),당귀(뿌리)',
             '관절애디메틸설폰'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '16bd3136-e2b6-429e-80aa-ea1f92d1dd11', 2, 4, '온가족영양소', 31000, 12, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             20060020003446, '16bd3136-e2b6-429e-80aa-ea1f92d1dd11', '제조일로부터 2년', '20110401',
             '1일 2회, 1회 2정을 씹어서 섭취하십시오.',
             '[비타민E]①유해산소로부터 세포를 보호하는데 필요 [철]①체내 산소운반과 혈액생성에 필요②에너지 생성에 필요 [아연]①정상적인 면역기능에 필요②정상적인 세포분열에 필요 [판토텐산]①지방, 탄수화물, 단백질 대사와 에너지 생성에 필요 [망간]①뼈 형성에 필요②에너지 이용에 필요③유해산소로부터 세포를 보호하는데 필요 [비타민A]①어두운 곳에서 시각 적응을 위해 필요②피부와 점막을 형성하고 기능을 유지하는데 필요③상피세포의 성장과 발달에 필요 [비타민D]①칼슘과 인이 흡수되고 이용되는데 필요②뼈의 형성과 유지에 필요 [비타민B2]①체내 에너지 생성에 필요',
             '[철]특히 6세 이하는 과량섭취하지 않도록 주의 특이체질, 알레르기 체질의 경우에는 간혹 개인에 따라 과민반응을 나타낼 수 있으므로 원료를 확인한 후 섭취하십시오.',
             '습기가 적고 직사광선을 받지 않는 실온에 보관하십시오.',
             '1. 성상 : 연한갈색의 원형 츄어블정제 2. 비타민A : 표시량(210ugRE/1,200mg) 80~150% 3. 비타민B2 : 표시량(0.48mg/1,200mg) 80~180% 4. 비타민E : 표시량(2.5mgα-TE/1,200mg) 80~150% 5. 비타민D : 표시량(2.7ug/1,200mg) 80~180% 6. 판토텐산 : 표시량(2.6mg/1,200mg) 80~180% 7. 망 간 : 표시량(1mg/1,200mg) 80~150% 8. 아 연 : 표시량(5.3mg/1,200mg) 80~150% 9. 철 : 표시량(2.96mg/1,200mg) 80~150% 10. 대장균군 : 음성',
             '비타민 A 혼합제제분말(가루, 과립),비타민 D3 혼합제제분말(가루, 과립),비타민 E 혼합제제분말(가루, 과립),비타민 D3,인산철,산화아연,판토텐산칼슘,황산망간,레티닐 아세트산염,비타민 B2,DL-α-토코페릴아세테이트,아라비아검,옥수수 전분,글리세린지방산에스테르,자당,말토덱스트린,이산화규소,비타민 E,비타민 E,말토덱스트린,아라비아검,옥수수 전분,변성전분,사과분말(가루, 과립),바나나분말(가루, 과립),딸기분말(가루, 과립),나무딸기(열매)분말(가루, 과립),쌀(알곡)분말(가루, 과립),해바라기레시틴,이산화규소,파라다이스넛추출물(추출액)분말(분말 추출물),파라다이스넛추출물(추출액)분말(분말 추출물),말토덱스트린,효소처리스테비아,니코틴산아미드,비타민 B6 염산염,비타민 B1질산염,비타민 B12 혼합제제분말(가루, 과립),자일리톨,말티톨시럽분말(가루, 과립),해조분말,비타민 B12,말토덱스트린,구연산삼나트륨,구연산,스테아린산마그네슘,베리혼합농축액(농축물)(블랙베리농축액26.51%, 까막까치밥(블랙커런트)농축액22.02%, 블루베리농축액19.94%, 딸기농축액10.43%, 나무딸기(라즈베리)농축액9.23%, 크랜베리농축액8.34%, 아사이베리 ,과일혼합분말(가루, 과립),베리혼합농축액(농축물)분말,덱스트린,건조효모(건조맥주효모),건조효모',
             '온가족영양소'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'e8ef02d3-e0e1-4013-899b-8ddf987af2a5', 2, 4, '고려홍삼차', 26000, 20, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '2007001702324', 'e8ef02d3-e0e1-4013-899b-8ddf987af2a5', '제조일로부터 3년까지', '20110315',
             '1일3회,1회 1포를 음용수에타서 섭취하십시오.',
             '[홍삼제품]면역력 증진·피로개선·혈소판 응집억제를 통한 혈액흐름·기억력 개선·항산화에 도움을 줄 수 있음',
             '섭취시 불쾌감등의 이상이 있을시 섭취를 중단하여 주시기 바랍니다. 알레르기등 특이체질이신 분은 제품의 성분을 확인후 섭취하십시오. 의약품(당뇨치료제, 혈액항응고제) 복용 시 섭취에 주의하시기 바랍니다.',
             '',
             '1) 성상: 홍삼고유의 향취미를 가진 미황색의 과립제품 2) 진세노사이드 Rg1, Rb1 및 Rg3의 합 : 표시량(3.5mg/5g)의 80%이상 3) 대장균군 : 음성 4) 붕해도: 적합하여야 한다.',
             '홍삼농축액(농축물)(고형분60%이상, 진세노사이드Rg1,Rb1 및 Rg3의합 7mg/g),대추농축액(농축물),결정(분말)포도당',
             '고려홍삼차'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '6e3f3ad5-1c4b-4df4-9f5f-7db41b867c21', 3, 5, '세포 보호에 도움을 주는 셀 닥터 영양소 캡슐', 34000, 9, 'APPROVED', 'https://image2.lotteimall.com/goods/27/93/64/12649327_2.jpg'
         );

INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '20040015083486', '6e3f3ad5-1c4b-4df4-9f5f-7db41b867c21', '제조일로부터 24개월', '20110210',
             '1일 1회, 1회 2캡슐을 충분한 물과 함께 섭취.',
             '[비타민A]①어두운 곳에서 시각 적응을 위해 필요②피부와 점막을 형성하고 기능을 유지하는데 필요③상피세포의 성장과 발달에 필요 [비타민C]①결합조직 형성과 기능유지에 필요②철의 흡수에 필요③유해산소로부터 세포를 보호하는데 필요 [비타민E]①유해산소로부터 세포를 보호하는데 필요 [셀레늄(또는 셀렌)]①유해산소로부터 세포를 보호하는데 필요',
             '1)특이체질, 알러지 체질의 경우 성분을 확인하시고 섭취하여 주시기 바랍니다. 2)제품 개봉 또는 섭취시 포장재에 의해 상처를 입을 수 있으니 주의.',
             '고온다습한 곳이나 직사광선을 피하여 서늘한 곳에 보관',
             '① 성상: 진한 분홍색의 내용물을 함유한 투명경질캡슐 제품으로 이미, 이취가 없다. ② 비타민A : 표시량(675ugRE/900mg)의 80~150% ③ 비타민C : 표시량(416mg/900mg)의 80~150% ④ 비타민E : 표시량(5.2mg a-TE/900mg)의 80~150% ⑤ 셀레늄(셀렌) : 표시량(31ug/900mg)의 80~150% ⑥ 대장균군 : 음성 ⑦ 붕해시험 :적합',
             '비타민 A 혼합제제분말(가루, 과립)(분말비타민A 11.5%, DL-알파-토코페롤1.5%, 말토덱스트린 47.0%, 아라비아검 20.0%, 옥수수전분20.0%),비타민 C(L-Ascorbic acid),비타민 E 혼합제제분말(가루, 과립)(DL-알파-토코페릴 초산염 50%, 변성전분 24.5%, 말토덱스트린 24.5%, 이산화규소 1%),파라다이스넛추출물(추출액)분말(분말 추출물)(파라다이스추출물분말 20%, 말토덱스트린 80%),젤라틴,빙초산,자당지방산에스테르,정제수,아로니아농축액(농축물)분말(아로니아농축고형분{아로니아농축액(65brix) 99%,갈락토올리고당 1%} 30%,덱스트린70%),결정셀룰로오스,식물혼합농축액(농축물)분말(식물혼합추출분말{소나무잎 7.2%, 엄나무 7.2%, 감잎 6.64%, 인진쑥 4.8%, 작약 4.8%, 당귀 4.8%, 황기 4.8%, 산약 4.8%, 천궁 4.8%, 진피 4.8%, 치자 3.6%, 지황 3.6%, 꿀풀 3.6%, 형 ,스테아린산마그네슘',
             '세포 보호에 도움을 주는 셀 닥터 영양소 캡슐'
         );

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '7ce54218-997f-4cf7-9913-c6cf76a4c6ea', 3, 5, '아보레 센스 100', 23000, 8, 'APPROVED', 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '2004001703527', '7ce54218-997f-4cf7-9913-c6cf76a4c6ea', '24개월', '20110128',
             '1일 3회, 1회당 2정 물과 함께 섭취한다.',
             '[알로에전잎 제품]①배변활동 원활에 도움을 줄 수 있음',
             '임산부, 수유부, 출혈성 질병, 알레르기 체질, 생리중인 여성, 영유아 및 어린이에게 섭취하고자 하실 경우에는 섭취 전 구입처 또는 고객지원팀으로 문의하시기 바랍니다.',
             '',
             '1. 성상 : 녹황색의 정제로서 이미, 이취가 없어야 함 2. 안트라퀴논계화합물(무수바바로인으로서) : 표시량 20.46mg/1,860mg 의 80~120% 3. 대장균군 : 음성 4. 붕해도 : 건강기능식품공전 III.2 붕해도 시험의 정제제품 시험법에 따라 30분내에 붕해',
             '알로에 아보레센스분말(가루, 과립)',
             '아보레 센스 100'
         );
-- PRODUCT 테이블 INSERT (product_id, name, price, stock_count, category_id, vendor_id, status, product_image)
INSERT INTO PRODUCT (product_id, name, price, stock_count, category_id, vendor_id, status, product_image) VALUES
    ('bcf5f3aa-2e1c-408d-814f-6dcb5f0325f5', '한삼인홍센칼슘', 35000, 20, 5, 5, 'APPROVED', 'data:image/jpeg;base64,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');

-- PRODUCT_DETAIL 테이블 INSERT
INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '200400200021028', 'bcf5f3aa-2e1c-408d-814f-6dcb5f0325f5', '제조일로부터 2년.', '20110217',
             '1일 2회, 1회 2정을 충분한 물과 함께 섭취하십시오.',
             '[칼슘]①뼈와 치아 형성에 필요②신경과 근육 기능 유지에 필요③정상적인 혈액응고에 필요④청년기 이전에 적절한 운동과 건강한 식습관을 유지하면서 충분한 칼슘을 섭취하면 향후 골다공증발생의 위험을 감소시킬 수 있음 [마그네슘]①에너지 이용에 필요②신경과 근육 기능 유지에 필요',
             '섭취 시 목에 걸리거나 불편할 수 있으므로 반드시 물과 함께 섭취하십시오. 섭취 시 위장장애, 소화불량의 증상이 있을 경우 섭취를 중단하십시오. 개인의 신체 상태에 따라 이상 증상이 생길 경우 섭취를 중단하십시오. 섭취 전 제품에 이상이 있는 경우 섭취를 금하십시오. 특정 원료 성분에 알레르기 체질은 원료 성분을 확인 후 섭취하십시오.',
             '수분, 열에 의해 영향을 받을 수 있으므로 직사광선을 피해 서늘한 곳에 보관하십시오. 어린이 손에 닿지 않는 곳에 보관하십시오.',
             '1) 성상 : 고유의 색택과 향미를 가지고 이미, 이취가 없어야 한다. 2) 칼슘 : 표시량(180mg/1000mg)의 80~150% 3) 마그네슘 : 표시량(40mg/1000mg)의 80~150% 4) 대장균군 : 음성 5) 붕해시험 : 적합(60분이내)',
             '해조분말(칼슘 32% 이상),산화마그네슘(마그네슘 60%),스테아린산마그네슘,홍삼분말(가루, 과립)(진세노사이드 Rg1과 Rb1의 합 0.6% 이상),우유단백가수분해물,글리세린지방산에스테르혼합제제(글리세린지방산에스테르 99.82%, 프로필렌글리콜 0.17%, 구연산 0.01%),비타민 D3 혼합제제(비타민D 0.25% 함유, 자당 36%, 옥수수전분 27%, 아라비아검 22%, 코코넛유 10.6975%, 정제수 3.5%, 제삼인산칼슘 0.5%, 비타민D3유 0.275%, dl-α-토코페롤 0.0275%),결정셀룰로오스,N-아세틸글로코사민분말(가루, 과립)(N-아세틸글루코사민 95% 이상 ),히드록시프로필메틸셀룰로오스,이산화규소',
             '한삼인홍센칼슘'
         );


INSERT INTO PRODUCT (
    product_id, name, price, stock_count, status, category_id, vendor_id, product_image
) VALUES (
             '7f89cbb4-8613-4e33-8cc0-cb798f01dd77', '디믹스', 25000, 5, 'APPROVED', 4, 5, 'data:image/jpeg;base64,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'
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '20040016037147', '7f89cbb4-8613-4e33-8cc0-cb798f01dd77', '2년', '20110318',
             '1일 3회, 1회 3캡슐(1440mg)의 제품을 충분한 물과 함께 섭취하십시오.',
             '[녹차추출물 제품] 1. 항산화에 도움을 줄 수 있음 2. 체지방 감소에 도움을 줄 수 있음 3. 혈중 콜레스테롤 개선에 도움을 줄 수 있음',
             '[녹차추출물 제품] 카페인이 함유되어 있어 초조감, 불면 등을 나타낼 수 있음',
             '',
             '1. 성상 : 갈색의 내용물을 함유한 백색의 경질 캡슐 2. 카테킨 : 표시량(340mg/4,320mg)의 80~120% 3. 카페인(mg/kg) : 50,000 이하 4. 대장균군 : 음성 5. 붕해도 : 적합',
             '녹차추출물분말(가루, 과립),이산화티타늄,카라기난,자당지방산에스테르,염화마그네슘,펙틴,피로인산칼륨,빙초산,히드록시프로필메틸셀룰로오스,정제수,비타민 B6 염산염,비타민 B2,비타민 B1염산염,이산화규소,알로에 겔동결건조(200:1),말토덱스트린,알로에 겔분말(가루, 과립),크랜베리(열매)농축액(농축물)분말,블루베리농축고형분,덱스트린,블루베리농축분말,옥수수 전분,L-카르니틴,알긴산나트륨,가르시니아캄보지아 추출물,D-α-토코페롤,구아검,제이인산칼륨,레시틴,카제인나트륨,말토덱스트린,미역(줄기,미역귀(포자엽))추출 농축액(농축추출물),미역(줄기,미역귀(포자엽))추출물(추출액)분말(분말 추출물)',
             '디믹스'
         );


INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '986d53d3-bde4-4635-9930-1ce3ce0713ae', 3, 5, '엑티브표고버섯균사체AHCC', 25000, 10, 'APPROVED', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXFxUVFRgWGBcdFxcXFxcXHRUYHRgaHSggGB0lHRcVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGhAQGzclICUtLS4tLS0tLy0tLS0tLS0tLS0tLS0vLS0vLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAKwBJAMBIgACEQEDEQH/xAAcAAABBAMBAAAAAAAAAAAAAAAEAQIDBQAGBwj/xABUEAABAwIDAwQMCAoIBQUBAAABAgMRAAQSITEFQVETImGTBhUyVHGBkZKx0dLTBxQjUlOhs8EXJDRCRGJyc7LwJUN0oqPC4eIzNWNktIKDhaTxFv/EABoBAAIDAQEAAAAAAAAAAAAAAAECAAMEBQb/xAA4EQACAQICBgkCBQQDAQAAAAAAAQIDERIhBBQxQVGhExUyUmFxgcHhM/BikaKx0SI0QoIjcvEF/9oADAMBAAIRAxEAPwArbnZldredwPKbbC1pQlECEpJAMxJJAnM76rP/AOju++nusV661Z/aqMRlT4OZhPIkeUpH10nbVqO7uPNZrPjR0FocmbYOya875e89VQq7ILrvl/rV+utX7aNx3b/mM/6007Ub+kuPMZqY0Nqcvv8A8NnVty575f61z2qjO2Ljvh/rXParW+2be5dx5jFYnaze9b/iQxUxIOqTNjO1H9773WL9dNO0XfpnesX6617tqj573VtVnbZHznvMa++piRNVmXxvHDq4vxrV66jL6j+crzjVOrazfznvMa9dZ23ajV7zGvXUxIGrTL23QFEY1CCY/wCIgFInNRSSVHflAndM0qLZrHmoFBJhWJAIT84tyVcebAJy41Qp2w3nm95jR+8Ug2y3xd8xr11LoGrTNkTYtEoAeQMSiSTACUAmCeCyBOE5iQKaLZooxBwDnKEKgqwjuVYQZz04dIia147Za3F7xpZ+4U07Yb4vea1UxImqzL1ttsq7rCmUgFRSDBIBJ8RJy0ipW2G5TLqQClCjzkyCrukzMSPJ461/ts1xe81mmja7e9T3iSz94qYkTVahf8knI4xEAnMEglKSRkedBURl808KmDLe5f8AiN7iBvg5jER4EzEnDrY2y1vL/ms+qnDbDXF8j9ln1VMSJqszYeTRH/EzjTGMzCTAMZd0Rzo7k601Tadzgnm/niM1rScsjAAQqd4J6KoDtlri/wCaz9wpDtlri/5rPqqYkTVZmwoSne7vjJQAjCSDmcxICfCrw1hSPn7if+KmJE5TOW7dv6K15O2Gt5f81mkXtdrcp/zWvXUxImqzNhdgAwuYiIcBmegZ8eO7pAxGEgfKETGq05EkjPPLSZPzhWtdtkfOe8xn/Sk7at/Pe6tn11MSJqszZ0EHR+Mic3BEjAQO61hSvGg04OwCfjByJAhwZ8wqmMWYmE7s56CdWO0mvnvdW17QrO2jXznvMa9qpiRHokza3bhYGVyVQdA6c9c8iejy9FQDaT30znWL9da+najG9b/mM+1WHa7Xz3+ra9upiRNVmbD2ze+md6xfrpe2b30zvWL9dUCdsMb13B8DbIz8OI1itssblXHTKGfXRxImrSNgG1rgaXDw8Drg/wA1PTtu6H6S/wBc57Va524Y+dceYz66cNsW/wA+56tj2qmJA1WRs6eyO7H6U91i/vNSp7Kb0fpTvnT6a1UbYt/pLnqmfbpDtdicnLiP3LM/aVMaDqkzcU9mN93yvyI+9NPHZttDdcnxtsn0orTO2zPz3yP3DXvaYdrt/PcHCWET4/lhQxg1OfA9K7A2mLm3bfGWNMkfNUMlp8SgR4qyuLdiXZrcMsqQzzkYyeenOSlMwArmjKYk6zvgZVqmjBNYZOLOf3YGI1DnoAT0AE+HSirtPOPhPpovYTUqcOYhpRjnZ5gajIa78vHFYz0t7QuvArFMr+id6tef1eCkSwv6Nzq3PZrdtlWVutKeUcKVleEgKQAEYVmTjGWaAN45yeMCVuxt5UeUVkgqHPazUADGW7MgDWRQUm1e3P4Ec2pNN/p+TRlWrgz5Nec6IUTrG4ZVibR0/wBWvSe5V09GuWmunGugL2dbSRyucpjnoiC4kHnYYPNKvJMRUDmymc4cGSoALiBIkZk4ToCrQZ4ZjOo5NbufwBVL7/0v+TTxsV/QIHnI6OmnHYNwMsH95Hr+utwb2Xbn+sVMmBLY5vOjnGBJgZ9I408bNYy+UOYBMlJEwqYKRlBwZHp1ypcb4cw4/H9L/k07tBcn8weNSfXWK7HrnTAPPR663hzZzA7l0nIcJzjXIAfnSNRllxJtrBkKzUYmJxoPg0TnuM6DTUUrqtbl+Yjnle/6X/JztPY7ckxyf95MeWajf2DcJIBZWZ+aMQ8ZTIHjrqTzbaAMBk5ZSDGRnTwDy0MtZNVT0txdnHn8CxnOWafL5OXr2c+CQWXcuDayPKBFYdnPZfIPZ/8ASc9munhNOCaXXfw8/gLc+K/L5OW9r3/oH+qc9ms7Xv8A0D/VOezXUFKqMuVNe/Dz+ArpOK/L5OZdr3/oHuqc9mlOz391u91Tns10kk1gTU138PP4JafHl8nNhs9/6B/qnPZpe1730D/VOezXScqYpVDXvw8yf18eXyc57XP/AED/AFLns1na5/vd/qXPZrouInSmKHGpr34eYLz48vk56Nl3B/RrjqXfZp3ai571uOpd9muk2yqOSKV6f+Hn8Acprfy+TlHai571uepd9mk7T3Mfktx1Lvs11kDgKwp40Osfw8/gTHPjy+Tkvai571uOpc9ml7T3Petz1Dvs11iOArAmd1TrF93n8ExT48vk5N2pue9bjqXPZpO1Fz3rcdS57NdZKBTYO7TXxDX0jyimjp8pOyhz+AOckruXL5OU9qbnvW46lz1Up2Tdd7P9Uv1ZeOuppZJ0IOmmucxu4DfTSYp56XUh2oWJCq59mSZy/tRdd7P9Wr1Uo2Nc97u+bXR3n8JzCzxCU5DMjNaoQDIMgqkRpSIdBUU6KACilQIUEmIVB1GYGISJymad1qyhjdPIirXlhxq5zsbIufoHfN/1ocJmunk5ECuaXRha+hShl4d1NQrdKm7WsaaUpYrSOpfBPs5tdo4pSMXy6gD0BtrLyzSVsfwHsA7PWSP0hz+BulrfGOSPP6TG9ab8WcVvO6PhPpNWXYy0ol/LRhajB0AW2Mx4SBQN+jnq/aV6TVx2Hpzuf7I7x+karLxPQyf/ABr0Dra8QGghSMRSZSThI7qSMxzRpx0O4xUzO0kpEclPOxRigd2FYQAnJOX1mqxIp6TxrJ00lsLnQg9vntLPt0iCOSyJJPOmATJGacx5DrnQd4+FKGEEACM4k5kzzQANdBw3aCMNA09LFLOtKSswwowg7oiE1M2DUrNko6Va2ex1GqduwM6sY7WAMsk1YW9nRa0oby7pQ3Dd4TuqMXDijAhA6Bn5fVUkku0ZZVJS2bCdFieFO+JmolN5ZknwmfTQ6kjU1XjjuRUk3vCl25FDOINQ8sqciR4JqZlxZ7pII8h+qo7D4WsyIisijUoCtD4RvqNxoCkIpAZNNKSaKwGnBupclwPk+mlDfAUYlrgPLS8nxNLcFwXk6X4tNFpZFSpb6KDkK5AzFvG6igAKcU0qU0jzEcrjCPEKTD/JqSR4aZE0LAEjx0i1fyKkCKjcqBW0hWAJNWOw0EhbkY8LziISEkoShtRRAOWMqjnHTFuxKNV5RxpbdeBZWFKQVCCEnIncriDxjXXdn0NAqwpzeLK5k02lUnhcM7bV7+nubDfOO5JWRhJIlYThMlKs8QgQkuJjg2TvrVdsPhC3yHAW2yzhclMJD4QAcWhCVLBkk6KJJJom6Ulea1LVkQAok4Z1jFMjISkkJOUig126FtqaM4VBQUdVErGa546EfsjwnoVdJoppSd1dbM95jo6PXc8SVkr+uTVvf0LfZrLTSGn+aC4guhXyIK5wlplKnSEp5hMwUkkYpoHsgU0GGLlIDeL82EoSp3BiVCcRTKkodbMEzjGZiSXse9QxbItsRcShJTKiQogk82UpyEEgRoABO+gOyV1u5UxIKUsEKQhJ5hVnkpJQIAwtxB0UoQNa2PSqF7uSt97ho6PUxbGMaTKwgzmoJygHNQGpyB6TlXONqNfLOgExyjkSQSRiMEnf4a6Ps8fKt5FR5RvLOVc4ZeE6eOufX4l1wgauL/iNcnRMoN+J3KXb9DuPwJJjZx6X3f8AKPurKn+BpMbMR0uPH++R91ZXZh2UcOv9WXm/3OJbSR8q4ODjn1LVVx2FJ511/Y3v42qqtrD5Z39479oqrfsLTz7n+x3HpbP3Vzt79TvP6S9BA3upqkUQpNKKwmwgQ2d1TQRrVlsq1CjzshRO17RCYw60typ1ljwkeyHQSEzBOgOU+Ci7zaJ7hswNCoanwHh0/wAnXXAM6sdl5iTmR/M0XJxjkV1KMb4wkJCR07qnt0kiemKns7HlFa59PrraLXZSEJiJ0PjE+upSoSq7DFW0iMMt5qD+sGmtszmav73ZMGd1VT4jKqZwcHZhhVUlkRJQKa4rhT0pypkUg6G8nmDv3UW1zsjkfTUAXTksLMEA9B4kcPnHwUUpSySBLxJiwKzkqct9KYC1IQojFCnG0mASCYKpGYIz3gipUoJAUCkpIkEKQQRMTIMUXRqd1/kynpFsuQ8lxrAgUSi3JMCCcz3SdBqddBUTDiVpxtuNLSJlSHW1JECVSpKiEwM86Xoandf5MHSLiMwVgFPTCgCkhQJgFKkkTkYlJ1zHlpmuKCk4TCglSVFJmIISSRnlQ6KeeTy8A4lxMmkPl8FMbzE7ukR9Rp4PClas7MYQj+RTaelNOw0tiDAPFUa+ipjTVpoBQGZppqZyo1I40yLUDqpqqmj/APKwo8tMMDkRTQnfUhbJNIoUQhGw87lnjyrX8YzrnN2SVr3ypRnxnhXTux5EXLP7xPprl7iM66Gi/T9fZBp/Ufkvc798EA/otnpW/wDbLH3VlSfBKI2Vb+G4+u4drK7UOyjg1e3LzZxDayfl3v3z32iqtewxXPuOmzuvqbn/AC1WbaB+MP8A7577RVWXYaJceHG0ux/gqrnPazvP6XogilCKysx1gNgQy9B+ukuLvXjuoRxJOlMINDCBQje5kSau9lswCfBQGzbaczV80mBlSVJbinSKn+KLnZJjeau0rrVbe4iju2GVXaPpHRo49Wi5SuGbTuBFa06uTUl5dFVBAzVNSbqO7NVCjgRMTQzzoHTTnlxQTqqWMTTCAQ09PHxUBdpY5S8+NhClKWvkMaJUq2KVC2FsTOFQOEEIggxJyNGWxMUe3eKSjAhakElRVhw84EJgEKSQdFD/ANRrZolWMJNPK+/yM2mUXK2HduNdUm5ASLhQUvtVciDONIlzmrJ7pYGu/UHOi9ptFVtslPJocldiOTWOaqbZvmqBmUkQDl4qOu3yll5aVAFth5SQpq3IwgTgjk+5UTBTpJ0M0WlCLi3ti6kEFm1dThKkYVhlIlHJFJREkQkxl0V0J6RBRU91/Y5vQyUnHfYK2BZNtvAptWGs0gLa5LEecmQcNsggHP8AO4a1XdgOdujL9IuOGc4Ms8j5asNn7Ka5RE8soYgClVzdKSUzmCkukKGuRFVHYS9FhjQlThDzuFKFoSZJa0UrmiAZiRkPBNPSKpTbi75rw333thwuMkn4gvYNbXCtnsFDqMBDgSksFageVckFfKpmSCYwiJ36krsfSoObQxEKX8cGJaU4QVAOSQJOETnE7tanVZtkknZbck/N2afSKJsEASkWgYQQpUpNqlOIA4JQwJWTpnESc+MrSThK21+X8hpq0lfd5jwkaejTpp2HyU7DTsE1wnm8zoZIaDTgmpEt0/BTKIjZDhphbmig3SFNHAwYgJTdMLRo8NimlM0HAfGAcnUakVYKbodbU0MLHUgMtHdSBsiivi51jwUvJEamoNiH7BH4yz+2K5U3OEE8B6K61scxcNkbsR8iFH7q5O0OanwD0V0dF+n6+yLaL/rfkvc9C/BgmNmW3gcPldWayp/g7H9G2v7sek0lduHZR5+fafmcJ28Pxq5HC4f+1XVh2GH5dz+zXf2C6C7Ih+N3P9ouPtV0b2FflJHzmLlPlYcrn/5Hfl9H0HY6kSiahbjU0/GTWFmtyD7EpBzirXaWEsGANUyY6aoLcZ1fpRiZWI3T5uf3UqybM1VWkpeIFZnLKrJkic9IPgmDh6QJieiaBs0ZUaykknmlUJUYAUQDBCSrCQcIUUzBGU1UleasV1t4OxdOqcuW8DANvhxEreheNta0hPNkZNq1A1FEbFuuWZQ64lKA4QUhBWohIccQ5iChEygEQeNVtql8XO0AOSkNNOrlLsQLclOEBUg4XCOdImiexlhw2TKcGPmEtlCXCoJLzpXjzwnMmIHDOutXowVNuMVc5VKpJzSbZKsK3/F/Eq4zHmZeOoWbgB9bLiEwlhNwlTa15pLzaCmFo1hZz3EDWanW44l+xAUtIU8+lSQVALShDSkyNFc5St3EaZVA9YvquHXeScP4mwyIbUMSnHWnThgQrCltcgab4pYU04XcVmm8l8luJqaim9qW0iZeaX8ZxwlTLrzQ+WQMXJJVCilQCoUoJTzZgnfoRm7lCmLNxLScVw+GVpUtasAU4tAUMCkTGDFmM8Qp1vCVXUtJcDtw+8hYXZwpDqTyYPLPIWiCcUYdRQzNglpjZvMbDwvWQ4pPJlRl94gF1ucQw8lvMQNIrSqVG+SXIqdWultfMP2rfoZbKw0nN9DYC1LIShaXDqkpJKeT1Os7t69kl43aB8fJl1JQW2lKcJwlSZBwlOqFY8z+bGcyMvLdpxwl0cokY0obgpbbSvJZhK1LcdIj5QkRhEJECM2gyp60vLRL6nS041bIL4CCMDuIpUpKylyOSVCihBygzuopU6MludtvDMtq1KsXvV9nHIs1HB3GBK8gqS9BGFJMBKpEqxZFRiE0LtnaLzTC3yllYbCSRL8kLcQgZlZjNwUbduoxAl5DaVLbaRLKVYnCgc0HDJKjOucyBMVrl+45cMllbqAhzaI2evA2lJKUqStK5mcWJKTh8FGFJyytFxvw+0VVKnnfzNouHsDa3AnNLK3QJMSGSsiRnBgjx74gtsL5Ttu26QAVtKdCSpZQDC8P5wJ7nMyJk6UPtht15v4ulQhxJDz5DaSlsmFMoZRzlKIEY1QmFkSdzdjWa2ErY7plKH1MOYk40pUhZLLiCQVEFRhaJGZkDQVRpwSwprOV7eAHJ3u+HMZszbKXbZLoShx3k1rW0yQeTJxhBWlT4WlIhs6yorgRuGb2ys7OXd8glLiUJWJCyyuXsBKYfxiAQMwBIkEzFLs1Lh2bbttAYnWFt4iUhDQWtYccXniUcJOEJBJUN0Ga3bezeS2fcNLbDgZSDbPwmQ2t9BwKGLEhYLixoUkL1yrQqNC9sKvfw+7FbnO17l/ZXKlXN0wpDcMC2wqTygUS80lwk4nFDKSIirO3ZKiEjUmBVTs9P9IbT/8Aj/rthVy4pKWyFlQU8FIRgjGECOUWJUI1CcUyCpMa1jr0IusklZWz3F9ObwXebHXLaUhBSrEFpxpUNCnmwR0EKBpz7QS8GcRJwoUTGQxlYG/XmEx0jjUt0zictQkc3k+AHNTyZjLIc0bqdZPocuHFcmkBBcBckz8mrkzloMwvxCndCF2krZpL93yApu35lc+YU9nDbPdrIJ/NBISlOalSSkJGZI8ExqWkpRh5TGskYFJTIgTJKFEDMpGpkq6DTnEzZMriOUeU86DxUXnM+EOBvPikUTsBHywxAjmFaZ4E4cQ4juhVNWlDpFBLbvzy4FkZPC5PcDQ2HFNrcWCnu1AAtoVhnDJOJRgiYEZxMzFe26o5yQCARIgiQNROR6OioFFfPOEyCpTn6qlqlUndzlHy1AXiay1kk2lG3jmaqdJtXbDi8fnU/wCNxkBJOsVW4zU7T4AhUgcfH6Kos0WumWCRO8ePWo1oG8+SgFOpOi0+WKVD6hrChxGo8I30bXF6Nlhs1XyyTwS59TS65and4BXTtmuDHi3Bt5XiDLhrmFdDR1an6v2LaHbl5L3PRfYAP6OtP3KD5RS1J2DpjZ1mP+3Y+zTSV247DgT7TOD9lA/HLn+0P/aKorsJ/K0/sXH/AI7tD9lYi9uf37/2iqn7CT+OtdIfH/13q5/+fqd/bo/+vsSMtTlRlvYk65VJZtDU7qsWVJOVcyU2i2cmthEwwlNWdrcAbqF+LjcaXkyKrUs7meVpGFISSN27wbqidIIUggFKsIIkjuVJUmCkgiFJScjuqV0E7sxVe6+ZpoNqV4jKGNWY5VixJPJZnU8o/JERB+UzEZZ063ZbQOa2IwqRBW8U4VghQCSuBIJEiDnMznQi3iantjWjp6tu0R6JTSvYjftmzBLQJTOEly4OGdSPlcp6OFMbeCFJWltIUlSVp59wRiSZScKnSDmAcxuo5RqrvFQeiDPhifQPrFNCvVeVww0ejvihiDRyMBSzKlJLVy3cHmBQUG9EjnpgmVST0ZVWY/Tu4RProljMx4N/g3eP01IOVN4kaK9ONSOFlqtxP9SstnErnlsLcwkynBLgQhQGUlKuIg5VBbbOQ3myS0rDgUVS6h5Mz8sgqTiVJJC0FMZQMhDLV483LVKDuGZxTvz0yHQaJbuOjPTX0cRvngQd9HpascopW9MzBUoQbu7/AJk20LYOpbCDgU06y+k4CpKnGgoEFBcBCFFU92SIiTMgjlrnL5RjUn/gP5Hj+Wa1HbvAmAI4yRO7dqRqJ4pNI1cHCCdSJIGoO9PSqcgMu5NLHSK0VhSRTKhBu5YLXJ3aCYEAmBiIG6TJjdNO3KGhKFpGUwVJKZIkTAUTEjw0Am5IPccPzt5xRmQAO48qhxqZNzBIyJlW+MgsJk5cDM9FZownjxpZ3uGSVrC7Ps+TYaaxYi2koxREjEpQOGTB5xESdAd8U3a+zeXt3WMZQXAhOLDigBxKzzcSZ7gb95qY3WgAiVAZkfSISoHgrnHLoNTLdgqmBhEgb1CCSZ3Z5b4wniIuip9J0j2lTSw4dwLbWeB+5fK55cMc0IACCygIHO5QlQIncN1OecKlAkkwMKZ0CeAjwDyCo7m81hOWe/hymmWYPJ5HeFJqH41E83SdDrBWI015mn6wpK061Rt+hZTpxig5V2tMKxqlKSlGkJBiYEZ6DWdKr03SwFBKlALkKIiVAzOZzzk5iNahuLvM82YJGvDlOj9T+8PHLZMlaiNw9pY+vCCOgikcqsVdvZ4+haoQSu0EMbReSnChxSB+qEH+NKo8UUGLtbay4lSsZ1USVKPQSqZHRoNwFW6rSBQT1jJqqOkzyWLIkOju3YAubx18jlXVrAMgHCEgjQ4EAJJBzBIJG40isqneaw1V3L01Y5yqO7dzVThHZFWRMp0TUT12IwkSOjUUMDStsFWegGpOlHCi9QitpnJtn88jwik5H5iwT4YNOU02NXPIKhWttOgKj05DyU1h1ns/YstkXKsbk5fi90VeEW7ufRWjqNbjsxRKnirX4pd/+O5H1RWnuHWtlPKC9SlK1SXkvc9J9iSYsbUcLdn7NNZU3Y8ItbccGWv4E1lddbDzL2nA+zEfj11+/d/iNP7CE/jzH/ujysOj76Ts1yv7r98v6zTuwk/j1v8AtK/gXXPf1PX3O+v7f/X2LW0TIjoFTYY1oJhUAeAVYNXAORrlyTRdNNZipcIqX4yaTkQdKYu3PhpMmVf0scLzoqN4BWcZ/VTeQVT0tnhRVlsGslsA3CNIpza6KUzO6mJs4/1p8SHxqwkZUI80asOTNOSnooKVgKdiqQ0aKZt6PNtGdPSio5klWvsGtIinpNPimkVWyi9xyVVMk0PFSpNK0K0Epp6TQ4VUqDQRU0FNmmvLisSaFeXJqybtGwiV2ZM51mD7/r1pU06sw5Gi3k1aW7UCg2TRiXarndlVRtj1JBqC4SAKnKxVbfP1VCLuLBNspdpO61T0bfKJoE104KyOzSjaJijUmAlIxEJTu6eOXGh1GnKfUAJAUkjfp0+A09i1p7jFqa/WPkqEvpHcpz4qz+qlLrfzCPAaRLaFaEg/raeWmyGtxuGbHmLk7/ilz9bZH3mtRe3+A1t+y0kJugdRaXHoSPvrTrjQ+A1qh2UUP6kvQ9QbHTFuyODTY/uisqayENoH6qfQKyuweWPPvZ0mNoXP71R8oBHppOwr8ut/2z/AqpvhBH9I3P7Y+zRUXYV+XW/7fpBrnP6nr7nfj/bf6+wWg/dUgNCJXlTgusDRtsHtukUSi4PGqkOVIHKRwEdNMtDcnhSouDwquDtTtu9BpXBCOmWCLjoqVL4NApJ4VMhB4UlkUuKCwlJpqm40piGempeUCaUTyGrERTcVY6d9MKwKKuFbB6adNVp2gnQhUpUoHMCM1aiRlCABPEaEmMZfknuiqRmTCcGIiQJiIBiczkfBfLR5JXYkZKRY0uOqtx1zlBnzOEeHU+T+dR2nnIVJJyEZb5OXj9VWam8GLEti5iqd5KNntsXhdp7b1UJddwjM6qnIAxIwiD0SJqVpbkpOLKRlG7pyEb9ScyNNKo6HxL3SyNhL2VCNvSaqVrdDbsqMnuTHcyB3IJAUM9SdZ8FDhx44cONMLUVAYJwwcucc+iDvBnKC0tHxf5Ioj2b2NmxUpXVQlbsoM80lsHUnJKy4VDKJJSNcikHfFGrcrNOnhtmRK5OHakFzVeXajLlJguP0dyycvKAeemo1rgUIt+mjAshS4D11EpkU9BnOobp+KtXAvineyBLmBQ6HinTyHMGkccmkgAc7yD7zWhKyNajZZji+N6E+ipGwhWQBSejMVGl4D8xPjk07lVqyAAHQIHloWI0GWGQupzizd+tTKf8ANWnO6GeBrbtnRguzuFoseV639Vak+Mj4D6K1Q7KMr7cvT9j1QyISB0D0VlPrK655c8/fCH/zK5/bT9k2aF7DzF7a/vmh5VAH00Z8In/Mrr9tH2LdV/Y2+lu7t1qICUvNKUToEhYkk7gBXOl9R+Z6Cmr6Ov8Ar7BCtTSpTRx2amT+NWmv049VP7Xp76tOvHqrK4SvsNKrU7bQEACpEugVKrZg77tOvHs1g2WO+rPrx7NDopE6anxEF2Kei+HCm9rB31Z9ePZpRswd92fX/wC2ldF8AY6XEn7YdFYNomo+1476tOv/ANtKLBPfVp13+2h0HgDFRCE3hOpqZtU6UM3ZoGt1a9d/toxHJgZXNr1v+2llRluRVKUNw5zKKYo5eT6jI+sUhCDrdW3W/wC2swt9823WH2aCpTW4S8RueuLPdwHiny/dlUBdOqjJiMhAABO4k556zw4VKtKDpdW3WK9ioOQR31bdY57unwTe1DwwIiKozk6k68aiUvpPl6KINsjvu189z3VNFmjvu06x33NMozHUqS+2Qg9J+rgctNM9KnDGKCVKEEqGExrGRAGYy06TT02rffdp57vuanbbaH6Xa+e77qhhq7hJypv7YzkIRhxKORzMTmZ4R/O+omW5VOJWU7+PgGcbqPBZ77tvPd91ULTbQ/S7Xz3fdUrjV4CRlC1v5MSxBKsS9EiCoxkDGXjpynKcotd9Wvnu+6oV9tB0u7Tz3vc0rpVZdpEhgX2xVOSaXFUKGED9LtPPe9zTnEIP6Xa+e/7mg9HnwLbx+0yC5uJ0odJzqc2iO+7Xzn/cU4Wjffdr5z/uaboZcC5VIJfDMU7AqtuHZNWK7VB/TLXzn/c1CrZ7fflr5z/uKaNGSzsGFSmt/JlbiohDYiQMR4cMuFE9rG+/LXzn/c1INntDMXtsDvgv+5p3SlwHlpFPjyYEbpQ0AHiqBx9StTVv8WT39bf43uajVaNHuru2PSOXn7GiqUluF1in9p/wRbLPyN5/Zo8r7EVrSBzh4R6a2hSmWre5SLhtxbiW0oShL0mHUKMlaABknjWv2DeJ1A4rQPKoCr4rJL72mdyv0kl95Hp6srKyuoebOCfCIk9sbn9pH2SK1uK678Lex2RZu3KUBD+JoFxPdGVJSZ3E4cpI3CuJhbn0y/I37FZZUG5N3OrS06MIKNthYiemlg1XhTn0y/Na9infKfTL8jfsUurviP1jDuhsGlg0IG1/TL8jfsUqbZR/rnP8P2KmrPiHrGHdC8JrADQ6bJX07v8Ah+xUidnH6d3yt+xQ1Z8SdYx7pJhNZhNOb2UT/Xvb97fsVM3sSSB8Yf14t9H6lToPEPWEe6QAHhSweFE9of8AuH/K37FOGwB3w/5W+n9Sp0HiTrBd0Fg8KyDRyOxwH9IuPOb4x8ylHY2O+Ljzm/YodB4k6wj3QCDwpCDViexsT+UXGnzm/d1PbdiiVAk3NxrHdN9H/To9B4k6wj3SkVNZnWxI7DkEx8ZudY7pr3dFnsDa75uvOa91U1d8SdYx7pqWdYJrd0fB2yQD8au8/wBZn3VSM/BswT+VXfnte6qas+IOsod00Qg0gnhXQx8GDHfd557XuqI/BVbd93nns+5qaq+JOs4d05pnwrCFcK6Z+Cm277vPPZ9zS/gptu+7zz2fc1NVfEnWcO6cwz4VmfCuofgotu+73z2fc1n4Jrbvu96xn3NTVXxJ1nDunMIPCkz4V1EfBNbd93vWM+5pfwS23fl91jPuamqviTrOHdOWZ8Kwg8K6uPgmte+r3rG/dVIj4JbTvm861Hu6mqviTrOPdOSgGlg8K64PgltO+LzrUe7p4+Ca074vOtT7FFaK+IOs4905DhPCm4TwrsH4JrP6e864exSj4J7P6e764ezU1Z8QdZx7px7AeFF7Ial9of8AVb/jFdW/BNZfTXfXf7asNh/B3Z2zodHKukDmh9eNKVBQUFgEZKBGR3SaMdGad7iz/wDoxlFqxt1ZWVlazlH/2Q=='
         );


INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '20040020006741', '986d53d3-bde4-4635-9930-1ce3ce0713ae', '제조일로부터 24개월', '20110324',
             '1일 1회, 1회 1포(2.0g)를 충분한 물과 함께 섭취.',
             '[표고버섯균사체 AHCC(2008-78호)]“면역기능 증진에 도움을 줄 수 있습니다” (기타기능II)',
             '임신, 수유부나 의약품을 섭취하시는 분은 본 제품을 드시기 전에 의사와 상담 후 섭취하십시오.',
             '① 제품은 직사광선을 받지 아니하는 실온에 보관 유통하십시오. ② 제품 개봉 후에는 인습되지 않게 주의하여 보관하십시오.',
             '(1) 성상 : 이미,이취가 없는 진한 갈색의 분말제 (2) α-glucan 함량 : 표시량(532mg/2.0g)의 80.0~120.0% (3) 납(mg/kg) : 2.0 이하 (4) 총비소(mg/kg) : 10.0 이하 (5) 카드뮴(mg/kg) : 0.5 이하 (6) 총수은(mg/kg) : 0.5 이하 (7) 대장균군 : 음성 (8) 아플라톡신B1(㎍/kg) : 10.0 이하',
             '표고버섯균사체 AHCC(표고버섯균사체배양물 76.7%, 시클로덱스트린 23.3%,α-glucan 280mg/g),메밀추출물(추출액)분말(분말 추출물),메밀추출물(추출액)분말(분말 추출물),갈락토올리고당,비타민 C,결정셀룰로오스',
             '엑티브표고버섯균사체AHCC'
         );


INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '3131180f-3f0d-47ae-a8a7-d166a62a9ee8', 3, 5, '아마가인지방산', 24000, 0, 'APPROVED', 'data:image/jpeg;base64,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'
         );

INSERT INTO PRODUCT_DETAIL (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             '20040020028173', '3131180f-3f0d-47ae-a8a7-d166a62a9ee8', '24개월', '20110324',
             '1일 2회, 1회 2캅셀씩 물과 함께 섭취하십시오.',
             '[필수지방산]①필수지방산의 보충',
             '특정 또는 특이체질등 알러지 체질의 경우 성분을 확인하신후 섭취하십시오. 섭취시 캅셀이 기도에 걸릴수 있으니 반드시물과 함께 섭취하십시오.',
             '직사광선을 피하고 서늘한 곳에 보관.',
             '성상: 투명의 연질캅셀 리놀렌산: 표시량(600mg/g)의80-120% 대장균군: 음성이어야한다 붕해시험: 20분이내',
             '아마씨유,젤라틴,D-소르비톨액,글리세린유지(Oil),에틸바닐린',
             '아마가인지방산'
         );
INSERT INTO PRODUCT (product_id, category_id, vendor_id, name, price, stock_count, status, product_image) VALUES ('0e6fcf3b-7051-49cf-9f57-3ac57a60d396', 1, 5, '진품홍삼', 29000, 0, 'APPROVED', 'data:image/jpeg;base64,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');

INSERT INTO PRODUCT_DETAIL (cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions, storage_method, standard, ingredients, product_name) VALUES ('200500200099', '0e6fcf3b-7051-49cf-9f57-3ac57a60d396', '제조일로부터 24개월', '20110406', '1일 2회, 1회 10g씩 직접 또는 냉, 온수에 타서 섭취, 1일 1포(15g)1회, 1스푼(5g) 1회 직접 또는 냉, 온수에 타서 섭취', '①면역력 증진②피로회복③혈소판 응집 억제를 통한 혈액흐름에 도움④기억력 개선에 도움을 줄 수 있음', '(1) 특이체질의 경우 제품섭취에 따른 알러지 등의 과민반응이 우려될 수 있으니 성분을 확인하신 후 섭취 (2) 포장용기가 유리이므로 파손에 주의 (3) 의약품(당뇨치료제, 혈액항응고제) 복용 시 섭취에 주의', '', '1. 성상 : 암갈색의 액상제품이며 이미, 이취가 없어야 함 2. 진세노 사이드 Rg1과 Rb1과 Rg3의 합 : 0.9mg/g 의 80% 이상 3. 세균수 : 1mL당 3000이하 4. 대장균군 : 음성이어야 한다.', '홍삼농축액(농축물),복분자딸기농축액(농축물)((고형분 60%이상)),영지버섯농축액(농축물)((고형분 60%이상)),당귀농축액(농축물)((고형분 60%이상)),칡농축액(농축물)((고형분 60%이상)),천궁농축액(농축물)((고형분 60%이상)),자몽종자추출물,말토덱스트로오스', '진품홍삼');






-- 8) STOCK_LOG (PRODUCT → STOCK_LOG)
INSERT INTO `STOCK_LOG` (`stock_log_id`,`product_id`,`change_type`,`count_change`,`changed_at`) VALUES
                                                                                                    (1, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'RESTOCK', 10, '2025-06-09 12:00'),
                                                                                                    (2, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'RESTOCK', 50, '2025-06-08 10:00');

-- 9) LIVE_M (VENDOR_M → LIVE_M)
INSERT INTO `LIVE_M` (`live_id`,`vendor_id`,`session_id`,`title`,`start_at`,`end_cd`,`thumnail`,`status_cd`,`announcement`, `category`) VALUES
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', 1, 'sess123', 'Bob Live', '2025-06-10 18:00', 'OFF', 'thumb.jpg', 'ON', 'Welcome to live sale', '혈압');

-- 10) LIVE_DASHBOARD_D (LIVE_M → LIVE_DASHBOARD_D)
INSERT INTO `LIVE_DASHBOARD_D` (`liveDashboard_id`,`live_id`,`total_viewers`,`purchase_ratio`,`total_orders`,`total_reve`,`purchase_rate`) VALUES
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 100, 20, 5, 2500000, 50);

-- 10-1)
INSERT INTO `LIVE_VIEWER_LOG` (`live_id`,  `user_id`,  `join_at`, `leave_at`, `is_anonymous`) VALUES
                                                                                                  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '1',                  '2025-06-10 18:00:00', '2025-06-10 18:30:00', FALSE),
                                                                                                  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-1234',    '2025-06-10 18:05:00', '2025-06-10 18:20:00', TRUE),
                                                                                                  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '2',                  '2025-06-10 18:10:00', '2025-06-10 18:25:00', FALSE);

-- 11) LIVE_PRODUCT_J (LIVE_M, PRODUCT → LI VE_PRODUCT_J)
INSERT INTO `LIVE_PRODUCT_J` (`live_product_id`,`live_id`,`product_id`,`discountRate`) VALUES

                                                                                           (1, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '10'),
                                                                                           (2, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '15');

-- 12) ORDERS_M (PAYMENT_D, USER_M → ORDERS_M)
INSERT INTO `ORDERS_M`
(`order_id`, `payments_id`, `user_id`, `order_status_code`, `discount_amount`, `order_date`, `total_amount`, `shipping_req`, `created_at`, `postal_code`, `basic_address`, `detail_address`)
VALUES
    ('3f9d4ca1-5d10-4ba4-9629-ec999f0bc3ef', '335c2ce6-1bd2-422f-82ad-b2498676a087', 7, 'DONE', 0, '20250618170145', 32000, NULL, '20250618170145', '15616', '경기 안산시 단원구 첨단로 7', 'ㅁㄴㅇㅁㄴㅇㅁㄴ'),
    ('9289b837-7ee1-41d6-809a-400a98652c43', '651ef69b-845d-4464-a961-d586f079e1e9', 7, 'DONE', 0, '20250618163924', 192000, 'ㅁㄴㅇㅁㄴ', '20250618163924', '10246', '경기 고양시 일산동구 감내길 1', 'ㅁㄴㅇㅁㄴㅇ'),
    ('00355546-5a8a-4290-955d-efc01a328ab2', '57b29a0d-3b7c-47e3-afa6-209a05777763', 7, 'DONE', 0, '20250618163824', 310000, 'ㅇㅁㄴ', '20250618163824', '10423', '경기 고양시 일산동구 강촌로 17-2', 'ㅁㄴㅇㅁㄴㅇㅁㄴ'),
    ('61517d4a-1ef5-4e93-ac2e-ca409d955eaf', 'd70dfec4-5fb3-4834-851c-f2729efc8a20', 7, 'DONE', 0, '20250618163647', 310000, 'ㅂㅂㅂ', '20250618163647', '10301', '경기 고양시 일산동구 경의로 486', 'ㅂㅂㅂ'),
    ('efb4d6ad-9f6f-4077-91af-6d43f895d515', 'd098b6b3-cb71-41a5-9162-10fe9eef5168', 7, 'DONE', 0, '20250618162909', 310000, 'ㅁㄴㅇㅁㄴ', '20250618162909', '21931', '인천 연수구 경원대로 지하 285', 'ㅁㄴㅇㅁㄴ'),
    ('18aed960-4288-41ad-9a03-50baa4805d8a', '2a6e887a-7fa6-482a-ab74-1a8765f0ecdc', 7, 'DONE', 0, '20250618162804', 310000, 'ㅇㅁㄴㅇㅁㄴ', '20250618162804', '13599', '경기 성남시 분당구 내정로166번길 27', 'ㅁㄴㅇㅁㄴㅇㅁㄴ'),
    ('6455d250-1454-4236-bdb1-3d5affc59989', 'd1ed414f-a911-4e12-bdb5-1f38b72191c3', 7, 'DONE', 0, '20250618162556', 310000, 'ㅁㄴㅇㅁㄴ', '20250618162556', '13536', '경기 성남시 분당구 판교역로 4', 'ㅁㄴㅇㅁㄴㅇ'),
    ('8b5fca93-4c12-4101-8992-fc68dbde8c9b', '7b06cefc-36de-450a-9c31-d70bcd894362', 7, 'DONE', 0, '20250618162313', 310000, 'ㅁㄴㅇㅁ', '20250618162313', '10397', '경기 고양시 일산동구 장항한강5로 40', 'ㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴ'),
    ('9bea8986-c048-44ed-8563-3faf29d81677', 'b0656eed-d317-4ced-b704-83856b97170b', 7, 'DONE', 0, '20250618161957', 310000, 'ㅁㄴㅇㅁㄴㅇ', '20250618161957', '10397', '경기 고양시 일산동구 장항한강2로 20', 'ㅁㄴㅇㅁㄴㅇ'),
    ('be8374a2-dafb-4b4b-84f6-f379f2f3bf32', 'a5af6113-5870-4c18-a0da-1f33978d10f5', 7, 'DONE', 0, '20250618155017', 412000, 'ㅁㄴㅇㅁㄴ', '20250618155017', '13536', '경기 성남시 분당구 판교역로 4', 'ㅁㄴㅇㅁㄴㅇ');

-- 13) ORDER_ITEM_D (ORDERS_M, PRODUCT → ORDER_ITEM_D)
INSERT INTO `ORDER_ITEM_D` (`order_item_id`,`order_id`,`product_id`,`quantity`,`created_at`,`paid_amount`) VALUES
                                                                                                               ('d572d7b3-8959-4aeb-aa6c-50fd770ec6b2', '3f9d4ca1-5d10-4ba4-9629-ec999f0bc3ef', '55555555-aaaa-bbbb-cccc-555555555555', 1, '20250618170145', '10000'),
                                                                                                               ('fce6613f-6228-4ccc-a21c-186e75201f3f', '9289b837-7ee1-41d6-809a-400a98652c43', '55555555-aaaa-bbbb-cccc-555555555555', 6, '20250618163924', '10000'),
                                                                                                               ('f81bb73d-f23f-4c33-8b7f-6a6d72d47d50', '00355546-5a8a-4290-955d-efc01a328ab2', '55555555-aaaa-bbbb-cccc-555555555555', 8, '20250618163824', '10000'),
                                                                                                               ('4ef2caca-34b2-41b5-9c9e-39edf5d21afb', '00355546-5a8a-4290-955d-efc01a328ab2', '22222222-aaaa-bbbb-cccc-222222222222', 3, '20250618163824', '10000'),
                                                                                                               ('2aebdc49-7248-489e-ab83-82ae7722e9c2', '61517d4a-1ef5-4e93-ac2e-ca409d955eaf', '22222222-aaaa-bbbb-cccc-222222222222', 3, '20250618163647', '10000'),
                                                                                                               ('7d791a5c-2748-4a3c-a68f-26d8bfde5b65', '61517d4a-1ef5-4e93-ac2e-ca409d955eaf', '55555555-aaaa-bbbb-cccc-555555555555', 8, '20250618163647', '10000'),
                                                                                                               ('5dfe512a-931b-4ba1-9a65-348fdcf63d9b', 'efb4d6ad-9f6f-4077-91af-6d43f895d515', '22222222-aaaa-bbbb-cccc-222222222222', 3, '20250618162909', '10000'),
                                                                                                               ('1d987b7d-f08e-4495-a0f2-d304c4ffcd77', 'efb4d6ad-9f6f-4077-91af-6d43f895d515', '55555555-aaaa-bbbb-cccc-555555555555', 8, '20250618162909', '10000'),
                                                                                                               ('c0e620dd-9109-417b-b537-7b7cef5ebb78', '18aed960-4288-41ad-9a03-50baa4805d8a', '55555555-aaaa-bbbb-cccc-555555555555', 8, '20250618162804', '10000'),
                                                                                                               ('338ff9ae-0113-4a4b-8e2e-9a957be2b1b3', '18aed960-4288-41ad-9a03-50baa4805d8a', '22222222-aaaa-bbbb-cccc-222222222222', 3, '20250618162804', '10000');

-- 14) SERVICE_M (ORDER_ITEM_D → SERVICE_M)
INSERT INTO `SERVICE_M` (`service_id`,`order_item_id`,`service_code`,`reason`,`img`,`status_code`,`refund_amount`,`update_at`,`created_at`) VALUES
    ('33333333-3333-3333-3333-333333333333', 'gggggggg-gggg-gggg-gggg-gggggggggggg', 'SR01', 'Defective', 'https://your-ncp-bucket-url.com/path/to/image.jpg', 'ST01', 100, '20250616154744', '20250616154744');

-- 15) REVIEW (ORDER_ITEM_D → REVIEW)
INSERT INTO `REVIEW` (`review_id`,`order_item_id`,`rating`,`feedback_choice`,`content`,`created_at`) VALUES
    (1, 'hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', 5, 1, 'Great product', '2025-06-08 17:00');

-- 16) CART_M (USER_M → CART_M)
INSERT INTO `CART_M` (`cart_id`,`created_at`,`user_id`) VALUES
    ('iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', '20250616154744', 1);

-- 17) CART_ITEM_D (CART_M, PRODUCT → CART_ITEM_D)
INSERT INTO `CART_ITEM_D` (`cart_item_id`,`cart_id`,`product_id`,`quantity`,`created_at`) VALUES
    ('jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj', 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 2, '20250616154744');

-- 18) CHAT_ROOM_M (LIVE_M → CHAT_ROOM_M)
INSERT INTO `CHAT_ROOM_M` (`room_id`,`participants_cnt`,`created_at`,`updated_at`,`live_id`) VALUES
    (1, 2, '2025-06-10 18:05:00', '2025-06-10 18:05:00', 'cccccccc-cccc-cccc-cccc-cccccccccccc');

-- 19) CHAT_PARTICIPANT_D (CHAT_ROOM_M, USER_M → CHAT_PARTICIPANT_D)
INSERT INTO `CHAT_PARTICIPANT_D` (`participant_id`,`banned_yn`,`created_at`,`room_id`,`user_id`) VALUES
                                                                                                     (1, 0, '2025-06-10 18:10:00', 1, 1),
                                                                                                     (2, 0, '2025-06-10 18:11:00', 1, 2);

-- 20) CHAT_MESSAGE_D (CHAT_ROOM_M, USER_M → CHAT_MESSAGE_D)
INSERT INTO `CHAT_MESSAGE_D` (`message_id`,`content`,`created_at`,`user_id`,`room_id`) VALUES
                                                                                           (1, 'Hello everyone', '2025-06-10 18:15:00', 1, 1),
                                                                                           (2, 'Hi Alice',       '2025-06-10 18:16:00', 2, 1);

-- 21) CHAT_REPORT_D (CHAT_MESSAGE_D, USER_M → CHAT_REPORT_D)
INSERT INTO `CHAT_REPORT_D` (`report_id`,`reason_nm`,`status_cd`,`reported_at`,`processed_at`,`message_id`,`user_id`) VALUES
    (1, 'Spam', '미처리', '2025-06-10 18:20:00', NULL, 1, 2);

-- 22) CHATBOT_LOG_D (USER_M → CHATBOT_LOG_D)
INSERT INTO `CHATBOT_LOG_D` (`log_id`,`question`,`answer`,`created_at`,`user_id`) VALUES
    (1, 'How to buy?', 'Use the cart', '2025-06-10 19:00:00', 1);


-- PAYMENT_D 더미 데이터 30개
INSERT INTO `PAYMENT_D` (`payments_id`, `payment_method`, `payment_Key`, `payment_payload`, `paid_at`, `created_at`,
                         `payment_status_code`)
VALUES ('p001-2025-0620-001', '간편결제', 'tgen_20250620080145zLh91', '{
  "vat": 2727,
  "card": {
    "amount": 30000,
    "number": "433028**********",
    "cardType": "신용",
    "approveNo": "00168056",
    "ownerType": "개인",
    "installmentPlanMonths": 0
  },
  "method": "간편결제",
  "status": "DONE",
  "orderId": "ord-001",
  "orderName": "가바트리플",
  "approvedAt": "2025-06-20T08:02:03+09:00",
  "paymentKey": "tgen_20250620080145zLh91",
  "receiptUrl": null,
  "totalAmount": 30000,
  "suppliedAmount": 27273,
  "easyPayProvider": null
}', '20250620080203', '20250620080145', 'DONE'),
       ('p002-2025-0620-002', '카드결제', 'tgen_20250620090245xMn82', '{
         "vat": 1818,
         "card": {
           "amount": 20000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168057",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-002",
         "orderName": "알로에아보레센스",
         "approvedAt": "2025-06-20T09:03:15+09:00",
         "paymentKey": "tgen_20250620090245xMn82",
         "receiptUrl": null,
         "totalAmount": 20000,
         "suppliedAmount": 18182,
         "easyPayProvider": null
       }', '20250620090315', '20250620090245', 'DONE'),
       ('p003-2025-0620-003', '간편결제', 'tgen_20250620100345yPq93', '{
         "vat": 1091,
         "card": {
           "amount": 12000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168058",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-003",
         "orderName": "행복한 한컵 락티움",
         "approvedAt": "2025-06-20T10:04:25+09:00",
         "paymentKey": "tgen_20250620100345yPq93",
         "receiptUrl": null,
         "totalAmount": 12000,
         "suppliedAmount": 10909,
         "easyPayProvider": null
       }', '20250620100425', '20250620100345', 'DONE'),
       ('p004-2025-0620-004', '간편결제', 'tgen_20250620110445zRs04', '{
         "vat": 1818,
         "card": {
           "amount": 20000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168059",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-004",
         "orderName": "홍삼타브렛",
         "approvedAt": "2025-06-20T11:05:35+09:00",
         "paymentKey": "tgen_20250620110445zRs04",
         "receiptUrl": null,
         "totalAmount": 20000,
         "suppliedAmount": 18182,
         "easyPayProvider": null
       }', '20250620110535', '20250620110445', 'DONE'),
       ('p005-2025-0620-005', '카드결제', 'tgen_20250620120545aTu15', '{
         "vat": 2273,
         "card": {
           "amount": 25000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168060",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-005",
         "orderName": "천지인 키즐홍짱 홍삼액",
         "approvedAt": "2025-06-20T12:06:45+09:00",
         "paymentKey": "tgen_20250620120545aTu15",
         "receiptUrl": null,
         "totalAmount": 25000,
         "suppliedAmount": 22727,
         "easyPayProvider": null
       }', '20250620120645', '20250620120545', 'DONE'),
       ('p006-2025-0620-006', '간편결제', 'tgen_20250620130645bVw26', '{
         "vat": 1636,
         "card": {
           "amount": 18000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168061",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-006",
         "orderName": "Silver plus propolis",
         "approvedAt": "2025-06-20T13:07:55+09:00",
         "paymentKey": "tgen_20250620130645bVw26",
         "receiptUrl": null,
         "totalAmount": 18000,
         "suppliedAmount": 16364,
         "easyPayProvider": null
       }', '20250620130755', '20250620130645', 'DONE'),
       ('p007-2025-0620-007', '간편결제', 'tgen_20250620140745cXy37', '{
         "vat": 1818,
         "card": {
           "amount": 20000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168062",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-007",
         "orderName": "종근당건강멀티비타민포우먼",
         "approvedAt": "2025-06-20T14:08:05+09:00",
         "paymentKey": "tgen_20250620140745cXy37",
         "receiptUrl": null,
         "totalAmount": 20000,
         "suppliedAmount": 18182,
         "easyPayProvider": null
       }', '20250620140805', '20250620140745', 'DONE'),
       ('p008-2025-0620-008', '카드결제', 'tgen_20250620150845dZa48', '{
         "vat": 909,
         "card": {
           "amount": 10000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168063",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-008",
         "orderName": "미라클",
         "approvedAt": "2025-06-20T15:09:15+09:00",
         "paymentKey": "tgen_20250620150845dZa48",
         "receiptUrl": null,
         "totalAmount": 10000,
         "suppliedAmount": 9091,
         "easyPayProvider": null
       }', '20250620150915', '20250620150845', 'DONE'),
       ('p009-2025-0620-009', '간편결제', 'tgen_20250620160945eBc59', '{
         "vat": 2909,
         "card": {
           "amount": 32000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168064",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-009",
         "orderName": "천백정",
         "approvedAt": "2025-06-20T16:10:25+09:00",
         "paymentKey": "tgen_20250620160945eBc59",
         "receiptUrl": null,
         "totalAmount": 32000,
         "suppliedAmount": 29091,
         "easyPayProvider": null
       }', '20250620161025', '20250620160945', 'DONE'),
       ('p010-2025-0620-010', '간편결제', 'tgen_20250620171045fDe60', '{
         "vat": 1636,
         "card": {
           "amount": 18000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168065",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-010",
         "orderName": "유한m 오메가-3 비거파워",
         "approvedAt": "2025-06-20T17:11:35+09:00",
         "paymentKey": "tgen_20250620171045fDe60",
         "receiptUrl": null,
         "totalAmount": 18000,
         "suppliedAmount": 16364,
         "easyPayProvider": null
       }', '20250620171135', '20250620171045', 'DONE'),
       ('p011-2025-0620-011', '카드결제', 'tgen_20250620181145gFh71', '{
         "vat": 3636,
         "card": {
           "amount": 40000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168066",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-011",
         "orderName": "큐자임",
         "approvedAt": "2025-06-20T18:12:45+09:00",
         "paymentKey": "tgen_20250620181145gFh71",
         "receiptUrl": null,
         "totalAmount": 40000,
         "suppliedAmount": 36364,
         "easyPayProvider": null
       }', '20250620181245', '20250620181145', 'DONE'),
       ('p012-2025-0620-012', '간편결제', 'tgen_20250620191245hGi82', '{
         "vat": 4545,
         "card": {
           "amount": 50000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168067",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-012",
         "orderName": "가바트리플 2개",
         "approvedAt": "2025-06-20T19:13:55+09:00",
         "paymentKey": "tgen_20250620191245hGi82",
         "receiptUrl": null,
         "totalAmount": 50000,
         "suppliedAmount": 45455,
         "easyPayProvider": null
       }', '20250620191355', '20250620191245', 'DONE'),
       ('p013-2025-0620-013', '간편결제', 'tgen_20250620201345iJk93', '{
         "vat": 2727,
         "card": {
           "amount": 30000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168068",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-013",
         "orderName": "홍삼타브렛 외 1건",
         "approvedAt": "2025-06-20T20:14:05+09:00",
         "paymentKey": "tgen_20250620201345iJk93",
         "receiptUrl": null,
         "totalAmount": 30000,
         "suppliedAmount": 27273,
         "easyPayProvider": null
       }', '20250620201405', '20250620201345', 'DONE'),
       ('p014-2025-0620-014', '카드결제', 'tgen_20250620211445jLm04', '{
         "vat": 3636,
         "card": {
           "amount": 40000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168069",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-014",
         "orderName": "알로에아보레센스 2개",
         "approvedAt": "2025-06-20T21:15:15+09:00",
         "paymentKey": "tgen_20250620211445jLm04",
         "receiptUrl": null,
         "totalAmount": 40000,
         "suppliedAmount": 36364,
         "easyPayProvider": null
       }', '20250620211515', '20250620211445', 'DONE'),
       ('p015-2025-0620-015', '간편결제', 'tgen_20250620221545kNp15', '{
         "vat": 5454,
         "card": {
           "amount": 60000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168070",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-015",
         "orderName": "행복한 한컵 락티움 5개",
         "approvedAt": "2025-06-20T22:16:25+09:00",
         "paymentKey": "tgen_20250620221545kNp15",
         "receiptUrl": null,
         "totalAmount": 60000,
         "suppliedAmount": 54546,
         "easyPayProvider": null
       }', '20250620221625', '20250620221545', 'DONE'),
       ('p016-2025-0621-016', '간편결제', 'tgen_20250621081645lQr26', '{
         "vat": 2273,
         "card": {
           "amount": 25000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168071",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-016",
         "orderName": "천지인 키즐홍짱 홍삼액",
         "approvedAt": "2025-06-21T08:17:35+09:00",
         "paymentKey": "tgen_20250621081645lQr26",
         "receiptUrl": null,
         "totalAmount": 25000,
         "suppliedAmount": 22727,
         "easyPayProvider": null
       }', '20250621081735', '20250621081645', 'DONE'),
       ('p017-2025-0621-017', '카드결제', 'tgen_20250621091745mSt37', '{
         "vat": 3273,
         "card": {
           "amount": 36000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168072",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-017",
         "orderName": "Silver plus propolis 2개",
         "approvedAt": "2025-06-21T09:18:45+09:00",
         "paymentKey": "tgen_20250621091745mSt37",
         "receiptUrl": null,
         "totalAmount": 36000,
         "suppliedAmount": 32727,
         "easyPayProvider": null
       }', '20250621091845', '20250621091745', 'DONE'),
       ('p018-2025-0621-018', '간편결제', 'tgen_20250621101845nUv48', '{
         "vat": 2727,
         "card": {
           "amount": 30000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168073",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-018",
         "orderName": "미라클 3개",
         "approvedAt": "2025-06-21T10:19:55+09:00",
         "paymentKey": "tgen_20250621101845nUv48",
         "receiptUrl": null,
         "totalAmount": 30000,
         "suppliedAmount": 27273,
         "easyPayProvider": null
       }', '20250621101955', '20250621101845', 'DONE'),
       ('p019-2025-0621-019', '간편결제', 'tgen_20250621111945oWx59', '{
         "vat": 2909,
         "card": {
           "amount": 32000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168074",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-019",
         "orderName": "천백정",
         "approvedAt": "2025-06-21T11:20:05+09:00",
         "paymentKey": "tgen_20250621111945oWx59",
         "receiptUrl": null,
         "totalAmount": 32000,
         "suppliedAmount": 29091,
         "easyPayProvider": null
       }', '20250621112005', '20250621111945', 'DONE'),
       ('p020-2025-0621-020', '카드결제', 'tgen_20250621122045pYz60', '{
         "vat": 6364,
         "card": {
           "amount": 70000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168075",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-020",
         "orderName": "가바트리플 외 2건",
         "approvedAt": "2025-06-21T12:21:15+09:00",
         "paymentKey": "tgen_20250621122045pYz60",
         "receiptUrl": null,
         "totalAmount": 70000,
         "suppliedAmount": 63636,
         "easyPayProvider": null
       }', '20250621122115', '20250621122045', 'DONE'),
       ('p021-2025-0621-021', '간편결제', 'tgen_20250621132145qAb71', '{
         "vat": 1636,
         "card": {
           "amount": 18000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168076",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-021",
         "orderName": "유한m 오메가-3 비거파워",
         "approvedAt": "2025-06-21T13:22:25+09:00",
         "paymentKey": "tgen_20250621132145qAb71",
         "receiptUrl": null,
         "totalAmount": 18000,
         "suppliedAmount": 16364,
         "easyPayProvider": null
       }', '20250621132225', '20250621132145', 'DONE'),
       ('p022-2025-0621-022', '간편결제', 'tgen_20250621142245rCd82', '{
         "vat": 7273,
         "card": {
           "amount": 80000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168077",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-022",
         "orderName": "큐자임 2개",
         "approvedAt": "2025-06-21T14:23:35+09:00",
         "paymentKey": "tgen_20250621142245rCd82",
         "receiptUrl": null,
         "totalAmount": 80000,
         "suppliedAmount": 72727,
         "easyPayProvider": null
       }', '20250621142335', '20250621142245', 'DONE'),
       ('p023-2025-0621-023', '카드결제', 'tgen_20250621152345sEf93', '{
         "vat": 1818,
         "card": {
           "amount": 20000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168078",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-023",
         "orderName": "종근당건강멀티비타민포우먼",
         "approvedAt": "2025-06-21T15:24:45+09:00",
         "paymentKey": "tgen_20250621152345sEf93",
         "receiptUrl": null,
         "totalAmount": 20000,
         "suppliedAmount": 18182,
         "easyPayProvider": null
       }', '20250621152445', '20250621152345', 'DONE'),
       ('p024-2025-0621-024', '간편결제', 'tgen_20250621162445tGh04', '{
         "vat": 4091,
         "card": {
           "amount": 45000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168079",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-024",
         "orderName": "홍삼타브렛 외 1건",
         "approvedAt": "2025-06-21T16:25:55+09:00",
         "paymentKey": "tgen_20250621162445tGh04",
         "receiptUrl": null,
         "totalAmount": 45000,
         "suppliedAmount": 40909,
         "easyPayProvider": null
       }', '20250621162555', '20250621162445', 'DONE'),
       ('p025-2025-0621-025', '간편결제', 'tgen_20250621172545uIj15', '{
         "vat": 2727,
         "card": {
           "amount": 30000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168080",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-025",
         "orderName": "알로에아보레센스 외 1건",
         "approvedAt": "2025-06-21T17:26:05+09:00",
         "paymentKey": "tgen_20250621172545uIj15",
         "receiptUrl": null,
         "totalAmount": 30000,
         "suppliedAmount": 27273,
         "easyPayProvider": null
       }', '20250621172605', '20250621172545', 'DONE'),
       ('p026-2025-0621-026', '카드결제', 'tgen_20250621182645vKl26', '{
         "vat": 3636,
         "card": {
           "amount": 40000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168081",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-026",
         "orderName": "천지인 키즐홍짱 홍삼액 외 1건",
         "approvedAt": "2025-06-21T18:27:15+09:00",
         "paymentKey": "tgen_20250621182645vKl26",
         "receiptUrl": null,
         "totalAmount": 40000,
         "suppliedAmount": 36364,
         "easyPayProvider": null
       }', '20250621182715', '20250621182645', 'DONE'),
       ('p027-2025-0621-027', '간편결제', 'tgen_20250621192745wMn37', '{
         "vat": 1818,
         "card": {
           "amount": 20000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168082",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-027",
         "orderName": "미라클 2개",
         "approvedAt": "2025-06-21T19:28:25+09:00",
         "paymentKey": "tgen_20250621192745wMn37",
         "receiptUrl": null,
         "totalAmount": 20000,
         "suppliedAmount": 18182,
         "easyPayProvider": null
       }', '20250621192825', '20250621192745', 'DONE'),
       ('p028-2025-0621-028', '간편결제', 'tgen_20250621202845xOp48', '{
         "vat": 5454,
         "card": {
           "amount": 60000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168083",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-028",
         "orderName": "Silver plus propolis 외 2건",
         "approvedAt": "2025-06-21T20:29:35+09:00",
         "paymentKey": "tgen_20250621202845xOp48",
         "receiptUrl": null,
         "totalAmount": 60000,
         "suppliedAmount": 54546,
         "easyPayProvider": null
       }', '20250621202935', '20250621202845', 'DONE'),
       ('p029-2025-0621-029', '카드결제', 'tgen_20250621212945yQr59', '{
         "vat": 2909,
         "card": {
           "amount": 32000,
           "number": "544125**********",
           "cardType": "신용",
           "approveNo": "00168084",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "카드결제",
         "status": "DONE",
         "orderId": "ord-029",
         "orderName": "천백정",
         "approvedAt": "2025-06-21T21:30:45+09:00",
         "paymentKey": "tgen_20250621212945yQr59",
         "receiptUrl": null,
         "totalAmount": 32000,
         "suppliedAmount": 29091,
         "easyPayProvider": null
       }', '20250621213045', '20250621212945', 'DONE'),
       ('p030-2025-0621-030', '간편결제', 'tgen_20250621223045zSt60', '{
         "vat": 3636,
         "card": {
           "amount": 40000,
           "number": "433028**********",
           "cardType": "신용",
           "approveNo": "00168085",
           "ownerType": "개인",
           "installmentPlanMonths": 0
         },
         "method": "간편결제",
         "status": "DONE",
         "orderId": "ord-030",
         "orderName": "유한m 오메가-3 비거파워 외 1건",
         "approvedAt": "2025-06-21T22:31:55+09:00",
         "paymentKey": "tgen_20250621223045zSt60",
         "receiptUrl": null,
         "totalAmount": 40000,
         "suppliedAmount": 36364,
         "easyPayProvider": null
       }', '20250621223155', '20250621223045', 'DONE');

-- ORDERS_M 더미 데이터 30개
INSERT INTO `ORDERS_M`
(`order_id`, `payments_id`, `user_id`, `order_status_code`, `discount_amount`, `order_date`, `total_amount`,
 `shipping_req`, `created_at`, `postal_code`, `basic_address`, `detail_address`)
VALUES ('ord-001', 'p001-2025-0620-001', 2, 'DONE', 0, '20250620080145', 30000, '문앞에 놓아주세요', '20250620080145', '06235',
        '서울 강남구 테헤란로 152', '강남파이낸스센터 101호'),
       ('ord-002', 'p002-2025-0620-002', 3, 'DONE', 0, '20250620090245', 20000, '경비실에 맡겨주세요', '20250620090245', '06292',
        '서울 강남구 역삼동 735', '스타타워 201호'),
       ('ord-003', 'p003-2025-0620-003', 4, 'DONE', 0, '20250620100345', 12000, NULL, '20250620100345', '06174',
        '서울 강남구 논현로 507', '강남빌딩 301호'),
       ('ord-004', 'p004-2025-0620-004', 5, 'DONE', 0, '20250620110445', 20000, '부재시 연락주세요', '20250620110445', '06085',
        '서울 강남구 선릉로 428', '대치타워 401호'),
       ('ord-005', 'p005-2025-0620-005', 6, 'DONE', 0, '20250620120545', 25000, '조심히 다뤄주세요', '20250620120545', '06267',
        '서울 강남구 강남대로 390', '미성빌딩 501호'),
       ('ord-006', 'p006-2025-0620-006', 2, 'DONE', 0, '20250620130645', 18000, '직접 수령', '20250620130645', '06235',
        '서울 강남구 테헤란로 152', '강남파이낸스센터 102호'),
       ('ord-007', 'p007-2025-0620-007', 3, 'DONE', 0, '20250620140745', 20000, NULL, '20250620140745', '06292',
        '서울 강남구 역삼동 735', '스타타워 202호'),
       ('ord-008', 'p008-2025-0620-008', 4, 'DONE', 0, '20250620150845', 10000, '벨 누르지 마세요', '20250620150845', '06174',
        '서울 강남구 논현로 507', '강남빌딩 302호'),
       ('ord-009', 'p009-2025-0620-009', 5, 'DONE', 0, '20250620160945', 32000, '오후 배송 희망', '20250620160945', '06085',
        '서울 강남구 선릉로 428', '대치타워 402호'),
       ('ord-010', 'p010-2025-0620-010', 6, 'DONE', 0, '20250620171045', 18000, NULL, '20250620171045', '06267',
        '서울 강남구 강남대로 390', '미성빌딩 502호'),
       ('ord-011', 'p011-2025-0620-011', 2, 'DONE', 0, '20250620181145', 40000, '문앞에 놓아주세요', '20250620181145', '06235',
        '서울 강남구 테헤란로 152', '강남파이낸스센터 103호'),
       ('ord-012', 'p012-2025-0620-012', 3, 'DONE', 0, '20250620191245', 50000, '경비실에 맡겨주세요', '20250620191245', '06292',
        '서울 강남구 역삼동 735', '스타타워 203호'),
       ('ord-013', 'p013-2025-0620-013', 4, 'DONE', 0, '20250620201345', 30000, '부재시 연락주세요', '20250620201345', '06174',
        '서울 강남구 논현로 507', '강남빌딩 303호'),
       ('ord-014', 'p014-2025-0620-014', 5, 'DONE', 0, '20250620211445', 40000, NULL, '20250620211445', '06085',
        '서울 강남구 선릉로 428', '대치타워 403호'),
       ('ord-015', 'p015-2025-0620-015', 6, 'DONE', 0, '20250620221545', 60000, '조심히 다뤄주세요', '20250620221545', '06267',
        '서울 강남구 강남대로 390', '미성빌딩 503호'),
       ('ord-016', 'p016-2025-0621-016', 2, 'DONE', 0, '20250621081645', 25000, '직접 수령', '20250621081645', '06235',
        '서울 강남구 테헤란로 152', '강남파이낸스센터 104호'),
       ('ord-017', 'p017-2025-0621-017', 3, 'DONE', 0, '20250621091745', 36000, '문앞에 놓아주세요', '20250621091745', '06292',
        '서울 강남구 역삼동 735', '스타타워 204호'),
       ('ord-018', 'p018-2025-0621-018', 4, 'DONE', 0, '20250621101845', 30000, NULL, '20250621101845', '06174',
        '서울 강남구 논현로 507', '강남빌딩 304호'),
       ('ord-019', 'p019-2025-0621-019', 5, 'DONE', 0, '20250621111945', 32000, '벨 누르지 마세요', '20250621111945', '06085',
        '서울 강남구 선릉로 428', '대치타워 404호'),
       ('ord-020', 'p020-2025-0621-020', 6, 'DONE', 0, '20250621122045', 70000, '오후 배송 희망', '20250621122045', '06267',
        '서울 강남구 강남대로 390', '미성빌딩 504호'),
       ('ord-021', 'p021-2025-0621-021', 2, 'DONE', 0, '20250621132145', 18000, '경비실에 맡겨주세요', '20250621132145', '06235',
        '서울 강남구 테헤란로 152', '강남파이낸스센터 105호'),
       ('ord-022', 'p022-2025-0621-022', 3, 'DONE', 0, '20250621142245', 80000, NULL, '20250621142245', '06292',
        '서울 강남구 역삼동 735', '스타타워 205호'),
       ('ord-023', 'p023-2025-0621-023', 4, 'DONE', 0, '20250621152345', 20000, '부재시 연락주세요', '20250621152345', '06174',
        '서울 강남구 논현로 507', '강남빌딩 305호'),
       ('ord-024', 'p024-2025-0621-024', 5, 'DONE', 0, '20250621162445', 45000, '조심히 다뤄주세요', '20250621162445', '06085',
        '서울 강남구 선릉로 428', '대치타워 405호'),
       ('ord-025', 'p025-2025-0621-025', 6, 'DONE', 0, '20250621172545', 30000, '직접 수령', '20250621172545', '06267',
        '서울 강남구 강남대로 390', '미성빌딩 505호'),
       ('ord-026', 'p026-2025-0621-026', 2, 'DONE', 0, '20250621182645', 40000, '문앞에 놓아주세요', '20250621182645', '06235',
        '서울 강남구 테헤란로 152', '강남파이낸스센터 106호'),
       ('ord-027', 'p027-2025-0621-027', 3, 'DONE', 0, '20250621192745', 20000, NULL, '20250621192745', '06292',
        '서울 강남구 역삼동 735', '스타타워 206호'),
       ('ord-028', 'p028-2025-0621-028', 4, 'DONE', 0, '20250621202845', 60000, '벨 누르지 마세요', '20250621202845', '06174',
        '서울 강남구 논현로 507', '강남빌딩 306호'),
       ('ord-029', 'p029-2025-0621-029', 5, 'DONE', 0, '20250621212945', 32000, '오후 배송 희망', '20250621212945', '06085',
        '서울 강남구 선릉로 428', '대치타워 406호'),
       ('ord-030', 'p030-2025-0621-030', 6, 'DONE', 0, '20250621223045', 40000, '경비실에 맡겨주세요', '20250621223045', '06267',
        '서울 강남구 강남대로 390', '미성빌딩 506호');
-- ORDER_ITEM_D 더미 데이터 30개
INSERT INTO `ORDER_ITEM_D` (`order_item_id`, `order_id`, `product_id`, `quantity`, `created_at`)
VALUES ('oi-001-20250620-001', 'ord-001', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, '20250620080145'),
       ('oi-002-20250620-002', 'ord-002', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, '20250620090245'),
       ('oi-003-20250620-003', 'ord-003', '64b56eed-5f4c-4061-9c70-192261b418b5', 1, '20250620100345'),
       ('oi-004-20250620-004', 'ord-004', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, '20250620110445'),
       ('oi-005-20250620-005', 'ord-005', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 1, '20250620120545'),
       ('oi-006-20250620-006', 'ord-006', '087a9785-4ca6-4cc1-b75f-0887ff416791', 1, '20250620130645'),
       ('oi-007-20250620-007', 'ord-007', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, '20250620140745'),
       ('oi-008-20250620-008', 'ord-008', '590b598b-3577-4f43-8e36-6ed31866b8c9', 1, '20250620150845'),
       ('oi-009-20250620-009', 'ord-009', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 1, '20250620160945'),
       ('oi-010-20250620-010', 'ord-010', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, '20250620171045'),
       ('oi-011-20250620-011', 'ord-011', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 1, '20250620181145'),
       ('oi-012-20250620-012', 'ord-012', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 2, '20250620191245'),
       ('oi-013-20250620-013', 'ord-013', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, '20250620201345'),
       ('oi-013-20250620-013-2', 'ord-013', '590b598b-3577-4f43-8e36-6ed31866b8c9', 1, '20250620201345'),
       ('oi-014-20250620-014', 'ord-014', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 2, '20250620211445'),
       ('oi-015-20250620-015', 'ord-015', '64b56eed-5f4c-4061-9c70-192261b418b5', 5, '20250620221545'),
       ('oi-016-20250621-016', 'ord-016', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 1, '20250621081645'),
       ('oi-017-20250621-017', 'ord-017', '087a9785-4ca6-4cc1-b75f-0887ff416791', 2, '20250621091745'),
       ('oi-018-20250621-018', 'ord-018', '590b598b-3577-4f43-8e36-6ed31866b8c9', 3, '20250621101845'),
       ('oi-019-20250621-019', 'ord-019', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 1, '20250621111945'),
       ('oi-020-20250621-020', 'ord-020', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, '20250621122045'),
       ('oi-020-20250621-020-2', 'ord-020', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, '20250621122045'),
       ('oi-020-20250621-020-3', 'ord-020', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, '20250621122045'),
       ('oi-021-20250621-021', 'ord-021', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, '20250621132145'),
       ('oi-022-20250621-022', 'ord-022', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 2, '20250621142245'),
       ('oi-023-20250621-023', 'ord-023', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, '20250621152345'),
       ('oi-024-20250621-024', 'ord-024', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, '20250621162445'),
       ('oi-024-20250621-024-2', 'ord-024', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, '20250621162445'),
       ('oi-025-20250621-025', 'ord-025', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, '20250621172545'),
       ('oi-025-20250621-025-2', 'ord-025', '590b598b-3577-4f43-8e36-6ed31866b8c9', 1, '20250621172545'),
       ('oi-026-20250621-026', 'ord-026', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 1, '20250621182645'),
       ('oi-026-20250621-026-2', 'ord-026', '64b56eed-5f4c-4061-9c70-192261b418b5', 1, '20250621182645'),
       ('oi-027-20250621-027', 'ord-027', '590b598b-3577-4f43-8e36-6ed31866b8c9', 2, '20250621192745'),
       ('oi-028-20250621-028', 'ord-028', '087a9785-4ca6-4cc1-b75f-0887ff416791', 1, '20250621202845'),
       ('oi-028-20250621-028-2', 'ord-028', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, '20250621202845'),
       ('oi-028-20250621-028-3', 'ord-028', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, '20250621202845'),
       ('oi-029-20250621-029', 'ord-029', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 1, '20250621212945'),
       ('oi-030-20250621-030', 'ord-030', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, '20250621223045'),
       ('oi-030-20250621-030-2', 'ord-030', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 1, '20250621223045');
-- LIVE_VIEWER_LOG 더미 데이터 30개
INSERT INTO `LIVE_VIEWER_LOG` (`live_id`, `user_id`, `join_at`, `leave_at`, `is_anonymous`)
VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', '2', '2025-06-20 09:00:00', '2025-06-20 09:45:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '3', '2025-06-20 09:05:00', '2025-06-20 09:50:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '4', '2025-06-20 09:10:00', '2025-06-20 09:55:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '5', '2025-06-20 09:15:00', '2025-06-20 10:00:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '6', '2025-06-20 09:20:00', '2025-06-20 10:05:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2001', '2025-06-20 09:25:00', '2025-06-20 10:10:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2002', '2025-06-20 09:30:00', '2025-06-20 10:15:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2003', '2025-06-20 09:35:00', '2025-06-20 10:20:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2004', '2025-06-20 09:40:00', '2025-06-20 10:25:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2005', '2025-06-20 09:45:00', '2025-06-20 10:30:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '2', '2025-06-20 14:00:00', '2025-06-20 14:30:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '3', '2025-06-20 14:05:00', '2025-06-20 14:35:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '4', '2025-06-20 14:10:00', '2025-06-20 14:40:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '5', '2025-06-20 14:15:00', '2025-06-20 14:45:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '6', '2025-06-20 14:20:00', '2025-06-20 14:50:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2006', '2025-06-20 14:25:00', '2025-06-20 14:55:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2007', '2025-06-20 14:30:00', '2025-06-20 15:00:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2008', '2025-06-20 14:35:00', '2025-06-20 15:05:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2009', '2025-06-20 14:40:00', '2025-06-20 15:10:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2010', '2025-06-20 14:45:00', '2025-06-20 15:15:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '2', '2025-06-20 19:00:00', '2025-06-20 19:40:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '3', '2025-06-20 19:05:00', '2025-06-20 19:45:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '4', '2025-06-20 19:10:00', '2025-06-20 19:50:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '5', '2025-06-20 19:15:00', '2025-06-20 19:55:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', '6', '2025-06-20 19:20:00', '2025-06-20 20:00:00', FALSE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2011', '2025-06-20 19:25:00', '2025-06-20 20:05:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2012', '2025-06-20 19:30:00', '2025-06-20 20:10:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2013', '2025-06-20 19:35:00', '2025-06-20 20:15:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2014', '2025-06-20 19:40:00', '2025-06-20 20:20:00', TRUE),
       ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'guest-uuid-2015', '2025-06-20 19:45:00', '2025-06-20 20:25:00', TRUE);
-- LIVE_PRODUCT_J 더미 데이터 30개
INSERT INTO `LIVE_PRODUCT_J` (`live_product_id`, `live_id`, `product_id`, `discountRate`)
VALUES (3, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 10),
       (4, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 15),
       (5, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '64b56eed-5f4c-4061-9c70-192261b418b5', 20),
       (6, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 12),
       (7, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 8),
       (8, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '087a9785-4ca6-4cc1-b75f-0887ff416791', 18),
       (9, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 25),
       (10, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '590b598b-3577-4f43-8e36-6ed31866b8c9', 30),
       (11, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 5),
       (12, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 22),
       (13, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 15),
       (14, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 12),
       (15, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 18),
       (16, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '64b56eed-5f4c-4061-9c70-192261b418b5', 25),
       (17, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 10),
       (18, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 14),
       (19, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '087a9785-4ca6-4cc1-b75f-0887ff416791', 20),
       (20, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 16),
       (21, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '590b598b-3577-4f43-8e36-6ed31866b8c9', 28),
       (22, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 8),
       (23, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 24),
       (24, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 17),
       (25, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 13),
       (26, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 19),
       (27, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '64b56eed-5f4c-4061-9c70-192261b418b5', 21),
       (28, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 11),
       (29, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 6),
       (30, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '087a9785-4ca6-4cc1-b75f-0887ff416791', 23),
       (31, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 27),
       (32, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '590b598b-3577-4f43-8e36-6ed31866b8c9', 9);
-- LIVE_DASHBOARD_D 더미 데이터 30개
INSERT INTO `LIVE_DASHBOARD_D` (`liveDashboard_id`, `live_id`, `total_viewers`, `purchase_ratio`, `total_orders`,
                                `total_reve`, `purchase_rate`)
VALUES ('dash-001-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 150, 25, 8, 280000, 65),
       ('dash-002-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 180, 22, 12, 420000, 58),
       ('dash-003-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 200, 28, 15, 650000, 72),
       ('dash-004-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 165, 30, 18, 780000, 75),
       ('dash-005-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 220, 24, 22, 920000, 62),
       ('dash-006-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 195, 26, 20, 850000, 68),
       ('dash-007-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 175, 32, 25, 1100000, 78),
       ('dash-008-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 210, 27, 28, 1250000, 70),
       ('dash-009-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 185, 29, 30, 1350000, 73),
       ('dash-010-20250620', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 240, 31, 35, 1580000, 76),
       ('dash-011-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 260, 33, 40, 1780000, 80),
       ('dash-012-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 280, 35, 45, 2100000, 82),
       ('dash-013-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 255, 28, 38, 1650000, 71),
       ('dash-014-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 275, 36, 48, 2350000, 85),
       ('dash-015-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 290, 32, 42, 1980000, 78),
       ('dash-016-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 310, 38, 52, 2680000, 88),
       ('dash-017-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 295, 34, 46, 2120000, 81),
       ('dash-018-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 320, 40, 58, 3100000, 92),
       ('dash-019-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 305, 37, 55, 2850000, 86),
       ('dash-020-20250621', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 285, 29, 41, 1920000, 74),
       ('dash-021-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 270, 31, 43, 2050000, 77),
       ('dash-022-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 315, 39, 59, 3200000, 90),
       ('dash-023-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 300, 35, 50, 2750000, 83),
       ('dash-024-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 325, 42, 62, 3500000, 95),
       ('dash-025-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 290, 33, 47, 2280000, 79),
       ('dash-026-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 340, 45, 68, 4100000, 98),
       ('dash-027-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 335, 41, 65, 3850000, 94),
       ('dash-028-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 280, 30, 44, 2150000, 75),
       ('dash-029-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 350, 47, 72, 4500000, 100),
       ('dash-030-20250622', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 365, 50, 78, 5200000, 105);


-- PAYMENT_D 2024년 더미 데이터 20개 (1월~5월)



INSERT INTO `PAYMENT_D` (`payments_id`,`payment_method`,`payment_Key`,`payment_payload`,`paid_at`,`created_at`,`payment_status_code`) VALUES
                                                                                                                                          ('p2024-001-0115-001', '간편결제', 'tgen_20240115080145aLm01', '{"vat": 2727, "card": {"amount": 30000, "number": "433028**********", "cardType": "신용", "approveNo": "00157001", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-001", "orderName": "가바트리플", "approvedAt": "2024-01-15T08:02:03+09:00", "paymentKey": "tgen_20240115080145aLm01", "receiptUrl": null, "totalAmount": 30000, "suppliedAmount": 27273, "easyPayProvider": null}', '20240115080203', '20240115080145', 'DONE'),
                                                                                                                                          ('p2024-002-0125-002', '카드결제', 'tgen_20240125090245bNp02', '{"vat": 1818, "card": {"amount": 20000, "number": "544125**********", "cardType": "신용", "approveNo": "00157002", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-002", "orderName": "알로에아보레센스", "approvedAt": "2024-01-25T09:03:15+09:00", "paymentKey": "tgen_20240125090245bNp02", "receiptUrl": null, "totalAmount": 20000, "suppliedAmount": 18182, "easyPayProvider": null}', '20240125090315', '20240125090245', 'DONE'),
                                                                                                                                          ('p2024-003-0208-003', '간편결제', 'tgen_20240208100345cQr03', '{"vat": 1091, "card": {"amount": 12000, "number": "433028**********", "cardType": "신용", "approveNo": "00157003", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-003", "orderName": "행복한 한컵 락티움", "approvedAt": "2024-02-08T10:04:25+09:00", "paymentKey": "tgen_20240208100345cQr03", "receiptUrl": null, "totalAmount": 12000, "suppliedAmount": 10909, "easyPayProvider": null}', '20240208100425', '20240208100345', 'DONE'),
                                                                                                                                          ('p2024-004-0214-004', '간편결제', 'tgen_20240214110445dSt04', '{"vat": 1818, "card": {"amount": 20000, "number": "433028**********", "cardType": "신용", "approveNo": "00157004", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-004", "orderName": "홍삼타브렛", "approvedAt": "2024-02-14T11:05:35+09:00", "paymentKey": "tgen_20240214110445dSt04", "receiptUrl": null, "totalAmount": 20000, "suppliedAmount": 18182, "easyPayProvider": null}', '20240214110535', '20240214110445', 'DONE'),
                                                                                                                                          ('p2024-005-0228-005', '카드결제', 'tgen_20240228120545eUv05', '{"vat": 2273, "card": {"amount": 25000, "number": "544125**********", "cardType": "신용", "approveNo": "00157005", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-005", "orderName": "천지인 키즐홍짱 홍삼액", "approvedAt": "2024-02-28T12:06:45+09:00", "paymentKey": "tgen_20240228120545eUv05", "receiptUrl": null, "totalAmount": 25000, "suppliedAmount": 22727, "easyPayProvider": null}', '20240228120645', '20240228120545', 'DONE'),
                                                                                                                                          ('p2024-006-0308-006', '간편결제', 'tgen_20240308130645fWx06', '{"vat": 1636, "card": {"amount": 18000, "number": "433028**********", "cardType": "신용", "approveNo": "00157006", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-006", "orderName": "Silver plus propolis", "approvedAt": "2024-03-08T13:07:55+09:00", "paymentKey": "tgen_20240308130645fWx06", "receiptUrl": null, "totalAmount": 18000, "suppliedAmount": 16364, "easyPayProvider": null}', '20240308130755', '20240308130645', 'DONE'),
                                                                                                                                          ('p2024-007-0315-007', '간편결제', 'tgen_20240315140745gYz07', '{"vat": 1818, "card": {"amount": 20000, "number": "433028**********", "cardType": "신용", "approveNo": "00157007", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-007", "orderName": "종근당건강멀티비타민포우먼", "approvedAt": "2024-03-15T14:08:05+09:00", "paymentKey": "tgen_20240315140745gYz07", "receiptUrl": null, "totalAmount": 20000, "suppliedAmount": 18182, "easyPayProvider": null}', '20240315140805', '20240315140745', 'DONE'),
                                                                                                                                          ('p2024-008-0322-008', '카드결제', 'tgen_20240322150845hAb08', '{"vat": 909, "card": {"amount": 10000, "number": "544125**********", "cardType": "신용", "approveNo": "00157008", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-008", "orderName": "미라클", "approvedAt": "2024-03-22T15:09:15+09:00", "paymentKey": "tgen_20240322150845hAb08", "receiptUrl": null, "totalAmount": 10000, "suppliedAmount": 9091, "easyPayProvider": null}', '20240322150915', '20240322150845', 'DONE'),
                                                                                                                                          ('p2024-009-0330-009', '간편결제', 'tgen_20240330160945iCd09', '{"vat": 2909, "card": {"amount": 32000, "number": "433028**********", "cardType": "신용", "approveNo": "00157009", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-009", "orderName": "천백정", "approvedAt": "2024-03-30T16:10:25+09:00", "paymentKey": "tgen_20240330160945iCd09", "receiptUrl": null, "totalAmount": 32000, "suppliedAmount": 29091, "easyPayProvider": null}', '20240330161025', '20240330160945', 'DONE'),
                                                                                                                                          ('p2024-010-0405-010', '간편결제', 'tgen_20240405171045jEf10', '{"vat": 1636, "card": {"amount": 18000, "number": "433028**********", "cardType": "신용", "approveNo": "00157010", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-010", "orderName": "유한m 오메가-3 비거파워", "approvedAt": "2024-04-05T17:11:35+09:00", "paymentKey": "tgen_20240405171045jEf10", "receiptUrl": null, "totalAmount": 18000, "suppliedAmount": 16364, "easyPayProvider": null}', '20240405171135', '20240405171045', 'DONE'),
                                                                                                                                          ('p2024-011-0412-011', '카드결제', 'tgen_20240412181145kGh11', '{"vat": 3636, "card": {"amount": 40000, "number": "544125**********", "cardType": "신용", "approveNo": "00157011", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-011", "orderName": "큐자임", "approvedAt": "2024-04-12T18:12:45+09:00", "paymentKey": "tgen_20240412181145kGh11", "receiptUrl": null, "totalAmount": 40000, "suppliedAmount": 36364, "easyPayProvider": null}', '20240412181245', '20240412181145', 'DONE'),
                                                                                                                                          ('p2024-012-0420-012', '간편결제', 'tgen_20240420191245lIj12', '{"vat": 4545, "card": {"amount": 50000, "number": "433028**********", "cardType": "신용", "approveNo": "00157012", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-012", "orderName": "가바트리플 2개", "approvedAt": "2024-04-20T19:13:55+09:00", "paymentKey": "tgen_20240420191245lIj12", "receiptUrl": null, "totalAmount": 50000, "suppliedAmount": 45455, "easyPayProvider": null}', '20240420191355', '20240420191245', 'DONE'),
                                                                                                                                          ('p2024-013-0428-013', '간편결제', 'tgen_20240428201345mKl13', '{"vat": 2727, "card": {"amount": 30000, "number": "433028**********", "cardType": "신용", "approveNo": "00157013", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-013", "orderName": "홍삼타브렛 외 1건", "approvedAt": "2024-04-28T20:14:05+09:00", "paymentKey": "tgen_20240428201345mKl13", "receiptUrl": null, "totalAmount": 30000, "suppliedAmount": 27273, "easyPayProvider": null}', '20240428201405', '20240428201345', 'DONE'),
                                                                                                                                          ('p2024-014-0505-014', '카드결제', 'tgen_20240505211445nMo14', '{"vat": 3636, "card": {"amount": 40000, "number": "544125**********", "cardType": "신용", "approveNo": "00157014", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-014", "orderName": "알로에아보레센스 2개", "approvedAt": "2024-05-05T21:15:15+09:00", "paymentKey": "tgen_20240505211445nMo14", "receiptUrl": null, "totalAmount": 40000, "suppliedAmount": 36364, "easyPayProvider": null}', '20240505211515', '20240505211445', 'DONE'),
                                                                                                                                          ('p2024-015-0512-015', '간편결제', 'tgen_20240512221545oPq15', '{"vat": 5454, "card": {"amount": 60000, "number": "433028**********", "cardType": "신용", "approveNo": "00157015", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-015", "orderName": "행복한 한컵 락티움 5개", "approvedAt": "2024-05-12T22:16:25+09:00", "paymentKey": "tgen_20240512221545oPq15", "receiptUrl": null, "totalAmount": 60000, "suppliedAmount": 54546, "easyPayProvider": null}', '20240512221625', '20240512221545', 'DONE'),
                                                                                                                                          ('p2024-016-0518-016', '간편결제', 'tgen_20240518081645pRs16', '{"vat": 2273, "card": {"amount": 25000, "number": "433028**********", "cardType": "신용", "approveNo": "00157016", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-016", "orderName": "천지인 키즐홍짱 홍삼액", "approvedAt": "2024-05-18T08:17:35+09:00", "paymentKey": "tgen_20240518081645pRs16", "receiptUrl": null, "totalAmount": 25000, "suppliedAmount": 22727, "easyPayProvider": null}', '20240518081735', '20240518081645', 'DONE'),
                                                                                                                                          ('p2024-017-0525-017', '카드결제', 'tgen_20240525091745qTu17', '{"vat": 3273, "card": {"amount": 36000, "number": "544125**********", "cardType": "신용", "approveNo": "00157017", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-017", "orderName": "Silver plus propolis 2개", "approvedAt": "2024-05-25T09:18:45+09:00", "paymentKey": "tgen_20240525091745qTu17", "receiptUrl": null, "totalAmount": 36000, "suppliedAmount": 32727, "easyPayProvider": null}', '20240525091845', '20240525091745', 'DONE'),
                                                                                                                                          ('p2024-018-0530-018', '간편결제', 'tgen_20240530101845rVw18', '{"vat": 2727, "card": {"amount": 30000, "number": "433028**********", "cardType": "신용", "approveNo": "00157018", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-018", "orderName": "미라클 3개", "approvedAt": "2024-05-30T10:19:55+09:00", "paymentKey": "tgen_20240530101845rVw18", "receiptUrl": null, "totalAmount": 30000, "suppliedAmount": 27273, "easyPayProvider": null}', '20240530101955', '20240530101845', 'DONE'),
                                                                                                                                          ('p2024-019-0531-019', '간편결제', 'tgen_20240531111945sXy19', '{"vat": 2909, "card": {"amount": 32000, "number": "433028**********", "cardType": "신용", "approveNo": "00157019", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "간편결제", "status": "DONE", "orderId": "ord2024-019", "orderName": "천백정", "approvedAt": "2024-05-31T11:20:05+09:00", "paymentKey": "tgen_20240531111945sXy19", "receiptUrl": null, "totalAmount": 32000, "suppliedAmount": 29091, "easyPayProvider": null}', '20240531112005', '20240531111945', 'DONE'),
                                                                                                                                          ('p2024-020-0531-020', '카드결제', 'tgen_20240531122045tZa20', '{"vat": 6364, "card": {"amount": 70000, "number": "544125**********", "cardType": "신용", "approveNo": "00157020", "ownerType": "개인", "installmentPlanMonths": 0}, "method": "카드결제", "status": "DONE", "orderId": "ord2024-020", "orderName": "가바트리플 외 2건", "approvedAt": "2024-05-31T12:21:15+09:00", "paymentKey": "tgen_20240531122045tZa20", "receiptUrl": null, "totalAmount": 70000, "suppliedAmount": 63636, "easyPayProvider": null}', '20240531122115', '20240531122045', 'DONE');

-- ORDERS_M 2024년 더미 데이터 20개 (1월~5월)
INSERT INTO `ORDERS_M`
(`order_id`, `payments_id`, `user_id`, `order_status_code`, `discount_amount`, `order_date`, `total_amount`, `shipping_req`, `created_at`, `postal_code`, `basic_address`, `detail_address`)
VALUES
    ('ord2024-001', 'p2024-001-0115-001', 2, 'DONE', 0, '20240115080145', 30000, '문앞에 놓아주세요', '20240115080145', '06235', '서울 강남구 테헤란로 152', '강남파이낸스센터 101호'),
    ('ord2024-002', 'p2024-002-0125-002', 3, 'DONE', 0, '20240125090245', 20000, '경비실에 맡겨주세요', '20240125090245', '06292', '서울 강남구 역삼동 735', '스타타워 201호'),
    ('ord2024-003', 'p2024-003-0208-003', 4, 'DONE', 0, '20240208100345', 12000, NULL, '20240208100345', '06174', '서울 강남구 논현로 507', '강남빌딩 301호'),
    ('ord2024-004', 'p2024-004-0214-004', 5, 'DONE', 0, '20240214110445', 20000, '부재시 연락주세요', '20240214110445', '06085', '서울 강남구 선릉로 428', '대치타워 401호'),
    ('ord2024-005', 'p2024-005-0228-005', 6, 'DONE', 0, '20240228120545', 25000, '조심히 다뤄주세요', '20240228120545', '06267', '서울 강남구 강남대로 390', '미성빌딩 501호'),
    ('ord2024-006', 'p2024-006-0308-006', 2, 'DONE', 0, '20240308130645', 18000, '직접 수령', '20240308130645', '06235', '서울 강남구 테헤란로 152', '강남파이낸스센터 102호'),
    ('ord2024-007', 'p2024-007-0315-007', 3, 'DONE', 0, '20240315140745', 20000, NULL, '20240315140745', '06292', '서울 강남구 역삼동 735', '스타타워 202호'),
    ('ord2024-008', 'p2024-008-0322-008', 4, 'DONE', 0, '20240322150845', 10000, '벨 누르지 마세요', '20240322150845', '06174', '서울 강남구 논현로 507', '강남빌딩 302호'),
    ('ord2024-009', 'p2024-009-0330-009', 5, 'DONE', 0, '20240330160945', 32000, '오후 배송 희망', '20240330160945', '06085', '서울 강남구 선릉로 428', '대치타워 402호'),
    ('ord2024-010', 'p2024-010-0405-010', 6, 'DONE', 0, '20240405171045', 18000, NULL, '20240405171045', '06267', '서울 강남구 강남대로 390', '미성빌딩 502호'),
    ('ord2024-011', 'p2024-011-0412-011', 2, 'DONE', 0, '20240412181145', 40000, '문앞에 놓아주세요', '20240412181145', '06235', '서울 강남구 테헤란로 152', '강남파이낸스센터 103호'),
    ('ord2024-012', 'p2024-012-0420-012', 3, 'DONE', 0, '20240420191245', 50000, '경비실에 맡겨주세요', '20240420191245', '06292', '서울 강남구 역삼동 735', '스타타워 203호'),
    ('ord2024-013', 'p2024-013-0428-013', 4, 'DONE', 0, '20240428201345', 30000, '부재시 연락주세요', '20240428201345', '06174', '서울 강남구 논현로 507', '강남빌딩 303호'),
    ('ord2024-014', 'p2024-014-0505-014', 5, 'DONE', 0, '20240505211445', 40000, NULL, '20240505211445', '06085', '서울 강남구 선릉로 428', '대치타워 403호'),
    ('ord2024-015', 'p2024-015-0512-015', 6, 'DONE', 0, '20240512221545', 60000, '조심히 다뤄주세요', '20240512221545', '06267', '서울 강남구 강남대로 390', '미성빌딩 503호'),
    ('ord2024-016', 'p2024-016-0518-016', 2, 'DONE', 0, '20240518081645', 25000, '직접 수령', '20240518081645', '06235', '서울 강남구 테헤란로 152', '강남파이낸스센터 104호'),
    ('ord2024-017', 'p2024-017-0525-017', 3, 'DONE', 0, '20240525091745', 36000, '문앞에 놓아주세요', '20240525091745', '06292', '서울 강남구 역삼동 735', '스타타워 204호'),
    ('ord2024-018', 'p2024-018-0530-018', 4, 'DONE', 0, '20240530101845', 30000, NULL, '20240530101845', '06174', '서울 강남구 논현로 507', '강남빌딩 304호'),
    ('ord2024-019', 'p2024-019-0531-019', 5, 'DONE', 0, '20240531111945', 32000, '벨 누르지 마세요', '20240531111945', '06085', '서울 강남구 선릉로 428', '대치타워 404호'),
    ('ord2024-020', 'p2024-020-0531-020', 6, 'DONE', 0, '20240531122045', 70000, '오후 배송 희망', '20240531122045', '06267', '서울 강남구 강남대로 390', '미성빌딩 504호');
-- ORDER_ITEM_D 2024년 더미 데이터 26개 (1월~5월)
INSERT INTO `ORDER_ITEM_D` (`order_item_id`,`order_id`,`product_id`,`quantity`,`created_at`) VALUES
                                                                                                 ('oi2024-001-0115-001', 'ord2024-001', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, '20240115080145'),
                                                                                                 ('oi2024-002-0125-002', 'ord2024-002', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, '20240125090245'),
                                                                                                 ('oi2024-003-0208-003', 'ord2024-003', '64b56eed-5f4c-4061-9c70-192261b418b5', 1, '20240208100345'),
                                                                                                 ('oi2024-004-0214-004', 'ord2024-004', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, '20240214110445'),
                                                                                                 ('oi2024-005-0228-005', 'ord2024-005', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 1, '20240228120545'),
                                                                                                 ('oi2024-006-0308-006', 'ord2024-006', '087a9785-4ca6-4cc1-b75f-0887ff416791', 1, '20240308130645'),
                                                                                                 ('oi2024-007-0315-007', 'ord2024-007', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, '20240315140745'),
                                                                                                 ('oi2024-008-0322-008', 'ord2024-008', '590b598b-3577-4f43-8e36-6ed31866b8c9', 1, '20240322150845'),
                                                                                                 ('oi2024-009-0330-009', 'ord2024-009', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 1, '20240330160945'),
                                                                                                 ('oi2024-010-0405-010', 'ord2024-010', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, '20240405171045'),
                                                                                                 ('oi2024-011-0412-011', 'ord2024-011', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 1, '20240412181145'),
                                                                                                 ('oi2024-012-0420-012', 'ord2024-012', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 2, '20240420191245'),
                                                                                                 ('oi2024-013-0428-013', 'ord2024-013', 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, '20240428201345'),
                                                                                                 ('oi2024-013-0428-013-2', 'ord2024-013', '590b598b-3577-4f43-8e36-6ed31866b8c9', 1, '20240428201345'),
                                                                                                 ('oi2024-014-0505-014', 'ord2024-014', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 2, '20240505211445'),
                                                                                                 ('oi2024-015-0512-015', 'ord2024-015', '64b56eed-5f4c-4061-9c70-192261b418b5', 5, '20240512221545'),
                                                                                                 ('oi2024-016-0518-016', 'ord2024-016', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 1, '20240518081645'),
                                                                                                 ('oi2024-017-0525-017', 'ord2024-017', '087a9785-4ca6-4cc1-b75f-0887ff416791', 2, '20240525091745'),
                                                                                                 ('oi2024-018-0530-018', 'ord2024-018', '590b598b-3577-4f43-8e36-6ed31866b8c9', 3, '20240530101845'),
                                                                                                 ('oi2024-019-0531-019', 'ord2024-019', 'f32f11bb-30a7-4f1a-a9d7-3d1ffbb44367', 1, '20240531111945'),
                                                                                                 ('oi2024-020-0531-020', 'ord2024-020', 'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, '20240531122045'),
                                                                                                 ('oi2024-020-0531-020-2', 'ord2024-020', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, '20240531122045'),
                                                                                                 ('oi2024-020-0531-020-3', 'ord2024-020', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 1, '20240531122045'),
                                                                                                 ('oi2024-020-0531-020-4', 'ord2024-020', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, '20240531122045'),
                                                                                                 ('oi2024-021-0530-021', 'ord2024-018', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, '20240530101845'),
                                                                                                 ('oi2024-022-0531-022', 'ord2024-019', '2cc10b17-802e-466f-a89e-8ef0e39b62e6', 1, '20240531111945');
-- 2025년 5월 주문 데이터 (약 640,000원 매출)
-- 현재 6월 대비 50% 증가 효과를 위한 데이터
-- 1. PAYMENT_D 먼저 (JSON 이스케이프 처리)
INSERT INTO `PAYMENT_D` (`payments_id`,`payment_method`,`payment_Key`,`payment_payload`,`paid_at`,`created_at`,`payment_status_code`) VALUES
                                                                                                                                          ('may2025-pay-001-abc123def456ghi7', '카드결제', 'tgen_20250505142030may01', '{\"vat\": 9091, \"card\": {\"amount\": 100000, \"number\": \"545454**********\", \"cardType\": \"신용\", \"approveNo\": \"00150001\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"카드결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-001\", \"orderName\": \"프로폴리스\", \"approvedAt\": \"2025-05-05T14:20:45+09:00\", \"paymentKey\": \"tgen_20250505142030may01\", \"receiptUrl\": null, \"totalAmount\": 100000, \"suppliedAmount\": 90909, \"easyPayProvider\": null}', '20250505142045', '20250505142030', 'DONE'),
                                                                                                                                          ('may2025-pay-002-def456ghi789jkl0', '간편결제', 'tgen_20250512103015may02', '{\"vat\": 13636, \"card\": {\"amount\": 150000, \"number\": \"433028**********\", \"cardType\": \"신용\", \"approveNo\": \"00150002\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"간편결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-002\", \"orderName\": \"비타민\", \"approvedAt\": \"2025-05-12T10:30:30+09:00\", \"paymentKey\": \"tgen_20250512103015may02\", \"receiptUrl\": null, \"totalAmount\": 150000, \"suppliedAmount\": 136364, \"easyPayProvider\": null}', '20250512103030', '20250512103015', 'DONE'),
                                                                                                                                          ('may2025-pay-003-ghi789jkl012mno3', '카드결제', 'tgen_20250518155030may03', '{\"vat\": 18182, \"card\": {\"amount\": 200000, \"number\": \"654321**********\", \"cardType\": \"신용\", \"approveNo\": \"00150003\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"카드결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-003\", \"orderName\": \"홍삼정\", \"approvedAt\": \"2025-05-18T15:50:45+09:00\", \"paymentKey\": \"tgen_20250518155030may03\", \"receiptUrl\": null, \"totalAmount\": 200000, \"suppliedAmount\": 181818, \"easyPayProvider\": null}', '20250518155045', '20250518155030', 'DONE'),
                                                                                                                                          ('may2025-pay-004-jkl012mno345pqr6', '간편결제', 'tgen_20250525180420may04', '{\"vat\": 17273, \"card\": {\"amount\": 190000, \"number\": \"433028**********\", \"cardType\": \"신용\", \"approveNo\": \"00150004\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"간편결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-004\", \"orderName\": \"영양제 세트\", \"approvedAt\": \"2025-05-25T18:04:35+09:00\", \"paymentKey\": \"tgen_20250525180420may04\", \"receiptUrl\": null, \"totalAmount\": 190000, \"suppliedAmount\": 172727, \"easyPayProvider\": null}', '20250525180435', '20250525180420', 'DONE');
-- 2. ORDERS_M 다음
INSERT INTO `ORDERS_M`
(`order_id`, `payments_id`, `user_id`, `order_status_code`, `discount_amount`, `order_date`, `total_amount`, `shipping_req`, `created_at`, `postal_code`, `basic_address`, `detail_address`)
VALUES
    ('may2025-order-001', 'may2025-pay-001-abc123def456ghi7', 2, 'DONE', 0, '20250505142030', 100000, '문앞에 놓아주세요', '20250505142030', '06234', '서울특별시 강남구 테헤란로 152', '101동 1502호'),
    ('may2025-order-002', 'may2025-pay-002-def456ghi789jkl0', 3, 'DONE', 0, '20250512103015', 150000, '경비실 보관 부탁', '20250512103015', '13561', '경기 성남시 분당구 정자일로 95', '202동 803호'),
    ('may2025-order-003', 'may2025-pay-003-ghi789jkl012mno3', 4, 'DONE', 0, '20250518155030', 200000, '직접 받겠습니다', '20250518155030', '21990', '인천 연수구 컨벤시아대로 165', '304동 1201호'),
    ('may2025-order-004', 'may2025-pay-004-jkl012mno345pqr6', 5, 'DONE', 0, '20250525180420', 190000, '택배함 사용해주세요', '20250525180420', '14056', '경기 안양시 동안구 시민대로 230', '105동 602호');
-- 3. ORDER_ITEM_D 마지막 (실제 존재하는 product_id 사용)
INSERT INTO `ORDER_ITEM_D` (`order_item_id`,`order_id`,`product_id`,`quantity`,`created_at`) VALUES
                                                                                                 ('may2025-item-001', 'may2025-order-001', '3e3f2a8d-4b17-4995-9672-7a4378fd7cd4', 2, '20250505142030'),
                                                                                                 ('may2025-item-002', 'may2025-order-002', '49cfce26-8e6b-4293-8e2d-3cf23d113243', 1, '20250512103015'),
                                                                                                 ('may2025-item-003', 'may2025-order-002', '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, '20250512103015'),
                                                                                                 ('may2025-item-004', 'may2025-order-003', '590b598b-3577-4f43-8e36-6ed31866b8c9', 1, '20250518155030'),
                                                                                                 ('may2025-item-005', 'may2025-order-004', '7ce54218-997f-4cf7-9913-c6cf76a4c6ea', 1, '20250525180420'),
                                                                                                 ('may2025-item-006', 'may2025-order-004', '64b56eed-5f4c-4061-9c70-192261b418b5', 1, '20250525180420');
-- 5월 추가 주문 (약 1,900,000원 추가해서 총 2,540,000원 만들기)
-- 1. PAYMENT_D 추가
INSERT INTO `PAYMENT_D` (`payments_id`,`payment_method`,`payment_Key`,`payment_payload`,`paid_at`,`created_at`,`payment_status_code`) VALUES
                                                                                                                                          ('may2025-pay-005-extra1234567890h', '카드결제', 'tgen_20250508143000may05', '{\"vat\": 45455, \"card\": {\"amount\": 500000, \"number\": \"654321**********\", \"cardType\": \"신용\", \"approveNo\": \"00150005\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"카드결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-005\", \"orderName\": \"건강세트\", \"approvedAt\": \"2025-05-08T14:30:15+09:00\", \"paymentKey\": \"tgen_20250508143000may05\", \"receiptUrl\": null, \"totalAmount\": 500000, \"suppliedAmount\": 454545, \"easyPayProvider\": null}', '20250508143015', '20250508143000', 'DONE'),
                                                                                                                                          ('may2025-pay-006-extra2345678901i', '간편결제', 'tgen_20250515160000may06', '{\"vat\": 36364, \"card\": {\"amount\": 400000, \"number\": \"433028**********\", \"cardType\": \"신용\", \"approveNo\": \"00150006\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"간편결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-006\", \"orderName\": \"영양제 패키지\", \"approvedAt\": \"2025-05-15T16:00:30+09:00\", \"paymentKey\": \"tgen_20250515160000may06\", \"receiptUrl\": null, \"totalAmount\": 400000, \"suppliedAmount\": 363636, \"easyPayProvider\": null}', '20250515160030', '20250515160000', 'DONE'),
                                                                                                                                          ('may2025-pay-007-extra3456789012j', '카드결제', 'tgen_20250522110000may07', '{\"vat\": 27273, \"card\": {\"amount\": 300000, \"number\": \"789456**********\", \"cardType\": \"신용\", \"approveNo\": \"00150007\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"카드결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-007\", \"orderName\": \"프리미엄 보충제\", \"approvedAt\": \"2025-05-22T11:00:45+09:00\", \"paymentKey\": \"tgen_20250522110000may07\", \"receiptUrl\": null, \"totalAmount\": 300000, \"suppliedAmount\": 272727, \"easyPayProvider\": null}', '20250522110045', '20250522110000', 'DONE'),
                                                                                                                                          ('may2025-pay-008-extra4567890123k', '간편결제', 'tgen_20250528140000may08', '{\"vat\": 36364, \"card\": {\"amount\": 400000, \"number\": \"433028**********\", \"cardType\": \"신용\", \"approveNo\": \"00150008\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"간편결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-008\", \"orderName\": \"종합영양세트\", \"approvedAt\": \"2025-05-28T14:00:15+09:00\", \"paymentKey\": \"tgen_20250528140000may08\", \"receiptUrl\": null, \"totalAmount\": 400000, \"suppliedAmount\": 363636, \"easyPayProvider\": null}', '20250528140015', '20250528140000', 'DONE'),
                                                                                                                                          ('may2025-pay-009-extra5678901234l', '카드결제', 'tgen_20250530180000may09', '{\"vat\": 27273, \"card\": {\"amount\": 300000, \"number\": \"654321**********\", \"cardType\": \"신용\", \"approveNo\": \"00150009\", \"ownerType\": \"개인\", \"installmentPlanMonths\": 0}, \"method\": \"카드결제\", \"status\": \"DONE\", \"orderId\": \"may2025-order-009\", \"orderName\": \"웰니스 패키지\", \"approvedAt\": \"2025-05-30T18:00:30+09:00\", \"paymentKey\": \"tgen_20250530180000may09\", \"receiptUrl\": null, \"totalAmount\": 300000, \"suppliedAmount\": 272727, \"easyPayProvider\": null}', '20250530180030', '20250530180000', 'DONE');
-- 2. ORDERS_M 추가
INSERT INTO `ORDERS_M`
(`order_id`, `payments_id`, `user_id`, `order_status_code`, `discount_amount`, `order_date`, `total_amount`, `shipping_req`, `created_at`, `postal_code`, `basic_address`, `detail_address`)
VALUES
    ('may2025-order-005', 'may2025-pay-005-extra1234567890h', 6, 'DONE', 0, '20250508143000', 500000, '안전 포장 부탁드려요', '20250508143000', '07327', '서울특별시 영등포구 국제금융로 10', '402동 808호'),
    ('may2025-order-006', 'may2025-pay-006-extra2345678901i', 2, 'DONE', 0, '20250515160000', 400000, '배송 전 연락 필수', '20250515160000', '48058', '부산광역시 해운대구 해운대해변로 264', '101동 2001호'),
    ('may2025-order-007', 'may2025-pay-007-extra3456789012j', 3, 'DONE', 0, '20250522110000', 300000, '조심히 다뤄주세요', '20250522110000', '42601', '대구광역시 달서구 달구벌대로 1617', '203동 1502호'),
    ('may2025-order-008', 'may2025-pay-008-extra4567890123k', 4, 'DONE', 0, '20250528140000', 400000, '문앞 배치 금지', '20250528140000', '35229', '대전광역시 서구 둔산로 100', '305동 903호'),
    ('may2025-order-009', 'may2025-pay-009-extra5678901234l', 5, 'DONE', 0, '20250530180000', 300000, '택배함 이용 부탁', '20250530180000', '61931', '광주광역시 서구 상무중앙로 61', '107동 1201호');
-- 3. ORDER_ITEM_D 추가
INSERT INTO `ORDER_ITEM_D` (`order_item_id`,`order_id`,`product_id`,`quantity`,`created_at`) VALUES
                                                                                                 ('may2025-item-007', 'may2025-order-005', '4dd8e072-ca61-4292-9498-36d0b05d1a19', 2, '20250508143000'),
                                                                                                 ('may2025-item-008', 'may2025-order-005', '53ec9f01-4fcb-4d3b-a8b3-dce02f24334d', 3, '20250508143000'),
                                                                                                 ('may2025-item-009', 'may2025-order-006', '6e3f3ad5-1c4b-4df4-9f5f-7db41b867c21', 2, '20250515160000'),
                                                                                                 ('may2025-item-010', 'may2025-order-006', '7f89cbb4-8613-4e33-8cc0-cb798f01dd77', 1, '20250515160000'),
                                                                                                 ('may2025-item-011', 'may2025-order-007', '8fbe80f4-d999-4903-a3ef-2371e449e77c', 1, '20250522110000'),
                                                                                                 ('may2025-item-012', 'may2025-order-007', '986d53d3-bde4-4635-9930-1ce3ce0713ae', 2, '20250522110000'),
                                                                                                 ('may2025-item-013', 'may2025-order-008', 'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, '20250528140000'),
                                                                                                 ('may2025-item-014', 'may2025-order-008', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', 2, '20250528140000'),
                                                                                                 ('may2025-item-015', 'may2025-order-009', 'bcf5f3aa-2e1c-408d-814f-6dcb5f0325f5', 1, '20250530180000'),
                                                                                                 ('may2025-item-016', 'may2025-order-009', 'd1fd3ad7-90b2-46cf-b0f7-40a90ffac168', 2, '20250530180000');
