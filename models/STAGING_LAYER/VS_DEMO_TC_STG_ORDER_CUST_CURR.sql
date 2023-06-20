{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}',
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='ORDER_CUST_CURR',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'STG_DL_SF1_ORDER_CUST_INCR', 'STG_DL_SF1_ORDER_CUST_INIT']
	)
}}
select * from (
	WITH "DIST_IO_FK1" AS 
	( 
		SELECT DISTINCT 
 			  "EXT_DIS_IO_SRC1"."O_CUSTKEY" AS "O_CUSTKEY"
		FROM {{ ref('VS_DEMO_TC_EXT_ORDER_CUST') }} "EXT_DIS_IO_SRC1"
	)
	, "SAT_SRC1" AS 
	( 
		SELECT 
			  "SAT_IO_SRC1"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "SAT_IO_SRC1"."C_CUSTKEY" AS "C_CUSTKEY"
			, MAX("SAT_IO_SRC1"."LOAD_DATE") AS "LOAD_DATE"
			, "SAT_IO_SRC1"."C_NAME" AS "C_NAME"
		FROM {{ source('RDV', 'S_SF1_CUSTOMER') }} "SAT_IO_SRC1"
		INNER JOIN "DIST_IO_FK1" "DIST_IO_FK1" ON  "DIST_IO_FK1"."O_CUSTKEY" = "SAT_IO_SRC1"."C_CUSTKEY"
		GROUP BY  "SAT_IO_SRC1"."CUSTOMER_HKEY",  "SAT_IO_SRC1"."C_CUSTKEY",  "SAT_IO_SRC1"."C_NAME"
	)
	, "DIST_FK1" AS 
	( 
		SELECT DISTINCT 
 			  "EXT_DIS_SRC1"."O_CUSTKEY" AS "O_CUSTKEY"
		FROM {{ ref('VS_DEMO_TC_EXT_ORDER_CUST') }} "EXT_DIS_SRC1"
	)
	, "PREP_FIND_BK_FK1" AS 
	( 
		SELECT 
			  UPPER(REPLACE(TRIM( "SAT_SRC1"."C_NAME"),'^','\\' || '^')) AS "C_NAME_BK"
			, "DIST_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
			, "SAT_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, 1 AS "GENERAL_ORDER"
		FROM "DIST_FK1" "DIST_FK1"
		INNER JOIN "SAT_SRC1" "SAT_SRC1" ON  "DIST_FK1"."O_CUSTKEY" = "SAT_SRC1"."C_CUSTKEY"
		INNER JOIN {{ source('RDV', 'H_CUSTOMER') }} "HUB_SRC1" ON  "HUB_SRC1"."CUSTOMER_HKEY" = "SAT_SRC1"."CUSTOMER_HKEY"
		UNION ALL 
		SELECT 
			  "EXT_FKBK_SRC1"."C_NAME_BK" AS "C_NAME_BK"
			, "DIST_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
			, "EXT_FKBK_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, 0 AS "GENERAL_ORDER"
		FROM "DIST_FK1" "DIST_FK1"
		INNER JOIN {{ ref('VS_DEMO_TC_EXT_SF1_CUSTOMER') }} "EXT_FKBK_SRC1" ON  "DIST_FK1"."O_CUSTKEY" = "EXT_FKBK_SRC1"."C_CUSTKEY"
	)
	, "ORDER_BK_FK1" AS 
	( 
		SELECT 
			  "PREP_FIND_BK_FK1"."C_NAME_BK" AS "C_NAME_BK"
			, "PREP_FIND_BK_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
			, ROW_NUMBER()OVER(PARTITION BY "PREP_FIND_BK_FK1"."O_CUSTKEY" ORDER BY "PREP_FIND_BK_FK1"."GENERAL_ORDER",
				"PREP_FIND_BK_FK1"."LOAD_DATE" DESC) AS "DUMMY"
		FROM "PREP_FIND_BK_FK1" "PREP_FIND_BK_FK1"
	)
	, "FIND_BK_FK1" AS 
	( 
		SELECT 
			  "ORDER_BK_FK1"."C_NAME_BK" AS "C_NAME_BK"
			, "ORDER_BK_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
		FROM "ORDER_BK_FK1" "ORDER_BK_FK1"
		WHERE  "ORDER_BK_FK1"."DUMMY" = 1
	)
	, "FAKE_PREV_REF" AS 
	( 
		SELECT 
			  "STG_DL_PREV_SRC"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST_PREV') }} "STG_DL_PREV_SRC"
		WHERE  0 = 1
	)
	SELECT 
		  UPPER(MD5_HEX(  'SF1' || '^' || COALESCE("FIND_BK_FK1"."C_NAME_BK","MEX_SRC"."KEY_ATTRIBUTE_VARCHAR")|| '^' || 
			'SF1' || '^' || "EXT_SRC"."O_ORDERKEY_FK_OORDERKEY_BK" || '^'  )) AS "LND_ORDERCUST_HKEY"
		, UPPER(MD5_HEX( 'SF1' || '^' || COALESCE("FIND_BK_FK1"."C_NAME_BK","MEX_SRC"."KEY_ATTRIBUTE_VARCHAR")|| '^' )) AS "CUSTOMER_HKEY"
		, UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."O_ORDERKEY_FK_OORDERKEY_BK" || '^' )) AS "ORDER_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1.ORDERCUST' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
		, "EXT_SRC"."O_CUSTKEY" AS "O_CUSTKEY"
		, TO_CHAR(NULL) AS "C_NAME_FK_OCUSTKEY_BK"
		, "EXT_SRC"."O_ORDERKEY_FK_OORDERKEY_BK" AS "O_ORDERKEY_FK_OORDERKEY_BK"
		, "EXT_SRC"."C_NAME" AS "C_NAME"
	FROM {{ ref('VS_DEMO_TC_EXT_ORDER_CUST') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'
	LEFT OUTER JOIN "FIND_BK_FK1" "FIND_BK_FK1" ON  "EXT_SRC"."O_CUSTKEY" = "FIND_BK_FK1"."O_CUSTKEY"

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "DIST_IO_FK1" AS 
	( 
		SELECT DISTINCT 
 			  "EXT_DIS_IO_SRC1"."O_CUSTKEY" AS "O_CUSTKEY"
		FROM {{ ref('VS_DEMO_TC_EXT_ORDER_CUST') }} "EXT_DIS_IO_SRC1"
	)
	, "SAT_SRC1" AS 
	( 
		SELECT 
			  "SAT_IO_SRC1"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "SAT_IO_SRC1"."C_CUSTKEY" AS "C_CUSTKEY"
			, MAX("SAT_IO_SRC1"."LOAD_DATE") AS "LOAD_DATE"
			, "SAT_IO_SRC1"."C_NAME" AS "C_NAME"
		FROM "DIST_IO_FK1" "DIST_IO_FK1"
		INNER JOIN {{ source('RDV', 'S_SF1_CUSTOMER') }} "SAT_IO_SRC1" ON  "DIST_IO_FK1"."O_CUSTKEY" = "SAT_IO_SRC1"."C_CUSTKEY"
		GROUP BY  "SAT_IO_SRC1"."CUSTOMER_HKEY",  "SAT_IO_SRC1"."C_CUSTKEY",  "SAT_IO_SRC1"."C_NAME"
	)
	, "DIST_FK1" AS 
	( 
		SELECT DISTINCT 
 			  "EXT_DIS_SRC1"."O_CUSTKEY" AS "O_CUSTKEY"
		FROM {{ ref('VS_DEMO_TC_EXT_ORDER_CUST') }} "EXT_DIS_SRC1"
	)
	, "PREP_FIND_BK_FK1" AS 
	( 
		SELECT 
			  UPPER(REPLACE(TRIM( "SAT_SRC1"."C_NAME"),'^','\\' || '^')) AS "C_NAME_BK"
			, "DIST_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
			, "SAT_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, 1 AS "GENERAL_ORDER"
		FROM "DIST_FK1" "DIST_FK1"
		INNER JOIN "SAT_SRC1" "SAT_SRC1" ON  "DIST_FK1"."O_CUSTKEY" = "SAT_SRC1"."C_CUSTKEY"
		INNER JOIN {{ source('RDV', 'H_CUSTOMER') }} "HUB_SRC1" ON  "HUB_SRC1"."CUSTOMER_HKEY" = "SAT_SRC1"."CUSTOMER_HKEY"
		UNION ALL 
		SELECT 
			  "EXT_FKBK_SRC1"."C_NAME_BK" AS "C_NAME_BK"
			, "DIST_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
			, "EXT_FKBK_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, 0 AS "GENERAL_ORDER"
		FROM "DIST_FK1" "DIST_FK1"
		INNER JOIN {{ ref('VS_DEMO_TC_EXT_SF1_CUSTOMER') }} "EXT_FKBK_SRC1" ON  "DIST_FK1"."O_CUSTKEY" = "EXT_FKBK_SRC1"."C_CUSTKEY"
	)
	, "ORDER_BK_FK1" AS 
	( 
		SELECT 
			  "PREP_FIND_BK_FK1"."C_NAME_BK" AS "C_NAME_BK"
			, "PREP_FIND_BK_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
			, ROW_NUMBER()OVER(PARTITION BY "PREP_FIND_BK_FK1"."O_CUSTKEY" ORDER BY "PREP_FIND_BK_FK1"."GENERAL_ORDER",
				"PREP_FIND_BK_FK1"."LOAD_DATE" DESC) AS "DUMMY"
		FROM "PREP_FIND_BK_FK1" "PREP_FIND_BK_FK1"
	)
	, "FIND_BK_FK1" AS 
	( 
		SELECT 
			  "ORDER_BK_FK1"."C_NAME_BK" AS "C_NAME_BK"
			, "ORDER_BK_FK1"."O_CUSTKEY" AS "O_CUSTKEY"
		FROM "ORDER_BK_FK1" "ORDER_BK_FK1"
		WHERE  "ORDER_BK_FK1"."DUMMY" = 1
	)
	SELECT 
		  UPPER(MD5_HEX(  'SF1' || '^' || COALESCE("FIND_BK_FK1"."C_NAME_BK","MEX_SRC"."KEY_ATTRIBUTE_VARCHAR")|| '^' || 
			'SF1' || '^' || "EXT_SRC"."O_ORDERKEY_FK_OORDERKEY_BK" || '^'  )) AS "LND_ORDERCUST_HKEY"
		, UPPER(MD5_HEX( 'SF1' || '^' || COALESCE("FIND_BK_FK1"."C_NAME_BK","MEX_SRC"."KEY_ATTRIBUTE_VARCHAR")|| '^' )) AS "CUSTOMER_HKEY"
		, UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."O_ORDERKEY_FK_OORDERKEY_BK" || '^' )) AS "ORDER_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1.ORDERCUST' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
		, "EXT_SRC"."O_CUSTKEY" AS "O_CUSTKEY"
		, TO_CHAR(NULL) AS "C_NAME_FK_OCUSTKEY_BK"
		, "EXT_SRC"."O_ORDERKEY_FK_OORDERKEY_BK" AS "O_ORDERKEY_FK_OORDERKEY_BK"
		, "EXT_SRC"."C_NAME" AS "C_NAME"
	FROM {{ ref('VS_DEMO_TC_EXT_ORDER_CUST') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'
	LEFT OUTER JOIN "FIND_BK_FK1" "FIND_BK_FK1" ON  "EXT_SRC"."O_CUSTKEY" = "FIND_BK_FK1"."O_CUSTKEY"

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'