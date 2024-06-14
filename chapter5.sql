SELECT * FROM AUTH;
SELECT * FROM INFO;

-- SELF JOIN - 프로그램에서 많이 사용됨, 하나의 테이블을 가지고 조인을 거는것
SELECT *
FROM EMPLOYEES A
JOIN EMPLOYEES B
ON A.MANAGER_ID = B.EMPLOYEE_ID;

-- INNER JOIN
SELECT * FROM INFO INNER JOIN AUTH ON INFO.AUTH_ID=AUTH.AUTH_ID; -- INNER 생략 가능

SELECT INFO.ID
     , INFO.TITLE
     , AUTH.AUTH_ID
     , AUTH.NAME
FROM INFO 
JOIN AUTH ON INFO.AUTH_ID=AUTH.AUTH_ID;

-- 테이블 명이 너무 길 경우 테이블 alias 기능 사용
SELECT * 
FROM INFO I
INNER JOIN AUTH A
ON I.AUTH_ID = A.AUTH_ID;

-- 연결할 키가 같아면 using 구문을 사용할 수 있다.
SELECT *
FROM INFO I
JOIN AUTH A
USING(AUTH_ID);


----------------------------------------------------------------------
-- OUTER JOIN
-- LEFT OUTHER JOIN
SELECT INFO.ID
     , INFO.AUTH_ID
     , INFO.TITLE
     , INFO.CONTENT
     , AUTH.NAME
     , AUTH.JOB 
FROM INFO 
LEFT OUTER JOIN AUTH -- OUTER 생략 가능
ON INFO.AUTH_ID=AUTH.AUTH_ID;

-- RIGHT OUTHER JOIN
-- RIGHT JOIN 의 테이블 자리만 바꾸면 LEFT JOIN이 된다.
SELECT INFO.ID
     , INFO.AUTH_ID
     , INFO.TITLE
     , INFO.CONTENT
     , AUTH.NAME
     , AUTH.JOB 
FROM INFO 
RIGHT OUTER JOIN AUTH 
ON INFO.AUTH_ID=AUTH.AUTH_ID;

-- FULL OUTHER JOIN
SELECT INFO.ID
     , INFO.AUTH_ID
     , INFO.TITLE
     , INFO.CONTENT
     , AUTH.NAME
     , AUTH.JOB 
FROM INFO 
FULL OUTER JOIN AUTH 
ON INFO.AUTH_ID=AUTH.AUTH_ID;

-- CROSS JOIN - 잘못된 조인 결과, 실제 쓸일 없다.
SELECT *
FROM INFO
CROSS JOIN AUTH;

----------------------------------------------------------------------
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT *
FROM EMPLOYEES
JOIN DEPARTMENTS
USING(DEPARTMENT_ID);

SELECT *
FROM EMPLOYEES
LEFT JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID;

-- 조인은 여러번 할 수 있다
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    D.DEPARTMENT_ID,
    L.CITY
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID=l.location_id
WHERE EMPLOYEE_ID >= 150;



-----------------------------------------------------------------------------
-- ORACLE JOIN - 오라클 에서만 사용 가능, 조인할 테이블을 FROM 절에 쓰고 조인 조건을 WHERE 절에 쓴다.
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID=A.AUTH_ID; -- ORACLE INNER JOIN

SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID=A.AUTH_ID(+); -- ORACLE LEFT JOIN

SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID(+)=A.AUTH_ID; -- ORACLE RIGHT JOIN

SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID(+)=A.AUTH_ID(+); -- ORACLE FULL RIGHT JOIN 은 없다.

SELECT *
FROM INFO I, AUTH A; -- ORACLE CROSS JOIN