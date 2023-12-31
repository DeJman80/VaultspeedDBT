{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_ORDERCUST_LDS_TMP',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'LDS_SF1_ORDER_CUST_INCR']
	)
}}
select * from (
	WITH "DIST_STG" AS 
	( 
		SELECT 
			  "STG_DIS_SRC"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "STG_DIS_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, MIN("STG_DIS_SRC"."LOAD_DATE") AS "MIN_LOAD_TIMESTAMP"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_DIS_SRC"
		GROUP BY  "STG_DIS_SRC"."LND_ORDERCUST_HKEY",  "STG_DIS_SRC"."LOAD_CYCLE_ID"
	)
	, "TEMP_TABLE_SET" AS 
	( 
		SELECT 
			  "STG_TEMP_SRC"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "STG_TEMP_SRC"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "STG_TEMP_SRC"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_TEMP_SRC"."O_CUSTKEY" AS "O_CUSTKEY"
			, "STG_TEMP_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
			, "STG_TEMP_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_TEMP_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, TO_TIMESTAMP(NULL, 'DD/MM/YYYY HH24:MI:SS') AS "LOAD_END_DATE"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."C_NAME"),'~'),'^','\\' || '^')|| '^',
				'^' || '~'),'~') )) AS "HASH_DIFF"
			, "STG_TEMP_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
			, 'STG' AS "SOURCE"
			, 1 AS "ORIGIN_ID"
			, CASE WHEN "STG_TEMP_SRC"."JRN_FLAG" = 'D' THEN CAST('Y' AS VARCHAR) ELSE CAST('N' AS VARCHAR) END AS "DELETE_FLAG"
			, "STG_TEMP_SRC"."C_NAME" AS "C_NAME"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_TEMP_SRC"
		UNION ALL 
		SELECT 
			  "LDS_SRC"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "LND_SRC"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "LND_SRC"."ORDER_HKEY" AS "ORDER_HKEY"
			, "LDS_SRC"."O_CUSTKEY" AS "O_CUSTKEY"
			, "LDS_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
			, "LDS_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "LDS_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, MAX("LDS_SRC"."LOAD_DATE")OVER(PARTITION BY "LDS_SRC"."LND_ORDERCUST_HKEY") AS "LOAD_END_DATE"
			, "LDS_SRC"."HASH_DIFF" AS "HASH_DIFF"
			, 'SAT' AS "RECORD_TYPE"
			, 'LDS' AS "SOURCE"
			, 0 AS "ORIGIN_ID"
			, "LDS_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
			, "LDS_SRC"."C_NAME" AS "C_NAME"
		FROM {{ source('RDV', 'S_SF1_ORDERCUST_LDS') }} "LDS_SRC"
		INNER JOIN {{ source('RDV', 'L_ORDERCUST_LND') }} "LND_SRC" ON  "LDS_SRC"."LND_ORDERCUST_HKEY" = "LND_SRC"."LND_ORDERCUST_HKEY"
		INNER JOIN "DIST_STG" "DIST_STG" ON  "LDS_SRC"."LND_ORDERCUST_HKEY" = "DIST_STG"."LND_ORDERCUST_HKEY"
	)
	SELECT 
		  "TEMP_TABLE_SET"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		, "TEMP_TABLE_SET"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
		, "TEMP_TABLE_SET"."ORDER_HKEY" AS "ORDER_HKEY"
		, "TEMP_TABLE_SET"."O_CUSTKEY" AS "O_CUSTKEY"
		, "TEMP_TABLE_SET"."O_ORDERKEY" AS "O_ORDERKEY"
		, "TEMP_TABLE_SET"."LOAD_DATE" AS "LOAD_DATE"
		, "TEMP_TABLE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "TEMP_TABLE_SET"."HASH_DIFF" AS "HASH_DIFF"
		, "TEMP_TABLE_SET"."RECORD_TYPE" AS "RECORD_TYPE"
		, "TEMP_TABLE_SET"."SOURCE" AS "SOURCE"
		, CASE WHEN "TEMP_TABLE_SET"."SOURCE" = 'STG' AND TO_CHAR("TEMP_TABLE_SET"."DELETE_FLAG") || TO_CHAR("TEMP_TABLE_SET"."HASH_DIFF")
			= LAG( TO_CHAR("TEMP_TABLE_SET"."DELETE_FLAG") || TO_CHAR("TEMP_TABLE_SET"."HASH_DIFF"),1)OVER(PARTITION BY "TEMP_TABLE_SET"."LND_ORDERCUST_HKEY" ORDER BY "TEMP_TABLE_SET"."LOAD_DATE","TEMP_TABLE_SET"."ORIGIN_ID")THEN 1 ELSE 0 END AS "EQUAL"
		, "TEMP_TABLE_SET"."DELETE_FLAG" AS "DELETE_FLAG"
		, "TEMP_TABLE_SET"."C_NAME" AS "C_NAME"
	FROM "TEMP_TABLE_SET" "TEMP_TABLE_SET"
	WHERE  "TEMP_TABLE_SET"."SOURCE" = 'STG' OR("TEMP_TABLE_SET"."LOAD_DATE" = "TEMP_TABLE_SET"."LOAD_END_DATE" AND "TEMP_TABLE_SET"."SOURCE" = 'LDS')

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'