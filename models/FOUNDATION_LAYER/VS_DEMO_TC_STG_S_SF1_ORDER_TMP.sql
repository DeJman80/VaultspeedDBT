{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_ORDER_TMP',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'SAT_SF1_ORDER_INCR']
	)
}}
select * from (
	WITH "TEMP_TABLE_SET" AS 
	( 
		SELECT 
			  "STG_TEMP_SRC"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_TEMP_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_TEMP_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, TO_TIMESTAMP(NULL, 'DD/MM/YYYY HH24:MI:SS') AS "LOAD_END_DATE"
			, "STG_TEMP_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
			, 'STG' AS "SOURCE"
			, 1 AS "ORIGIN_ID"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."C_NAME"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."O_ORDERSTATUS")
				,'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_TEMP_SRC"."O_TOTALPRICE")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_TEMP_SRC"."O_ORDERDATE", 'DD/MM/YYYY')),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."O_ORDERPRIORITY"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."O_CLERK"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_TEMP_SRC"."O_SHIPPRIORITY")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."O_COMMENT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_TEMP_SRC"."DSS_RECORD_SOURCE"),'~'),'^','\\' || '^')|| '^','^' || '~'),'~') )) AS "HASH_DIFF"
			, CASE WHEN "STG_TEMP_SRC"."JRN_FLAG" = 'D' THEN CAST('Y' AS VARCHAR) ELSE CAST('N' AS VARCHAR) END AS "DELETE_FLAG"
			, "STG_TEMP_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
			, "STG_TEMP_SRC"."C_NAME" AS "C_NAME"
			, "STG_TEMP_SRC"."O_ORDERSTATUS" AS "O_ORDERSTATUS"
			, "STG_TEMP_SRC"."O_TOTALPRICE" AS "O_TOTALPRICE"
			, "STG_TEMP_SRC"."O_ORDERDATE" AS "O_ORDERDATE"
			, "STG_TEMP_SRC"."O_ORDERPRIORITY" AS "O_ORDERPRIORITY"
			, "STG_TEMP_SRC"."O_CLERK" AS "O_CLERK"
			, "STG_TEMP_SRC"."O_SHIPPRIORITY" AS "O_SHIPPRIORITY"
			, "STG_TEMP_SRC"."O_COMMENT" AS "O_COMMENT"
			, "STG_TEMP_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER') }} "STG_TEMP_SRC"
		WHERE  "STG_TEMP_SRC"."RECORD_TYPE" = 'S'
		UNION ALL 
		SELECT 
			  "SAT_SRC"."ORDER_HKEY" AS "ORDER_HKEY"
			, "SAT_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "SAT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, MAX("SAT_SRC"."LOAD_DATE")OVER( PARTITION BY "SAT_SRC"."ORDER_HKEY") AS "LOAD_END_DATE"
			, 'SAT' AS "RECORD_TYPE"
			, 'SAT' AS "SOURCE"
			, 0 AS "ORIGIN_ID"
			, "SAT_SRC"."HASH_DIFF" AS "HASH_DIFF"
			, "SAT_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
			, "SAT_SRC"."O_ORDERKEY" AS "O_ORDERKEY"
			, "SAT_SRC"."C_NAME" AS "C_NAME"
			, "SAT_SRC"."O_ORDERSTATUS" AS "O_ORDERSTATUS"
			, "SAT_SRC"."O_TOTALPRICE" AS "O_TOTALPRICE"
			, "SAT_SRC"."O_ORDERDATE" AS "O_ORDERDATE"
			, "SAT_SRC"."O_ORDERPRIORITY" AS "O_ORDERPRIORITY"
			, "SAT_SRC"."O_CLERK" AS "O_CLERK"
			, "SAT_SRC"."O_SHIPPRIORITY" AS "O_SHIPPRIORITY"
			, "SAT_SRC"."O_COMMENT" AS "O_COMMENT"
			, "SAT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM {{ source('RDV', 'S_SF1_ORDER') }} "SAT_SRC"
		INNER JOIN {{ ref('VS_DEMO_TC_STG_ORDER') }} "STG_TEMP_SAT_SRC" ON  "SAT_SRC"."ORDER_HKEY" = "STG_TEMP_SAT_SRC"."ORDER_HKEY"
		WHERE  "STG_TEMP_SAT_SRC"."RECORD_TYPE" = 'S'
	)
	SELECT 
		  "TEMP_TABLE_SET"."ORDER_HKEY" AS "ORDER_HKEY"
		, "TEMP_TABLE_SET"."LOAD_DATE" AS "LOAD_DATE"
		, "TEMP_TABLE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "TEMP_TABLE_SET"."RECORD_TYPE" AS "RECORD_TYPE"
		, "TEMP_TABLE_SET"."SOURCE" AS "SOURCE"
		, CASE WHEN "TEMP_TABLE_SET"."SOURCE" = 'STG' AND TO_CHAR("TEMP_TABLE_SET"."DELETE_FLAG") || TO_CHAR("TEMP_TABLE_SET"."HASH_DIFF")
			= LAG( TO_CHAR("TEMP_TABLE_SET"."DELETE_FLAG") || TO_CHAR("TEMP_TABLE_SET"."HASH_DIFF"),1)OVER(PARTITION BY "TEMP_TABLE_SET"."ORDER_HKEY" ORDER BY "TEMP_TABLE_SET"."LOAD_DATE","TEMP_TABLE_SET"."ORIGIN_ID")THEN 1 ELSE 0 END AS "EQUAL"
		, "TEMP_TABLE_SET"."HASH_DIFF" AS "HASH_DIFF"
		, "TEMP_TABLE_SET"."DELETE_FLAG" AS "DELETE_FLAG"
		, "TEMP_TABLE_SET"."O_ORDERKEY" AS "O_ORDERKEY"
		, "TEMP_TABLE_SET"."C_NAME" AS "C_NAME"
		, "TEMP_TABLE_SET"."O_ORDERSTATUS" AS "O_ORDERSTATUS"
		, "TEMP_TABLE_SET"."O_TOTALPRICE" AS "O_TOTALPRICE"
		, "TEMP_TABLE_SET"."O_ORDERDATE" AS "O_ORDERDATE"
		, "TEMP_TABLE_SET"."O_ORDERPRIORITY" AS "O_ORDERPRIORITY"
		, "TEMP_TABLE_SET"."O_CLERK" AS "O_CLERK"
		, "TEMP_TABLE_SET"."O_SHIPPRIORITY" AS "O_SHIPPRIORITY"
		, "TEMP_TABLE_SET"."O_COMMENT" AS "O_COMMENT"
		, "TEMP_TABLE_SET"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "TEMP_TABLE_SET" "TEMP_TABLE_SET"
	WHERE  "TEMP_TABLE_SET"."SOURCE" = 'STG' OR("TEMP_TABLE_SET"."LOAD_DATE" = "TEMP_TABLE_SET"."LOAD_END_DATE" AND "TEMP_TABLE_SET"."SOURCE" = 'SAT')

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'