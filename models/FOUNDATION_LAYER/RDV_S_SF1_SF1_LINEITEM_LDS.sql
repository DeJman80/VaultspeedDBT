{{
	config(
		materialized='incremental',
		pre_hook= [
			'{% if var("load_type") == "INIT" and var("source") == "VS_DEMO_TC" %} TRUNCATE TABLE {{ this }}; {% endif %}'
		],
		alias='S_SF1_SF1_LINEITEM_LDS',
		schema='RDV',
		tags=['VS_DEMO_TC', 'LDS_SF1_SF1LINEITEM_INCR', 'LDS_SF1_SF1LINEITEM_INIT']
	)
}}
select * from (
	SELECT 
		  "LDS_TEMP_SRC_INUR"."LND_SF1_LINEITEM_HKEY" AS "LND_SF1_LINEITEM_HKEY"
		, "LDS_TEMP_SRC_INUR"."L_ORDERKEY" AS "L_ORDERKEY"
		, "LDS_TEMP_SRC_INUR"."L_LINENUMBER" AS "L_LINENUMBER"
		, "LDS_TEMP_SRC_INUR"."L_PARTKEY" AS "L_PARTKEY"
		, "LDS_TEMP_SRC_INUR"."L_SUPPKEY" AS "L_SUPPKEY"
		, "LDS_TEMP_SRC_INUR"."LOAD_DATE" AS "LOAD_DATE"
		, "LDS_TEMP_SRC_INUR"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "LDS_TEMP_SRC_INUR"."HASH_DIFF" AS "HASH_DIFF"
		, "LDS_TEMP_SRC_INUR"."DELETE_FLAG" AS "DELETE_FLAG"
		, "LDS_TEMP_SRC_INUR"."P_NAME" AS "P_NAME"
		, "LDS_TEMP_SRC_INUR"."P_SIZE" AS "P_SIZE"
		, "LDS_TEMP_SRC_INUR"."S_NAME" AS "S_NAME"
		, "LDS_TEMP_SRC_INUR"."L_QUANTITY" AS "L_QUANTITY"
		, "LDS_TEMP_SRC_INUR"."L_EXTENDEDPRICE" AS "L_EXTENDEDPRICE"
		, "LDS_TEMP_SRC_INUR"."L_DISCOUNT" AS "L_DISCOUNT"
		, "LDS_TEMP_SRC_INUR"."L_TAX" AS "L_TAX"
		, "LDS_TEMP_SRC_INUR"."L_RETURNFLAG" AS "L_RETURNFLAG"
		, "LDS_TEMP_SRC_INUR"."L_LINESTATUS" AS "L_LINESTATUS"
		, "LDS_TEMP_SRC_INUR"."L_SHIPDATE" AS "L_SHIPDATE"
		, "LDS_TEMP_SRC_INUR"."L_COMMITDATE" AS "L_COMMITDATE"
		, "LDS_TEMP_SRC_INUR"."L_RECEIPTDATE" AS "L_RECEIPTDATE"
		, "LDS_TEMP_SRC_INUR"."L_SHIPINSTRUCT" AS "L_SHIPINSTRUCT"
		, "LDS_TEMP_SRC_INUR"."L_SHIPMODE" AS "L_SHIPMODE"
		, "LDS_TEMP_SRC_INUR"."L_COMMENT" AS "L_COMMENT"
		, "LDS_TEMP_SRC_INUR"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM {{ ref('VS_DEMO_TC_STG_S_SF1_SF1_LINEITEM_LDS_TMP') }} "LDS_TEMP_SRC_INUR"
	WHERE  "LDS_TEMP_SRC_INUR"."SOURCE" = 'STG' AND "LDS_TEMP_SRC_INUR"."EQUAL" = 0

) final 
where '{{ var("load_type") }}' = 'INCR' and '{{ var("source") }}' = 'VS_DEMO_TC'

UNION ALL

