{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_CUSTOMER',
		schema='RDV',
		tags=['VS_DEMO_TC', 'SAT_SF1_CUSTOMER_INCR', 'SAT_SF1_CUSTOMER_INIT']
	)
}}
select * from (
	SELECT 
		  "SAT_TEMP_SRC_INUR"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
		, "SAT_TEMP_SRC_INUR"."LOAD_DATE" AS "LOAD_DATE"
		, "SAT_TEMP_SRC_INUR"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "SAT_TEMP_SRC_INUR"."HASH_DIFF" AS "HASH_DIFF"
		, "SAT_TEMP_SRC_INUR"."DELETE_FLAG" AS "DELETE_FLAG"
		, "SAT_TEMP_SRC_INUR"."C_CUSTKEY" AS "C_CUSTKEY"
		, "SAT_TEMP_SRC_INUR"."C_NAME" AS "C_NAME"
		, "SAT_TEMP_SRC_INUR"."C_ADDRESS" AS "C_ADDRESS"
		, "SAT_TEMP_SRC_INUR"."C_NATIONKEY" AS "C_NATIONKEY"
		, "SAT_TEMP_SRC_INUR"."C_PHONE" AS "C_PHONE"
		, "SAT_TEMP_SRC_INUR"."C_ACCTBAL" AS "C_ACCTBAL"
		, "SAT_TEMP_SRC_INUR"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "SAT_TEMP_SRC_INUR"."C_COMMENT" AS "C_COMMENT"
		, "SAT_TEMP_SRC_INUR"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_STG_S_SF1_CUSTOMER_TMP') }} "SAT_TEMP_SRC_INUR"
	WHERE  "SAT_TEMP_SRC_INUR"."SOURCE" = 'STG' AND "SAT_TEMP_SRC_INUR"."EQUAL" = 0

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "STG_SRC" AS 
	( 
		SELECT 
			  "STG_INR_SRC"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "STG_INR_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_INR_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_INR_SRC"."C_ADDRESS"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_INR_SRC"."C_NATIONKEY")
				),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."C_PHONE"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_INR_SRC"."C_ACCTBAL")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."C_MKTSEGMENT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."C_COMMENT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."DSS_RECORD_SOURCE"),'~'),'^','\\' || '^')|| '^','^' || '~'),'~') )) AS "HASH_DIFF"
			, CAST('N' AS VARCHAR) AS "DELETE_FLAG"
			, "STG_INR_SRC"."C_CUSTKEY" AS "C_CUSTKEY"
			, "STG_INR_SRC"."C_NAME" AS "C_NAME"
			, "STG_INR_SRC"."C_ADDRESS" AS "C_ADDRESS"
			, "STG_INR_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
			, "STG_INR_SRC"."C_PHONE" AS "C_PHONE"
			, "STG_INR_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
			, "STG_INR_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "STG_INR_SRC"."C_COMMENT" AS "C_COMMENT"
			, "STG_INR_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "STG_INR_SRC"."CUSTOMER_HKEY" ORDER BY "STG_INR_SRC"."LOAD_DATE") AS "DUMMY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_CUSTOMER') }} "STG_INR_SRC"
	)
	SELECT 
		  "STG_SRC"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
		, "STG_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "STG_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "STG_SRC"."HASH_DIFF" AS "HASH_DIFF"
		, "STG_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
		, "STG_SRC"."C_CUSTKEY" AS "C_CUSTKEY"
		, "STG_SRC"."C_NAME" AS "C_NAME"
		, "STG_SRC"."C_ADDRESS" AS "C_ADDRESS"
		, "STG_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
		, "STG_SRC"."C_PHONE" AS "C_PHONE"
		, "STG_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
		, "STG_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "STG_SRC"."C_COMMENT" AS "C_COMMENT"
		, "STG_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "STG_SRC" "STG_SRC"
	WHERE  "STG_SRC"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'