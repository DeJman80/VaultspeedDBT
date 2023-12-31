{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INCR" and var("source") == "VS_DEMO_TC" %} DELETE  FROM {{ this }} "STG_DL_DEL_TGT"	WHERE  NOT EXISTS	(		SELECT 			  1 AS "DUMMY"		FROM {{ source(\'VS_DEMO_TC_MTD\', \'LOAD_CYCLE_INFO\') }} "LCI_DEL_SRC"		INNER JOIN {{ source(\'VS_DEMO_TC_STG\', \'SF1_PARTSUPP_CURR\') }} "STG_DL_DEL_CURR_SRC" ON  "LCI_DEL_SRC"."LOAD_CYCLE_ID" = "STG_DL_DEL_CURR_SRC"."LOAD_CYCLE_ID"	) {% endif %}'
		],
		alias='SF1_PARTSUPP_PREV',
		schema='VS_DEMO_TC_STG',
		tags=['VS_DEMO_TC', 'STG_DL_SF1_SF1PARTSUPP_INCR']
	)
}}
select * from (
	SELECT 
		  "STG_DL_CURR_SRC"."LND_SF1_PARTSUPP_HKEY" AS "LND_SF1_PARTSUPP_HKEY"
		, "STG_DL_CURR_SRC"."SUPPLIER_HKEY" AS "SUPPLIER_HKEY"
		, "STG_DL_CURR_SRC"."PART_HKEY" AS "PART_HKEY"
		, "STG_DL_CURR_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "STG_DL_CURR_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "STG_DL_CURR_SRC"."RECORD_SOURCE" AS "RECORD_SOURCE"
		, "STG_DL_CURR_SRC"."JRN_FLAG" AS "JRN_FLAG"
		, "STG_DL_CURR_SRC"."RECORD_TYPE" AS "RECORD_TYPE"
		, "STG_DL_CURR_SRC"."PS_PARTKEY" AS "PS_PARTKEY"
		, "STG_DL_CURR_SRC"."PS_SUPPKEY" AS "PS_SUPPKEY"
		, "STG_DL_CURR_SRC"."S_NAME_FK_PSSUPPKEY_BK" AS "S_NAME_FK_PSSUPPKEY_BK"
		, "STG_DL_CURR_SRC"."P_NAME_FK_PSPARTKEY_BK" AS "P_NAME_FK_PSPARTKEY_BK"
		, "STG_DL_CURR_SRC"."P_SIZE_FK_PSPARTKEY_BK" AS "P_SIZE_FK_PSPARTKEY_BK"
		, "STG_DL_CURR_SRC"."P_NAME" AS "P_NAME"
		, "STG_DL_CURR_SRC"."P_SIZE" AS "P_SIZE"
		, "STG_DL_CURR_SRC"."S_NAME" AS "S_NAME"
		, "STG_DL_CURR_SRC"."PS_AVAILQTY" AS "PS_AVAILQTY"
		, "STG_DL_CURR_SRC"."PS_SUPPLYCOST" AS "PS_SUPPLYCOST"
		, "STG_DL_CURR_SRC"."PS_COMMENT" AS "PS_COMMENT"
		, "STG_DL_CURR_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ source('VS_DEMO_TC_STG', 'SF1_PARTSUPP_CURR') }} "STG_DL_CURR_SRC"
	LEFT OUTER JOIN {{ source('VS_DEMO_TC_MTD', 'LOAD_CYCLE_INFO') }} "LCI_SRC" ON  "STG_DL_CURR_SRC"."LOAD_CYCLE_ID" = "LCI_SRC"."LOAD_CYCLE_ID"
	LEFT OUTER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_SRC_CURR_TO_PREV" ON  "MEX_SRC_CURR_TO_PREV"."LOAD_CYCLE_ID" = TO_CHAR("STG_DL_CURR_SRC"."LOAD_CYCLE_ID" )
	WHERE  "LCI_SRC"."LOAD_CYCLE_ID" IS NULL AND "MEX_SRC_CURR_TO_PREV"."LOAD_CYCLE_ID" IS NULL

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'