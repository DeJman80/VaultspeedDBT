/*
 __     __          _ _                           _      __  ___  __   __   
 \ \   / /_ _ _   _| | |_ ___ ____   ___  ___  __| |     \ \/ _ \/ /  /_/   
  \ \ / / _` | | | | | __/ __|  _ \ / _ \/ _ \/ _` |      \/ / \ \/ /\      
   \ V / (_| | |_| | | |_\__ \ |_) |  __/  __/ (_| |      / / \/\ \/ /      
    \_/ \__,_|\__,_|_|\__|___/ .__/ \___|\___|\__,_|     /_/ \/_/\__/       
                             |_|                                            

Vaultspeed version: 5.3.1.10, generation date: 2023/06/16 19:12:05
DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40
 */

/* DROP TABLES */
-- START
DROP TABLE IF EXISTS "VS_DEMO_TC_MTD"."FMC_LOADING_WINDOW_TABLE" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_MTD"."LOAD_CYCLE_INFO" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_MTD"."MTD_EXCEPTION_RECORDS" 
CASCADE
;

-- END


/* CREATE TABLES */
-- START

CREATE   TABLE "VS_DEMO_TC_MTD"."FMC_LOADING_WINDOW_TABLE"
(
	"FMC_BEGIN_LW_TIMESTAMP" TIMESTAMP_NTZ,
	"FMC_END_LW_TIMESTAMP" TIMESTAMP_NTZ
)
;

COMMENT ON TABLE "VS_DEMO_TC_MTD"."FMC_LOADING_WINDOW_TABLE" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_MTD"."LOAD_CYCLE_INFO"
(
	"LOAD_CYCLE_ID" INTEGER,
	"LOAD_DATE" TIMESTAMP_NTZ
)
;

COMMENT ON TABLE "VS_DEMO_TC_MTD"."LOAD_CYCLE_INFO" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_MTD"."MTD_EXCEPTION_RECORDS"
(
	"LOAD_CYCLE_ID" VARCHAR(3),
	"RECORD_TYPE" VARCHAR(3),
	"KEY_ATTRIBUTE_BINARY" VARCHAR(3),
	"KEY_ATTRIBUTE_BOOLEAN" VARCHAR(5),
	"KEY_ATTRIBUTE_DATE" VARCHAR(10),
	"KEY_ATTRIBUTE_INTEGER" VARCHAR(11),
	"KEY_ATTRIBUTE_NUMBER" VARCHAR(3),
	"KEY_ATTRIBUTE_TIMESTAMP_NTZ" VARCHAR(19),
	"KEY_ATTRIBUTE_VARCHAR" VARCHAR(3),
	"ATTRIBUTE_BINARY" VARCHAR(3),
	"ATTRIBUTE_BOOLEAN" VARCHAR(5),
	"ATTRIBUTE_DATE" VARCHAR(10),
	"ATTRIBUTE_INTEGER" VARCHAR(11),
	"ATTRIBUTE_NUMBER" VARCHAR(3),
	"ATTRIBUTE_TIMESTAMP_NTZ" VARCHAR(19),
	"ATTRIBUTE_VARCHAR" VARCHAR(3)
)
;

COMMENT ON TABLE "VS_DEMO_TC_MTD"."MTD_EXCEPTION_RECORDS" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


INSERT INTO "VS_DEMO_TC_MTD"."MTD_EXCEPTION_RECORDS"
("LOAD_CYCLE_ID", "RECORD_TYPE", "KEY_ATTRIBUTE_BINARY", "KEY_ATTRIBUTE_BOOLEAN", "KEY_ATTRIBUTE_DATE", "KEY_ATTRIBUTE_INTEGER", "KEY_ATTRIBUTE_NUMBER", "KEY_ATTRIBUTE_TIMESTAMP_NTZ", "KEY_ATTRIBUTE_VARCHAR", "ATTRIBUTE_BINARY", "ATTRIBUTE_BOOLEAN", "ATTRIBUTE_DATE", "ATTRIBUTE_INTEGER", "ATTRIBUTE_NUMBER", "ATTRIBUTE_TIMESTAMP_NTZ", "ATTRIBUTE_VARCHAR") VALUES ('-2','U','~?~','false','01/01/2899','-2147483647','-2','01/01/1899 00:00:00','~?~','~?~','false','01/01/2899','-2147483647','-2','01/01/1899 00:00:00','~?~');

INSERT INTO "VS_DEMO_TC_MTD"."MTD_EXCEPTION_RECORDS"
("LOAD_CYCLE_ID", "RECORD_TYPE", "KEY_ATTRIBUTE_BINARY", "KEY_ATTRIBUTE_BOOLEAN", "KEY_ATTRIBUTE_DATE", "KEY_ATTRIBUTE_INTEGER", "KEY_ATTRIBUTE_NUMBER", "KEY_ATTRIBUTE_TIMESTAMP_NTZ", "KEY_ATTRIBUTE_VARCHAR", "ATTRIBUTE_BINARY", "ATTRIBUTE_BOOLEAN", "ATTRIBUTE_DATE", "ATTRIBUTE_INTEGER", "ATTRIBUTE_NUMBER", "ATTRIBUTE_TIMESTAMP_NTZ", "ATTRIBUTE_VARCHAR") VALUES ('-1','N','0','false','01/01/2999','-2147483648','-1','01/01/1900 00:00:00','0','0','false','01/01/2999','-2147483648','-1','01/01/1900 00:00:00','0');

-- END


