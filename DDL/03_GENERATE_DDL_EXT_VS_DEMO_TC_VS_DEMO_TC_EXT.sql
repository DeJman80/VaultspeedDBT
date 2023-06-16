/*
 __     __          _ _                           _      __  ___  __   __   
 \ \   / /_ _ _   _| | |_ ___ ____   ___  ___  __| |     \ \/ _ \/ /  /_/   
  \ \ / / _` | | | | | __/ __|  _ \ / _ \/ _ \/ _` |      \/ / \ \/ /\      
   \ V / (_| | |_| | | |_\__ \ |_) |  __/  __/ (_| |      / / \/\ \/ /      
    \_/ \__,_|\__,_|_|\__|___/ .__/ \___|\___|\__,_|     /_/ \/_/\__/       
                             |_|                                            

Vaultspeed version: 5.3.1.9, generation date: 2023/06/14 18:37:29
DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40
 */

/* DROP TABLES */

-- START

DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."ORDER" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."ORDER_CUST" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."SF1_CUSTOMER" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."SF1_LINEITEM" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."SF1_PART" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."SF1_PARTSUPP" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_EXT"."SF1_SUPPLIER" 
CASCADE
;

-- END


/* CREATE TABLES */

-- START


CREATE   TABLE "VS_DEMO_TC_EXT"."ORDER"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"O_ORDERKEY" NUMBER
   ,"O_ORDERKEY_BK" VARCHAR(1500)
   ,"C_NAME" VARCHAR(25)
   ,"O_ORDERSTATUS" VARCHAR(3)
   ,"O_TOTALPRICE" NUMBER
   ,"O_ORDERDATE" DATE
   ,"O_ORDERPRIORITY" VARCHAR(15)
   ,"O_CLERK" VARCHAR(15)
   ,"O_SHIPPRIORITY" NUMBER
   ,"O_COMMENT" VARCHAR(79)
   ,"DSS_RECORD_SOURCE" VARCHAR(37)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."ORDER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_EXT"."ORDER_CUST"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"O_ORDERKEY" NUMBER
   ,"O_CUSTKEY" NUMBER
   ,"O_ORDERKEY_FK_OORDERKEY_BK" VARCHAR(1500)
   ,"C_NAME" VARCHAR(25)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."ORDER_CUST" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_EXT"."SF1_CUSTOMER"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"C_CUSTKEY" NUMBER
   ,"C_NAME_BK" VARCHAR(1500)
   ,"C_NAME" VARCHAR(25)
   ,"C_ADDRESS" VARCHAR(40)
   ,"C_NATIONKEY" NUMBER
   ,"C_PHONE" VARCHAR(15)
   ,"C_ACCTBAL" NUMBER
   ,"C_MKTSEGMENT" VARCHAR(10)
   ,"C_COMMENT" VARCHAR(117)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."SF1_CUSTOMER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_EXT"."SF1_LINEITEM"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"L_ORDERKEY" NUMBER
   ,"L_LINENUMBER" NUMBER
   ,"L_PARTKEY" NUMBER
   ,"L_SUPPKEY" NUMBER
   ,"O_ORDERKEY_FK_LORDERKEY_BK" VARCHAR(1500)
   ,"P_NAME" VARCHAR(55)
   ,"P_SIZE" NUMBER
   ,"S_NAME" VARCHAR(25)
   ,"L_QUANTITY" NUMBER
   ,"L_EXTENDEDPRICE" NUMBER
   ,"L_DISCOUNT" NUMBER
   ,"L_TAX" NUMBER
   ,"L_RETURNFLAG" VARCHAR(3)
   ,"L_LINESTATUS" VARCHAR(3)
   ,"L_SHIPDATE" DATE
   ,"L_COMMITDATE" DATE
   ,"L_RECEIPTDATE" DATE
   ,"L_SHIPINSTRUCT" VARCHAR(25)
   ,"L_SHIPMODE" VARCHAR(10)
   ,"L_COMMENT" VARCHAR(44)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."SF1_LINEITEM" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_EXT"."SF1_PART"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"P_PARTKEY" NUMBER
   ,"P_NAME_BK" VARCHAR(750)
   ,"P_SIZE_BK" VARCHAR(750)
   ,"P_NAME" VARCHAR(55)
   ,"P_SIZE" NUMBER
   ,"P_MFGR" VARCHAR(25)
   ,"P_BRAND" VARCHAR(10)
   ,"P_TYPE" VARCHAR(25)
   ,"P_CONTAINER" VARCHAR(10)
   ,"P_RETAILPRICE" NUMBER
   ,"P_COMMENT" VARCHAR(23)
   ,"DSS_RECORD_SOURCE" VARCHAR(35)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."SF1_PART" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_EXT"."SF1_PARTSUPP"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"PS_PARTKEY" NUMBER
   ,"PS_SUPPKEY" NUMBER
   ,"P_NAME" VARCHAR(55)
   ,"P_SIZE" NUMBER
   ,"S_NAME" VARCHAR(25)
   ,"PS_AVAILQTY" NUMBER
   ,"PS_SUPPLYCOST" NUMBER
   ,"PS_COMMENT" VARCHAR(199)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."SF1_PARTSUPP" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


CREATE   TABLE "VS_DEMO_TC_EXT"."SF1_SUPPLIER"
(
    "LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"S_SUPPKEY" NUMBER
   ,"S_NAME_BK" VARCHAR(1500)
   ,"S_NAME" VARCHAR(25)
   ,"S_ADDRESS" VARCHAR(40)
   ,"S_NATIONKEY" NUMBER
   ,"S_PHONE" VARCHAR(15)
   ,"S_ACCTBAL" NUMBER
   ,"S_COMMENT" VARCHAR(101)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_EXT"."SF1_SUPPLIER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00, 
SRC_NAME: VS_DEMO_TC - Release: VS_DEMO_TC(14) - Comment: change PARTSUPP to Link - Release date: 2023/05/23 20:51:40';


-- END

