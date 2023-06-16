{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}',
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='SF1_CUSTOMER_CURR',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'STG_SF1_SF1CUSTOMER_INCR', 'STG_SF1_SF1CUSTOMER_INIT']
	)
}}
select * from (
	WITH "FAKE_PREV_REF" AS 
	( 
		SELECT 
			  "STG_PREV_SRC"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_CUSTOMER_PREV') }} "STG_PREV_SRC"
		WHERE  0 = 1
	)
	SELECT 
		  UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."C_NAME_BK" || '^' )) AS "CUSTOMER_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1' AS "SRC_BK"
		, 'SF1.SF1_CUSTOMER' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."C_CUSTKEY" AS "C_CUSTKEY"
		, "EXT_SRC"."C_NAME_BK" AS "CUSTOMER_BK"
		, "EXT_SRC"."C_NAME" AS "C_NAME"
		, "EXT_SRC"."C_ADDRESS" AS "C_ADDRESS"
		, "EXT_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
		, "EXT_SRC"."C_PHONE" AS "C_PHONE"
		, "EXT_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
		, "EXT_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "EXT_SRC"."C_COMMENT" AS "C_COMMENT"
		, "EXT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_EXT_SF1_CUSTOMER') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	SELECT 
		  UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."C_NAME_BK" || '^' )) AS "CUSTOMER_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1' AS "SRC_BK"
		, 'SF1.SF1_CUSTOMER' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."C_CUSTKEY" AS "C_CUSTKEY"
		, "EXT_SRC"."C_NAME_BK" AS "CUSTOMER_BK"
		, "EXT_SRC"."C_NAME" AS "C_NAME"
		, "EXT_SRC"."C_ADDRESS" AS "C_ADDRESS"
		, "EXT_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
		, "EXT_SRC"."C_PHONE" AS "C_PHONE"
		, "EXT_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
		, "EXT_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "EXT_SRC"."C_COMMENT" AS "C_COMMENT"
		, "EXT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_EXT_SF1_CUSTOMER') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'