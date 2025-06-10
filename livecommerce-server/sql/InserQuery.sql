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
DROP TABLE IF EXISTS `ADDRESS_M`;            -- 참조: ORDERS_M
DROP TABLE IF EXISTS `LIVE_DASHBOARD_D`;     -- 참조: LIVE_M
DROP TABLE IF EXISTS `CART_M`;               -- 참조: USER_M
DROP TABLE IF EXISTS `CHAT_ROOM_M`;          -- 참조: LIVE_M

-- 2. 이제 중간 단계 테이블 제거
DROP TABLE IF EXISTS `ORDERS_M`;             -- 참조: PAYMENT_D, USER_M
DROP TABLE IF EXISTS `PRODUCT`;              -- 참조: CATEGORY, VENDOR_M
DROP TABLE IF EXISTS `LIVE_M`;               -- 참조: VENDOR_M
DROP TABLE IF EXISTS `VENDOR_M`;             -- 참조: USER_M

-- 3. 끝으로 루트 테이블들 제거
DROP TABLE IF EXISTS `PAYMENT_D`;
DROP TABLE IF EXISTS `USER_M`;
DROP TABLE IF EXISTS `CATEGORY`;

DROP TABLE IF EXISTS `BANWORD_M`;

-- ========================================================
-- 2) CREATE TABLE statements
-- ========================================================
CREATE TABLE `CHAT_ROOM_M` (
                               room_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                               `participants_cnt` INT      NULL,
                               `created_at`       DATETIME NULL,
                               `updated_at`       DATETIME NULL,
                               `live_id`          CHAR(36) NOT NULL
);

CREATE TABLE `USER_M` (
                          `user_id`        BIGINT           NOT NULL,
                          `email`          VARCHAR(256) UNIQUE NULL,
                          `password`       VARCHAR(256)     NULL,
                          `name`           VARCHAR(256)     NULL,
                          `interest`       VARCHAR(256)     NULL,
                          `provider`       ENUM('local','kakao','naver') NULL,
                          `provider_id`    VARCHAR(256)     NULL,
                          `role`           ENUM('USER','VENDOR','ADMIN') NULL,
                          `email_verified` BOOLEAN          NULL
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
                                 `report_id`    BIGINT       NOT NULL,
                                 `reason_nm`    VARCHAR(100) NULL,
                                 `status_cd`    ENUM('미처리','제재됨','해제됨') NULL,
                                 `reported_at`  DATETIME     NULL,
                                 `processed_at` DATETIME     NULL,
                                 `message_id`   BIGINT       NOT NULL,
                                 `user_id`      BIGINT       NOT NULL
);

CREATE TABLE `SERVICE_M` (
                             `service_id`    CHAR(36)   NOT NULL,
                             `order_item_id` CHAR(36)   NOT NULL,
                             `service_code`  CHAR(4)    NULL,
                             `reason`        VARCHAR(100) NULL,
                             `img`           JSON       NULL,
                             `status_code`   CHAR(4)    NULL,
                             `refund_amount` INT        NULL,
                             `update_at`     CHAR(16)   NULL,
                             `created_at`    CHAR(16)   NULL
);

CREATE TABLE `REVIEW` (
                          `review_id`      BIGINT    NOT NULL,
                          `order_item_id`  CHAR(36)  NOT NULL,
                          `rating`         INTEGER   NULL,
                          `feedback_choice` TINYINT  NULL,
                          `content`        VARCHAR(256) NULL,
                          `created_at`     CHAR(16)  NULL
);

CREATE TABLE `ORDERS_M` (
                            `order_id`          CHAR(36) NOT NULL,
                            `payments_id`       CHAR(36) NOT NULL,
                            `user_id`           BIGINT    NOT NULL,
                            `order_status_code` CHAR(4)   NULL,
                            `discount_amount`   INT       NULL,
                            `order_date`        CHAR(16)  NULL,
                            `total_amount`      INT       NULL,
                            `shipping_req`      VARCHAR(256) NULL,
                            `created_at`        CHAR(16)  NULL
);

CREATE TABLE `VENDOR_M` (
                            `vendor_id`      BIGINT NOT NULL,
                            `user_id`        BIGINT NOT NULL,
                            `name`           VARCHAR(256) NULL,
                            `address`        VARCHAR(256) NULL,
                            `business_number` VARCHAR(256) NULL,
                            `permit_number`  VARCHAR(256) NULL,
                            `status`         ENUM('PENDING','APPROVED','REJECTED') NULL
);

