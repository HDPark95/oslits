/*------------------------------------------------------------------------------
-- ��ü �̸�: OSLAGLDB.SF_ADM1000_GET_NEW_MENU_ID
-- ���� ��¥: 2016-12-20 ���� 11:57:33
-- ���������� ������ ��¥: 2016-12-20 ���� 11:57:33
-- ����: VALID
------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION OSLAGLDB.SF_ADM1000_GET_NEW_MENU_ID
(
		I_LIC_GRP_ID 	IN 	VARCHAR2
	,	I_MENU_ID		IN	VARCHAR2
)

/*******************************************************************************************************
 FUNCTION �� 	  :	SF_ADM1000_GET_NEW_MENU_ID
 FUNCTION ����     : ���� �޴�ID �� �̿��� �� �޴�ID�� �߱��Ѵ�.
 ���ȭ��          : ����, ADM1000
 INPUT             : I_UPPER_MENU_ID	: ���� �޴� ID

 RETURN			   : MENU_ID
 �ۼ���/�ۼ���     : ������ / 2016-01-13
 �������̺�        : ADM1000
 ������/������     : 2016-01-13
 ��������          : ���ʻ���
*******************************************************************************************************/

RETURN VARCHAR2 IS

	V_MENU_ID			VARCHAR2(12);
    V_TEMP_MENU_ID		VARCHAR2(12);
    V_LVL				VARCHAR2(2);
	V_CNT				NUMBER;
BEGIN
	BEGIN
        --���� �޴� ���� ����
        SELECT	LVL
        INTO	V_LVL
        FROM	ADM1000 A
        WHERE	1=1
        AND		A.LIC_GRP_ID = I_LIC_GRP_ID
        AND		A.MENU_ID = I_MENU_ID
        ;

        SELECT	COUNT(*)
        INTO	V_CNT
        FROM	ADM1000 A
        WHERE	1=1
        AND		A.LIC_GRP_ID = I_LIC_GRP_ID
        AND		A.UPPER_MENU_ID = I_MENU_ID
        ;

        --���� �޴��� ��Ʈ(0) �̸� 1���� �޴���(�� 4�ڸ�)
        --���� �޴��� �������� ������ 0001 ������ ����
        IF V_LVL = '0' THEN
            SELECT	LPAD(NVL(MAX(SUBSTR(MENU_ID,1,4)) + 1 , '0001'), 4, '0') || '00000000' AS MENU_ID
            INTO	V_MENU_ID
            FROM	ADM1000 A
            WHERE	1=1
            AND		A.LIC_GRP_ID = I_LIC_GRP_ID
            AND		A.UPPER_MENU_ID = I_MENU_ID
            ;

		--�����޴��� 1���� �̸�
        ELSIF V_LVL = '1' THEN
            V_TEMP_MENU_ID := SUBSTR(I_MENU_ID, 1, 4);

            SELECT	LPAD(NVL(MAX(SUBSTR(MENU_ID,1,8)) + 1 , V_TEMP_MENU_ID || '0001'), 8, '0') || '0000' AS MENU_ID
            INTO	V_MENU_ID
            FROM	ADM1000 A
            WHERE	1=1
            AND		A.LIC_GRP_ID = I_LIC_GRP_ID
            AND		A.UPPER_MENU_ID = I_MENU_ID
            ;

        --�����޴��� 2�����̸�
        ELSIF V_LVL = '2' THEN
            V_TEMP_MENU_ID := SUBSTR(I_MENU_ID, 1, 8);

            SELECT	LPAD(NVL(MAX(SUBSTR(MENU_ID,1,12)) + 1 , V_TEMP_MENU_ID || '0001'), 12, '0') AS MENU_ID
            INTO	V_MENU_ID
            FROM	ADM1000 A
            WHERE	1=1
            AND		A.LIC_GRP_ID = I_LIC_GRP_ID
            AND		A.UPPER_MENU_ID = I_MENU_ID
            ;

        ELSE
            V_MENU_ID := '';
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_MENU_ID := '';
            DBMS_OUTPUT.PUT_LINE('SQL_ERR : '  || SQLCODE || ' : ' || SQLERRM);
            RETURN V_MENU_ID;
        WHEN OTHERS THEN
            V_MENU_ID := '';
            DBMS_OUTPUT.PUT_LINE('SQL_ERR : '  || SQLCODE || ' : ' || SQLERRM);
            RETURN V_MENU_ID;
    END;

	RETURN V_MENU_ID;

END;


