-- ���� �Լ�

-- ROUND �ݿø�
SELECT ROUND(45.923), ROUND(45.923, 1), ROUND(45.923, -1), ROUND(45.923, -2) FROM DUAL;

-- TRUNC ����
SELECT TRUNC(45.923), TRUNC(45.923, 2), TRUNC(45.923), TRUNC(45.923, -1) FROM DUAL;

-- ABS ���밪
-- CEIL �ø�
-- FLOOR ����
SELECT ABS(-45), CEIL(45.3), FLOOR(45.9) FROM DUAL;

-- MOD ������
SELECT 5/3, MOD(5,3) FROM DUAL;

-----------------------------------------------------------------------------------
-- ��¥ �Լ�

-- SYSDATE ���� ��¥
SELECT SYSDATE FROM DUAL; -- �����
SELECT SYSTIMESTAMP FROM DUAL; -- ����� �ú���

-- ��¥�� ���� ����, DAY �������� ���� �ȴ�.
SELECT HIRE_DATE, HIRE_DATE+18, HIRE_DATE-1 FROM EMPLOYEES;

SELECT FIRST_NAME, ROUND((SYSDATE - HIRE_DATE) / 7) FROM EMPLOYEES; -- �Ի��� ���� �� ��?
SELECT FIRST_NAME, ROUND((SYSDATE - HIRE_DATE) / 365) FROM EMPLOYEES; -- �Ի��� ���� �� ��?

-- ��¥�� �ݿø�, ����
-- ROUND ���� ����, TRUNC ���� ����
SELECT ROUND(SYSDATE), TRUNC(SYSDATE) FROM DUAL;
SELECT ROUND(SYSDATE,'MONTH'), TRUNC(SYSDATE, 'MONTH') FROM DUAL; -- �� ����
SELECT ROUND(SYSDATE,'YEAR'), TRUNC(SYSDATE, 'YEAR') FROM DUAL; -- �� ����
