USE AdventureWorks2019; -- Change le nom de la base de données si nécessaire

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'Sales';

----------------------------------------------------------------------------------------------------
--wrangling creditcard
SELECT * 
FROM Sales.CreditCard;
-- donnees manquantes
SELECT * 
FROM Sales.CreditCard
WHERE [CreditCardID] IS NULL
OR [CardType] IS NULL
OR [CardNumber] IS NULL
--OR [ExpMonth] IS NULL
--OR [ExpYear] IS NULL
--OR [ModifiedDate] IS NULL

-- supprimer donnees manquantes
DELETE FROM Sales.CreditCard
WHERE [CreditCardID] IS NULL
OR [CardType] IS NULL
OR [CardNumber] IS NULL
OR [ExpMonth] IS NULL
OR [ExpYear] IS NULL
OR [ModifiedDate] IS NULL

-- Invalide rows
SELECT * FROM Sales.CreditCard
WHERE CardNumber = 'Invalid'

-- donnees doublantes
SELECT DISTINCT [CardType] From Sales.CreditCard

--requete si deux attribus sont similaire on fait une update pour remplacer l un par l autre pour eviter le double
UPDATE Sales.CreditCard
SET [CardType] = ''
WHERE [CardType] = ''

-- aussi si on a dans lignes des mots similaire ou d autre similarite comme on 'fishing' et dans d autre case 'fishing avec un mots'
--ou on a des case similaire mais le different c est des espaces ex 'N' ' N' alors on doit updater 
SELECT DISTINCT [ExpYear] From Sales.CreditCard 
WHERE [ExpYear] like '10'

UPDATE Sales.CreditCard
SET [CardType] = ''
WHERE [CardType] = ''




-----------------------------------------------------------------------------------------

SELECT * 
FROM Sales.CurrencyRate;

------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.Customer
WHERE [StoreID] IS NULL


------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.Currency;

------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.CountryRegionCurrency;



-------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.Store;

-------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SpecialOffer;

--------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SpecialOfferProduct;

--------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.ShoppingCartItem;

---------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vPersonDemographics;


---------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vIndividualCustomer;



---------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vStoreWithAddresses;




----------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vStoreWithDemographics;

----------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vStoreWithContacts;

------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vSalesPerson;

-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesTerritoryHistory;

----------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vSalesPersonSalesByFiscalYears;

------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesTaxRate;

-----------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.PersonCreditCard;

-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesTerritory;

-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderHeader;

SELECT 
    COUNT(*) AS TotalRecords,
    COUNT(OrderDate) AS RecordsWithOrderDate,
    COUNT(CustomerID) AS RecordsWithCustomerID,
    COUNT(ShipMethodID) AS RecordsWithShipMethod
FROM Sales.SalesOrderHeader;

SELECT 
    SalesOrderID, 
    COUNT(*) AS DuplicateCount 
FROM Sales.SalesOrderHeader 
GROUP BY SalesOrderID 
HAVING COUNT(*) > 1;

SELECT * 
FROM Sales.SalesOrderHeader 
WHERE OrderDate IS NULL OR OrderDate > GETDATE();

SELECT * 
FROM Sales.SalesOrderHeader 
WHERE SubTotal < 0 
   OR TaxAmt < 0 
   OR Freight < 0;

------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesReason;

------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesPersonQuotaHistory;

------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderDetail;

SELECT * 
FROM Sales.SalesOrderDetail 
WHERE OrderQty <= 0;

SELECT * 
FROM Sales.SalesOrderDetail 
WHERE [UnitPrice] < 0;

SELECT * 
FROM Sales.SalesOrderDetail 
WHERE [LineTotal] != [OrderQty] * [UnitPrice];

UPDATE Sales.SalesOrderDetail 
SET LineTotal = OrderQty * UnitPrice
WHERE LineTotal != OrderQty * UnitPrice;

-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderHeaderSalesReason;

--------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesPerson;

---------------------------------------------------------------------------------------------------------