select * from (
	WITH "STG_DL_SRC" AS 
	( 
		SELECT 
			  "STG_DL_INR_SRC"."LND_SF1_LINEITEM_HKEY" AS "LND_SF1_LINEITEM_HKEY"
			, "STG_DL_INR_SRC"."L_ORDERKEY" AS "L_ORDERKEY"
			, "STG_DL_INR_SRC"."L_LINENUMBER" AS "L_LINENUMBER"
			, "STG_DL_INR_SRC"."L_PARTKEY" AS "L_PARTKEY"
			, "STG_DL_INR_SRC"."L_SUPPKEY" AS "L_SUPPKEY"
			, "STG_DL_INR_SRC"."LOAD_DATE" AS "LOAD_DATE"
			, "STG_DL_INR_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
			, UPPER(MD5_HEX(COALESCE(RTRIM( REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."P_NAME"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."P_SIZE")
				),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."S_NAME"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_LINENUMBER")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_QUANTITY")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_EXTENDEDPRICE")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_DISCOUNT")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_TAX")),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."L_RETURNFLAG"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."L_LINESTATUS"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_SHIPDATE", 'DD/MM/YYYY')),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_COMMITDATE", 'DD/MM/YYYY')),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( TO_CHAR("STG_DL_INR_SRC"."L_RECEIPTDATE", 'DD/MM/YYYY')),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."L_SHIPINSTRUCT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."L_SHIPMODE"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."L_COMMENT"),'~'),'^','\\' || '^')|| '^' ||  REPLACE(COALESCE(TRIM( "STG_DL_INR_SRC"."DSS_RECORD_SOURCE"),'~'),'^','\\' || '^')|| '^','^' || '~'),'~') )) AS "HASH_DIFF"
			, CAST('N' AS VARCHAR) AS "DELETE_FLAG"
			, "STG_DL_INR_SRC"."P_NAME" AS "P_NAME"
			, "STG_DL_INR_SRC"."P_SIZE" AS "P_SIZE"
			, "STG_DL_INR_SRC"."S_NAME" AS "S_NAME"
			, "STG_DL_INR_SRC"."L_QUANTITY" AS "L_QUANTITY"
			, "STG_DL_INR_SRC"."L_EXTENDEDPRICE" AS "L_EXTENDEDPRICE"
			, "STG_DL_INR_SRC"."L_DISCOUNT" AS "L_DISCOUNT"
			, "STG_DL_INR_SRC"."L_TAX" AS "L_TAX"
			, "STG_DL_INR_SRC"."L_RETURNFLAG" AS "L_RETURNFLAG"
			, "STG_DL_INR_SRC"."L_LINESTATUS" AS "L_LINESTATUS"
			, "STG_DL_INR_SRC"."L_SHIPDATE" AS "L_SHIPDATE"
			, "STG_DL_INR_SRC"."L_COMMITDATE" AS "L_COMMITDATE"
			, "STG_DL_INR_SRC"."L_RECEIPTDATE" AS "L_RECEIPTDATE"
			, "STG_DL_INR_SRC"."L_SHIPINSTRUCT" AS "L_SHIPINSTRUCT"
			, "STG_DL_INR_SRC"."L_SHIPMODE" AS "L_SHIPMODE"
			, "STG_DL_INR_SRC"."L_COMMENT" AS "L_COMMENT"
			, "STG_DL_INR_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
			, ROW_NUMBER()OVER(PARTITION BY "STG_DL_INR_SRC"."LND_SF1_LINEITEM_HKEY" ORDER BY "STG_DL_INR_SRC"."LOAD_DATE") AS "DUMMY"
		FROM {{ ref('VS_DEMO_TC_STG_SF1_LINEITEM') }} "STG_DL_INR_SRC"
	)
	SELECT 
		  "STG_DL_SRC"."LND_SF1_LINEITEM_HKEY" AS "LND_SF1_LINEITEM_HKEY"
		, "STG_DL_SRC"."L_ORDERKEY" AS "L_ORDERKEY"
		, "STG_DL_SRC"."L_LINENUMBER" AS "L_LINENUMBER"
		, "STG_DL_SRC"."L_PARTKEY" AS "L_PARTKEY"
		, "STG_DL_SRC"."L_SUPPKEY" AS "L_SUPPKEY"
		, "STG_DL_SRC"."LOAD_DATE" AS "LOAD_DATE"
		, "STG_DL_SRC"."LOAD_CYCLE_ID" AS "LOAD_CYCLE_ID"
		, "STG_DL_SRC"."HASH_DIFF" AS "HASH_DIFF"
		, "STG_DL_SRC"."DELETE_FLAG" AS "DELETE_FLAG"
		, "STG_DL_SRC"."P_NAME" AS "P_NAME"
		, "STG_DL_SRC"."P_SIZE" AS "P_SIZE"
		, "STG_DL_SRC"."S_NAME" AS "S_NAME"
		, "STG_DL_SRC"."L_QUANTITY" AS "L_QUANTITY"
		, "STG_DL_SRC"."L_EXTENDEDPRICE" AS "L_EXTENDEDPRICE"
		, "STG_DL_SRC"."L_DISCOUNT" AS "L_DISCOUNT"
		, "STG_DL_SRC"."L_TAX" AS "L_TAX"
		, "STG_DL_SRC"."L_RETURNFLAG" AS "L_RETURNFLAG"
		, "STG_DL_SRC"."L_LINESTATUS" AS "L_LINESTATUS"
		, "STG_DL_SRC"."L_SHIPDATE" AS "L_SHIPDATE"
		, "STG_DL_SRC"."L_COMMITDATE" AS "L_COMMITDATE"
		, "STG_DL_SRC"."L_RECEIPTDATE" AS "L_RECEIPTDATE"
		, "STG_DL_SRC"."L_SHIPINSTRUCT" AS "L_SHIPINSTRUCT"
		, "STG_DL_SRC"."L_SHIPMODE" AS "L_SHIPMODE"
		, "STG_DL_SRC"."L_COMMENT" AS "L_COMMENT"
		, "STG_DL_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "STG_DL_SRC" "STG_DL_SRC"
	WHERE  "STG_DL_SRC"."DUMMY" = 1

) final 
where '{{ var("load_type") }}' = 'INIT' and '{{ var("source") }}' = 'VS_DEMO_TC'