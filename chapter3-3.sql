-- ��ȯ�Լ�

-- ����ȯ�Լ�
-- �ڵ�����ȯ�� �������ش�. (���ڿ� ����, ���ڿ� ��¥)
SELECT * FROM EMPLOYEES WHERE SALARY >= '10000'; -- ���� -> ���� �ڵ� ����ȯ
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '08/01/01';
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '080101';

-- ��������ȯ
-- TO_CHAR > ��¥�� ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY�� MM�� DD��') FROM DUAL; -- ��, ��, �� �� ��¥ ������ �ƴ϶� ����
SELECT TO_CHAR(SYSDATE, 'YY"��" MM"��" DD"��"') FROM DUAL; -- ��¥ ������ �ƴ� ���ڴ� " "�� �����ش�

-- TO_CHAR > ���ڸ� ����
SELECT TO_CHAR(20000, '999999999') AS RESULT FROM DUAL; -- 9�ڸ� ���ڷ� ǥ��
SELECT TO_CHAR(20000, '099999999') AS RESULT FROM DUAL; -- 9�ڸ�, ���ڸ� 0���� ä��
SELECT TO_CHAR(20000, '999') AS RESULT FROM DUAL; -- �ڸ����� �����ϸ� # ���� ó���ȴ�.
SELECT TO_CHAR(20000.123, '999999.9999') AS RESULT FROM DUAL; -- ���� 6�ڸ�, �Ǽ� 4�ڸ�
SELECT TO_CHAR(20000, '$9999999') AS RESULT FROM DUAL;
SELECT TO_CHAR(200000, 'L9,999,999') AS RESULT FROM DUAL;

-- ���� ȯ�� 1372.17��, SALARY �� ��ȭ�� ǥ��
SELECT FIRST_NAME, TO_CHAR(SALARY * 1372.17, 'L999,999,999,999,999') AS WON FROM EMPLOYEES;

-- TO_DATE ���ڸ� ��¥��
SELECT TO_DATE('2024 06 13', 'YYYY MM DD') FROM DUAL; -- ��¥ ���˿� ���� ��Ȯ�� ������ �ȴ�.
SELECT TO_DATE('20240613', 'YYYYMMDD') FROM DUAL;
SELECT SYSDATE-TO_DATE('20240613', 'YYYYMMDD') FROM DUAL;
SELECT TO_DATE('2024�� 06�� 13��', 'YYYY"��" MM"��" DD"��"') FROM DUAL; -- ��¥ ���� ���� �ƴ϶�� " " �� �����ش�.
SELECT TO_DATE('24-06-13 11�� 30�� 23��', 'YYYY-MM-DD HH"��" MI"��" SS"��"') FROM DUAL;

--
SELECT TO_CHAR(TO_DATE('240613', 'YYMMDD'), 'YYYY"��"MM"��"DD"��"') FROM DUAL;

-- TO_NUMBER ���ڸ� ���ڷ�, �ڵ�����ȯ �ȵɶ� ���
SELECT '4000' - 3000 FROM DUAL; -- �ڵ�����ȯ
SELECT '4,000' - 3000 FROM DUAL; -- �ڵ�����ȯ �ȵ�
SELECT TO_NUMBER('4,000', '9,999') - 3000 FROM DUAL; -- ����� ����ȯ �� ����
SELECT TO_NUMBER() FROM DUAL;

-- NVL NULL ó�� �Լ�
SELECT NVL (1000, 0), NVL(NULL, 0) FROM DUAL;
SELECT NULL + 1000 FROM DUAL; -- NULL �� �� ������ NULL �� ����

SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY*NVL(COMMISSION_PCT, 0) AS TOTAL FROM EMPLOYEES;

-- NVL2 (���, ���� �ƴ� ���, ���ΰ��)
SELECT NVL2(NULL, 'NOT NULL', 'YES NULL') FROM DUAL;
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, 
        NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY) AS TOTAL 
        FROM EMPLOYEES;

-- COALESCE (��, ��, ��......) NULL �� �ƴ� ù ��° ���� ��ȯ ������
SELECT COALESCE(1,2,3) FROM DUAL;
SELECT COALESCE(NULL, 2, 3, 4) FROM DUAL;
SELECT COALESCE(NULL, NULL, NULL, 3, NULL) FROM DUAL;
SELECT COALESCE(NULL, NULL) FROM DUAL;
SELECT COALESCE(COMMISSION_PCT, 0) FROM EMPLOYEES; -- NVL�� ����

