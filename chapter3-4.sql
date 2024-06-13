-- ���տ�����
/*
UNION - ������, �ߺ�X
UNION ALL - ������, �ߺ� ���
INTERSECT - ������
MINUS - ������

�÷� ������ ��ġ�ؾ� ���� ������ ����� �����ϴ�.
*/
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
UNION
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
UNION ALL
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
INTERSECT
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
MINUS
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------

-- ���տ����ڴ� DUAL ���� ���� �����͸� ���� ��ĥ �� �ִ�.
SELECT 200, 'HONG', '�����' FROM DUAL
UNION 
SELECT 300, 'LEE', '��⵵' FROM DUAL
UNION 
SELECT EMPLOYEE_ID, LAST_NAME, '�����' FROM EMPLOYEES;


---------------------------------------------------------------------
-- �м��Լ�
-- �м��Լ�() OVER (���� ���)
SELECT 
    FIRST_NAME,
    SALARY,
    RANK() OVER(ORDER BY SALARY DESC) AS �ߺ��������, -- �ߺ� ���� ���
    DENSE_RANK() OVER(ORDER BY SALARY DESC) AS �ߺ����µ��, -- �ߺ� ���� ��� X
    ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS �Ϸù�ȣ,
    ROWNUM AS ��ȸ���� -- ��ȸ�� �� ����
FROM EMPLOYEES;

-- ROWNUM �� ORDER ��ų �� ����� �ٲ��.
SELECT ROWNUM,
FIRST_NAME,
SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;