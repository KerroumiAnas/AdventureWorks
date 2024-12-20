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
OR [ExpMonth] IS NULL
OR [ExpYear] IS NULL
OR [ModifiedDate] IS NULL

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

SELECT * 
FROM Sales.CurrencyRate
WHERE [CurrencyRateID] IS NULL
OR [CurrencyRateDate] IS NULL
OR [FromCurrencyCode] IS NULL
OR [ToCurrencyCode] IS NULL
OR [AverageRate] IS NULL
OR [EndOfDayRate] IS NULL
OR [ModifiedDate] IS NULL

-- supprimer donnees manquantes
DELETE FROM Sales.CurrencyRate
WHERE [CurrencyRateID] IS NULL
OR [CurrencyRateDate] IS NULL
OR [FromCurrencyCode] IS NULL
OR [ToCurrencyCode] IS NULL
OR [AverageRate] IS NULL
OR [EndOfDayRate] IS NULL
OR [ModifiedDate] IS NULL

--Pour identifier les doublons
SELECT CurrencyRateDate, FromCurrencyCode, ToCurrencyCode, AverageRate, EndOfDayRate, ModifiedDate, COUNT(*)
FROM Sales.CurrencyRate
GROUP BY CurrencyRateDate, FromCurrencyCode, ToCurrencyCode, AverageRate, EndOfDayRate, ModifiedDate
HAVING COUNT(*) > 1;
--Pour vérifier la longueur des codes des devises (ils devraient être de 3 caractères)
SELECT *
FROM Sales.CurrencyRate
WHERE LEN(FromCurrencyCode) <> 3
   OR LEN(ToCurrencyCode) <> 3;
