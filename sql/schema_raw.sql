DROP TABLE IF EXISTS raw_online_retail;

CREATE TABLE raw_online_retail (
  invoiceno    TEXT,
  stockcode    TEXT,
  description  TEXT,
  quantity     TEXT,
  invoicedate  TEXT,
  unitprice    TEXT,
  customerid   TEXT,
  country      TEXT
);
