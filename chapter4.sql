-- �׷� �Լ�
-- NULL �� ���ܵ� �����͵鿡 ���ؼ� �����.
SELECT MAX(SALARY), MIN(SALARY), SUM(SALARY), AVG(SALARY), COUNT(SALARY) FROM EMPLOYEES;

-- MIN, MAX �� ��¥, ���ڿ��� ����ȴ�.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;

-- COUNT() �ΰ��� �����
SELECT COUNT(*), COUNT(COMMISSION_PCT) FROM EMPLOYEES;

-- �μ��� 80�� ����� ��, Ŀ�̼��� ���� ���� ���
SELECT MAX(COMMISSION_PCT) FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;

-- �׷� �Լ��� �Ϲ� �÷��̶� ���� ��� ���Ѵ�. �ٸ� DB �� ������ DB�� �ִ�.
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES; -- �ȵ�

-- �׷� �Լ� �ڿ� OVER() �� ���̸� ��� �࿡ ���� ���� ���� �Ϲ� �÷��� ���ÿ� ��� �����ϴ�.
SELECT FIRST_NAME, AVG(SALARY) OVER() FROM EMPLOYEES;

---------------------------------------------------------------

-- GROUP BY �� -  WHERE �� ORDER �� ���̿� ���´�.
-- GROUP BY �� ���� ����� �÷��� SELECT���� ����� �� �ִ�.
SELECT DEPARTMENT_ID, 
       SUM(SALARY), 
       AVG(SALARY), 
       MIN(SALARY), 
       MAX(SALARY),
       COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- 2�� �̻��� �׷�ȭ (���� �׷�)
SELECT DEPARTMENT_ID, JOB_ID
       , SUM(SALARY) AS "�μ� ������ �޿� ��"
       , AVG(SALARY) AS "�μ� ������ �޿� ���"
       , COUNT(*) AS �μ��ο���
       , COUNT(*) OVER() AS ���������� -- COUNT(*) OVER() : �� ���� ����
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID DESC;

SELECT EMPLOYEE_ID
FROM EMPLOYEES
GROUP BY EMPLOYEE_ID;

SELECT DEPARTMENT_ID
       , AVG(SALARY)
FROM EMPLOYEES
WHERE AVG(SALARY) > 1000 -- �׷��� ������ ���� ���� HAVING �̶�� ���� �ִ�.
GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL;
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 5000;
