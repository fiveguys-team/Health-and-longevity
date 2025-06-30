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
INSERT INTO category (name) VALUES
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



INSERT INTO product (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'fb23b1ea-f2c0-4af1-aef8-f2cb41a5c546', 1, 1, '가바트리플', 25000, 15, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EA%B0%80%EB%B0%94.jpg'
         );

INSERT INTO product_detail (
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
INSERT INTO product (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             'b8cae837-7d4b-43af-b332-4bdc94b885ff', 1, 1, '알로에아보레센스', 25000, 15, 'APPROVED', 'https://m.dulyaloe.com/web/product/big/202307/6b4e56038f1029819a65d54747e9a28f.jpg'
         );

INSERT INTO product_detail (
    cert_no, product_id, approval_date, expiry_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             '20040020007894', 'b8cae837-7d4b-43af-b332-4bdc94b885ff', '20110216', '제조일로부터 24개월',
             '1일 3회, 1회 2캡슐을 물과 함께 섭취하십시오.', '[알로에전잎 제품] 배변활동 원활에 도움을 줄 수 있음', '다른 치료나 약물 복용중인 경우 전문의와 상의하시고 임산부는 섭취 시 주의하십시오. 특이체질, 알레르기 체질인 경우 성분을 확인하신 후 섭취하십시오. 용기 안의 실리카겔(방습제)은 드시지 마십시오.',
             '직사광선을 받지 않는 서늘한 곳에서 유통 보관하시오.', '성상 : 갈색의 내용물의 함유한 녹색의 경질캡슐 안트라퀴논계화합물(무수바바로인으로서) : 표시량 80~120%(표시량 : 20 mg / 2,580mg) 대장균군 : 음성 붕해시험 : 적합(20분 이내)', '알로에 전잎(알로에아보레센스분말),젤라틴,정제수,이산화티타늄,식용색소황색제4호,식용색소청색제1호,빙초산,자당지방산에스테르,결정셀룰로오스,스테아린산마그네슘,이산화규소,치커리추출물(추출액)분말(분말 추출물),민들레(전체)추출물(추출액)분말(분말 추출물),푸룬농축액(농축물)분말,프락토올리고당,병풀추출물(추출액)분말(분말 추출물)(고투콜라),알로에 베라농축액(농축물)분말(알로에 베라 겔)', '알로에아보레센스'
         );

-- 상품 기본 정보
INSERT INTO product (product_id, category_id, vendor_id, name, price, stock_count, status, product_image)
VALUES ('64b56eed-5f4c-4061-9c70-192261b418b5', 2, 1, '행복한 한컵 락티움', 12000, 25, 'APPROVED', 'https://m.optihealth.co.kr/web/product/extra/big/202304/9bb48480c2da5ab58cad237feff910f9.jpg' );

-- 상품 상세 정보
INSERT INTO product_detail (
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
INSERT INTO product (product_id, category_id, vendor_id, name, price, stock_count, status, product_image)
VALUES ('ba98cdf0-1de7-437b-88d6-8950e1f955c2', 1, 1, '홍삼타브렛', 20000, 50, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%99%8D%EC%82%BC%ED%83%80%EB%B8%8C%EB%A0%9B.jpeg');

-- Product Detail Table
INSERT INTO product_detail (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             8406784402430241303, 'ba98cdf0-1de7-437b-88d6-8950e1f955c2', '2년', '20110325', '1일 2회, 1회 3정씩 음용수와 함께 섭취하거나 씹어서 섭취',
             '[홍삼제품]①면역력증진②피로개선③혈소판응집억제를통한혈액흐름에도움④기억력개선⑤항산화에도움을줄수있음', '알러지 등 특이체질이신 분은 제품성분을 확인후 섭취여부를 결정 어린이의 경우 보호자의 지도하에 섭취 의약품(당뇨치료제, 혈액항응고제)복용 시 섭취에 주의', '', '1.성상:고유의 색택과 향미를 가지며 이미, 이취가 없어야 함. 2.진세노사이드 Rb1,Rg1 및 Rg3의 합:표시량(5.8mg/900mg)의 80%이상 3.대장균군:음성 4.붕해도: 붕해시험에 적합하여야 한다.', '홍삼분말(가루, 과립)', '홍삼타브렛'
         );
-- Product Table (더미 데이터)
INSERT INTO product (product_id, category_id, vendor_id, name, price, stock_count, status, product_image)
VALUES ('4dd8e072-ca61-4292-9498-36d0b05d1a19', 5, 1, '천지인 키즐홍짱 홍삼액', 25000, 30, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%82%A4%EC%A6%90%ED%99%8D%EC%A7%B1.jpg');

-- Product Detail Table
INSERT INTO product_detail (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function, precautions,
    storage_method, standard, ingredients, product_name
) VALUES (
             18866061144, '4dd8e072-ca61-4292-9498-36d0b05d1a19', '제조일로부터 24개월', '20110331', '1일 1회, 1회 1포(15ml)씩 섭취하십시오.',
             '[홍삼제품]①면역력 증진②피로개선③혈소판 응집 억제를 통한 혈액흐름④기억력 개선⑤항산화에 도움을 줄 수 있음', '① 알러지 등 특이체질의 경우 과민반응이 우려될 수 있으니 성분을 확인하신 후 섭취하십시오. ② 임산부와 수유부는 섭취를 피하는 것이 좋습니다. ③ 의약품(당뇨치료제, 혈액항응고제) 복용 시 분은 의사와 상의하시기 바랍니다. ④ 천연물 성분에 의한 침전물이 생기는 경우가 있으나 안심하고 잘 흔들어 섭취하십시오. ⑤ 제품의 개봉 또는 섭취 시 포장재에 의해 다칠 우려가 있으니 주의하십시오. ⑥ 제품 개봉 후 변질될 수 있으므로 바로 섭취하십시오.', '습기와 직사광선을 피하여 실온에 보관.', '① 성상 : 갈색의 액상 ② 진세노사이드 Rg1과 Rb1 및 Rg3의 합 : 표시량(5.5mg/15mL)의 80% 이상 ③ 세균수 : 1ml당 100 이하 ④ 대장균군 : 음성', '홍삼농축액(농축물),시클로덱스트린시럽,액상프락토올리고당(고형분기준 55%),정제수,아미노산혼합(아미노믹스),L-페닐알라닌,L-로이신,벌꿀,요구르트향(천연),칡농축액(농축물),천궁농축액(농축물),녹용농축액(농축물),비타민 A 혼합제제,비타민 B6 염산염,비타민 B2,비타민 D3 혼합제제,효소처리스테비아,블루베리농축액(농축물),니코틴산아미드,판토텐산칼슘,비타민 B1염산염,엽산,비오틴,비타민 B12,당귀농축액(농축물),블루베리농축액(농축물)분말,덱스트린,L-메티오닌,L-라이신,팔라티노스,L-히스티딘,L-발린,L-이소로이신,L-트레오닌,L-트립토판,가시오갈피(줄기)농축액(농축물),비타믹스,비타민 C,팔라티노스,비타민 E 혼합제제', '천지인 키즐홍짱 홍삼액'
         );
INSERT INTO product (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '087a9785-4ca6-4cc1-b75f-0887ff416791', 5, 2, 'Silver plus propolis', 18000, 50, 'APPROVED', 'https://lh3.googleusercontent.com/proxy/r_tjMA6vxTqoLfFoQguGf2TN6Om2sbDLjutHtjeAI7vyh3bmM0h8qeM2Yk_cUZ60zaABmrq-Y0voS3Z2pvIV3hkzVnsWRuJWP3mlJ5rjYdOrqRWc7ObFYojgkTPQ9Yv4stFecjmfvtge2FaOnn1pxKNOoH5YQ_ZlBXKAMYwolNiqd2SSMbcVUWX_dthoxvgN2Uxo9tL121CQRKESteMLqAuai6sBUnYwPNUbgIeZKD3ezJJ-IjWEspVJXH07VLCF'
         );

INSERT INTO product_detail (
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
INSERT INTO product (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', 1, 2, '종근당건강멀티비타민포우먼', 20000, 50, 'APPROVED', 'https://sitem.ssgcdn.com/06/82/95/item/1000552958206_i1_750.jpg'
         );

-- PRODUCT_DETAIL 테이블에 데이터 삽입
INSERT INTO product_detail (
    cert_no, product_id, expiry_date, approval_date, how_to_take, main_function,
    precautions, storage_method, standard, ingredients, product_name
) VALUES (
             2004001706253, '4b8a3f13-2e55-4415-93cc-b4a1d96a6b7f', '24개월', '20110131', '1일 1회, 1회 1정씩 씹어서 섭취하십시오.', '[비타민A]①어두운 곳에서 시각 적응을 위해 필요②피부와 점막을 형성하고 기능을 유지하는데 필요③상피세포의 성장과 발달에 필요 [비타민E]①유해산소로부터 세포를 보호하는데 필요 [비타민B1]①탄수화물과 에너지 대사에 필요 [비타민B2]①체내 에너지 생성에 필요 [나이아신]①체내 에너지 생성에 필요 [비타민B6]①단백질 및 아미노산 이용에 필요②혈액의 호모시스테인 수준을 정상으로 유지하는데 필요 [엽산]①세포와 혈액생성에 필요②태아 신경관의 정상 발달에 필요③혈액의 호모시스테인 수준을 정상으로 유지하는데 필요 [비타민C]①결합조직 형성과 기능유지에 필요②철의 흡수에 필요③유해산소로부터 세포를 보호하는데 필요',
             '1) 알레르기 체질이신분은 성분을 확인 후 섭취하여 주십시오. 2) 섭취량 및 섭취방법을 확인하시고 섭취하여 주십시오. 3) 유통기한이 경과된 제품은 섭취하지 않도록 주의 바랍니다. 4) 개봉 후 공기가 들어가지 않도록 뚜껑을 꼭 닫아 보관하십시오.', '고온, 직사광선, 습기를 피해 서늘하고 통풍이 잘 되는 곳에 보관하십시오.', '① 성상 : 노란색의 원형정제로 이미,이취가 없어야 한다. ② 비타민A : 표시량(350μgRE/1,200mg)의 80~150% ③ 비타민E : 표시량(6㎎α-TE/1,200mg)의 80~150% ④ 비타민B1 : 표시량(0.7mg/1,200mg)의 80~180% ⑤ 비타민B2 : 표시량(0.96mg/1,200mg)의 80~180% ⑥ 나이아신 : 표시량(9.75mgNE/1,200mg)의 80~150% ⑦ 비타민B6 : 표시량(1.28mg/1,200mg)의 80~150% ⑧ 엽산 : 표시량(212.5μg/1,200mg)의 80~150% ⑨ 비타민C : 표시량(80mg/1,200mg)의 80~150% ⑩ 대장균군 : 음성', '분말비타민 A,비타민 E 혼합제제,비타민 B1염산염,비타민 B2,나이아신,비타민 B6 염산염,엽산,비타민 C,석류농축액농축액(농축물)분말,덱스트린,석류농축액농축액(농축물),아스파탐(페닐알라닌 함유),콜라겐,글리세린,프로필렌글리콜,치자황색소,치커리(뿌리)추출물(추출액)분말(분말 추출물),치자황색소,정제수,결정(분말)포도당,유당혼합,덱스트린,유당,D-소르비톨,석류향분말(가루, 과립),정제수,물엿,변성전분,석류향,그레나딘향유지(Oil),스테아린산마그네슘,석류향,정제수,프로필렌글리콜,글리세린,식용주정,벤즈알데히드,에틸 말톨,캐롯유지(Oil),러비지유지(Oil),위스키향,딸기향,체리향,복숭아향', '종근당건강멀티비타민포우먼'
         );

INSERT INTO PRODUCT (product_id, name, status, stock_count, price, category_id, vendor_id, product_image)
VALUES ('590b598b-3577-4f43-8e36-6ed31866b8c9', '미라클', 'APPROVED', 100, 10000, 1, 2, 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EB%AF%B8%EB%9D%BC%ED%81%B4.jpg');

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
             'a1e17bb2-ecfa-4b42-a754-2a08c7e16d68', 1, 2, '유한m 오메가-3 비거파워', 18000, 10, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%9C%A0%ED%95%9Cm.jpg'
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
             '2cc10b17-802e-466f-a89e-8ef0e39b62e6', '큐자임', 1, 3, 40000, 0, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%81%90%EC%9E%90%EC%9E%84.jpeg'
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
             '53ec9f01-4fcb-4d3b-a8b3-dce02f24334d', 4, 3, '메가프리미엄골드', 26000, 0, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%94%84%EB%A6%AC%EB%AF%B8%EC%97%84%EA%B3%A8%EB%93%9C.avif'
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
             'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%99%8D%EC%82%BC%EB%86%8D%EC%B6%95%EC%95%A1.jpeg'
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
             '49cfce26-8e6b-4293-8e2d-3cf23d113243', '면역력을 증진시키는 엔케이캡슐', 4, 3, 11000, 0, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%97%94%EC%BC%80%EC%9D%B4.jpg'
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
             '0a213d25-9404-43b1-b4a4-8702c51b3e94', 1, 3, '닥터맘튼튼메론맛', 11000, 16, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EB%A9%94%EB%A1%A0%ED%8A%BC%ED%8A%BC.jpg'
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
             '8fbe80f4-d999-4903-a3ef-2371e449e77c', 1, 4, '프림로즈', 17000, 14, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%94%84%EB%A6%BC%EB%A1%9C%EC%A6%88.jpg'
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
    ('f296d746-f8de-406b-91d4-84be19b8bcbd', 1, 4, '엽산600㎍', 15000, 15, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%97%BD%EC%82%B0.jpeg');
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
             'd1fd3ad7-90b2-46cf-b0f7-40a90ffac168', 2, 4, '관절애디메틸설폰', 13000, 6, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%84%A4%ED%8F%B0.jpg'
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
             '16bd3136-e2b6-429e-80aa-ea1f92d1dd11', 2, 4, '온가족영양소', 31000, 12, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%98%A8%EA%B0%80%EC%A1%B1.jpg'
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
             'e8ef02d3-e0e1-4013-899b-8ddf987af2a5', 2, 4, '고려홍삼차', 26000, 20, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EA%B3%A0%EB%A0%A4%ED%99%8D%EC%82%BC%EC%B0%A8.png'
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
             '6e3f3ad5-1c4b-4df4-9f5f-7db41b867c21', 3, 5, '세포 보호에 도움을 주는 셀 닥터 영양소 캡슐', 34000, 9, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EB%8B%A5%ED%84%B0%EC%85%80.jpg'
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
             '7ce54218-997f-4cf7-9913-c6cf76a4c6ea', 3, 5, '아보레 센스 100', 23000, 8, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%95%84%EB%B3%B4%EB%A0%88%EC%84%BC%EC%8A%A4100.jpg'
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
    ('bcf5f3aa-2e1c-408d-814f-6dcb5f0325f5', '한삼인홍센칼슘', 35000, 20, 5, 5, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%95%9C%EC%82%BC%EC%9D%B8%ED%99%8D%EC%84%BC.jpg');

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
             '7f89cbb4-8613-4e33-8cc0-cb798f01dd77', '디믹스', 25000, 5, 'APPROVED', 4, 5, 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EB%94%94%EB%AF%B9%EC%8A%A4.png'
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
             '986d53d3-bde4-4635-9930-1ce3ce0713ae', 3, 5, '엑티브표고버섯균사체AHCC', 25000, 10, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%ED%91%9C%EA%B3%A0%EB%B2%84%EC%84%AF.avif'
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
             '3131180f-3f0d-47ae-a8a7-d166a62a9ee8', 3, 5, '아마가인지방산', 24000, 0, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%95%84%EB%A7%88%EA%B0%80%EC%9D%B8%EC%A7%80%EB%B0%A9%EC%82%B0.jpg'
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
INSERT INTO PRODUCT (product_id, category_id, vendor_id, name, price, stock_count, status, product_image) VALUES ('0e6fcf3b-7051-49cf-9f57-3ac57a60d396', 1, 5, '진품홍삼', 29000, 0, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/products/%EC%A7%84%ED%92%88%ED%99%8D%EC%82%BC.jpeg');

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