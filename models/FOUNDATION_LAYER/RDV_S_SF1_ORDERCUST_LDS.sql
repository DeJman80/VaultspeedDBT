{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_ORDERCUST_LDS',
		schema='RDV',
		tags=['VS_DEMO_TC', 'LDS_SF1_ORDER_CUST_INCR', 'LDS_SF1_ORDER_CUST_INIT']
	)
}}
select * from (
	SELECT 
		  "LDS_TEMP_SRC_INUR"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		, "LDS_TEMP_SRC_INUR"."O_CUSTKEY" AS "O_CUSTKEY"
		, "LDS_TEMP_SRC_INUR"."O_ORDERKEY" AS "O_ORDERKEY"
		, "LDS_TEMP_SRC_INUR"."LOAD_DATE" AS "LOAD_DATE"
		, "LDS_TEMP_SRC_INUR"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "LDS_TEMP_SRC_INUR"."HASH_DIFF" AS "HASH_DIFF"
		, "LDS_TEMP_SRC_INUR"."DELETE_FLAG" AS "DELETE_FLAG"
		, "LDS_TEMP_SRC_INUR"."C_NAME" AS "C_NAME"
	FROM {{ ref('VS_DEMO_TC_STG_S_SF1_ORDERCUST_LDS_TMP') }} "LDS_TEMP_SRC_INUR"
	WHERE  "LDS_TEMP_SRC_INUR"."SOURCE" = 'STG' AND "LDS_TEMP_SRC_INUR"."EQUAL" = 0

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "STG_DL_SRC" AS 
	( 
		SELECT 
			  "STG_DL_INR_SRC"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "STG_DL_INR_SRC"."O_CUSTKEY" AS "O_CUSTKEY"
			, "STG_DL_INR_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
			, "STG_DL_INR_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_DL_INR_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."C_NAME"),'~'),'^','\\' || '^')|| '^',
				'^' || '~'),'~') )) AS "HASH_DIFF"
			, CAST('N' AS VARCHAR) AS "DELETE_FLAG"
			, "STG_DL_INR_SRC"."C_NAME" AS "C_NAME"
			, ROW_NUMBER()OVER(PARTITION BY "STG_DL_INR_SRC"."LND_ORDERCUST_HKEY" ORDER BY "STG_DL_INR_SRC"."LOAD_DATE") AS "DUMMY"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_DL_INR_SRC"
	)
	SELECT 
		  "STG_DL_SRC"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		, "STG_DL_SRC"."O_CUSTKEY" AS "O_CUSTKEY"
		, "STG_DL_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
		, "STG_DL_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "STG_DL_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "STG_DL_SRC"."HASH_DIFF" AS "HASH_DIFF"
		, "STG_DL_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
		, "STG_DL_SRC"."C_NAME" AS "C_NAME"
	FROM "STG_DL_SRC" "STG_DL_SRC"
	WHERE  "STG_DL_SRC"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'