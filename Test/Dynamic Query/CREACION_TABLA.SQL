-- VER SI EXISTEN LAS TABLAS
IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL
    DROP TABLE dbo.Orders;

-- CREAR TABLAS
CREATE TABLE dbo.Orders
(
    OrderId INT IDENTITY(1, 1)
  CONSTRAINT PK_Orders_OrderID PRIMARY KEY (OrderId),
    CustomerId INT,
    Product VARCHAR(50),
    Amount DECIMAL(6, 2)
);

-- SETEAR VARIABLES
DECLARE 
    @Customers INT = 1000,
    @Products INT = 8;

WITH 
L0 AS (SELECT 1 AS N UNION ALL SELECT 1),
L1 AS (SELECT 1 AS N FROM L0 AS A CROSS JOIN L0 AS B),
L2 AS (SELECT 1 AS N FROM L1 AS A CROSS JOIN L1 AS B),
L3 AS (SELECT 1 AS N FROM L2 AS A CROSS JOIN L2 AS B),
L4 AS (SELECT 1 AS N FROM L3 AS A CROSS JOIN L3 AS B)

INSERT INTO dbo.Orders (CustomerId, Product, Amount)
SELECT
 CustomerId,
    CASE ProductID
        WHEN 1 THEN 'Monitor'
        WHEN 2 THEN 'Laptop'
        WHEN 3 THEN 'PC'
        WHEN 4 THEN 'Tablet'
        WHEN 5 THEN 'Mobile Phone'
        WHEN 6 THEN 'Printer'
        WHEN 7 THEN 'Scanner'
        WHEN 8 THEN 'Headset'
    END AS Product,
 Amount
FROM
(
    SELECT
    CustomerId,
    CEILING(ROW_NUMBER() OVER(PARTITION BY CustomerId ORDER BY (SELECT NULL)) / 9.00) AS ProductId,
    Amount
    FROM
    (
    SELECT
    NTILE(@Customers) OVER(ORDER BY (SELECT NULL)) AS CustomerId,
    CAST(ABS(CHECKSUM(NEWID())) / 1000000.00 AS DECIMAL(6, 2)) AS Amount
    FROM L4
    ) AS D
) AS D2;

SELECT
    *
FROM dbo.Orders;