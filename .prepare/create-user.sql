ALTER SESSION SET CONTAINER=FREEPDB1 SERVICE=FREEPDB1;

CREATE USER DEV IDENTIFIED BY "DEV_PW" QUOTA UNLIMITED ON USERS;
GRANT DB_DEVELOPER_ROLE TO DEV;

create user f1data identified by "Formula1Database!"
/
GRANT DB_DEVELOPER_ROLE TO f1data;


connect DEV/DEV_PW@localhost:1521/FREEPDB1

show user
