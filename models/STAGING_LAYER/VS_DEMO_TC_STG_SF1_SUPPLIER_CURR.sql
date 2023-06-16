{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}',
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='SF1_SUPPLIER_CURR',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'STG_SF1_SF1SUPPLIER_INCR', 'STG_SF1_SF1SUPPLIER_INIT']
	)
}}
select * from (
	WITH "FAKE_PREV_REF" AS 
	( 
		SELECT 
			  "STG_PREV_SRC"."SUPPLIER_HKEY" AS "SUPPLIER_HKEY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_SUPPLIER_PREV') }} "STG_PREV_SRC"
		WHERE  0 = 1
	)
	SELECT 
		  UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."S_NAME_BK" || '^' )) AS "SUPPLIER_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1' AS "SRC_BK"
		, 'SF1.SF1_SUPPLIER' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."S_SUPPKEY" AS "S_SUPPKEY"
		, "EXT_SRC"."S_NAME_BK" AS "SUPPLIER_BK"
		, "EXT_SRC"."S_NAME" AS "S_NAME"
		, "EXT_SRC"."S_ADDRESS" AS "S_ADDRESS"
		, "EXT_SRC"."S_NATIONKEY" AS "S_NATIONKEY"
		, "EXT_SRC"."S_PHONE" AS "S_PHONE"
		, "EXT_SRC"."S_ACCTBAL" AS "S_ACCTBAL"
		, "EXT_SRC"."S_COMMENT" AS "S_COMMENT"
		, "EXT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_EXT_SF1_SUPPLIER') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	SELECT 
		  UPPER(MD5_HEX( 'SF1' || '^' || "EXT_SRC"."S_NAME_BK" || '^' )) AS "SUPPLIER_HKEY"
		, "EXT_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "EXT_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, 'SF1' AS "SRC_BK"
		, 'SF1.SF1_SUPPLIER' AS "RECORD_SOURCE"
		, "EXT_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "EXT_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "EXT_SRC"."S_SUPPKEY" AS "S_SUPPKEY"
		, "EXT_SRC"."S_NAME_BK" AS "SUPPLIER_BK"
		, "EXT_SRC"."S_NAME" AS "S_NAME"
		, "EXT_SRC"."S_ADDRESS" AS "S_ADDRESS"
		, "EXT_SRC"."S_NATIONKEY" AS "S_NATIONKEY"
		, "EXT_SRC"."S_PHONE" AS "S_PHONE"
		, "EXT_SRC"."S_ACCTBAL" AS "S_ACCTBAL"
		, "EXT_SRC"."S_COMMENT" AS "S_COMMENT"
		, "EXT_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_EXT_SF1_SUPPLIER') }} "EXT_SRC"
	INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC" ON  "MEX_SRC"."RECORD_TYPE" = 'U'

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'