--Pour identifier les taux qui ne sont pas des valeurs positives (anomalie sur AverageRate ou EndOfDayRate
SELECT *
FROM Sales.CurrencyRate
WHERE AverageRate <= 0
   OR EndOfDayRate <= 0;
--Pour identifier les dates incorrectes ou absurdes (par exemple, des dates futures pour CurrencyRateDate ou ModifiedDate)
SELECT *
FROM Sales.CurrencyRate
WHERE CurrencyRateDate > GETDATE()
   OR ModifiedDate > GETDATE();



------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.Customer
SELECT *
FROM Sales.Customer
WHERE CustomerID IS NULL
   OR PersonID IS NULL
   OR StoreID IS NULL
   OR TerritoryID IS NULL
   OR AccountNumber IS NULL
   OR rowguid IS NULL
   OR ModifiedDate IS NULL;

 -- 1. Mettre à jour les valeurs NULL dans StoreID uniquement si elles existent dans Sales.Store
UPDATE Sales.Customer
SET StoreID = COALESCE(StoreID, 
                       (SELECT TOP 1 BusinessEntityID FROM Sales.Store))  -- Remplace NULL par une valeur valide de StoreID
WHERE StoreID IS NULL;

-- 2. Mettre à jour les autres colonnes pour corriger les valeurs NULL
UPDATE Sales.Customer
SET PersonID = COALESCE(PersonID, -1),  -- Remplace NULL par -1 (ou une autre valeur par défaut)
    TerritoryID = COALESCE(TerritoryID, -1), -- Remplace NULL par -1 (ou une autre valeur par défaut)
    rowguid = COALESCE(rowguid, NEWID()), -- Remplace NULL par un nouvel identifiant unique (UUID)
    ModifiedDate = COALESCE(ModifiedDate, GETDATE()) -- Remplace NULL par la date actuelle
WHERE PersonID IS NULL
   OR TerritoryID IS NULL
   OR rowguid IS NULL
   OR ModifiedDate IS NULL;


 --Pour identifier les doublons dans le tableau
 SELECT PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate, COUNT(*)
FROM Sales.Customer
GROUP BY PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate
HAVING COUNT(*) > 1;
--Vérification du format ou de la longueur de AccountNumber 
SELECT *
FROM Sales.Customer
WHERE LEN(AccountNumber) <> 10;
--Vérification du format de rowguid (qui doit être un identifiant UUID) :
SELECT *
FROM Sales.Customer
WHERE TRY_CONVERT(uniqueidentifier, rowguid) IS NULL;
--Vérification des dates incorrectes dans ModifiedDate
SELECT *
FROM Sales.Customer
WHERE ModifiedDate > GETDATE();


 


------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.Currency;
SELECT 
     Name, 
    COUNT(*) AS DuplicateCount 
FROM  Sales.Currency
GROUP BY  Name
HAVING COUNT(*) > 1;

--CLEAN
------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.CountryRegionCurrency;
SELECT 
    CountryRegionCode , 
    COUNT(*) AS DuplicateCount 
FROM  Sales.CountryRegionCurrency
GROUP BY  CountryRegionCode
HAVING COUNT(*) > 1;

SELECT 
    CurrencyCode , 
    COUNT(*) AS DuplicateCount2
FROM  Sales.CountryRegionCurrency
GROUP BY  CurrencyCode
HAVING COUNT(*) > 1;

-------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.Store;
SELECT 
     BusinessEntityID, 
    COUNT(*) AS DuplicateCount
FROM  Sales.Store
GROUP BY   BusinessEntityID
HAVING COUNT(*) > 1;

 
SELECT 
     SalesPersonID, 
    COUNT(*) AS DuplicateCount2
FROM  Sales.Store
GROUP BY   SalesPersonID
HAVING COUNT(*) > 1;
--!!!
-------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SpecialOffer;
 



--UPDATE Sales.SpecialOffer
--SET MaxQty = 
--WHERE MaxQty IS NULL;

--?????
--------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SpecialOfferProduct;
SELECT 
     SpecialOfferID, 
    COUNT(*) AS DuplicateCount
FROM  Sales.SpecialOfferProduct
GROUP BY SpecialOfferID
HAVING COUNT(*) > 1;
SELECT 
     ProductID, 
    COUNT(*) AS DuplicateCount2
FROM  Sales.SpecialOfferProduct
GROUP BY ProductID
HAVING COUNT(*) > 1;
--------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.ShoppingCartItem;
--clean
---------------------------------------------------------------------------------------------
 

---------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vIndividualCustomer;

--clean

---------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.vStoreWithAddresses;
SELECT 
     BusinessEntityID, 
    COUNT(*) AS DuplicateCount
FROM  Sales.vStoreWithAddresses
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;
 SELECT 
     Name, 
    COUNT(*) AS DuplicateCount
FROM  Sales.vStoreWithAddresses
GROUP BY Name
HAVING COUNT(*) > 1;
SELECT 
     CountryRegionName, 
    COUNT(*) AS DuplicateCount
FROM  Sales.vStoreWithAddresses
GROUP BY CountryRegionName
HAVING COUNT(*) > 1;
UPDATE Sales.vStoreWithAddresses
SET AddressLine2 = 'Inconnue'
WHERE AddressLine2 IS NULL;



----------------------------------------------------------------------------------------------
SELECT 
    COALESCE(DateFirstPurchase, 'aucun') AS DateFirstPurchase
   -- COALESCE(BirthDate, 'aucun') AS BirthDate,
   -- COALESCE(MaritalStatus, 'aucun') AS MaritalStatus,
   -- COALESCE(YearlyIncome, 'aucun') AS YearlyIncome
    -- ajouter les autres colonnes si nécessaire
FROM Sales.vPersonDemographics;

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
SELECT * FROM sales.vSalesPersonSalesByFiscalYears;



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
SELECT*FROM Sales.SalesTerritory
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
WHERE [ReasonType] IS NULL
OR [Name] IS NULL;


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
SELECT * 
FROM Sales.SalesOrderDetail;

SELECT * 
FROM Sales.SalesOrderDetail 
WHERE ProductID IS NULL OR OrderQty IS NULL OR LineTotal IS NULL;

-- quantite et somme des produits les plus vemdus

SELECT 
    ProductID, 
    SUM(OrderQty) AS TotalQuantitySold,
    SUM(LineTotal) AS TotalRevenue
FROM sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY TotalRevenue DESC;

-- l ajout des colones "TotalQuantitySold" et " TotalRevenue"
ALTER TABLE Sales.SalesOrderDetail
ADD TotalQuantitySold INT DEFAULT 0, -- Quantité totale vendue (entier)
    TotalRevenue DECIMAL(18, 2) DEFAULT 0; -- Revenu total (décimal)

UPDATE sod
SET 
    sod.TotalQuantitySold = (
        SELECT SUM(OrderQty)
        FROM sales.SalesOrderDetail
        WHERE ProductID = sod.ProductID
    ),
    sod.TotalRevenue = (
        SELECT SUM(LineTotal)
        FROM sales.SalesOrderDetail
        WHERE ProductID = sod.ProductID
    )
FROM sales.SalesOrderDetail sod;

--------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderHeader;

SELECT * 
FROM Sales.SalesPerson;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'  -- Le schéma de la table
  AND TABLE_NAME = 'SalesPerson';  -- Le nom de la table

  SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'  -- Le schéma de la table
  AND TABLE_NAME = 'SalesOrderHeader';  -- Le nom de la table


  SELECT 
    soh.SalesPersonID,                    -- Identifiant du commercial
    COUNT(soh.SalesOrderID) AS NumberOfSales   -- Nombre de ventes pour chaque commercial
FROM 
    sales.SalesOrderHeader soh
            -- Vous pouvez ajouter une condition pour ne considérer que les commandes confirmées
GROUP BY 
    soh.SalesPersonID                    -- Grouper les résultats par commercial (SalesPersonID)
ORDER BY 
    NumberOfSales DESC; 

CREATE VIEW Sales.SalesPersonKPIs AS
SELECT 
    soh.SalesPersonID,                                        -- Identifiant du commercial
    COUNT(soh.SalesOrderID) AS NumberOfSales,                   -- Nombre de ventes par commercial
    SUM(soh.TotalDue) AS RevenueGenerated                       -- Revenu généré par commercial (TotalDue correspond au montant total dû)
FROM 
    sales.SalesOrderHeader soh
                                 -- Filtrer sur les commandes confirmées (à ajuster si nécessaire)
GROUP BY 
    soh.SalesPersonID;

SELECT * FROM sales.SalesPersonKPIs;

  -----------------------------------------------------------------------------
  --territory

  SELECT * FROM Sales.SalesTerritory;
--  les revenus actuels par territoire
  SELECT 
    Name AS TerritoryName,
    SalesYTD AS CurrentYearRevenue
FROM 
    Sales.SalesTerritory
ORDER BY 
    CurrentYearRevenue DESC;
	-- la croissance des ventes (Année sur Année)
SELECT 
    Name AS TerritoryName,
    SalesYTD,
    SalesLastYear,
    ((SalesYTD - SalesLastYear) * 100.0 / SalesLastYear) AS GrowthRate
FROM 
    Sales.SalesTerritory
WHERE 
    SalesLastYear > 0 -- Éviter les divisions par zéro
ORDER BY 
    GrowthRate DESC;

-- la contribution au revenu total par territoire
SELECT 
    Name AS TerritoryName,
    SalesYTD,
    (SalesYTD * 100.0 / SUM(SalesYTD) OVER ()) AS RevenueContributionPercentage
FROM 
    Sales.SalesTerritory
ORDER BY 
    RevenueContributionPercentage DESC;

-- ajout de deux colones GrowthRate ; RevenueContributionPercentage
ALTER TABLE Sales.SalesTerritory
ADD 
    GrowthRate DECIMAL(18, 2),  -- Croissance des Ventes (Année sur Année)
    RevenueContributionPercentage DECIMAL(18, 2);  -- Contribution au Revenu Total par Territoire

-- attribue le resultat de la colone GrowthRate
	UPDATE Sales.SalesTerritory
SET 
    GrowthRate = ((SalesYTD - SalesLastYear) * 100.0 / NULLIF(SalesLastYear, 0))
WHERE 
    SalesLastYear > 0;

	-- attribue le resultat de la colone RevenueContributionPercentage 
WITH TotalSales AS (
    SELECT SUM(SalesYTD) AS TotalSalesYTD
    FROM Sales.SalesTerritory
)
UPDATE Sales.SalesTerritory
SET 
    RevenueContributionPercentage = (SalesYTD * 100.0 / (SELECT TotalSalesYTD FROM TotalSales))
WHERE 
    SalesYTD > 0;

SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;



SELECT
    pc.Name AS CategoryName,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalSales
FROM
    Sales.SalesOrderDetail sod
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductCategory pc ON p.ProductSubcategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name;
-------Marge bénéficiaire par catégorie
SELECT
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty) AS Profit
FROM
    Sales.SalesOrderDetail sod
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductCategory pc ON p.ProductSubcategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name;

