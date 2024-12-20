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

-------
 ALTER TABLE Sales.Customer
DROP COLUMN CustomerAcquisitionCost;




 


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
 



UPDATE Sales.SpecialOffer
SET MaxQty = 
WHERE MaxQty IS NULL;

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
-- 1. Ajouter la colonne TotalRevenue dans la table SalesOrderHeader
ALTER TABLE Sales.SalesOrderHeader
ADD TotalRevenue DECIMAL(18, 2);

-- 2. Calculer et insérer le chiffre d'affaires total dans la colonne TotalRevenue
WITH TotalRevenueCalculation AS (
    SELECT 
        SalesOrderID,
        SUM(SubTotal) OVER () AS TotalRevenue -- Calcule la somme de SubTotal pour toutes les lignes
    FROM 
        Sales.SalesOrderHeader
)
UPDATE Sales.SalesOrderHeader
SET TotalRevenue = TotalRevenueCalculation.TotalRevenue
FROM TotalRevenueCalculation
WHERE Sales.SalesOrderHeader.SalesOrderID = TotalRevenueCalculation.SalesOrderID;

-- 3. Vérification des résultats
SELECT SalesOrderID, SubTotal, TotalRevenue
FROM Sales.SalesOrderHeader;

------
-- Ajouter une nouvelle colonne 'TotalOrders' dans la table SalesOrderHeader
ALTER TABLE Sales.SalesOrderHeader
ADD TotalOrders INT;
-- Calculer le nombre total de commandes et mettre à jour la colonne TotalOrders
WITH OrderCount AS (
    SELECT COUNT(SalesOrderID) AS TotalOrders
    FROM Sales.SalesOrderHeader
)
UPDATE Sales.SalesOrderHeader
SET TotalOrders = (SELECT TotalOrders FROM OrderCount);

----
-- Ajouter une nouvelle colonne 'AverageOrderValue' dans la table SalesOrderHeader
ALTER TABLE Sales.SalesOrderHeader
ADD AverageOrderValue DECIMAL(18, 2);
-- Calculer la valeur moyenne d'une commande et mettre à jour la colonne AverageOrderValue
WITH AverageOrderCalculation AS (
    SELECT 
        SUM(SubTotal) / COUNT(SalesOrderID) AS AverageOrderValue -- Calcul de la moyenne
    FROM 
        Sales.SalesOrderHeader
)
UPDATE Sales.SalesOrderHeader
SET AverageOrderValue = (SELECT AverageOrderValue FROM AverageOrderCalculation);
-----
-- Ajouter une nouvelle colonne 'SalesGrowthPercentage' dans la table SalesOrderHeader
ALTER TABLE Sales.SalesOrderHeader
ADD SalesGrowthPercentage DECIMAL(18, 2);
-- 1. Ajouter une colonne pour stocker la croissance des ventes
ALTER TABLE Sales.SalesOrderHeader
ADD SalesGrowthPercentage DECIMAL(18, 2);

