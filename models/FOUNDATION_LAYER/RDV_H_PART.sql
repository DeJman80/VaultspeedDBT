{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='H_PART',
		schema='RDV',
		tags=['VS_DEMO_TC', 'HUB_SF1_PART_INCR', 'HUB_SF1_PART_INIT']
	)
}}
select * from (
	WITH "CHANGE_SET" AS 
	( 
		SELECT 
			  "STG_SRC1"."PART_HKEY" AS "PART_HKEY"
			, "STG_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_SRC1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_SRC1"."PART_BK" AS "PART_BK"
			, "STG_SRC1"."SRC_BK" AS "SRC_BK"
			, "STG_SRC1"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 0 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_PART') }} "STG_SRC1"
		WHERE  "STG_SRC1"."RECORD_TYPE" = 'S'
	)
	, "MIN_LOAD_TIME" AS 
	( 
		SELECT 
			  "CHANGE_SET"."PART_HKEY" AS "PART_HKEY"
			, "CHANGE_SET"."LOAD_DATE" AS "LOAD_DATE"
			, "CHANGE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CHANGE_SET"."PART_BK" AS "PART_BK"
			, "CHANGE_SET"."SRC_BK" AS "SRC_BK"
			, "CHANGE_SET"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "CHANGE_SET"."PART_HKEY" ORDER BY "CHANGE_SET"."GENERAL_ORDER","CHANGE_SET"."LOAD_DATE",
				"CHANGE_SET"."LOGPOSITION") AS "DUMMY"
		FROM "CHANGE_SET" "CHANGE_SET"
	)
	SELECT 
		  "MIN_LOAD_TIME"."PART_HKEY" AS "PART_HKEY"
		, "MIN_LOAD_TIME"."LOAD_DATE" AS "LOAD_DATE"
		, "MIN_LOAD_TIME"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "MIN_LOAD_TIME"."PART_BK" AS "PART_BK"
		, "MIN_LOAD_TIME"."SRC_BK" AS "SRC_BK"
		, "MIN_LOAD_TIME"."RECORD_SOURCE" AS "RECORD_SOURCE"
	FROM "MIN_LOAD_TIME" "MIN_LOAD_TIME"
	LEFT OUTER JOIN {{ this }} "HUB_SRC" ON  "MIN_LOAD_TIME"."PART_HKEY" = "HUB_SRC"."PART_HKEY"
	WHERE  "MIN_LOAD_TIME"."DUMMY" = 1 AND "HUB_SRC"."PART_HKEY" is NULL

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "CHANGE_SET" AS 
	( 
		SELECT 
			  "STG_SRC1"."PART_HKEY" AS "PART_HKEY"
			, "STG_SRC1"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_SRC1"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, 0 AS "LOGPOSITION"
			, "STG_SRC1"."PART_BK" AS "PART_BK"
			, "STG_SRC1"."SRC_BK" AS "SRC_BK"
			, "STG_SRC1"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, 0 AS "GENERAL_ORDER"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_PART') }} "STG_SRC1"
	)
	, "MIN_LOAD_TIME" AS 
	( 
		SELECT 
			  "CHANGE_SET"."PART_HKEY" AS "PART_HKEY"
			, "CHANGE_SET"."LOAD_DATE" AS "LOAD_DATE"
			, "CHANGE_SET"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, "CHANGE_SET"."PART_BK" AS "PART_BK"
			, "CHANGE_SET"."SRC_BK" AS "SRC_BK"
			, "CHANGE_SET"."RECORD_SOURCE" AS "RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "CHANGE_SET"."PART_HKEY" ORDER BY "CHANGE_SET"."GENERAL_ORDER","CHANGE_SET"."LOAD_DATE",
				"CHANGE_SET"."LOGPOSITION") AS "DUMMY"
		FROM "CHANGE_SET" "CHANGE_SET"
	)
	SELECT 
		  "MIN_LOAD_TIME"."PART_HKEY" AS "PART_HKEY"
		, "MIN_LOAD_TIME"."LOAD_DATE" AS "LOAD_DATE"
		, "MIN_LOAD_TIME"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "MIN_LOAD_TIME"."PART_BK" AS "PART_BK"
		, "MIN_LOAD_TIME"."SRC_BK" AS "SRC_BK"
		, "MIN_LOAD_TIME"."RECORD_SOURCE" AS "RECORD_SOURCE"
	FROM "MIN_LOAD_TIME" "MIN_LOAD_TIME"
	WHERE  "MIN_LOAD_TIME"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'