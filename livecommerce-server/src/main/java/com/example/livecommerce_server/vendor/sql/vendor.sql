use livecommerce_db;

select * from VENDOR_M;
select * from USER_M;

select u.name, u.email, v.business_number, v.permit_number, v.status from VENDOR_M v join USER_M u
where v.user_id = u.user_id;