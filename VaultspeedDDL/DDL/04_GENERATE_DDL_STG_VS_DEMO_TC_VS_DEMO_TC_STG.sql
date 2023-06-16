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

DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."ORDER" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."ORDER_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."ORDER_CUST" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."ORDER_CUST_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."ORDER_CUST_PREV" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."ORDER_PREV" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_CUSTOMER" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_CUSTOMER_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_CUSTOMER_PREV" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_LINEITEM" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_LINEITEM_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_LINEITEM_PREV" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_PART" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_PART_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_PART_PREV" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_PARTSUPP" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_PARTSUPP_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_PARTSUPP_PREV" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_SUPPLIER" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_SUPPLIER_CURR" 
CASCADE
;
DROP TABLE IF EXISTS "VS_DEMO_TC_STG"."SF1_SUPPLIER_PREV" 
CASCADE
;
-- END


/* CREATE TABLES */

-- START


CREATE   TABLE "VS_DEMO_TC_STG"."ORDER"
(
    "ORDER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"ORDER_BK" VARCHAR
   ,"O_ORDERKEY_BK" VARCHAR(1500)
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
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."ORDER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."ORDER_CURR"
(
    "ORDER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"ORDER_BK" VARCHAR
   ,"O_ORDERKEY_BK" VARCHAR(1500)
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
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."ORDER_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."ORDER_CUST"
(
    "LND_ORDERCUST_HKEY" VARCHAR(32)
   ,"ORDER_HKEY" VARCHAR(32)
   ,"CUSTOMER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"C_NAME_FK_OCUSTKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY_FK_OORDERKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY" NUMBER
   ,"O_CUSTKEY" NUMBER
   ,"C_NAME" VARCHAR(25)
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."ORDER_CUST" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."ORDER_CUST_CURR"
(
    "LND_ORDERCUST_HKEY" VARCHAR(32)
   ,"ORDER_HKEY" VARCHAR(32)
   ,"CUSTOMER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"C_NAME_FK_OCUSTKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY_FK_OORDERKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY" NUMBER
   ,"O_CUSTKEY" NUMBER
   ,"C_NAME" VARCHAR(25)
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."ORDER_CUST_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."ORDER_CUST_PREV"
(
    "LND_ORDERCUST_HKEY" VARCHAR(32)
   ,"ORDER_HKEY" VARCHAR(32)
   ,"CUSTOMER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"C_NAME_FK_OCUSTKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY_FK_OORDERKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY" NUMBER
   ,"O_CUSTKEY" NUMBER
   ,"C_NAME" VARCHAR(25)
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."ORDER_CUST_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."ORDER_PREV"
(
    "ORDER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"ORDER_BK" VARCHAR
   ,"O_ORDERKEY_BK" VARCHAR(1500)
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
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."ORDER_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_CUSTOMER"
(
    "CUSTOMER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"CUSTOMER_BK" VARCHAR
   ,"C_NAME_BK" VARCHAR(1500)
   ,"C_CUSTKEY" NUMBER
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_CUSTOMER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_CUSTOMER_CURR"
(
    "CUSTOMER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"CUSTOMER_BK" VARCHAR
   ,"C_NAME_BK" VARCHAR(1500)
   ,"C_CUSTKEY" NUMBER
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_CUSTOMER_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_CUSTOMER_PREV"
(
    "CUSTOMER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"CUSTOMER_BK" VARCHAR
   ,"C_NAME_BK" VARCHAR(1500)
   ,"C_CUSTKEY" NUMBER
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_CUSTOMER_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_LINEITEM"
(
    "LND_SF1_LINEITEM_HKEY" VARCHAR(32)
   ,"ORDER_HKEY" VARCHAR(32)
   ,"SUPPLIER_HKEY" VARCHAR(32)
   ,"PART_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"P_NAME_FK_LPARTKEY_BK" VARCHAR(750)
   ,"P_SIZE_FK_LPARTKEY_BK" VARCHAR(750)
   ,"S_NAME_FK_LSUPPKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY_FK_LORDERKEY_BK" VARCHAR(1500)
   ,"L_ORDERKEY" NUMBER
   ,"L_LINENUMBER" NUMBER
   ,"L_PARTKEY" NUMBER
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
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_LINEITEM" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_LINEITEM_CURR"
(
    "LND_SF1_LINEITEM_HKEY" VARCHAR(32)
   ,"ORDER_HKEY" VARCHAR(32)
   ,"SUPPLIER_HKEY" VARCHAR(32)
   ,"PART_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"P_NAME_FK_LPARTKEY_BK" VARCHAR(750)
   ,"P_SIZE_FK_LPARTKEY_BK" VARCHAR(750)
   ,"S_NAME_FK_LSUPPKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY_FK_LORDERKEY_BK" VARCHAR(1500)
   ,"L_ORDERKEY" NUMBER
   ,"L_LINENUMBER" NUMBER
   ,"L_PARTKEY" NUMBER
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
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_LINEITEM_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_LINEITEM_PREV"
(
    "LND_SF1_LINEITEM_HKEY" VARCHAR(32)
   ,"ORDER_HKEY" VARCHAR(32)
   ,"SUPPLIER_HKEY" VARCHAR(32)
   ,"PART_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"P_NAME_FK_LPARTKEY_BK" VARCHAR(750)
   ,"P_SIZE_FK_LPARTKEY_BK" VARCHAR(750)
   ,"S_NAME_FK_LSUPPKEY_BK" VARCHAR(1500)
   ,"O_ORDERKEY_FK_LORDERKEY_BK" VARCHAR(1500)
   ,"L_ORDERKEY" NUMBER
   ,"L_LINENUMBER" NUMBER
   ,"L_PARTKEY" NUMBER
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
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_LINEITEM_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_PART"
(
    "PART_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"PART_BK" VARCHAR
   ,"P_NAME_BK" VARCHAR(750)
   ,"P_SIZE_BK" VARCHAR(750)
   ,"P_PARTKEY" NUMBER
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_PART" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_PART_CURR"
(
    "PART_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"PART_BK" VARCHAR
   ,"P_NAME_BK" VARCHAR(750)
   ,"P_SIZE_BK" VARCHAR(750)
   ,"P_PARTKEY" NUMBER
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_PART_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_PART_PREV"
(
    "PART_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"PART_BK" VARCHAR
   ,"P_NAME_BK" VARCHAR(750)
   ,"P_SIZE_BK" VARCHAR(750)
   ,"P_PARTKEY" NUMBER
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_PART_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_PARTSUPP"
(
    "LND_SF1_PARTSUPP_HKEY" VARCHAR(32)
   ,"PART_HKEY" VARCHAR(32)
   ,"SUPPLIER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"P_NAME_FK_PSPARTKEY_BK" VARCHAR(750)
   ,"P_SIZE_FK_PSPARTKEY_BK" VARCHAR(750)
   ,"S_NAME_FK_PSSUPPKEY_BK" VARCHAR(1500)
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_PARTSUPP" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_PARTSUPP_CURR"
(
    "LND_SF1_PARTSUPP_HKEY" VARCHAR(32)
   ,"PART_HKEY" VARCHAR(32)
   ,"SUPPLIER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"P_NAME_FK_PSPARTKEY_BK" VARCHAR(750)
   ,"P_SIZE_FK_PSPARTKEY_BK" VARCHAR(750)
   ,"S_NAME_FK_PSSUPPKEY_BK" VARCHAR(1500)
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_PARTSUPP_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_PARTSUPP_PREV"
(
    "LND_SF1_PARTSUPP_HKEY" VARCHAR(32)
   ,"PART_HKEY" VARCHAR(32)
   ,"SUPPLIER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"P_NAME_FK_PSPARTKEY_BK" VARCHAR(750)
   ,"P_SIZE_FK_PSPARTKEY_BK" VARCHAR(750)
   ,"S_NAME_FK_PSSUPPKEY_BK" VARCHAR(1500)
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

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_PARTSUPP_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_SUPPLIER"
(
    "SUPPLIER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"SUPPLIER_BK" VARCHAR
   ,"S_NAME_BK" VARCHAR(1500)
   ,"S_SUPPKEY" NUMBER
   ,"S_NAME" VARCHAR(25)
   ,"S_ADDRESS" VARCHAR(40)
   ,"S_NATIONKEY" NUMBER
   ,"S_PHONE" VARCHAR(15)
   ,"S_ACCTBAL" NUMBER
   ,"S_COMMENT" VARCHAR(101)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_SUPPLIER" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_SUPPLIER_CURR"
(
    "SUPPLIER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"SUPPLIER_BK" VARCHAR
   ,"S_NAME_BK" VARCHAR(1500)
   ,"S_SUPPKEY" NUMBER
   ,"S_NAME" VARCHAR(25)
   ,"S_ADDRESS" VARCHAR(40)
   ,"S_NATIONKEY" NUMBER
   ,"S_PHONE" VARCHAR(15)
   ,"S_ACCTBAL" NUMBER
   ,"S_COMMENT" VARCHAR(101)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_SUPPLIER_CURR" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


CREATE   TABLE "VS_DEMO_TC_STG"."SF1_SUPPLIER_PREV"
(
    "SUPPLIER_HKEY" VARCHAR(32)
   ,"LOAD_DATE" TIMESTAMP_NTZ
   ,"SRC_BK" VARCHAR
   ,"LOAD_CYCLE_ID" INTEGER
   ,"JRN_FLAG" VARCHAR
   ,"RECORD_TYPE" VARCHAR
   ,"RECORD_SOURCE" VARCHAR
   ,"SUPPLIER_BK" VARCHAR
   ,"S_NAME_BK" VARCHAR(1500)
   ,"S_SUPPKEY" NUMBER
   ,"S_NAME" VARCHAR(25)
   ,"S_ADDRESS" VARCHAR(40)
   ,"S_NATIONKEY" NUMBER
   ,"S_PHONE" VARCHAR(15)
   ,"S_ACCTBAL" NUMBER
   ,"S_COMMENT" VARCHAR(101)
   ,"DSS_RECORD_SOURCE" VARCHAR(39)
)
;

COMMENT ON TABLE "VS_DEMO_TC_STG"."SF1_SUPPLIER_PREV" IS 'DV_NAME: DEMO_VS_TC - Release: concat all(13) - Comment: concat all - Release date: 2023/06/14 13:52:00';


-- END


