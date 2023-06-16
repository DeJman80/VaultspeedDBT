{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}',
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='SF1_PART_CURR',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'STG_SF1_SF1PART_INCR', 'STG_SF1_SF1PART_INIT']
	)
}}
select * from (
	WITH "FAKE_PREV_REF" AS 
	( 
		SELECT 
			  "STG_PREV_SRC"."PART_HKEY" AS "PART_HKEY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_PART_PREV') }} "STG_PREV_SRC"
		WHERE  0 = 1
	)
	SELECT 
		  UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."P_NAME_BK" || '^' ||  "EXT_SRC"."P_SIZE_BK" || '^' )) AS "PART_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1' AS "SRC_BK"
		, 'SF1.SF1_PART' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."P_PARTKEY" AS "P_PARTKEY"
		, "EXT_SRC"."P_NAME_BK" || '^' ||  "EXT_SRC"."P_SIZE_BK" AS "PART_BK"
		, "EXT_SRC"."P_NAME" AS "P_NAME"
		, "EXT_SRC"."P_SIZE" AS "P_SIZE"
		, "EXT_SRC"."P_MFGR" AS "P_MFGR"
		, "EXT_SRC"."P_BRAND" AS "P_BRAND"
		, "EXT_SRC"."P_TYPE" AS "P_TYPE"
		, "EXT_SRC"."P_CONTAINER" AS "P_CONTAINER"
		, "EXT_SRC"."P_RETAILPRICE" AS "P_RETAILPRICE"
		, "EXT_SRC"."P_COMMENT" AS "P_COMMENT"
		, "EXT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_EXT_SF1_PART') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	SELECT 
		  UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."P_NAME_BK" || '^' ||  "EXT_SRC"."P_SIZE_BK" || '^' )) AS "PART_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1' AS "SRC_BK"
		, 'SF1.SF1_PART' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."P_PARTKEY" AS "P_PARTKEY"
		, "EXT_SRC"."P_NAME_BK" || '^' ||  "EXT_SRC"."P_SIZE_BK" AS "PART_BK"
		, "EXT_SRC"."P_NAME" AS "P_NAME"
		, "EXT_SRC"."P_SIZE" AS "P_SIZE"
		, "EXT_SRC"."P_MFGR" AS "P_MFGR"
		, "EXT_SRC"."P_BRAND" AS "P_BRAND"
		, "EXT_SRC"."P_TYPE" AS "P_TYPE"
		, "EXT_SRC"."P_CONTAINER" AS "P_CONTAINER"
		, "EXT_SRC"."P_RETAILPRICE" AS "P_RETAILPRICE"
		, "EXT_SRC"."P_COMMENT" AS "P_COMMENT"
		, "EXT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_EXT_SF1_PART') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'