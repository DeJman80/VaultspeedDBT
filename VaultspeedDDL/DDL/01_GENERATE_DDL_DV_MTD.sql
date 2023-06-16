/*
 __     __          _ _                           _      __  ___  __   __   
 \ \   / /_ _ _   _| | |_ ___ ____   ___  ___  __| |     \ \/ _ \/ /  /_/   
  \ \ / / _` | | | | | __/ __|  _ \ / _ \/ _ \/ _` |      \/ / \ \/ /\      
   \ V / (_| | |_| | | |_\__ \ |_) |  __/  __/ (_| |      / / \/\ \/ /      
    \_/ \__,_|\__,_|_|\__|___/ .__/ \___|\___|\__,_|     /_/ \/_/\__/       
                             |_|                                            

Vaultspeed version: 5.3.1.9, generation date: 2023/06/14 18:37:29
DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00
 */

DROP TABLE IF EXISTS "DV_MTD"."FMC_LOADING_HISTORY" 
CASCADE
;

CREATE   TABLE "DV_MTD"."FMC_LOADING_HISTORY"
(
	"DAG_NAME" VARCHAR,
	"SRC_BK" VARCHAR,
	"LOAD_CYCLE_ID" INTEGER,
	"LOAD_DATE" TIMESTAMP_NTZ,
	"FMC_BEGIN_LW_TIMESTAMP" TIMESTAMP_NTZ,
	"FMC_END_LW_TIMESTAMP" TIMESTAMP_NTZ,
	"LOAD_START_DATE" TIMESTAMP_TZ,
	"LOAD_END_DATE" TIMESTAMP_TZ,
	"SUCCESS_FLAG" INTEGER
)
;

COMMENT ON TABLE "DV_MTD"."FMC_LOADING_HISTORY" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';

