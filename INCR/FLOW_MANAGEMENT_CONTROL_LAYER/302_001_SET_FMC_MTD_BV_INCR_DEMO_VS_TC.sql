CREATE OR REPLACE PROCEDURE "DV_PROC"."SET_FMC_MTD_BV_INCR_DEMO_VS_TC"(P_DAG_NAME VARCHAR2,
P_LOAD_CYCLE_ID VARCHAR2,
P_LOAD_DATE VARCHAR2)
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



var HIST_INS = snowflake.createStatement( {sqlText: `
	INSERT INTO "DV_MTD"."FMC_LOADING_HISTORY"(
		 "DAG_NAME"
		,"SRC_BK"
		,"LOAD_CYCLE_ID"
		,"LOAD_DATE"
		,"FMC_BEGIN_LW_TIMESTAMP"
		,"FMC_END_LW_TIMESTAMP"
		,"LOAD_START_DATE"
		,"LOAD_END_DATE"
		,"SUCCESS_FLAG"
	)
	WITH "PREV_BV_LOAD" AS 
	( 
		SELECT 
			  MAX("FMCH_SRC"."LOAD_CYCLE_ID") AS "LOAD_CYCLE_ID"
		FROM "DV_MTD"."FMC_LOADING_HISTORY" "FMCH_SRC"
		WHERE  "FMCH_SRC"."SRC_BK" = 'DEMO_VS_TC' AND "FMCH_SRC"."SUCCESS_FLAG" = 1
	)
	, "SRC_WINDOW" AS 
	( 
		SELECT 
			  MIN("FMCH_SRC"."FMC_BEGIN_LW_TIMESTAMP") AS "FMC_BEGIN_LW_TIMESTAMP"
		FROM "DV_MTD"."FMC_LOADING_HISTORY" "FMCH_SRC"
		INNER JOIN "PREV_BV_LOAD" "PREV_BV_LOAD" ON  1 = 1
		WHERE  "FMCH_SRC"."SRC_BK" IN('SF1') AND "FMCH_SRC"."SUCCESS_FLAG" = 1 AND "FMCH_SRC"."LOAD_CYCLE_ID" > "PREV_BV_LOAD"."LOAD_CYCLE_ID"
	)
	SELECT 
		  '` + P_DAG_NAME + `' AS "DAG_NAME"
		, 'DEMO_VS_TC' AS "SRC_BK"
		, '` + P_LOAD_CYCLE_ID + `'::integer AS "LOAD_CYCLE_ID"
		, TO_TIMESTAMP('` + P_LOAD_DATE + `', 'YYYY-MM-DD HH24:MI:SS.FF6') AS "LOAD_DATE"
		, "SRC_WINDOW"."FMC_BEGIN_LW_TIMESTAMP" AS "FMC_BEGIN_LW_TIMESTAMP"
		, TO_TIMESTAMP('` + P_LOAD_DATE + `', 'YYYY-MM-DD HH24:MI:SS.FF6') AS "FMC_END_LW_TIMESTAMP"
		, CURRENT_TIMESTAMP AS "LOAD_START_DATE"
		, NULL AS "LOAD_END_DATE"
		, NULL AS "SUCCESS_FLAG"
	FROM "SRC_WINDOW" "SRC_WINDOW"
	WHERE  NOT EXISTS
	(
		SELECT 
			  1 AS "DUMMY"
		FROM "DV_MTD"."FMC_LOADING_HISTORY" "FMCH_SRC"
		WHERE  "FMCH_SRC"."LOAD_CYCLE_ID" = '` + P_LOAD_CYCLE_ID + `'::integer
	)
	;
`} ).execute();

var truncate_LCI_TGT = snowflake.createStatement( {sqlText: `
	TRUNCATE TABLE "DV_MTD"."LOAD_CYCLE_INFO";
`} ).execute();


var LCI_INS = snowflake.createStatement( {sqlText: `
	INSERT INTO "DV_MTD"."LOAD_CYCLE_INFO"(
		 "LOAD_CYCLE_ID"
		,"LOAD_DATE"
	)
	SELECT 
		  '` + P_LOAD_CYCLE_ID + `'::integer AS "LOAD_CYCLE_ID"
		, TO_TIMESTAMP('` + P_LOAD_DATE + `', 'YYYY-MM-DD HH24:MI:SS.FF6') AS "LOAD_DATE"
	;
`} ).execute();

var truncate_LWT_TGT = snowflake.createStatement( {sqlText: `
	TRUNCATE TABLE "DV_MTD"."FMC_BV_LOADING_WINDOW_TABLE";
`} ).execute();


var LWT_INS = snowflake.createStatement( {sqlText: `
	INSERT INTO "DV_MTD"."FMC_BV_LOADING_WINDOW_TABLE"(
		 "FMC_BEGIN_LW_TIMESTAMP"
		,"FMC_END_LW_TIMESTAMP"
	)
	SELECT 
		  "FMCH_SRC"."FMC_BEGIN_LW_TIMESTAMP" AS "FMC_BEGIN_LW_TIMESTAMP"
		, "FMCH_SRC"."FMC_END_LW_TIMESTAMP" AS "FMC_END_LW_TIMESTAMP"
	FROM "DV_MTD"."FMC_LOADING_HISTORY" "FMCH_SRC"
	WHERE  "FMCH_SRC"."LOAD_CYCLE_ID" = '` + P_LOAD_CYCLE_ID + `'::integer
	;
`} ).execute();

var truncate_LCI_TGT = snowflake.createStatement( {sqlText: `
	TRUNCATE TABLE "DV_MTD"."DV_LOAD_CYCLE_INFO";
`} ).execute();


var LCI_INS = snowflake.createStatement( {sqlText: `
	INSERT INTO "DV_MTD"."DV_LOAD_CYCLE_INFO"(
		 "DV_LOAD_CYCLE_ID"
	)
	WITH "PREV_BV_LOAD" AS 
	( 
		SELECT 
			  MAX("FMCH_SRC"."LOAD_CYCLE_ID") AS "LOAD_CYCLE_ID"
		FROM "DV_MTD"."FMC_LOADING_HISTORY" "FMCH_SRC"
		WHERE  "FMCH_SRC"."SRC_BK" = 'DEMO_VS_TC' AND "FMCH_SRC"."SUCCESS_FLAG" = 1
	)
	SELECT 
		  "FMCH_SRC"."LOAD_CYCLE_ID" AS "DV_LOAD_CYCLE_ID"
	FROM "DV_MTD"."FMC_LOADING_HISTORY" "FMCH_SRC"
	INNER JOIN "PREV_BV_LOAD" "PREV_BV_LOAD" ON  1 = 1
	WHERE  "FMCH_SRC"."SRC_BK" IN('SF1') AND "FMCH_SRC"."SUCCESS_FLAG" = 1 AND "FMCH_SRC"."LOAD_CYCLE_ID" > "PREV_BV_LOAD"."LOAD_CYCLE_ID"
	;
`} ).execute();

return "Done.";$$;
 
 
