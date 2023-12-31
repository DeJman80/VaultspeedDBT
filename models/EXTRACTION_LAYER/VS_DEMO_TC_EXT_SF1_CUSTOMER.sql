{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}',
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='SF1_CUSTOMER',
		schema='VS_DEMO_TC_EXT',
		tags=['VS_DEMO_TC', 'EXT_SF1_SF1CUSTOMER_INCR', 'EXT_SF1_SF1CUSTOMER_INIT']
	)
}}
select * from (
	WITH "CALCULATE_BK" AS 
	( 
		SELECT 
			  "LCI_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "LCI_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "MEX_SRC"."ATTRIBUTE_VARCHAR" AS "JRN_FLAG"
			, "TDFV_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
			, "TDFV_SRC"."C_CUSTKEY" AS "C_CUSTKEY"
			, COALESCE(UPPER(REPLACE(TRIM( "TDFV_SRC"."C_NAME"),'^','\\' || '^')),"MEX_SRC"."KEY_ATTRIBUTE_VARCHAR") AS "C_NAME_BK"
			, "TDFV_SRC"."C_NAME" AS "C_NAME"
			, "TDFV_SRC"."C_ADDRESS" AS "C_ADDRESS"
			, "TDFV_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
			, "TDFV_SRC"."C_PHONE" AS "C_PHONE"
			, "TDFV_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
			, "TDFV_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "TDFV_SRC"."C_COMMENT" AS "C_COMMENT"
			, "TDFV_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM {{ ref('VS_DEMO_TC_DFV_VW_SF1_CUSTOMER') }} "TDFV_SRC"
		INNER JOIN {{ source('VS_DEMO_TC_MTD', 'LOAD_CYCLE_INFO') }} "LCI_SRC" ON  1 = 1
		INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  1 = 1
		WHERE  "MEX_SRC"."RECORD_TYPE" = 'N'
	)
	, "EXT_UNION" AS 
	( 
		SELECT 
			  "CALCULATE_BK"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CALCULATE_BK"."LOAD_DATE" AS "LOAD_DATE"
			, "CALCULATE_BK"."JRN_FLAG" AS "JRN_FLAG"
			, "CALCULATE_BK"."RECORD_TYPE" AS "RECORD_TYPE"
			, "CALCULATE_BK"."C_CUSTKEY" AS "C_CUSTKEY"
			, "CALCULATE_BK"."C_NAME_BK" AS "C_NAME_BK"
			, "CALCULATE_BK"."C_NAME" AS "C_NAME"
			, "CALCULATE_BK"."C_ADDRESS" AS "C_ADDRESS"
			, "CALCULATE_BK"."C_NATIONKEY" AS "C_NATIONKEY"
			, "CALCULATE_BK"."C_PHONE" AS "C_PHONE"
			, "CALCULATE_BK"."C_ACCTBAL" AS "C_ACCTBAL"
			, "CALCULATE_BK"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "CALCULATE_BK"."C_COMMENT" AS "C_COMMENT"
			, "CALCULATE_BK"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM "CALCULATE_BK" "CALCULATE_BK"
	)
	SELECT 
		  "EXT_UNION"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "EXT_UNION"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_UNION"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_UNION"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_UNION"."C_CUSTKEY" AS "C_CUSTKEY"
		, "EXT_UNION"."C_NAME_BK" AS "C_NAME_BK"
		, "EXT_UNION"."C_NAME" AS "C_NAME"
		, "EXT_UNION"."C_ADDRESS" AS "C_ADDRESS"
		, "EXT_UNION"."C_NATIONKEY" AS "C_NATIONKEY"
		, "EXT_UNION"."C_PHONE" AS "C_PHONE"
		, "EXT_UNION"."C_ACCTBAL" AS "C_ACCTBAL"
		, "EXT_UNION"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "EXT_UNION"."C_COMMENT" AS "C_COMMENT"
		, "EXT_UNION"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "EXT_UNION" "EXT_UNION"

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "LOAD_INIT_DATA" AS 
	( 
		SELECT 
			  TO_CHAR('I' ) AS "JRN_FLAG"
			, TO_CHAR('S') AS "RECORD_TYPE"
			, COALESCE("INI_SRC"."C_CUSTKEY", CAST("MEX_INR_SRC"."KEY_ATTRIBUTE_NUMBER" AS NUMBER)) AS "C_CUSTKEY"
			, "INI_SRC"."C_NAME" AS "C_NAME"
			, "INI_SRC"."C_ADDRESS" AS "C_ADDRESS"
			, "INI_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
			, "INI_SRC"."C_PHONE" AS "C_PHONE"
			, "INI_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
			, "INI_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "INI_SRC"."C_COMMENT" AS "C_COMMENT"
			, "INI_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM {{ source('VS_DEMO_TC_INI', 'SF1_CUSTOMER') }} "INI_SRC"
		INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_INR_SRC" ON  "MEX_INR_SRC"."RECORD_TYPE" = 'N'
	)
	, "PREP_EXCEP" AS 
	( 
		SELECT 
			  "LOAD_INIT_DATA"."JRN_FLAG" AS "JRN_FLAG"
			, "LOAD_INIT_DATA"."RECORD_TYPE" AS "RECORD_TYPE"
			, NULL AS "LOAD_CYCLE_ID"
			, "LOAD_INIT_DATA"."C_CUSTKEY" AS "C_CUSTKEY"
			, "LOAD_INIT_DATA"."C_NAME" AS "C_NAME"
			, "LOAD_INIT_DATA"."C_ADDRESS" AS "C_ADDRESS"
			, "LOAD_INIT_DATA"."C_NATIONKEY" AS "C_NATIONKEY"
			, "LOAD_INIT_DATA"."C_PHONE" AS "C_PHONE"
			, "LOAD_INIT_DATA"."C_ACCTBAL" AS "C_ACCTBAL"
			, "LOAD_INIT_DATA"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "LOAD_INIT_DATA"."C_COMMENT" AS "C_COMMENT"
			, "LOAD_INIT_DATA"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM "LOAD_INIT_DATA" "LOAD_INIT_DATA"
		UNION ALL 
		SELECT 
			  TO_CHAR('I' ) AS "JRN_FLAG"
			, "MEX_EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
			, "MEX_EXT_SRC"."LOAD_CYCLE_ID" ::integer AS "LOAD_CYCLE_ID"
			, CAST("MEX_EXT_SRC"."KEY_ATTRIBUTE_NUMBER" AS NUMBER) AS "C_CUSTKEY"
			, CAST("MEX_EXT_SRC"."KEY_ATTRIBUTE_VARCHAR" AS VARCHAR) AS "C_NAME"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_VARCHAR" AS VARCHAR) AS "C_ADDRESS"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_NUMBER" AS NUMBER) AS "C_NATIONKEY"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_VARCHAR" AS VARCHAR) AS "C_PHONE"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_NUMBER" AS NUMBER) AS "C_ACCTBAL"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_VARCHAR" AS VARCHAR) AS "C_MKTSEGMENT"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_VARCHAR" AS VARCHAR) AS "C_COMMENT"
			, CAST("MEX_EXT_SRC"."ATTRIBUTE_VARCHAR" AS VARCHAR) AS "DSS_RECORD_SOURCE"
		FROM {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_EXT_SRC"
	)
	, "CALCULATE_BK" AS 
	( 
		SELECT 
			  COALESCE("PREP_EXCEP"."LOAD_CYCLE_ID","LCI_SRC"."LOAD_CYCLE_ID") AS "LOAD_CYCLE_ID"
			, "LCI_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "PREP_EXCEP"."JRN_FLAG" AS "JRN_FLAG"
			, "PREP_EXCEP"."RECORD_TYPE" AS "RECORD_TYPE"
			, "PREP_EXCEP"."C_CUSTKEY" AS "C_CUSTKEY"
			, COALESCE(UPPER(REPLACE(TRIM("PREP_EXCEP"."C_NAME"),'^','\\' || '^')),"MEX_SRC"."KEY_ATTRIBUTE_VARCHAR") AS "C_NAME_BK"
			, "PREP_EXCEP"."C_NAME" AS "C_NAME"
			, "PREP_EXCEP"."C_ADDRESS" AS "C_ADDRESS"
			, "PREP_EXCEP"."C_NATIONKEY" AS "C_NATIONKEY"
			, "PREP_EXCEP"."C_PHONE" AS "C_PHONE"
			, "PREP_EXCEP"."C_ACCTBAL" AS "C_ACCTBAL"
			, "PREP_EXCEP"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "PREP_EXCEP"."C_COMMENT" AS "C_COMMENT"
			, "PREP_EXCEP"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM "PREP_EXCEP" "PREP_EXCEP"
		INNER JOIN {{ source('VS_DEMO_TC_MTD', 'LOAD_CYCLE_INFO') }} "LCI_SRC" ON  1 = 1
		INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  1 = 1
		WHERE  "MEX_SRC"."RECORD_TYPE" = 'N'
	)
	SELECT 
		  "CALCULATE_BK"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "CALCULATE_BK"."LOAD_DATE" AS "LOAD_DATE"
		, "CALCULATE_BK"."JRN_FLAG" AS "JRN_FLAG"
		, "CALCULATE_BK"."RECORD_TYPE" AS "RECORD_TYPE"
		, "CALCULATE_BK"."C_CUSTKEY" AS "C_CUSTKEY"
		, "CALCULATE_BK"."C_NAME_BK" AS "C_NAME_BK"
		, "CALCULATE_BK"."C_NAME" AS "C_NAME"
		, "CALCULATE_BK"."C_ADDRESS" AS "C_ADDRESS"
		, "CALCULATE_BK"."C_NATIONKEY" AS "C_NATIONKEY"
		, "CALCULATE_BK"."C_PHONE" AS "C_PHONE"
		, "CALCULATE_BK"."C_ACCTBAL" AS "C_ACCTBAL"
		, "CALCULATE_BK"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "CALCULATE_BK"."C_COMMENT" AS "C_COMMENT"
		, "CALCULATE_BK"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "CALCULATE_BK" "CALCULATE_BK"

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'