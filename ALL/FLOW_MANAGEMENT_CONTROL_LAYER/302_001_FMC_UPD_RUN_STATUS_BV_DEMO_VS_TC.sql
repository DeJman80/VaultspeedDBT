CREATE OR REPLACE PROCEDURE "DV_PROC"."FMC_UPD_RUN_STATUS_BV_DEMO_VS_TC"(P_LOAD_CYCLE_ID VARCHAR2,
P_SUCCESS_FLAG VARCHAR2)
 RETURNS varchar 
LANGUAGE JAVASCRIPT 

AS $$ 
/*
 __     __          _ _                           _      __  ___  __   __   
 \ \   / /_ _ _   _| | |_ ___ ____   ___  ___  __| |     \ \/ _ \/ /  /_/   
  \ \ / / _` | | | | | __/ __|  _ \ / _ \/ _ \/ _` |      \/ / \ \/ /\      
   \ V / (_| | |_| | | |_\__ \ |_) |  __/  __/ (_| |      / / \/\ \/ /      
    \_/ \__,_|\__,_|_|\__|___/ .__/ \___|\___|\__,_|     /_/ \/_/\__/       
                             |_|                                            

Vaultspeed version: 5.3.1.10, generation date: 2023/06/16 21:12:49
DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 15:52:00, 
BV release: init(1) - Comment: initial release - Release date: 2023/06/14 13:52:21, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 22:51:40
 */



var HIST_UPD = snowflake.createStatement( {sqlText: `
	UPDATE "DV_MTD"."FMC_LOADING_HISTORY" "HIST_UPD"
	SET 
		 "SUCCESS_FLAG" =  '` + P_SUCCESS_FLAG + `'::integer
		,"LOAD_END_DATE" =  CURRENT_TIMESTAMP
	WHERE "HIST_UPD"."LOAD_CYCLE_ID" =  '` + P_LOAD_CYCLE_ID + `'::integer
	;
`} ).execute();

return "Done.";$$;
 
 
