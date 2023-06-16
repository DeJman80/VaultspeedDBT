{{
	config(
		materialized='view',
		alias='VIEW_PIT_DETAIL_ORDERCUST_SNAPSHOTDATES',
		schema='BV',
		tags=['view', 'BV', 'BV_VIEW_PIT_DETAIL_ORDERCUST_SNAPSHOTDATES_SSD_VIEW']
	)
}}
	SELECT DISTINCT 
		  "SAT_SRC1"."LND_ORDERCUST_HKEY" AS "LND_ORDERCUST_HKEY"
		, "SAT_SRC1"."LOAD_DATE" AS "SNAPSHOT_TIMESTAMP"
	FROM {{ ref('RDV_S_SF1_ORDERCUST_LDS') }} "SAT_SRC1"
