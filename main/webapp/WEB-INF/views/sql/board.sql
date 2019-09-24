CREATE OR REPLACE PACKAGE PACK_ENCRYPTION_DECRYPTION
IS
FUNCTION FUNC_ENCRYPT -- ��ȣȭ�� ���� �Լ�
(V_INPUT_STRING IN VARCHAR2, KEY_DATA IN VARCHAR2:='boardpwd$!')
RETURN RAW;
FUNCTION FUNC_DECRYPT -- ��ȣȭ�� ���� �Լ�
(V_INPUT_STRING IN VARCHAR2, KEY_DATA IN VARCHAR2:='boardpwd$!')
RETURN VARCHAR2;
END PACK_ENCRYPTION_DECRYPTION;
/

--3. ��Ű�� ����
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
-- INPUT���� RAW Ÿ������ ����
V_ORIGINAL_RAW := UTL_I18N.STRING_TO_RAW(V_INPUT_STRING,
'AL32UTF8');
--Ű ���� RAW Ÿ������ ����.
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
b_num number not null primary key, --�Խù���ȣ 
b_unum number default null,         --�θ� ��ȣ
b_gnum number default 0,            --�Խù� �׷� ���� ����
b_mnum number default null,     --�ֻ����� ��ȣ
b_writer varchar2(60) not null, --�ۼ���
b_pwd varchar2(70) not null,    --��й�ȣ
b_subject varchar2(170) not null, --����
b_content clob not null, --����
b_readcount number default 0,	--��ȸ��
b_date date default sysdate, --�ۼ����� 
b_show char(1) default 'Y',    --�Խ��� ��� ����
b_secret char(1) default 'N'  --��б� ����
);

drop sequence seq_b;
create sequence seq_b
start with 1
increment by 1;

commit;

drop table board_comment;

create table board_comment (
c_num number not null primary key, --��� �Ϸù�ȣ 
b_num number not null,
c_writer varchar2(60) not null,
c_pwd varchar2(50) not null,
c_content varchar2(800) not null, 
c_date date default sysdate,
c_show char(1) default 'Y',    --��� ��� ����
c_secret char(1) default 'N'
);

drop sequence seq_comment;
create sequence seq_comment
start with 1
increment by 1;

drop table board_file;
create table board_file(
f_num number not null primary key,
b_num number not null,
b_filename varchar2(300), --���� �̸�
b_file blob,            --����
b_filesize number     --���� ũ��
);

select * from board_file;

drop sequence seq_file;
create sequence seq_file
start with 1
increment by 1;

declare --�����
    i number := 2;
begin --�����
    while i<=250 loop
        insert into board (b_num,b_mnum,b_subject,b_content,b_writer, b_pwd, b_gnum)
        values
        ( seq_b.nextval,seq_b.nextval
        ,'����'||i, '����'||i, 'kim', '1234', 0);
        i := i+1; --���� ����
    end loop;
end;
/

commit;

select * from board order by b_num desc;

select count(*) from board where b_num=214 and b_writer='123123' and b_pwd='1234';

select LEVEL, b_num,b_unum, b_gnum,b_writer,LPAD(' ', 4*(LEVEL-1)) || CASE WHEN (LEVEL -1) > 0 THEN '��' END || b_subject as b_subject
                    ,b_date,b_readcount,b_show,b_secret --,ROW_NUMBER() OVER(ORDER BY b_num ASC) as idx
	  				,(select count(*) from board_comment c where c.b_num=b.b_num and c_show='Y') c_count
from board b
START WITH b_unum IS NULL
                    CONNECT BY PRIOR b_num = b_unum  
					ORDER SIBLINGS BY b_gnum ASC, b_num DESC;
                    
insert into board(b_num, b_unum, b_gnum, b_writer, b_pwd, b_subject, b_content) values(251, 250, 1, '�ۼ���', '����', '1234', '����');
insert into board(b_num, b_unum, b_gnum, b_writer, b_pwd, b_subject, b_content) values(252, 251, 1, '�ۼ���', '����', '1234', '����');
insert into board(b_num, b_unum, b_gnum, b_writer, b_pwd, b_subject, b_content) values(253, 250, 2, '�ۼ���', '����', '1234', '����');


SELECT * FROM (
             SELECT rownum AS rn, ROW_NUMBER() OVER(ORDER BY rownum DESC) as idx,
			A.* FROM (
				SELECT level, b_num,b_unum, b_gnum,b_mnum,b_writer,LPAD(' ', 4*(LEVEL-1)) || CASE WHEN (LEVEL -1) > 0 THEN '�� ' END || b_subject as b_subject
                    , b_pwd ,b_date,b_readcount,b_show,b_secret 
	  				,(select count(*) from board_comment c where c.b_num=b.b_num and c_show='Y') c_count,
                    (select count(*) from board_file f where f.b_num=b.b_num) f_count
					FROM board b
					WHERE b.b_show LIKE '%' AND b.b_writer LIKE '%'
                    START WITH b_unum IS NULL
                    CONNECT BY PRIOR b_num = b_unum  
					ORDER SIBLINGS BY b_gnum DESC, b_num DESC
					) A
		) WHERE rn BETWEEN 1 AND 10 order by rn ASC; 
        
        
        
select * from board order by b_num desc;

update board set b_show='Y', b_secret='N' where b_num>=262;

commit;

SELECT b_num as b_unum, (SELECT nvl2(max(b_gnum),max(b_gnum)+1,1) FROM board WHERE b_unum=248) as b_gnum
			, b_writer, b_subject, b_content, b_date
			FROM board 
			WHERE b_num=248;

SELECT nvl2(max(b_gnum),max(b_gnum)+1,1) FROM board WHERE b_unum=248;

delete from board where b_num=253;

SELECT b_show FROM board WHERE b_num=253 OR b_mnum=251;

create index b_num_idx on board(b_num, b_writer);
drop index b_num_idx;

SELECT seq_b.currval FROM dual;
select seq_board.nextval from dual;

INSERT INTO board 
			(b_num, b_mnum, b_writer, b_pwd, b_subject, b_content) 
			VALUES(seq_b.nextval,seq_b.nextval, '�ۼ���1', '1234', '������', '���־־־ֿ�');

select * from board;

commit;

delete from board where b_num > 251;
