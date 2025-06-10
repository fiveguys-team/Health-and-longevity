DROP TABLE IF EXISTS PRODUCT;

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

INSERT INTO PRODUCT (
    product_id, category_id, vendor_id, name, price, stock_count, status, product_image
) VALUES (
             '1',
             1,
             1,
             '테스트 상품',
             12345,
             10,
             'APPROVED',
             'test-image.jpg'
         );