-- 2. Calcul de la croissance des ventes par mois et mise à jour de la colonne
WITH SalesPeriod AS (
    SELECT 
        YEAR(OrderDate) AS OrderYear,  
        MONTH(OrderDate) AS OrderMonth,  
        SUM(SubTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
SalesGrowthCalculation AS (
    SELECT 
        sp1.OrderYear,
        sp1.OrderMonth,
        sp1.SalesAmount AS CurrentPeriodSales,
        COALESCE(sp2.SalesAmount, 0) AS PreviousPeriodSales,
        CASE 
            WHEN COALESCE(sp2.SalesAmount, 0) = 0 THEN NULL  -- Eviter la division par zéro
            ELSE (sp1.SalesAmount - sp2.SalesAmount) / sp2.SalesAmount * 100
        END AS SalesGrowthPercentage
    FROM SalesPeriod sp1
    LEFT JOIN SalesPeriod sp2 
        ON sp1.OrderYear = sp2.OrderYear 
        AND sp1.OrderMonth = sp2.OrderMonth + 1  -- Mois précédent
)
UPDATE Sales.SalesOrderHeader
SET SalesGrowthPercentage = (
    SELECT SalesGrowthPercentage
    FROM SalesGrowthCalculation
    WHERE Sales.SalesOrderHeader.OrderDate >= DATEFROMPARTS(SalesGrowthCalculation.OrderYear, SalesGrowthCalculation.OrderMonth, 1)
    AND Sales.SalesOrderHeader.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(SalesGrowthCalculation.OrderYear, SalesGrowthCalculation.OrderMonth, 1))
);
--------
ALTER TABLE Sales.SalesOrderHeader
ADD ActiveCustomers INT;
WITH ActiveCustomersCalculation AS (
    SELECT DISTINCT CustomerID
    FROM Sales.SalesOrderHeader
    WHERE OrderDate >= DATEADD(MONTH, -12, GETDATE())  -- Clients ayant passé une commande dans les 12 derniers mois
)
UPDATE Sales.SalesOrderHeader
SET ActiveCustomers = (
    SELECT COUNT(*) FROM ActiveCustomersCalculation WHERE Sales.SalesOrderHeader.CustomerID = ActiveCustomersCalculation.CustomerID
);

-----
ALTER TABLE Sales.SalesOrderHeader
ADD NumberOfOrders INT;

WITH CustomerOrders AS (
    SELECT 
        CustomerID, 
        COUNT(SalesOrderID) AS NumberOfOrders
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
        CustomerID
)
UPDATE Sales.SalesOrderHeader
SET NumberOfOrders = CustomerOrders.NumberOfOrders
FROM CustomerOrders
WHERE Sales.SalesOrderHeader.CustomerID = CustomerOrders.CustomerID;

 -----
 ALTER TABLE Sales.SalesOrderHeader
DROP COLUMN ActiveCustomers;
------
ALTER TABLE Sales.SalesOrderHeader
ADD CustomerLifetimeValue DECIMAL(18, 2);

WITH CLV_Calculation AS (
    SELECT 
        CustomerID,
        SUM(TotalDue) AS CustomerLifetimeValue
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
        CustomerID
)
UPDATE Sales.SalesOrderHeader
SET CustomerLifetimeValue = CLV_Calculation.CustomerLifetimeValue
FROM CLV_Calculation
WHERE Sales.SalesOrderHeader.CustomerID = CLV_Calculation.CustomerID;
-----------------------
 -- 1. Ajouter une colonne Taux de fidélité client dans la table SalesOrderHeader
ALTER TABLE Sales.SalesOrderHeader
ADD CustomerLoyaltyRate DECIMAL(5, 2);
 -- Calculer et mettre à jour le taux de fidélité pour chaque client
WITH CustomerOrders AS (
    SELECT 
        CustomerID, 
        COUNT(SalesOrderID) AS NumberOfOrders  -- Nombre de commandes pour chaque client
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
        CustomerID
),
TotalCustomers AS (
    SELECT COUNT(DISTINCT CustomerID) AS TotalClients  -- Nombre total de clients
    FROM Sales.SalesOrderHeader
)
UPDATE Sales.SalesOrderHeader
SET CustomerLoyaltyRate = (
    SELECT 
        (CustomerOrders.NumberOfOrders * 1.0 / TotalCustomers.TotalClients) * 100  -- Calcul du taux de fidélité pour chaque client
    FROM 
        CustomerOrders, TotalCustomers
    WHERE Sales.SalesOrderHeader.CustomerID = CustomerOrders.CustomerID
);



 


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

--------
ALTER TABLE Sales.SalesOrderDetail
ADD SalesMarginPercentage DECIMAL(5, 2);  -- La colonne pour le taux de marge, avec deux décimales
WITH CostAndRevenue AS (
    SELECT 
        sod.SalesOrderDetailID, 
        sod.LineTotal AS Revenue, 
        p.StandardCost AS Cost
    FROM 
        Sales.SalesOrderDetail sod
    INNER JOIN 
        Production.Product p
    ON 
        sod.ProductID = p.ProductID
)
UPDATE sod
SET sod.SalesMarginPercentage = 
    ( (car.Revenue - car.Cost) / car.Revenue ) * 100  -- Calcul du pourcentage de marge
FROM 
    Sales.SalesOrderDetail sod
INNER JOIN 
    CostAndRevenue car
ON 
    sod.SalesOrderDetailID = car.SalesOrderDetailID;


-------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesOrderHeaderSalesReason;

--cleean

--------------------------------------------------------------------------------------------------------
SELECT * 
FROM Sales.SalesPerson;

--cleean

---------------------------------------------------------------------------------------------------------