CREATE TABLE `CHAT_PARTICIPANT_D` (
                                      `participant_id` BIGINT   NOT NULL,
                                      `banned_yn`      BOOLEAN  NULL,
                                      `created_at`     DATETIME NULL,
                                      `room_id`        BIGINT   NOT NULL,
                                      `user_id`        BIGINT   NOT NULL
);

CREATE TABLE `LIVE_DASHBOARD_D` (
                                    `liveDashboard_id` CHAR(36) NOT NULL,
                                    `live_id`          CHAR(36) NOT NULL,
                                    `total_viewers`    INTEGER NULL,
                                    `total_chats`      INTEGER NULL,
                                    `total_orders`     INTEGER NULL,
                                    `total_reve`       BIGINT  NULL,
                                    `purchase_rate`    INTEGER NULL
);

CREATE TABLE `CHAT_MESSAGE_D` (
                                  `message_id` BIGINT   NOT NULL,
                                  `content`    TEXT     NULL,
                                  `created_at` DATETIME NULL,
                                  `user_id`    BIGINT   NOT NULL,
                                  `room_id`    BIGINT   NOT NULL
);

CREATE TABLE `BANWORD_M` (
                             `word_id`    BIGINT       NOT NULL,
                             `word`       VARCHAR(100) NULL,
                             `category`   VARCHAR(50)  NULL,
                             `created_at` DATETIME     NULL
);

CREATE TABLE `CHATBOT_LOG_D` (
                                 `log_id`    BIGINT   NOT NULL,
                                 `question`  TEXT     NULL,
                                 `answer`    TEXT     NULL,
                                 `created_at` DATETIME NULL,
                                 `user_id`   BIGINT   NOT NULL
);

CREATE TABLE `CART_M` (
                          `cart_id`    CHAR(36) NOT NULL,
                          `created_at` DATETIME NULL,
                          `user_id`    BIGINT   NOT NULL
);

CREATE TABLE `ADDRESS_M` (
                             `address_id` BIGINT    NOT NULL,
                             `order_id`   CHAR(36)  NOT NULL,
                             `name`       VARCHAR(256) NULL,
                             `zip_code`   VARCHAR(256) NULL,
                             `detailed`   VARCHAR(256) NULL,
                             `is_default` BOOLEAN   NULL,
                             `is_saved`   BOOLEAN   NULL
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
                          `announcement` TEXT     NULL
);

CREATE TABLE `PRODUCT` (
                           `product_id`    CHAR(36) NOT NULL,
                           `category_id`   BIGINT   NOT NULL,
                           `vendor_id`     BIGINT   NOT NULL,
                           `name`          VARCHAR(256) NULL,
                           `price`         INT      NULL,
                           `stock_count`   INT      NULL,
                           `status`        ENUM('PENDING','APPROVED','REJECTED','RESUBMITTED') NULL,
                           `product_image` VARCHAR(256) NULL
);

CREATE TABLE `STOCK_LOG` (
                             `stock_log_id` BIGINT NOT NULL,
                             `product_id`   CHAR(36) NOT NULL,
                             `change_type`  ENUM('SALE','RESTOCK','CANCEL','ADJUST') NULL,
                             `count_change` INT    NULL,
                             `changed_at`   CHAR(16) NULL
);

CREATE TABLE `CATEGORY` (
                            `category_id` BIGINT         NOT NULL,
                            `name`        VARCHAR(256)   NULL
);


CREATE TABLE `ORDER_ITEM_D` (
                                `order_item_id` CHAR(36) NOT NULL,
                                `order_id`      CHAR(36) NOT NULL,
                                `product_id`    CHAR(36) NOT NULL,
                                `quantity`      INT      NULL,
                                `created_at`    CHAR(16) NULL
);

CREATE TABLE `CART_ITEM_D` (
                               `cart_item_id` CHAR(36) NOT NULL,
                               `cart_id`      CHAR(36) NOT NULL,
                               `product_id`   CHAR(36) NOT NULL,
                               `quantity`     INT      NULL,
                               `created_at`   CHAR(16) NULL
);

CREATE TABLE `LIVE_PRODUCT_J` (
                                  `live_product_id` BIGINT NOT NULL,
                                  `live_id`         CHAR(36) NOT NULL,
                                  `product_id`      CHAR(36) NOT NULL,
                                  `discount_cd`     ENUM('10','15','20') NULL
);

