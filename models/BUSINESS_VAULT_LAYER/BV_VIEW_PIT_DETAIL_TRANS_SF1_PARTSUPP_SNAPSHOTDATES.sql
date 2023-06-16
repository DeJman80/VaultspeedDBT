{{
	config(
		materialized='view',
		alias='VIEW_PIT_DETAIL_TRANS_SF1_PARTSUPP_SNAPSHOTDATES',
		schema='BV',
		tags=['view', 'BV', 'BV_VIEW_PIT_DETAIL_TRANS_SF1_PARTSUPP_SNAPSHOTDATES_SSD_VIEW']
	)
}}
	SELECT DISTINCT 
		  "SAT_SRC1"."LND_SF1_PARTSUPP_HKEY" AS "LND_SF1_PARTSUPP_HKEY"
		, "SAT_SRC1"."LOAD_DATE" AS "SNAPSHOT_TIMESTAMP"
	FROM {{ ref('RDV_S_SF1_SF1_PARTSUPP_LDS') }} "SAT_SRC1"
