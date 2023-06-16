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

/* DROP TABLES */

-- START
DROP TABLE IF EXISTS "RDV"."S_SF1_ORDERCUST_LDS" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."S_SF1_SF1_LINEITEM_LDS" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."S_SF1_SF1_PARTSUPP_LDS" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."L_ORDERCUST_LND" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."L_SF1_LINEITEM_LND" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."L_SF1_PARTSUPP_LND" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."S_SF1_CUSTOMER" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."S_SF1_ORDER" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."S_SF1_PART" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."S_SF1_SUPPLIER" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."H_CUSTOMER" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."H_ORDER" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."H_PART" 
CASCADE
;
DROP TABLE IF EXISTS "RDV"."H_SUPPLIER" 
CASCADE
;

-- END


/* CREATE TABLES */

-- START

CREATE   TABLE "RDV"."H_CUSTOMER"
(
    "LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"SRC_BK" VARCHAR DEFAULT '0' NOT NULL
   ,"CUSTOMER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"CUSTOMER_BK" VARCHAR DEFAULT '0' NOT NULL
   ,CONSTRAINT "H_CUSTOMER_PK" PRIMARY KEY ("CUSTOMER_HKEY")   
   ,CONSTRAINT "H_CUSTOMER_UK" UNIQUE ("SRC_BK", "CUSTOMER_BK")   
)
;

COMMENT ON TABLE "RDV"."H_CUSTOMER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."H_ORDER"
(
    "ORDER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"SRC_BK" VARCHAR DEFAULT '0' NOT NULL
   ,"ORDER_BK" VARCHAR DEFAULT '0' NOT NULL
   ,CONSTRAINT "H_ORDER_PK" PRIMARY KEY ("ORDER_HKEY")   
   ,CONSTRAINT "H_ORDER_UK" UNIQUE ("SRC_BK", "ORDER_BK")   
)
;

COMMENT ON TABLE "RDV"."H_ORDER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."H_PART"
(
    "LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"SRC_BK" VARCHAR DEFAULT '0' NOT NULL
   ,"PART_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"PART_BK" VARCHAR DEFAULT '0' NOT NULL
   ,CONSTRAINT "H_PART_PK" PRIMARY KEY ("PART_HKEY")   
   ,CONSTRAINT "H_PART_UK" UNIQUE ("SRC_BK", "PART_BK")   
)
;

COMMENT ON TABLE "RDV"."H_PART" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."H_SUPPLIER"
(
    "LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"SRC_BK" VARCHAR DEFAULT '0' NOT NULL
   ,"SUPPLIER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"SUPPLIER_BK" VARCHAR DEFAULT '0' NOT NULL
   ,CONSTRAINT "H_SUPPLIER_PK" PRIMARY KEY ("SUPPLIER_HKEY")   
   ,CONSTRAINT "H_SUPPLIER_UK" UNIQUE ("SRC_BK", "SUPPLIER_BK")   
)
;

