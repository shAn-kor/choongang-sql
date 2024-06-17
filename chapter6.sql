-- �������� (SELECT �������� Ư�� ��ġ�� �ٽ� SELECT�� ���� ����
-- ������ �������� - ���������� ����� 1���� ��������

-- ���ú��� �޿��� ���� ���
-- 1. ������ �޿��� ã�´�.
-- 2. ã�� �޿��� WHERE ���� �ִ´�.
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='Nancy');

-- 103���� ������ ���� ���
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=103);

-- ������ �� - ���� �÷��� ��Ȯ�� �Ѱ����� �Ѵ�.
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT *FROM EMPLOYEES WHERE EMPLOYEE_ID=103);

-- ������ �� - �������� ������ �����̶��, ������ �������� �����ڸ� ����� �Ѵ�.
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Steven';
SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Steven');

--------------------------------------------------------------------------
-- ���� �� �������� - ���������� ����� ���� �� ���� �Ǵ� ��� (IN, ANY, ALL)
SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David';

-- ���̺���� �ּ� �޿����� ���� �޴� ���
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');

-- ���̺���� �ִ� �޿����� ���� �޴� ���
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');

-- ���̺�� �ִ� �޿����� ���� �޴� ���
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');

-- ���̺�� �ּ� �޿����� ���� �޴� ���
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');


-- IN ������ ������ ��, ��ġ�ϴ� ������
-- ���̺��� �μ��� ���� �����
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
FROM EMPLOYEES
WHERE FIRST_NAME='David');


--------------------------------------------------------------------------
-- ��Į�� ���� - SELECT ���� ���������� ���� ��� (JOIN ��ü)
SELECT FIRST_NAME,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID;

-- ��Į��� �ٲ㺸��
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME
       FROM DEPARTMENTS D
       WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID) AS DEPARTMENT_NAME
FROM EMPLOYEES E;

-- ��Į�� ������ �ٸ� ���̺��� 1���� �÷��� ������ �ö�, JOIN���� ������ ����ϴ�.
SELECT FIRST_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) JOB_TITLE
FROM EMPLOYEES E;
---
-- �ѹ��� �ϳ��� Į���� �������� ������ ���� ���� �����ö��� JOIN�� �������� ����.
SELECT FIRST_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) JOB_TITLE,
       (SELECT MIN_SALARY FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) MIN_SALARY
FROM EMPLOYEES E;

-- ����
-- FIRST ANME �÷�, DEPARTMENT_NAME, JOB_TITLE�� ���ÿ� SELECT
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID) DEPARTMENT_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) JOB_TITLE
FROM EMPLOYEES E;

-------------------------------------------------------------------------------
-- �ζ��� �� - FROM ���� �������� ���� ����.
-- �ζ��� �信�� (�����÷�) �� �����, �� �÷��� ���ؼ� ��ȸ�� ������ ����Ѵ�.

-- ROWNUM �� ��ȸ�� ������ ���� ��ȣ�� �ٽ��ϴ�.
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;

-- ORDER�� ���� ��Ų ����� ���� ����ȸ
SELECT ROWNUM,
FIRST_NAME,
SALARY
FROM (SELECT FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC)
WHERE ROWNUM BETWEEN 11 AND 20; -- ROWNUM�� Ư¡�� �ݵ�� 1���� ���� (��� ����)

-- ORDER BY �� ���� ��Ų ����� �����, ROWNUM ���󿭷� �ٽ� �����, ����ȸ
SELECT *
FROM (
    SELECT ROWNUM AS RN, -- ���� �� (���������� ������ ��)
           FIRST_NAME,
           SALARY
    FROM (
        SELECT FIRST_NAME,
               SALARY
        FROM EMPLOYEES
        ORDER BY SALARY DESC
    )
)
WHERE RN BETWEEN 11 AND 20; -- �ȿ��� RN���� ������� ������ �ۿ��� ����� �� �ִ�.

-- ����
-- �ټӳ�� 5��° �Ǵ� ����鸸 ����ϰڴ�.
SELECT *
FROM (SELECT FIRST_NAME,
       HIRE_DATE,
       TRUNC((SYSDATE-HIRE_DATE) / 365) AS �ټӳ�� -- �ȿ��� ���� ���󿭿� ���ؼ� ����ȸ �Ҷ� �ζ��κ䰡 ����
       FROM EMPLOYEES)
WHERE MOD(�ټӳ��, 5)=0
ORDER BY �ټӳ�� DESC;

-- �ζ��� �信�� ���̺� �ٸ���� ��ȸ
SELECT ROWNUM AS RN,
       A.*
FROM  (SELECT E.*,
       TRUNC((SYSDATE-HIRE_DATE) / 365) AS �ټӳ�� -- �ȿ��� ���� ���󿭿� ���ؼ� ����ȸ �Ҷ� �ζ��κ䰡 ����
       FROM EMPLOYEES E
       ORDER BY �ټӳ�� DESC
) A;