------ Croissance des ventes par catégorie
SELECT
    pc.Name AS CategoryName,
    SUM(CASE WHEN MONTH(soh.OrderDate) = 1 THEN sod.LineTotal ELSE 0 END) AS SalesJanuary,
    SUM(CASE WHEN MONTH(soh.OrderDate) = 2 THEN sod.LineTotal ELSE 0 END) AS SalesFebruary,
    (SUM(CASE WHEN MONTH(soh.OrderDate) = 2 THEN sod.LineTotal ELSE 0 END) - 
     SUM(CASE WHEN MONTH(soh.OrderDate) = 1 THEN sod.LineTotal ELSE 0 END)) / 
     NULLIF(SUM(CASE WHEN MONTH(soh.OrderDate) = 1 THEN sod.LineTotal ELSE 0 END), 0) * 100 AS GrowthPercentage
FROM
    Sales.SalesOrderDetail sod
JOIN
    Production.Product p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductCategory pc ON p.ProductSubcategoryID = pc.ProductCategoryID
JOIN
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY
    pc.Name;
  
CREATE TABLE Sales.SalesCategoryKPIs (
    CategoryName NVARCHAR(100),
    TotalQuantitySold INT,
    TotalSales DECIMAL(18, 2),
    Profit DECIMAL(18, 2),
    SalesJanuary DECIMAL(18, 2),
    SalesFebruary DECIMAL(18, 2),
    GrowthPercentage DECIMAL(10, 2)
);
 -- Étape 2 : Insérer les données
