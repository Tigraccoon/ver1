CREATE OR REPLACE PACKAGE PACK_ENCRYPTION_DECRYPTION
IS
FUNCTION FUNC_ENCRYPT -- 암호화를 위한 함수
(V_INPUT_STRING IN VARCHAR2, KEY_DATA IN VARCHAR2:='boardpwd$!')
RETURN RAW;
FUNCTION FUNC_DECRYPT -- 복호화를 위한 함수
(V_INPUT_STRING IN VARCHAR2, KEY_DATA IN VARCHAR2:='boardpwd$!')
RETURN VARCHAR2;
END PACK_ENCRYPTION_DECRYPTION;
/

--3. 패키지 구현
CREATE OR REPLACE PACKAGE BODY PACK_ENCRYPTION_DECRYPTION
IS
FUNCTION FUNC_ENCRYPT
( V_INPUT_STRING IN VARCHAR2,
KEY_DATA IN VARCHAR2 := 'boardpwd$!'
) RETURN RAW
IS
V_ORIGINAL_RAW RAW(64);
V_KEY_DATA_RAW RAW(64);
ENCRYTED_RAW RAW(64);
BEGIN
-- INPUT값을 RAW 타입으로 변경
V_ORIGINAL_RAW := UTL_I18N.STRING_TO_RAW(V_INPUT_STRING,
'AL32UTF8');
--키 또한 RAW 타입으로 변경.
V_KEY_DATA_RAW := UTL_I18N.STRING_TO_RAW(KEY_DATA, 'AL32UTF8');
ENCRYTED_RAW := DBMS_CRYPTO.ENCRYPT(
SRC => V_ORIGINAL_RAW,
TYP => DBMS_CRYPTO.DES_CBC_PKCS5,
KEY => V_KEY_DATA_RAW,
IV => NULL);
RETURN ENCRYTED_RAW;
END FUNC_ENCRYPT;
FUNCTION FUNC_DECRYPT
( V_INPUT_STRING IN VARCHAR2,
KEY_DATA IN VARCHAR2 := 'boardpwd$!'
) RETURN VARCHAR2
IS
V_KEY_DATA_RAW RAW(64);
DECRYPTED_RAW RAW(64);
CONVERTED_STRING VARCHAR2(64);
BEGIN
V_KEY_DATA_RAW := UTL_I18N.STRING_TO_RAW(KEY_DATA, 'AL32UTF8');
DECRYPTED_RAW := DBMS_CRYPTO.DECRYPT(
SRC => V_INPUT_STRING,
TYP => DBMS_CRYPTO.DES_CBC_PKCS5,
KEY => V_KEY_DATA_RAW,
IV => NULL);
CONVERTED_STRING := UTL_I18N.RAW_TO_CHAR(DECRYPTED_RAW,
'AL32UTF8');
RETURN CONVERTED_STRING;
END FUNC_DECRYPT;
END PACK_ENCRYPTION_DECRYPTION;
/


drop table board;

create table board (
b_num number not null primary key, --게시물번호 
b_writer varchar2(60) not null, --작성자
b_pwd varchar2(70) not null,
b_subject varchar2(170) not null, --제목
b_content clob not null, --본문
b_readcount number default 0,	--조회수
b_date date default sysdate, --작성일자 
b_show char(1) default 'Y',    --게시판 출력 여부
b_secret char(1) default 'N'  --비밀글 여부
);

drop sequence seq_b;
create sequence seq_b
start with 1
increment by 1;

commit;

drop table board_comment;

create table board_comment (
c_num number not null primary key, --댓글 일련번호 
b_num number not null,
c_writer varchar2(60) not null,
c_pwd varchar2(50) not null,
c_content varchar2(800) not null, 
c_date date default sysdate,
c_show char(1) default 'Y',    --댓글 출력 여부
c_secret char(1) default 'N'
);

drop sequence seq_comment;
create sequence seq_comment
start with 1
increment by 1;



declare --선언부
    i number := 1;
begin --실행부
    while i<=250 loop
        insert into board (b_num,b_subject,b_content,b_writer, b_pwd)
        values
        ( seq_b.nextval
        ,'제목'||i, '내용'||i, 'kim', '1234');
        i := i+1; --조건 변경
    end loop;
end;
/

commit;

select * from board order by b_num desc;

select count(*) from board where b_num=214 and b_writer='123123' and b_pwd='1234';

SELECT * FROM (
			SELECT rownum AS rn,
			A.* FROM (
				SELECT b_num,b_writer,b_subject,b_date,b_readcount,b_show,b_secret ,ROW_NUMBER() OVER(ORDER BY b_num ASC) as idx
	  				,(select count(*) from board_comment c where c.b_num=b.b_num and c_show='Y') c_count					
					FROM board b
					WHERE b.b_show='Y' AND b.b_writer LIKE '%'
					ORDER BY b_num DESC 
					) A
		) WHERE rn BETWEEN 1 AND 10;
        
select * from board order by b_num desc;


delete from board where b_num=221;


create index b_num_idx on board(b_num, b_writer);
drop index b_num_idx;

SELECT seq_b.currval FROM dual;
select seq_board.nextval from dual;

INSERT INTO board 
			(b_num, b_writer, b_pwd, b_subject, b_content) 
			VALUES(seq_board.nextval, '작성자1', '1234', '제에목', '내애애애애용');

commit;

