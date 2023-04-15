CREATE TABLE TICKETSALES(
    ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100),
    CAPACITY NUMBER RESERVABLE CONSTRAINT MINIMUM_CAPACITY CHECK (CAPACITY >= 10)
);

INSERT INTO TICKETSALES VALUES (
    1,
    'TikTok Live',
    2000
);

COMMIT;

SELECT
    OBJECT_NAME,
    OBJECT_ID
FROM
    USER_OBJECTS OBJ
WHERE
    OBJ.OBJECT_NAME = 'TICKETSALES' DESC SYS_RESERVJRNL_78947;


Session 1:

update ticketsales set capacity = capacity -200 where id = 1;

select * from SYS_RESERVJRNL_78947;


Session 2:
update ticketsales set capacity = capacity - 300 where id=1;

select * from SYS_RESERVJRNL_78947;

update ticketsales set capacity = capacity - 150 where id=1;

select * from SYS_RESERVJRNL_78947;

select * from ticketsales;

select * from SYS_RESERVJRNL_78947;

commit;

Session 3:

update ticketsales set capacity = capacity - 1000 where id = 1;

Session 1:

update ticketsales set capacity = capacity -400 where id = 1;

Session 3:

update ticketsales set capacity = capacity + 500 where id = 1;

select * from SYS_RESERVJRNL_78947;

Session 1:

Session 1:

update ticketsales set capacity = capacity -400 where id = 1;


Session 3:

rollback;

select * from SYS_RESERVJRNL_78947;


Session 1:

update ticketsales set capacity = capacity -400 where id = 1;

select * from SYS_RESERVJRNL_78947 as of timestamp sysdate - 5/(24*60);