INSERT INTO Sales.SalesCategoryKPIs (CategoryName, TotalQuantitySold, TotalSales, Profit, SalesJanuary, SalesFebruary, GrowthPercentage)
SELECT 
    TotalSalesQuery.CategoryName,
    TotalSalesQuery.TotalQuantitySold,
    TotalSalesQuery.TotalSales,
    ProfitQuery.Profit,
    SalesGrowthQuery.SalesJanuary,
    SalesGrowthQuery.SalesFebruary,
    SalesGrowthQuery.GrowthPercentage
FROM 
    (
        -- Sous-requête pour Total Sales et Quantity Sold
        SELECT 
            pc.Name AS CategoryName,
            SUM(sod.OrderQty) AS TotalQuantitySold,
            SUM(sod.LineTotal) AS TotalSales
        FROM 
            Sales.SalesOrderDetail sod
        JOIN 
            Production.Product p ON sod.ProductID = p.ProductID
        JOIN 
            Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN 
            Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        GROUP BY 
            pc.Name
    ) AS TotalSalesQuery
JOIN 
    (
        -- Sous-requête pour Profit
        SELECT 
            pc.Name AS CategoryName,
            SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty) AS Profit
        FROM 
            Sales.SalesOrderDetail sod
        JOIN 
            Production.Product p ON sod.ProductID = p.ProductID
        JOIN 
            Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN 
            Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        GROUP BY 
            pc.Name
    ) AS ProfitQuery 
ON TotalSalesQuery.CategoryName = ProfitQuery.CategoryName
JOIN 
    (
        -- Sous-requête pour Sales Growth
        SELECT 
            pc.Name AS CategoryName,
            SUM(CASE WHEN MONTH(soh.OrderDate) = 1 THEN sod.LineTotal ELSE 0 END) AS SalesJanuary,
            SUM(CASE WHEN MONTH(soh.OrderDate) = 2 THEN sod.LineTotal ELSE 0 END) AS SalesFebruary,
            (SUM(CASE WHEN MONTH(soh.OrderDate) = 2 THEN sod.LineTotal ELSE 0 END) - 
             SUM(CASE WHEN MONTH(soh.OrderDate) = 1 THEN sod.LineTotal ELSE 0 END)) / 
             NULLIF(SUM(CASE WHEN MONTH(soh.OrderDate) = 1 THEN sod.LineTotal ELSE 0 END), 0) * 100 AS GrowthPercentage
        FROM 
            Sales.SalesOrderDetail sod
        JOIN 
            Production.Product p ON sod.ProductID = p.ProductID
        JOIN 
            Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN 
            Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        JOIN 
            Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
        GROUP BY 
            pc.Name
    ) AS SalesGrowthQuery
ON TotalSalesQuery.CategoryName = SalesGrowthQuery.CategoryName;
SELECT * 
FROM Sales.SalesCategoryKPIs;



CREATE VIEW v_ProductProfitability AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalRevenue,
    SUM(sod.OrderQty * p.StandardCost) AS TotalCost,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost))  AS Profitability
FROM 
    sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.Name;

SELECT * 
FROM  Sales.SalesPerson   


 CREATE VIEW Sales.Top10Products AS

SELECT TOP 10 

    p.ProductID,

    p.Name AS ProductName,

    SUM(sod.OrderQty) AS TotalQuantitySold,

    SUM(sod.LineTotal) AS TotalRevenue

FROM 

    sales.SalesOrderDetail sod

INNER JOIN 

    production.Product p ON sod.ProductID = p.ProductID

GROUP BY 

    p.ProductID, p.Name

ORDER BY 

    TotalQuantitySold DESC;

SELECT * 
FROM  ProductProfitability

CREATE VIEW ProductProfitability AS
WITH ProductProfit AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        ps.Name AS SubcategoryName,
        pc.Name AS CategoryName,
        SUM(sod.LineTotal) AS TotalRevenue,
        SUM(p.StandardCost * sod.OrderQty) AS TotalCost,
        (SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty)) AS TotalProfit,
        ((SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty)) / SUM(sod.LineTotal)) * 100 AS ProfitabilityPercentage
    FROM
        Sales.SalesOrderDetail sod
    INNER JOIN
        Production.Product p ON sod.ProductID = p.ProductID
    LEFT JOIN
        Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    LEFT JOIN
        Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY
        p.ProductID, p.Name, ps.Name, pc.Name
)
SELECT
    ProductName,
    SubcategoryName,
    CategoryName,
    SUM(TotalRevenue) AS TotalRevenue,
    SUM(TotalCost) AS TotalCost,
    SUM(TotalProfit) AS TotalProfit,
    AVG(ProfitabilityPercentage) AS AvgProfitabilityPercentage
FROM
    ProductProfit
GROUP BY
    CategoryName, SubcategoryName, ProductName;