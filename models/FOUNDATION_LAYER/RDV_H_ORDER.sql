{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='H_ORDER',
		schema='RDV',
		tags=['VS_DEMO_TC', 'HUB_SF1_ORDER_INCR', 'HUB_SF1_ORDER_INIT']
	)
}}
select * from (
	WITH "CHANGE_SET" AS 
	( 
		SELECT 
			  "STG_SRC1"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_SRC1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_SRC1"."ORDER_BK" AS "ORDER_BK"
			, "STG_SRC1"."SRC_BK" AS "SRC_BK"
			, "STG_SRC1"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 0 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER') }} "STG_SRC1"
		WHERE  "STG_SRC1"."RECORD_TYPE" = 'S'
		UNION 
		SELECT 
			  "STG_FK_SRC1_1"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_FK_SRC1_1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_FK_SRC1_1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_FK_SRC1_1"."O_ORDERKEY_FK_OORDERKEY_BK" AS "ORDER_BK"
			, 'SF1' AS "SRC_BK"
			, "STG_FK_SRC1_1"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 1 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_FK_SRC1_1"
		WHERE  "STG_FK_SRC1_1"."RECORD_TYPE" = 'S'
		UNION 
		SELECT 
			  "STG_FK_SRC1_2"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_FK_SRC1_2"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_FK_SRC1_2"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_FK_SRC1_2"."O_ORDERKEY_FK_LORDERKEY_BK" AS "ORDER_BK"
			, 'SF1' AS "SRC_BK"
			, "STG_FK_SRC1_2"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 1 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_LINEITEM') }} "STG_FK_SRC1_2"
		WHERE  "STG_FK_SRC1_2"."RECORD_TYPE" = 'S'
	)
	, "MIN_LOAD_TIME" AS 
	( 
		SELECT 
			  "CHANGE_SET"."ORDER_HKEY" AS "ORDER_HKEY"
			, "CHANGE_SET"."LOAD_DATE" AS "LOAD_DATE"
			, "CHANGE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CHANGE_SET"."ORDER_BK" AS "ORDER_BK"
			, "CHANGE_SET"."SRC_BK" AS "SRC_BK"
			, "CHANGE_SET"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "CHANGE_SET"."ORDER_HKEY" ORDER BY "CHANGE_SET"."GENERAL_ORDER","CHANGE_SET"."LOAD_DATE",
				"CHANGE_SET"."LOGPOSITION") AS "DUMMY"
		FROM "CHANGE_SET" "CHANGE_SET"
	)
	SELECT 
		  "MIN_LOAD_TIME"."ORDER_HKEY" AS "ORDER_HKEY"
		, "MIN_LOAD_TIME"."LOAD_DATE" AS "LOAD_DATE"
		, "MIN_LOAD_TIME"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "MIN_LOAD_TIME"."ORDER_BK" AS "ORDER_BK"
		, "MIN_LOAD_TIME"."SRC_BK" AS "SRC_BK"
		, "MIN_LOAD_TIME"."RECORD_SOURCE" AS "RECORD_SOURCE"
	FROM "MIN_LOAD_TIME" "MIN_LOAD_TIME"
	LEFT OUTER JOIN {{ this }} "HUB_SRC" ON  "MIN_LOAD_TIME"."ORDER_HKEY" = "HUB_SRC"."ORDER_HKEY"
	WHERE  "MIN_LOAD_TIME"."DUMMY" = 1 AND "HUB_SRC"."ORDER_HKEY" is NULL

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "CHANGE_SET" AS 
	( 
		SELECT 
			  "STG_SRC1"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_SRC1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_SRC1"."ORDER_BK" AS "ORDER_BK"
			, "STG_SRC1"."SRC_BK" AS "SRC_BK"
			, "STG_SRC1"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 0 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER') }} "STG_SRC1"
		UNION 
		SELECT 
			  "STG_FK_SRC1_1"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_FK_SRC1_1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_FK_SRC1_1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_FK_SRC1_1"."O_ORDERKEY_FK_OORDERKEY_BK" AS "ORDER_BK"
			, 'SF1' AS "SRC_BK"
			, "STG_FK_SRC1_1"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 1 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_ORDER_CUST') }} "STG_FK_SRC1_1"
		UNION 
		SELECT 
			  "STG_FK_SRC1_2"."ORDER_HKEY" AS "ORDER_HKEY"
			, "STG_FK_SRC1_2"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_FK_SRC1_2"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_FK_SRC1_2"."O_ORDERKEY_FK_LORDERKEY_BK" AS "ORDER_BK"
			, 'SF1' AS "SRC_BK"
			, "STG_FK_SRC1_2"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 1 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_LINEITEM') }} "STG_FK_SRC1_2"
	)
	, "MIN_LOAD_TIME" AS 
	( 
		SELECT 
			  "CHANGE_SET"."ORDER_HKEY" AS "ORDER_HKEY"
			, "CHANGE_SET"."LOAD_DATE" AS "LOAD_DATE"
			, "CHANGE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CHANGE_SET"."ORDER_BK" AS "ORDER_BK"
			, "CHANGE_SET"."SRC_BK" AS "SRC_BK"
			, "CHANGE_SET"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "CHANGE_SET"."ORDER_HKEY" ORDER BY "CHANGE_SET"."GENERAL_ORDER","CHANGE_SET"."LOAD_DATE",
				"CHANGE_SET"."LOGPOSITION") AS "DUMMY"
		FROM "CHANGE_SET" "CHANGE_SET"
	)
	SELECT 
		  "MIN_LOAD_TIME"."ORDER_HKEY" AS "ORDER_HKEY"
		, "MIN_LOAD_TIME"."LOAD_DATE" AS "LOAD_DATE"
		, "MIN_LOAD_TIME"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "MIN_LOAD_TIME"."ORDER_BK" AS "ORDER_BK"
		, "MIN_LOAD_TIME"."SRC_BK" AS "SRC_BK"
		, "MIN_LOAD_TIME"."RECORD_SOURCE" AS "RECORD_SOURCE"
	FROM "MIN_LOAD_TIME" "MIN_LOAD_TIME"
	WHERE  "MIN_LOAD_TIME"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'