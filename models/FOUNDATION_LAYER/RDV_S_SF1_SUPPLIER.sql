{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_SUPPLIER',
		schema='RDV',
		tags=['VS_DEMO_TC', 'SAT_SF1_SUPPLIER_INCR', 'SAT_SF1_SUPPLIER_INIT']
	)
}}
select * from (
	SELECT 
		  "SAT_TEMP_SRC_INUR"."SUPPLIER_HKEY" AS "SUPPLIER_HKEY"
		, "SAT_TEMP_SRC_INUR"."LOAD_DATE" AS "LOAD_DATE"
		, "SAT_TEMP_SRC_INUR"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "SAT_TEMP_SRC_INUR"."HASH_DIFF" AS "HASH_DIFF"
		, "SAT_TEMP_SRC_INUR"."DELETE_FLAG" AS "DELETE_FLAG"
		, "SAT_TEMP_SRC_INUR"."S_SUPPKEY" AS "S_SUPPKEY"
		, "SAT_TEMP_SRC_INUR"."S_NAME" AS "S_NAME"
		, "SAT_TEMP_SRC_INUR"."S_ADDRESS" AS "S_ADDRESS"
		, "SAT_TEMP_SRC_INUR"."S_NATIONKEY" AS "S_NATIONKEY"
		, "SAT_TEMP_SRC_INUR"."S_PHONE" AS "S_PHONE"
		, "SAT_TEMP_SRC_INUR"."S_ACCTBAL" AS "S_ACCTBAL"
		, "SAT_TEMP_SRC_INUR"."S_COMMENT" AS "S_COMMENT"
		, "SAT_TEMP_SRC_INUR"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_STG_S_SF1_SUPPLIER_TMP') }} "SAT_TEMP_SRC_INUR"
	WHERE  "SAT_TEMP_SRC_INUR"."SOURCE" = 'STG' AND "SAT_TEMP_SRC_INUR"."EQUAL" = 0

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "STG_SRC" AS 
	( 
		SELECT 
			  "STG_INR_SRC"."SUPPLIER_HKEY" AS "SUPPLIER_HKEY"
			, "STG_INR_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_INR_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_INR_SRC"."S_ADDRESS"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_INR_SRC"."S_NATIONKEY")
				),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."S_PHONE"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_INR_SRC"."S_ACCTBAL")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."S_COMMENT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."DSS_RECORD_SOURCE"),'~'),'^','\\' || '^')|| '^','^' || '~'),'~') )) AS "HASH_DIFF"
			, CAST('N' AS VARCHAR) AS "DELETE_FLAG"
			, "STG_INR_SRC"."S_SUPPKEY" AS "S_SUPPKEY"
			, "STG_INR_SRC"."S_NAME" AS "S_NAME"
			, "STG_INR_SRC"."S_ADDRESS" AS "S_ADDRESS"
			, "STG_INR_SRC"."S_NATIONKEY" AS "S_NATIONKEY"
			, "STG_INR_SRC"."S_PHONE" AS "S_PHONE"
			, "STG_INR_SRC"."S_ACCTBAL" AS "S_ACCTBAL"
			, "STG_INR_SRC"."S_COMMENT" AS "S_COMMENT"
			, "STG_INR_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "STG_INR_SRC"."SUPPLIER_HKEY" ORDER BY "STG_INR_SRC"."LOAD_DATE") AS "DUMMY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_SUPPLIER') }} "STG_INR_SRC"
	)
	SELECT 
		  "STG_SRC"."SUPPLIER_HKEY" AS "SUPPLIER_HKEY"
		, "STG_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "STG_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "STG_SRC"."HASH_DIFF" AS "HASH_DIFF"
		, "STG_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
		, "STG_SRC"."S_SUPPKEY" AS "S_SUPPKEY"
		, "STG_SRC"."S_NAME" AS "S_NAME"
		, "STG_SRC"."S_ADDRESS" AS "S_ADDRESS"
		, "STG_SRC"."S_NATIONKEY" AS "S_NATIONKEY"
		, "STG_SRC"."S_PHONE" AS "S_PHONE"
		, "STG_SRC"."S_ACCTBAL" AS "S_ACCTBAL"
		, "STG_SRC"."S_COMMENT" AS "S_COMMENT"
		, "STG_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "STG_SRC" "STG_SRC"
	WHERE  "STG_SRC"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'