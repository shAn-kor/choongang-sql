-- 시퀀스 (순차적으로 증가하는 값)
-- 주로 PK에 적용 가능

-- HR 계정 시퀀스 모두 조회
SELECT * FROM USER_SEQUENCES;

-- 시퀀스 생성
CREATE SEQUENCE DEPTS_SEQ
   INCREMENT BY 1
   START WITH 1
   MAXVALUE 10
   NOCACHE -- 캐시에 시퀀스 두지 않음
   NOCYCLE; -- 최대값 도달 시 재사용 안함

DROP TABLE DEPTS;

CREATE TABLE DEPTS (
   DEPT_NO NUMBER(2) PRIMARY KEY,
   DEPT_NAME VARCHAR(30)
);

-- 시퀀스 사용 방법 2가지
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; -- 현재 시퀀스 , NEXTVAL 먼저 실행되야함
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL; -- 현재 시퀀스 증가값만큼 증가

-- SEQUENCE 적용
INSERT INTO DEPTS VALUES(DEPTS_SEQ.NEXTVAL, 'EXAMPLE'); -- 시퀀스 꽉 차면 더 이상 추가 불가
SELECT * FROM DEPTS;

-- 시퀀스 수정
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10;

-- 시퀀스가 이미 사용 중일 경우 DROP 하면 안된다.
DROP SEQUENCE DEPTS_SEQ; -- 되기는 한다.

-- 시퀀스를 초기화해야 할 경우
-- 시퀀스 증가값을 음수로 만들어 초기화 인거 처럼 쓸수 있다.
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -69;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;

-----------------------------------------------------------------------------
-- 시퀀스 응용 (나중에 테이블 설계 시 데이터가 엄청 많다면 PK에 시퀀스 사용 고려)
-- 문자열 PK (년도값-일련번호)

CREATE TABLE DEPTS2 (
 DEPT_NO VARCHAR2(20) PRIMARY KEY,
 DEPT_NAME VARCHAR2(20)
 );
 INSERT INTO DEPTS2 VALUES(TO_CHAR(SYSDATE,'YYYY-MM')||LPAD(DEPTS_SEQ.NEXTVAL,6,0), 'EXAMPLE');
 SELECT * FROM DEPTS2;
 
 ---------------------------------------------------------------------------
 -- INDEX
 -- INDEX는 PK, UNIQUE에 자동으로 생성되고, 조회를 빠르게 하는 HINT 역할
 -- INDEX 종류는 고유인덱스, 비고유인덱스 가 있다.
 -- UNIQUE한 컬럼은 고유 인덱스가 쓰인다.
 -- 일반 컬럼에는 비고유 인덱스가 쓰인다.
 -- INDEX는 조회를 빠르게 하지만, DML 구문이 많이 사용되는 컬럼은 오히려 성능저하를 부른다.
 
 -- 인덱스 생성
 CREATE TABLE EMPS_IT AS (SELECT * FROM EMPLOYEES);
 
 -- 인덱스 없을 때 조회
 SELECT * FROM EMPS_IT WHERE FIRST_NAME='Nancy';
 
 -- 비고유 인덱스 생성
 CREATE INDEX EMPS_IT_IX ON EMPS_IT (FIRST_NAME);
 
 -- 인덱스 있을 때 조회
 SELECT * FROM EMPS_IT WHERE FIRST_NAME='Nancy';
 
 
 -- 인덱스 삭제 (테이블 영향 없음)
DROP INDEX EMPS_IT_IX;

-- 결합 인덱스 (여러개 컬럼을 동시에 인덱스로 지정)
CREATE INDEX EMPS_IT_IX ON EMPLOYEES (FIRST_NAME, LAST_NAME);

SELECT * FROM EMPLOYEES WHERE FIRST_NAME='Nancy'; -- 힌트 얻음
SELECT * FROM EMPLOYEES WHERE FIRST_NAME='Nancy' AND LAST_NAME='Greenberg'; -- 힌트 얻음
SELECT * FROM EMPLOYEES WHERE LAST_NAME='Greenberg';-- 힌트 얻음

-- 고유인덱스 (PK, UNIQUE에서 자동 생성)
-- CREATE UNIQUE INDEX 인덱스명