CREATE TABLE `PRODUCT_DETAIL` (
                                  `cert_no`      BIGINT    NOT NULL,
                                  `product_id`   CHAR(36)  NOT NULL,
                                  `expiry_date`  VARCHAR(256) NULL,
                                  `approval_date` VARCHAR(256) NULL,
                                  `how_to_take`  VARCHAR(256) NULL,
                                  `main_function` VARCHAR(256) NULL,
                                  `precautions`  VARCHAR(256) NULL,
                                  `storage_method` VARCHAR(256) NULL,
                                  `standard`     VARCHAR(256) NULL,
                                  `ingredients`  VARCHAR(256) NULL,
                                  `product_name` VARCHAR(256) NULL
);


-- ========================================================
-- 3) PRIMARY KEY constraints
-- ========================================================
ALTER TABLE `CHAT_ROOM_M` ADD CONSTRAINT `PK_CHAT_ROOM_M` PRIMARY KEY (`room_id`);
ALTER TABLE `USER_M`      ADD CONSTRAINT `PK_USER_M`      PRIMARY KEY (`user_id`);
ALTER TABLE `PAYMENT_D`   ADD CONSTRAINT `PK_PAYMENT_D`   PRIMARY KEY (`payments_id`);
ALTER TABLE `CHAT_REPORT_D` ADD CONSTRAINT `PK_CHAT_REPORT_D` PRIMARY KEY (`report_id`);
ALTER TABLE `SERVICE_M`   ADD CONSTRAINT `PK_SERVICE_M`   PRIMARY KEY (`service_id`);
ALTER TABLE `REVIEW`      ADD CONSTRAINT `PK_REVIEW`      PRIMARY KEY (`review_id`);
ALTER TABLE `ORDERS_M`    ADD CONSTRAINT `PK_ORDERS_M`    PRIMARY KEY (`order_id`);
ALTER TABLE `VENDOR_M`    ADD CONSTRAINT `PK_VENDOR_M`    PRIMARY KEY (`vendor_id`);
ALTER TABLE `CHAT_PARTICIPANT_D` ADD CONSTRAINT `PK_CHAT_PARTICIPANT_D` PRIMARY KEY (`participant_id`);
ALTER TABLE `LIVE_DASHBOARD_D`   ADD CONSTRAINT `PK_LIVE_DASHBOARD_D`   PRIMARY KEY (`liveDashboard_id`);
ALTER TABLE `CHAT_MESSAGE_D`     ADD CONSTRAINT `PK_CHAT_MESSAGE_D`     PRIMARY KEY (`message_id`);
ALTER TABLE `BANWORD_M`          ADD CONSTRAINT `PK_BANWORD_M`          PRIMARY KEY (`word_id`);
ALTER TABLE `CHATBOT_LOG_D`      ADD CONSTRAINT `PK_CHATBOT_LOG_D`      PRIMARY KEY (`log_id`);
ALTER TABLE `CART_M`             ADD CONSTRAINT `PK_CART_M`             PRIMARY KEY (`cart_id`);
ALTER TABLE `ADDRESS_M`          ADD CONSTRAINT `PK_ADDRESS_M`          PRIMARY KEY (`address_id`);
ALTER TABLE `LIVE_M`             ADD CONSTRAINT `PK_LIVE_M`             PRIMARY KEY (`live_id`);
ALTER TABLE `PRODUCT`            ADD CONSTRAINT `PK_PRODUCT`            PRIMARY KEY (`product_id`);
ALTER TABLE `STOCK_LOG`          ADD CONSTRAINT `PK_STOCK_LOG`          PRIMARY KEY (`stock_log_id`);
ALTER TABLE `CATEGORY`           ADD CONSTRAINT `PK_CATEGORY`           PRIMARY KEY (`category_id`);
ALTER TABLE `ORDER_ITEM_D`       ADD CONSTRAINT `PK_ORDER_ITEM_D`       PRIMARY KEY (`order_item_id`);
ALTER TABLE `CART_ITEM_D`        ADD CONSTRAINT `PK_CART_ITEM_D`        PRIMARY KEY (`cart_item_id`);
ALTER TABLE `LIVE_PRODUCT_J`     ADD CONSTRAINT `PK_LIVE_PRODUCT_J`     PRIMARY KEY (`live_product_id`);
ALTER TABLE `PRODUCT_DETAIL`     ADD CONSTRAINT `PK_PRODUCT_DETAIL`     PRIMARY KEY (`cert_no`);


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

ALTER TABLE `ADDRESS_M`
    ADD CONSTRAINT `FK_ORDERS_M_TO_ADDRESS_M_1`
        FOREIGN KEY (`order_id`)    REFERENCES `ORDERS_M`    (`order_id`);

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
