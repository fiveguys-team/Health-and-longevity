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
                          `role`           ENUM('USER','VENDOR','ADMIN') default 'USER' NOT NULL ,
                          `email_verified` BOOLEAN          NULL
);

ALTER TABLE `USER_M` MODIFY `user_id` BIGINT AUTO_INCREMENT NOT NULL,
ADD CONSTRAINT `PK_USER_M` PRIMARY KEY (`user_id`);

INSERT INTO USER_M (email, password, name, role) VALUES ('admin@example.com', '{noop}1234', '관리자', 'ADMIN');
insert into USER_M (email, password, name, role) values ('vendor@example.com', '{noop}1234', '업체', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendor1@test.com', '{noop}password123', '강지욱', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendor2@test.com', '{noop}password123', '이윤주', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendo3@test.com', '{noop}password123', '장호영', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendo4@test.com', '{noop}password123', '김미성', 'VENDOR');
insert into USER_M (email, password, name, role) values ('vendo@test.com', '{noop}password123', '김미성', 'VENDOR');

select * from USER_M;

insert into VENDOR_M (user_id, business_number, permit_number) values (5, 1111111111, 11111111111);

select * from VENDOR_M;
select * from PRODUCT;

insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (2, '오펠라헬스케어코리아', '서울특별시 서초구', 1728801879, 20110099003, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%98%A4%ED%8E%A0%EB%9D%BC.jpg', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (3, '브리드케어', '서울특별시 강남구', 5088802515, 20230141301, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EB%B8%8C%EB%A6%AC%EB%93%9C%EC%BC%80%EC%96%B4.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (4, '네츄럴헬스코리아', '서울특별시 강남구', 2088601927, 20200105633, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EB%84%A4%EC%B8%84%EB%9F%B4%ED%97%AC%EC%8A%A4%EC%BD%94%EB%A6%AC%EC%95%84.jpg', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (5, '미성뉴트리션', '서울특별시 강남구', 8748102863, 20240144484, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EB%AF%B8%EC%84%B1.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');
insert into VENDOR_M (user_id, name, address, business_number, permit_number, status, vendor_img, b_img, p_img)
values (6, '영메디케어', '경기도 하남시', 4454900895, 20250525654, 'APPROVED', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%98%81%EB%A9%94%EB%94%94.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%EC%82%AC%EC%97%85%EC%9E%90%EB%93%B1%EB%A1%9D%EC%A6%9D%EC%98%88%EC%8B%9C.png', 'https://kr.object.ncloudstorage.com/health-and-longevity-storage/images/%ED%86%B5%EC%8B%A0%ED%8C%90%EB%A7%A4%EC%97%85%EC%8B%A0%EA%B3%A0%EC%A6%9D%EC%98%88%EC%8B%9C.webp');