/*------------------------------------------------------------------------------
-- ��ü �̸�: OSLAGLDB.SF_ADM1000_MENU_NM
-- ���� ��¥: 2016-12-20 ���� 11:57:35
-- ���������� ������ ��¥: 2016-12-20 ���� 11:57:35
-- ����: VALID
------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION OSLAGLDB.SF_ADM1000_MENU_NM
(
		I_LIC_GRP_ID 	IN 	VARCHAR2
	,	I_MENU_ID		IN	VARCHAR2
    ,	I_RTN_GB		IN	VARCHAR2
)

/*******************************************************************************************************
 FUNCTION �� 	  :	SF_ADM1000_MENU_NM
 FUNCTION ����     : �޴��� ��� �Լ�
 ���ȭ��          : ����, ADM1000
 INPUT             : I_LIC_GRP_ID 	: ���̼��� �׷� �ڵ�
 					 I_MENU_ID 		: �޴� ID
                     I_RTN_GB		: 1 (���� �޴��ڵ��� �޴���)
                      				  2 (���� �޴��ڵ��� �θ� �޴���)
                                      3 (���� �޴��ڵ��� �θ��� �θ� �޴���)
 RETURN			   : �޴���
 �ۼ���/�ۼ���     : ������ / 2015-12-17
 �������̺�        : ADM1000
 ������/������     : 2015-12-17
 ��������          : ���ʻ���
*******************************************************************************************************/

RETURN VARCHAR2 IS

 	RTN_MENU_NM		VARCHAR2(1000);

BEGIN

	BEGIN

    	-- ������ 1�ϰ�� �޴��ڵ��� �޴���
    	IF I_RTN_GB = '1' THEN
        	SELECT	MENU_NM
            INTO	RTN_MENU_NM
            FROM	ADM1000 A
            WHERE	1=1
            AND		A.LIC_GRP_ID = I_LIC_GRP_ID
            AND		A.MENU_ID = I_MENU_ID
            ;

        -- ������ 2�� ��� �޴��ڵ��� �θ� �޴���
        ELSIF I_RTN_GB = '2' THEN
        	SELECT	MENU_NM
            INTO	RTN_MENU_NM
            FROM	ADM1000 A
            WHERE	1=1
            AND		A.LIC_GRP_ID = I_LIC_GRP_ID
            AND		A.MENU_ID = (
            						SELECT 	UPPER_MENU_ID
                                    FROM	ADM1000 A
                                    WHERE	1=1
                                    AND		A.LIC_GRP_ID = I_LIC_GRP_ID
                                    AND		A.MENU_ID = I_MENU_ID

            					)
            ;

        -- ������ 3�� ��� �޴��ڵ��� �θ��� �θ� �޴���
        ELSIF I_RTN_GB = '3' THEN
        	SELECT	MENU_NM
            INTO	RTN_MENU_NM
            FROM	ADM1000 A
            WHERE	1=1
			AND		A.LIC_GRP_ID = I_LIC_GRP_ID
            AND		A.MENU_ID = (
            						SELECT 	UPPER_MENU_ID
                                    FROM	ADM1000 A
                                    WHERE	1=1
                                    AND		A.LIC_GRP_ID = I_LIC_GRP_ID
                                    AND		A.MENU_ID = (
                                    						SELECT	UPPER_MENU_ID
                                                            FROM	ADM1000 A
                                                            WHERE	1=1
                                                            AND		A.LIC_GRP_ID = I_LIC_GRP_ID
                                                            AND 	A.MENU_ID = I_MENU_ID
                                    					)
            					)
            ;

        -- �׿� ��� �� ����.
        ELSE
        	RTN_MENU_NM := '';
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RTN_MENU_NM :=  '';
        WHEN OTHERS THEN
           RTN_MENU_NM :=  '';
    END;

 	RETURN RTN_MENU_NM;
END;


/*------------------------------------------------------------------------------
-- ��ü �̸�: OSLAGLDB.SF_ADM1000_MST_CD_NM
-- ���� ��¥: 2016-12-20 ���� 11:57:36
-- ���������� ������ ��¥: 2016-12-20 ���� 11:57:36
-- ����: VALID
------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION OSLAGLDB.SF_ADM1000_MST_CD_NM
(
		I_LIC_GRP_ID 	IN 	VARCHAR2
	,	I_MST_CD		IN	VARCHAR2
)

/*******************************************************************************************************
 FUNCTION �� 	  :	SF_ADM1000_MST_CD_NM
 FUNCTION ����     : ��з��� ��� �Լ�
 ���ȭ��          : ����, ADM1000
 INPUT             : I_LIC_GRP_ID 	: ���̼��� �׷� �ڵ�
 					 I_MST_CD 		: ��з� CD
 RETURN			   : �����ڵ� ��з� ��
 �ۼ���/�ۼ���     : ������ / 2016-01-14
 �������̺�        : ADM4000
 ������/������     : 2016-01-14
 ��������          : ���ʻ���
*******************************************************************************************************/

