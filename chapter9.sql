-- DDL (트랜잭션 없음)
-- CREATE, ALTER, DROP

DROP TABLE DEPTS; -- 테이블 삭제

CREATE TABLE DEPTS (
   DEPT_NO NUMBER(2), -- 숫자 정수 2자리
   DEPT_NAME VARCHAR2(30), -- 30 바이트 (한글은 15글자, 숫자 영어 30글자)
   DEPT_YN CHAR(1), -- 고정문자 1바이트 (VARCHAR2 대체 가능)
   DEPT_DATE DATE,
   DEPT_BONUS NUMBER(10,2), -- 숫자 정수 10자리, 소수점 2자리
   DEPT_CONTENT LONG -- 2기가 까지 저장되는 가변 문자열 (VARCHAR2 보다 더 큰
);
DESC DEPTS;
INSERT INTO DEPTS VALUES(99,'HELLO', 'Y', SYSDATE, 3.14, 'LONG TEXT~~~~');
INSERT INTO DEPTS VALUES(100,'HELLO', 'Y', SYSDATE, 3.14, 'LONG TEXT~~~'); -- NUMBER 정수 2자리 초과
INSERT INTO DEPTS VALUES(1,'HELLO', '가', SYSDATE, 3.14, 'LONG TEXT~~~'); -- DEPT_YN 초과 (한글 2바이트)
SELECT * FROM DEPTS;


-----------------------------------------------------------------------------
-- ALTER - 테이블 구조 변경
-- ADD, MODIFY, RENAME, DROP
ALTER TABLE DEPTS ADD DEPT_COUNT NUMBER(3); -- 마지막에 컬럼 추가

ALTER TABLE DEPTS RENAME COLUMN DEPT_COUNT TO EMP_COUNT; -- 컬럼명 변경

ALTER TABLE DEPTS MODIFY EMP_COUNT NUMBER(5); -- 컬럼 크기 수정
ALTER TABLE DEPTS MODIFY EMP_COUNT NUMBER(1); -- 컬럼 크기 수정
ALTER TABLE DEPTS MODIFY DEPT_NAME VARCHAR(1); -- 이미 저장된 값 보다 작은 크기로 변경 불가

ALTER TABLE DEPTS DROP COLUMN EMP_COUNT;

-------------------------------------------------------------------------------
DROP TABLE DEPTS; -- 테이블 삭제
DROP TABLE DEPTS CASCADE; -- 테이블이 가지는 FK 제약조건을 삭제하면서, 테이블 날려버림 (위험)

