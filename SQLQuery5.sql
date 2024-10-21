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
-- donnees manquantes
SELECT * 
FROM Sales.vStoreWithContacts
WHERE [Suffix] IS NULL 
   OR [Title] IS NULL
   OR [FirstName] IS NULL 
   OR [LastName] IS NULL 
   OR [EmailAddress] IS NULL 
   OR [Suffix] IS NULL
   OR [EmailAddress] IS NULL
   OR [PhoneNumber] IS NULL;

UPDATE Sales.vStoreWithContacts
SET Suffix = 'Inconnue'
WHERE Suffix = 'N/A';
UPDATE Sales.vStoreWithContacts
SET MiddleName = 'Inconnue'
WHERE MiddleName IS NULL;
UPDATE Sales.vStoreWithContacts
SET Title = 'N/A'
WHERE Title IS NULL;

ALTER TABLE Sales.vStoreWithContacts
DROP COLUMN [Suffix];
-- donnees doublantes

SELECT 
    BusinessEntityID, 
    COUNT(*) AS DuplicateCount 
FROM Sales.vStoreWithContacts
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;

SELECT * 
FROM Sales.vStoreWithContacts
WHERE BusinessEntityID IN (
    SELECT BusinessEntityID
    FROM Sales.vStoreWithContacts
    GROUP BY BusinessEntityID
    HAVING COUNT(*) > 1
);
------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vSalesPerson;
-- donnees manquantes
SELECT *
FROM Sales.vSalesPerson
WHERE TerritoryName IS NULL
  AND TerritoryGroup IS NULL
  AND SalesQuota IS NULL;

-- UPDATE Sales.vSalesPerson
--SET [TerritoryName] = 'Default Territory',  -- Remplace par un territoire générique ou assigné
  --  [TerritoryGroup] = 'Default Group',
    --[SalesQuota] = '10000'  -- Ou une autre valeur par défaut
--WHERE [TerritoryName] IS NULL
 -- AND [TerritoryGroup] IS NULL
 --AND [SalesQuota] IS NULL;

SELECT 
    name AS ConstraintName, 
    definition 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('Sales.SalesPerson')
AND name = 'CK_SalesPerson_SalesQuota';
UPDATE Sales.vSalesPerson
SET [Suffix] = 'aucun'
WHERE [Suffix] IS NULL;

UPDATE Sales.vSalesPerson
SET [Title] = 'aucun'
WHERE [Title] IS NULL;

UPDATE Sales.vSalesPerson
SET [AddressLine2] = 'aucun'
WHERE [AddressLine2] IS NULL;

UPDATE Sales.vSalesPerson
SET [MiddleName] = 'aucun'
WHERE [MiddleName] IS NULL;
--donnees doublantes

SELECT EmailAddress, COUNT(*) AS DuplicateCount
FROM Sales.vSalesPerson
GROUP BY EmailAddress
HAVING COUNT(*) > 1;

SELECT PhoneNumber, COUNT(*) AS DuplicateCount
FROM Sales.vSalesPerson
GROUP BY PhoneNumber
HAVING COUNT(*) > 1;

SELECT BusinessEntityID, COUNT(*) AS DuplicateCount
FROM Sales.vSalesPerson
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;

--aucune donnees doublantes
--donnees incorrectes
SELECT *
FROM Sales.vSalesPerson
WHERE SalesQuota < 0
   OR SalesYTD < 0
   OR SalesLastYear < 0;

SELECT *
FROM Sales.vSalesPerson
WHERE FirstName = ''
   OR LastName = '';
 --aucune formats est incorrectes
-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesTerritoryHistory;

--cleaan

----------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vSalesPersonSalesByFiscalYears;
--donnees manquantes
SELECT *
FROM Sales.vSalesPersonSalesByFiscalYears
WHERE [FullName] IS NULL
   OR [2002] IS NULL
   OR [2003] IS NULL
   OR [2004] IS NULL;
--correction
UPDATE Sales.vSalesPersonSalesByFiscalYears
SET [2002] = '0'
WHERE [2002] IS NULL;--erreur a cause de vue
--creation d une table temporaire
CREATE TABLE #TempSalesPersonSalesByFiscalYears (
    SalesPersonID INT,
    FullName NVARCHAR(100),
    JobTitle NVARCHAR(100),
    SalesTerritory NVARCHAR(100),
    [2002] DECIMAL(18, 2),
    [2003] DECIMAL(18, 2),
    [2004] DECIMAL(18, 2)
);
-- Insérer les données de la vue dans la table temporaire
INSERT INTO #TempSalesPersonSalesByFiscalYears
SELECT * FROM vSalesPersonSalesByFiscalYears;



------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesTaxRate;



-----------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.PersonCreditCard;

SELECT BusinessEntityID, COUNT(CreditCardID) AS NumberOfCreditCards
FROM Sales.PersonCreditCard
GROUP BY BusinessEntityID;

--cleean

-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesTerritory;

--SELECT TerritoryID, SUM(SalesYTD) AS TotalSalesYTD
FROM Sales.SalesTerritory
GROUP BY TerritoryID;
-- comparaison des ventes annee par annee
SELECT TerritoryID, 
       SUM(SalesYTD) AS TotalSalesYTD, 
       SUM(SalesLastYear) AS TotalSalesLastYear
FROM Sales.SalesTerritory
GROUP BY TerritoryID;

-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderHeader;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SalesOrderHeader';

UPDATE Sales.SalesOrderHeader
SET Comment = 'No Comment'
WHERE Comment IS NULL;

SELECT *
FROM Sales.SalesOrderHeader
WHERE [SalesOrderID] IS NULL
OR [RevisionNumber] IS NULL
OR [OrderDate] IS NULL
OR [DueDate] IS NULL
OR [ShipDate] IS NULL
OR [Status] IS NULL
OR [OnlineOrderFlag] IS NULL
OR [SalesOrderNumber] IS NULL
OR [PurchaseOrderNumber] IS NULL
OR [AccountNumber] IS NULL
OR [CustomerID] IS NULL
OR [SalesPersonID] IS NULL
OR [TerritoryID] IS NULL
OR [BillToAddressID] IS NULL
OR [ShipToAddressID] IS NULL
OR [ShipMethodID] IS NULL
OR [CreditCardID] IS NULL
OR [CreditCardApprovalCode] IS NULL
OR [CurrencyRateID] IS NULL
OR [SubTotal] IS NULL;

UPDATE Sales.SalesOrderHeader
SET PurchaseOrderNumber = 'N/A'
WHERE PurchaseOrderNumber IS NULL;

UPDATE Sales.SalesOrderHeader
SET CreditCardID = '0',  
    CreditCardApprovalCode = 'N/A' 
WHERE CreditCardID IS NULL OR CreditCardApprovalCode IS NULL;

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

SELECT * 
FROM Sales.SalesReason
WHERE [ReasonType] IS NULL;


--cleaan

------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesPersonQuotaHistory;

--cleaan


------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderDetail;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SalesOrderDetail';

SELECT *
FROM Sales.SalesOrderDetail
WHERE CarrierTrackingNumber IS NULL;

UPDATE SAles.SalesOrderDetail
SET CarrierTrackingNumber = 'N/A'
WHERE CarrierTrackingNumber IS NULL;

--Total des Ventes par Commande
SELECT SalesOrderID, SUM(LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

--Quantité Totale Commandée par Produit
SELECT ProductID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

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

--cleean

--------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesPerson;

--cleean

---------------------------------------------------------------------------------------------------------








