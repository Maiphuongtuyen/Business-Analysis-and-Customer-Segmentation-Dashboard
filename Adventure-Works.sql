/*Check if SalesOrderNumber has duplicate values*/
SELECT 
    SalesOrderNumber,
    COUNT(*) AS DuplicateCount
FROM FactInternetSales
GROUP BY 
    SalesOrderNumber
HAVING 
    COUNT(*) > 1

/*Check if SalesOrderNumber has null values*/
SELECT *
FROM FactInternetSales
WHERE 
    SalesOrderNumber IS NULL

/*check if this is the product cart detail for every transaction: in every unique SalesOrderNumber have no duplicate product id*/

SELECT TOP (1000) [SalesOrderNumber], [ProductKey], count (*) as duplicate_productid
FROM FactInternetSales
GROUP BY [SalesOrderNumber], [ProductKey]
  HAVING COUNT (*) >1

/*
- check if customerkey has the same key number as resellerkey
- remove employeekey column or create a new column named employeekey for internetsales table with all values set to = 'null'
*/

Select CustomerKey, ResellerKey
from FactInternetSales as I
join FactResellerSales as R
on I.OrderDateKey = R.OrderDateKey
where CustomerKey = ResellerKey

/*create new column and append 2 tables, but we have to make sure that these columns are
both align, and the number of columns between the 2 tables is equal
(these columns must be placed in the respective order)*/

SELECT [SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[ResellerKey]
      ,[ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[EmployeeKey]
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmount]
      ,[FreightAmount]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
      ,[RevisionNumber]
  FROM [Adv2020].[dbo].[FactResellerSales]
union 
SELECT [SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[CustomerKey] AS [ResellerKey]
      ,[ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
	  ,'' AS [EmployeeKey]
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmount]
      ,[FreightAmount]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
      ,[RevisionNumber]
  FROM [Adv2020].[dbo].[FactInternetSales]

/* besides, instead of 'null', if we want to label EmployeeKey as 'Unknown' or whatever it is as a string, we must convert the EmployeeKey 
in the FactResellerSales table into VARCHAR before setting the value, here is the code for that case: */

  
SELECT [SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[ResellerKey]
      ,[ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
    ,CAST([EmployeeKey] AS VARCHAR(50)) AS [EmployeeKey] -- Convert EmployeeKey to VARCHAR
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmount]
      ,[FreightAmount]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
      ,[RevisionNumber]
  FROM [Adv2020].[dbo].[FactResellerSales]
union 
SELECT [SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[CustomerKey] AS [ResellerKey]
      ,[ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
	  ,'Unknown' AS [EmployeeKey]
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmount]
      ,[FreightAmount]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
      ,[RevisionNumber]
  FROM [Adv2020].[dbo].[FactInternetSales]

/*Product Pair Frequently Bought Together*/

SELECT A.ProductKey, B.ProductKey, Count(*) as PurchaseFrequency
  FROM FactSales as A
  INNER JOIN   FactSales as B
  ON A.CustomerKey = B.CustomerKey
  AND A.SalesOrderNumber =  B.SalesOrderNumber 
  AND A.ProductKey < B.ProductKey
  GROUP BY A.ProductKey, B.ProductKey
  ORDER BY PurchaseFrequency DESC