-- DECODE (���, �񱳰�, �����, �񱳰�, ����� ....., DEFAULT)
SELECT DECODE('A', 'A', 'A�Դϴ�') FROM DUAL;
SELECT DECODE('X', 'A', 'A�Դϴ�', 'A���ƴ�') FROM DUAL;
SELECT DECODE('B', 'A', 'A�Դϴ�', 'B', 'B�Դϴ�', 'C', 'C�Դϴ�', '���ڰ��ƴ�') FROM DUAL;

SELECT JOB_ID, DECODE(JOB_ID, 
    'IT_PROG', SALARY * 1.1,
    'AD_VP', SALARY * 1.2,
    'FI_MGR', SALARY * 1.3,
    SALARY) AS �޿�
FROM EMPLOYEES;


-- CASE~WHEN~THEN ELSE END (SWITCH ���� ���)
SELECT FIRST_NAME, JOB_ID,
    CASE JOB_ID  -- �� ������ CASE�� ���´�.
        WHEN 'IT_PROG' THEN SALARY * 1.1
        WHEN 'AD_VP' THEN SALARY * 1.2
        WHEN 'FI_MGR' THEN SALARY *1.3
        ELSE SALARY
    END AS �޿�
FROM EMPLOYEES;

SELECT LAST_NAME, JOB_ID,
    CASE
        WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.1 -- ������ WHEN �������� �� �� �ִ�.
        WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.2
        WHEN JOB_ID = 'FI_MGR' THEN SALARY *1.3
        ELSE SALARY
    END AS �޿�
FROM EMPLOYEES;

-------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEES;
--���� 1.
--�������ڸ� �������� EMPLOYEE���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 10�� �̻���
--����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��� ������. 
--���� 1) �ټӳ���� ���� ��� ������� ����� �������� �մϴ�.
SELECT 
    EMPLOYEE_ID AS �����ȣ, 
    CONCAT(FIRST_NAME, LAST_NAME) AS �����,
    HIRE_DATE AS �Ի�����,
    TRUNC((SYSDATE - HIRE_DATE)/365) AS �ټӳ��
FROM EMPLOYEES
WHERE TRUNC((SYSDATE - HIRE_DATE)/365) >= 10
ORDER BY �ټӳ�� DESC;
--
--���� 2.
--EMPLOYEE ���̺��� manager_id�÷��� Ȯ���Ͽ� first_name, manager_id, ������ ����մϴ�.
--100�̶�� �����塯 
--120�̶�� �����塯
--121�̶�� ���븮��
--122��� �����ӡ�
--�������� ������� ���� ����մϴ�.
--���� 1) �μ��� 50�� ������� ������θ� ��ȸ�մϴ�
--���� 2) DECODE�������� ǥ���غ�����.
SELECT FIRST_NAME, MANAGER_ID, 
    DECODE(MANAGER_ID,
    100, '����',
    120, '����',
    121, '�븮',
    122, '����',
    '���') AS ����
FROM EMPLOYEES
WHERE DEPARTMENT_ID=50;
--���� 3) CASE�������� ǥ���غ�����.
SELECT FIRST_NAME, MANAGER_ID, 
    CASE MANAGER_ID
    WHEN 100 THEN '����'
    WHEN 120 THEN '����'
    WHEN 121 THEN '�븮'
    WHEN 122 THEN '����'
    ELSE '���'
    END AS ����
FROM EMPLOYEES
WHERE DEPARTMENT_ID=50;
--
--���� 3. 
--EMPLOYEES ���̺��� �̸�, �Ի���, �޿�, ���޴�� �� ����մϴ�.
--����1) HIRE_DATE�� XXXX��XX��XX�� �������� ����ϼ���. 
--����2) �޿��� Ŀ�̼ǰ��� �ۼ�Ʈ�� ������ ���� ����ϰ�, 1300�� ���� ��ȭ�� �ٲ㼭 ����ϼ���.
--����3) ���޴���� 5�� ���� �̷�� ���ϴ�. �ټӳ���� 5�� ������ ���޴������ ����մϴ�.
--����4) �μ��� NULL�� �ƴ� �����͸� ������� ����մϴ�.
--```
SELECT 
    FIRST_NAME AS �̸�,
    TO_CHAR(HIRE_DATE, 'YYYY"��"MM"��"DD"��"') AS �Ի���, 
    TO_CHAR(
        NVL2(COMMISSION_PCT, SALARY+SALARY*COMMISSION_PCT, SALARY)*1300, 'L999,999,999'
    ) AS �޿�,
    DECODE(
        MOD(TRUNC((SYSDATE - HIRE_DATE)/365), 5), 
        0, '���޴��',
        ' '
    ) AS ���޴��
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL;