RETURN VARCHAR2 IS

 	RTN_MST_CD_NM		VARCHAR2(1000);

BEGIN

	BEGIN

    	SELECT	MST_CD_NM
        INTO	RTN_MST_CD_NM
        FROM	ADM4000 A
        WHERE	1=1
        AND		A.LIC_GRP_ID = I_LIC_GRP_ID
        AND		A.MST_CD = I_MST_CD
        ;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RTN_MST_CD_NM :=  '';
        WHEN OTHERS THEN
           RTN_MST_CD_NM :=  '';
    END;

 	RETURN RTN_MST_CD_NM;
END;


/*------------------------------------------------------------------------------
-- ��ü �̸�: OSLAGLDB.SF_ADM2000_USR_INFO
-- ���� ��¥: 2016-12-20 ���� 11:57:37
-- ���������� ������ ��¥: 2017-08-31 ���� 2:01:20
-- ����: VALID
------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION OSLAGLDB.SF_ADM2000_USR_INFO
(
		I_USR_ID		IN	VARCHAR2
	,	I_USR_INFO_CODE	IN 	VARCHAR2
)

/*******************************************************************************************************
 FUNCTION �� 	  :	SF_ADM2000_USR_INFO
 FUNCTION ����     : �����ID�� ����ڸ� ��ȸ
 ���ȭ��          : ����
 INPUT             : I_USR_ID			: ����� ID
 					 I_USR_INFO_CODE 	: ����� ���� ����
                     						1 = ����
                                            2 = �̸���
                                            3 = ��ȭ��ȣ
                                            4 = �ٹ����۽ð�
                                            5 = �ٹ�����ð�
                                            6 = ������̹���ID
 RETURN			   : �۾��帧��
 �ۼ���/�ۼ���     : ������ / 2016-01-23
 �������̺�        : ADM2000
 ������/������     : ���ֿ� / 2017-04-07
 ��������          : ������̹���ID �߰�
*******************************************************************************************************/

RETURN VARCHAR2 IS

 	V_USR_NM		VARCHAR(20);
    V_USR_EMAIL		VARCHAR(50);
	V_USR_TELNO		VARCHAR(20);
    V_WK_ST_TM		VARCHAR2(7);
    V_WK_ED_TM		VARCHAR2(7);
    V_USR_IMG_ID	VARCHAR2(20);

    O_RESULT		VARCHAR(50);

BEGIN

	BEGIN

    	SELECT	A.USR_NM
        	,	A.EMAIL
            ,	A.TELNO
            ,	A.WK_ST_TM
            ,	A.WK_ED_TM
            ,	A.USR_IMG_ID
        INTO	V_USR_NM
        	,	V_USR_EMAIL
            ,	V_USR_TELNO
            ,	V_WK_ST_TM
            ,	V_WK_ED_TM
            ,	V_USR_IMG_ID
        FROM	ADM2000	A
        WHERE	A.USR_ID = I_USR_ID
        ;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_USR_NM :=  '';
           V_USR_EMAIL := '';
           V_USR_TELNO := '';
           V_WK_ST_TM := '';
           V_WK_ED_TM := '';
           V_USR_IMG_ID := '';
        WHEN OTHERS THEN
   			V_USR_NM :=  '';
           V_USR_EMAIL := '';
           V_USR_TELNO := '';
           V_WK_ST_TM := '';
           V_WK_ED_TM := '';
           V_USR_IMG_ID := '';
    END;

	IF I_USR_INFO_CODE = '1' THEN O_RESULT := V_USR_NM;
    ELSIF I_USR_INFO_CODE ='2' THEN O_RESULT := V_USR_EMAIL;
    ELSIF I_USR_INFO_CODE ='3' THEN O_RESULT := V_USR_TELNO;
    ELSIF I_USR_INFO_CODE ='4' THEN O_RESULT := V_WK_ST_TM;
    ELSIF I_USR_INFO_CODE ='5' THEN O_RESULT := V_WK_ED_TM;
    ELSIF I_USR_INFO_CODE ='6' THEN O_RESULT := V_USR_IMG_ID;
 	END IF;

    RETURN O_RESULT;
END;


