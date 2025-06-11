use livecommerce_db;

drop table USER_M;
CREATE TABLE `USER_M` (
                          `user_id`        BIGINT           NOT NULL,
                          `email`          VARCHAR(256) UNIQUE NULL,
                          `password`       VARCHAR(256)     NULL,
                          `name`           VARCHAR(256)     NULL,
                          `interest`       VARCHAR(256)     NULL,
                          `social_id`    VARCHAR(256)     NULL,
                          `social_type`       ENUM('KAKAO','GOOGLE') NULL,
                          `role`           ENUM('USER','VENDOR','ADMIN') default 'USER',
                          `email_verified` BOOLEAN          NULL
);

ALTER TABLE `USER_M` MODIFY `user_id` BIGINT AUTO_INCREMENT NOT NULL,
ADD CONSTRAINT `PK_USER_M` PRIMARY KEY (`user_id`);

insert into USER_M (email, password, role) values ('admin@example.com', '{noop}1234', 'ADMIN');
insert into USER_M (email, password, role) values ('vendor@example.com', '{noop}1234', 'VENDOR');

select * from USER_M;

