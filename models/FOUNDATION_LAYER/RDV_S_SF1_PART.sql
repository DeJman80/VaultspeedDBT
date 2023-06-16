{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_PART',
		schema='RDV',
		tags=['VS_DEMO_TC', 'SAT_SF1_PART_INCR', 'SAT_SF1_PART_INIT']
	)
}}
select * from (
	SELECT 
		  "SAT_TEMP_SRC_INUR"."PART_HKEY" AS "PART_HKEY"
		, "SAT_TEMP_SRC_INUR"."LOAD_DATE" AS "LOAD_DATE"
		, "SAT_TEMP_SRC_INUR"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "SAT_TEMP_SRC_INUR"."HASH_DIFF" AS "HASH_DIFF"
		, "SAT_TEMP_SRC_INUR"."DELETE_FLAG" AS "DELETE_FLAG"
		, "SAT_TEMP_SRC_INUR"."P_PARTKEY" AS "P_PARTKEY"
		, "SAT_TEMP_SRC_INUR"."P_NAME" AS "P_NAME"
		, "SAT_TEMP_SRC_INUR"."P_SIZE" AS "P_SIZE"
		, "SAT_TEMP_SRC_INUR"."P_MFGR" AS "P_MFGR"
		, "SAT_TEMP_SRC_INUR"."P_BRAND" AS "P_BRAND"
		, "SAT_TEMP_SRC_INUR"."P_TYPE" AS "P_TYPE"
		, "SAT_TEMP_SRC_INUR"."P_CONTAINER" AS "P_CONTAINER"
		, "SAT_TEMP_SRC_INUR"."P_RETAILPRICE" AS "P_RETAILPRICE"
		, "SAT_TEMP_SRC_INUR"."P_COMMENT" AS "P_COMMENT"
		, "SAT_TEMP_SRC_INUR"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_STG_S_SF1_PART_TMP') }} "SAT_TEMP_SRC_INUR"
	WHERE  "SAT_TEMP_SRC_INUR"."SOURCE" = 'STG' AND "SAT_TEMP_SRC_INUR"."EQUAL" = 0

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "STG_SRC" AS 
	( 
		SELECT 
			  "STG_INR_SRC"."PART_HKEY" AS "PART_HKEY"
			, "STG_INR_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_INR_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_INR_SRC"."P_MFGR"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."P_BRAND")
				,'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."P_TYPE"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."P_CONTAINER"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_INR_SRC"."P_RETAILPRICE")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."P_COMMENT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_INR_SRC"."DSS_RECORD_SOURCE"),'~'),'^','\\' || '^')|| '^','^' || '~'),'~') )) AS "HASH_DIFF"
			, CAST('N' AS VARCHAR) AS "DELETE_FLAG"
			, "STG_INR_SRC"."P_PARTKEY" AS "P_PARTKEY"
			, "STG_INR_SRC"."P_NAME" AS "P_NAME"
			, "STG_INR_SRC"."P_SIZE" AS "P_SIZE"
			, "STG_INR_SRC"."P_MFGR" AS "P_MFGR"
			, "STG_INR_SRC"."P_BRAND" AS "P_BRAND"
			, "STG_INR_SRC"."P_TYPE" AS "P_TYPE"
			, "STG_INR_SRC"."P_CONTAINER" AS "P_CONTAINER"
			, "STG_INR_SRC"."P_RETAILPRICE" AS "P_RETAILPRICE"
			, "STG_INR_SRC"."P_COMMENT" AS "P_COMMENT"
			, "STG_INR_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "STG_INR_SRC"."PART_HKEY" ORDER BY "STG_INR_SRC"."LOAD_DATE") AS "DUMMY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_PART') }} "STG_INR_SRC"
	)
	SELECT 
		  "STG_SRC"."PART_HKEY" AS "PART_HKEY"
		, "STG_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "STG_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "STG_SRC"."HASH_DIFF" AS "HASH_DIFF"
		, "STG_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
		, "STG_SRC"."P_PARTKEY" AS "P_PARTKEY"
		, "STG_SRC"."P_NAME" AS "P_NAME"
		, "STG_SRC"."P_SIZE" AS "P_SIZE"
		, "STG_SRC"."P_MFGR" AS "P_MFGR"
		, "STG_SRC"."P_BRAND" AS "P_BRAND"
		, "STG_SRC"."P_TYPE" AS "P_TYPE"
		, "STG_SRC"."P_CONTAINER" AS "P_CONTAINER"
		, "STG_SRC"."P_RETAILPRICE" AS "P_RETAILPRICE"
		, "STG_SRC"."P_COMMENT" AS "P_COMMENT"
		, "STG_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "STG_SRC" "STG_SRC"
	WHERE  "STG_SRC"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'