COMMENT ON TABLE "RDV"."H_SUPPLIER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_CUSTOMER"
(
    "CUSTOMER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"C_CUSTKEY" NUMBER
   ,"C_ADDRESS" VARCHAR(40)
   ,"C_NATIONKEY" NUMBER
   ,"C_PHONE" VARCHAR(15)
   ,"C_ACCTBAL" NUMBER
   ,"C_MKTSEGMENT" VARCHAR(10)
   ,"C_COMMENT" VARCHAR(117)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
   ,"C_NAME" VARCHAR(25)
   ,CONSTRAINT "S_SF1_CUSTOMER_UK" UNIQUE ("CUSTOMER_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_CUSTOMER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_ORDER"
(
    "ORDER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"O_ORDERKEY" NUMBER
   ,"C_NAME" VARCHAR(25)
   ,"O_ORDERSTATUS" VARCHAR(3)
   ,"O_TOTALPRICE" NUMBER
   ,"O_ORDERDATE" DATE
   ,"O_ORDERPRIORITY" VARCHAR(15)
   ,"O_CLERK" VARCHAR(15)
   ,"O_SHIPPRIORITY" NUMBER
   ,"O_COMMENT" VARCHAR(79)
   ,"DSS_RECORD_SOURCE" VARCHAR(37)
   ,CONSTRAINT "S_SF1_ORDER_UK" UNIQUE ("ORDER_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_ORDER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_PART"
(
    "PART_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"P_PARTKEY" NUMBER
   ,"P_MFGR" VARCHAR(25)
   ,"P_BRAND" VARCHAR(10)
   ,"P_TYPE" VARCHAR(25)
   ,"P_CONTAINER" VARCHAR(10)
   ,"P_RETAILPRICE" NUMBER
   ,"P_COMMENT" VARCHAR(23)
   ,"DSS_RECORD_SOURCE" VARCHAR(35)
   ,"P_NAME" VARCHAR(55)
   ,"P_SIZE" NUMBER
   ,CONSTRAINT "S_SF1_PART_UK" UNIQUE ("PART_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_PART" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_SUPPLIER"
(
    "SUPPLIER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"S_SUPPKEY" NUMBER
   ,"S_ADDRESS" VARCHAR(40)
   ,"S_NATIONKEY" NUMBER
   ,"S_PHONE" VARCHAR(15)
   ,"S_ACCTBAL" NUMBER
   ,"S_COMMENT" VARCHAR(101)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
   ,"S_NAME" VARCHAR(25)
   ,CONSTRAINT "S_SF1_SUPPLIER_UK" UNIQUE ("SUPPLIER_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_SUPPLIER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."L_ORDERCUST_LND"
(
    "LND_ORDERCUST_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"ORDER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"CUSTOMER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,CONSTRAINT "L_ORDER_CUST_LND_PK" PRIMARY KEY ("LND_ORDERCUST_HKEY")   
   ,CONSTRAINT "L_ORDER_CUST_LND_UK" UNIQUE ("CUSTOMER_HKEY", "ORDER_HKEY")   
)
;

COMMENT ON TABLE "RDV"."L_ORDERCUST_LND" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."L_SF1_LINEITEM_LND"
(
    "LND_SF1_LINEITEM_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"ORDER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"PART_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"SUPPLIER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,CONSTRAINT "L_SF1LINEITEM_LND_PK" PRIMARY KEY ("LND_SF1_LINEITEM_HKEY")   
   ,CONSTRAINT "L_SF1LINEITEM_LND_UK" UNIQUE ("PART_HKEY", "SUPPLIER_HKEY", "ORDER_HKEY")   
)
;

COMMENT ON TABLE "RDV"."L_SF1_LINEITEM_LND" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."L_SF1_PARTSUPP_LND"
(
    "LND_SF1_PARTSUPP_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"RECORD_SOURCE" VARCHAR DEFAULT '0' NOT NULL
   ,"SUPPLIER_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"PART_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,CONSTRAINT "L_SF1PARTSUPP_LND_PK" PRIMARY KEY ("LND_SF1_PARTSUPP_HKEY")   
   ,CONSTRAINT "L_SF1PARTSUPP_LND_UK" UNIQUE ("SUPPLIER_HKEY", "PART_HKEY")   
)
;

COMMENT ON TABLE "RDV"."L_SF1_PARTSUPP_LND" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_ORDERCUST_LDS"
(
    "LND_ORDERCUST_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"O_CUSTKEY" NUMBER DEFAULT -1 NOT NULL
   ,"O_ORDERKEY" NUMBER DEFAULT -1 NOT NULL
   ,"C_NAME" VARCHAR(25)
   ,CONSTRAINT "S_SF1_ORDER_CUST_LDS_UK" UNIQUE ("LND_ORDERCUST_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_ORDERCUST_LDS" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_SF1_LINEITEM_LDS"
(
    "LND_SF1_LINEITEM_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"L_ORDERKEY" NUMBER DEFAULT -1 NOT NULL
   ,"L_PARTKEY" NUMBER
   ,"L_LINENUMBER" NUMBER DEFAULT -1 NOT NULL
   ,"L_SUPPKEY" NUMBER
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
   ,CONSTRAINT "S_SF1_SF1LINEITEM_LDS_UK" UNIQUE ("LND_SF1_LINEITEM_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_SF1_LINEITEM_LDS" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "RDV"."S_SF1_SF1_PARTSUPP_LDS"
(
    "LND_SF1_PARTSUPP_HKEY" VARCHAR(32) DEFAULT '0' NOT NULL
   ,"LOAD_DATE" TIMESTAMP_NTZ DEFAULT TO_TIMESTAMP('01/01/1900 00:00:00', 'DD/MM/YYYY HH24:MI:SS') NOT NULL
   ,"LOAD_CYCLE_ID" INTEGER DEFAULT -2147483648 NOT NULL
   ,"HASH_DIFF" VARCHAR(32)
   ,"DELETE_FLAG" VARCHAR(3) DEFAULT '0' NOT NULL
   ,"PS_PARTKEY" NUMBER DEFAULT -1 NOT NULL
   ,"PS_SUPPKEY" NUMBER DEFAULT -1 NOT NULL
   ,"P_NAME" VARCHAR(55)
   ,"P_SIZE" NUMBER
   ,"S_NAME" VARCHAR(25)
   ,"PS_AVAILQTY" NUMBER
   ,"PS_SUPPLYCOST" NUMBER
   ,"PS_COMMENT" VARCHAR(199)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
   ,CONSTRAINT "S_SF1_SF1PARTSUPP_LDS_UK" UNIQUE ("LND_SF1_PARTSUPP_HKEY", "LOAD_DATE")   
)
;

COMMENT ON TABLE "RDV"."S_SF1_SF1_PARTSUPP_LDS" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


-- END


