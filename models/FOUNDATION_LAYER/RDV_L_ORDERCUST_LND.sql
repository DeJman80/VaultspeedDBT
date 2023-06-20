{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='L_ORDERCUST_LND',
		schema='RDV',
		tags=['VS_DEMO_TC', 'LND_SF1_ORDERCUST_INCR', 'LND_SF1_ORDERCUST_INIT']
	)
}}
select * from (
	WITH "CHANGE_SET" AS 
	( 
		SELECT 
			  "STG_SRC1"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "STG_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_SRC1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "STG_SRC1"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "STG_SRC1"."ORDER_HKEY" AS "ORDER_HKEY"
			, 0 AS "LOGPOSITION"
			, "STG_SRC1"."RECORD_SOURCE" AS "RECORD_SOURCE"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_SRC1"
		WHERE  "STG_SRC1"."RECORD_TYPE" = 'S'
	)
	, "MIN_LOAD_TIME" AS 
	( 
		SELECT 
			  "CHANGE_SET"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "CHANGE_SET"."LOAD_DATE" AS "LOAD_DATE"
			, "CHANGE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CHANGE_SET"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "CHANGE_SET"."ORDER_HKEY" AS "ORDER_HKEY"
			, "CHANGE_SET"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "CHANGE_SET"."LND_ORDERCUST_HKEY" ORDER BY "CHANGE_SET"."LOAD_DATE",
				"CHANGE_SET"."LOGPOSITION") AS "DUMMY"
		FROM "CHANGE_SET" "CHANGE_SET"
	)
	SELECT 
		  "MIN_LOAD_TIME"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		, "MIN_LOAD_TIME"."LOAD_DATE" AS "LOAD_DATE"
		, "MIN_LOAD_TIME"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "MIN_LOAD_TIME"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
		, "MIN_LOAD_TIME"."ORDER_HKEY" AS "ORDER_HKEY"
		, "MIN_LOAD_TIME"."RECORD_SOURCE" AS "RECORD_SOURCE"
	FROM "MIN_LOAD_TIME" "MIN_LOAD_TIME"
	LEFT OUTER JOIN {{ this }} "LND_SRC" ON  "MIN_LOAD_TIME"."LND_ORDERCUST_HKEY" = "LND_SRC"."LND_ORDERCUST_HKEY"
	WHERE  "LND_SRC"."LND_ORDERCUST_HKEY" IS NULL AND "MIN_LOAD_TIME"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "CHANGE_SET" AS 
	( 
		SELECT 
			  "STG_SRC1"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "STG_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_SRC1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "STG_SRC1"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "STG_SRC1"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_SRC1"."RECORD_SOURCE" AS "RECORD_SOURCE"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_SRC1"
	)
	, "MIN_LOAD_TIME" AS 
	( 
		SELECT 
			  "CHANGE_SET"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
			, "CHANGE_SET"."LOAD_DATE" AS "LOAD_DATE"
			, "CHANGE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CHANGE_SET"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
			, "CHANGE_SET"."ORDER_HKEY" AS "ORDER_HKEY"
			, "CHANGE_SET"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "CHANGE_SET"."LND_ORDERCUST_HKEY" ORDER BY "CHANGE_SET"."LOAD_CYCLE_ID",
				"CHANGE_SET"."LOAD_DATE") AS "DUMMY"
		FROM "CHANGE_SET" "CHANGE_SET"
	)
	SELECT 
		  "MIN_LOAD_TIME"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		, "MIN_LOAD_TIME"."LOAD_DATE" AS "LOAD_DATE"
		, "MIN_LOAD_TIME"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "MIN_LOAD_TIME"."CUSTOMER_HKEY" AS "CUSTOMER_HKEY"
		, "MIN_LOAD_TIME"."ORDER_HKEY" AS "ORDER_HKEY"
		, "MIN_LOAD_TIME"."RECORD_SOURCE" AS "RECORD_SOURCE"
	FROM "MIN_LOAD_TIME" "MIN_LOAD_TIME"
	WHERE  "MIN_LOAD_TIME"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'