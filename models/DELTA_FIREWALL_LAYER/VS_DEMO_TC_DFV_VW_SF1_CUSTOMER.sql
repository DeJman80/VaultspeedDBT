{{
	config(
		materialized='view',
		alias='VW_SF1_CUSTOMER',
		schema='VS_DEMO_TC_DFV',
		tags=['view', 'VS_DEMO_TC', 'SRC_SF1_SF1CUSTOMER_TDFV_INCR']
	)
}}
	WITH "DELTA_VIEW_FILTER" AS 
	( 
		SELECT 
			  TO_CHAR('S' ) AS "RECORD_TYPE"
			, "CDC_SRC"."C_CUSTKEY" AS "C_CUSTKEY"
			, "CDC_SRC"."C_NAME" AS "C_NAME"
			, "CDC_SRC"."C_ADDRESS" AS "C_ADDRESS"
			, "CDC_SRC"."C_NATIONKEY" AS "C_NATIONKEY"
			, "CDC_SRC"."C_PHONE" AS "C_PHONE"
			, "CDC_SRC"."C_ACCTBAL" AS "C_ACCTBAL"
			, "CDC_SRC"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "CDC_SRC"."C_COMMENT" AS "C_COMMENT"
			, "CDC_SRC"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM {{ source('PG2_SOURCE_DATA_TC"."TPCH_SF1', 'SF1_CUSTOMER') }} "CDC_SRC"
	)
	, "DELTA_VIEW" AS 
	( 
		SELECT 
			  "DELTA_VIEW_FILTER"."RECORD_TYPE" AS "RECORD_TYPE"
			, "DELTA_VIEW_FILTER"."C_CUSTKEY" AS "C_CUSTKEY"
			, "DELTA_VIEW_FILTER"."C_NAME" AS "C_NAME"
			, "DELTA_VIEW_FILTER"."C_ADDRESS" AS "C_ADDRESS"
			, "DELTA_VIEW_FILTER"."C_NATIONKEY" AS "C_NATIONKEY"
			, "DELTA_VIEW_FILTER"."C_PHONE" AS "C_PHONE"
			, "DELTA_VIEW_FILTER"."C_ACCTBAL" AS "C_ACCTBAL"
			, "DELTA_VIEW_FILTER"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "DELTA_VIEW_FILTER"."C_COMMENT" AS "C_COMMENT"
			, "DELTA_VIEW_FILTER"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM "DELTA_VIEW_FILTER" "DELTA_VIEW_FILTER"
	)
	, "PREPJOINBK" AS 
	( 
		SELECT 
			  "DELTA_VIEW"."RECORD_TYPE" AS "RECORD_TYPE"
			, COALESCE("DELTA_VIEW"."C_CUSTKEY", CAST("MEX_BK_SRC"."KEY_ATTRIBUTE_NUMBER" AS NUMBER)) AS "C_CUSTKEY"
			, "DELTA_VIEW"."C_NAME" AS "C_NAME"
			, "DELTA_VIEW"."C_ADDRESS" AS "C_ADDRESS"
			, "DELTA_VIEW"."C_NATIONKEY" AS "C_NATIONKEY"
			, "DELTA_VIEW"."C_PHONE" AS "C_PHONE"
			, "DELTA_VIEW"."C_ACCTBAL" AS "C_ACCTBAL"
			, "DELTA_VIEW"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
			, "DELTA_VIEW"."C_COMMENT" AS "C_COMMENT"
			, "DELTA_VIEW"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
		FROM "DELTA_VIEW" "DELTA_VIEW"
		INNER JOIN {{ source('VS_DEMO_TC_MTD', 'MTD_EXCEPTION_RECORDS') }} "MEX_BK_SRC" ON  1 = 1
		WHERE  "MEX_BK_SRC"."RECORD_TYPE" = 'N'
	)
	SELECT 
		  "PREPJOINBK"."RECORD_TYPE" AS "RECORD_TYPE"
		, "PREPJOINBK"."C_CUSTKEY" AS "C_CUSTKEY"
		, "PREPJOINBK"."C_NAME" AS "C_NAME"
		, "PREPJOINBK"."C_ADDRESS" AS "C_ADDRESS"
		, "PREPJOINBK"."C_NATIONKEY" AS "C_NATIONKEY"
		, "PREPJOINBK"."C_PHONE" AS "C_PHONE"
		, "PREPJOINBK"."C_ACCTBAL" AS "C_ACCTBAL"
		, "PREPJOINBK"."C_MKTSEGMENT" AS "C_MKTSEGMENT"
		, "PREPJOINBK"."C_COMMENT" AS "C_COMMENT"
		, "PREPJOINBK"."DSS_RECORD_SOURCE" AS "DSS_RECORD_SOURCE"
	FROM "PREPJOINBK" "PREPJOINBK"
