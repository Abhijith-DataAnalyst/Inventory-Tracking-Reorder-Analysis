use salesdata;

select * from `inventory-tracking`;

show tables;

select * from `inventory-tracking` limit 20;

select sum(ProductID is null)as null_ProductID,
sum(ProductName is null)as null_ProductName,
sum(QuantityInStock is null)as null_QuantityInStock,
sum(ReorderPoint is null)as null_ReorderPoint,
sum(Supplier is null)as null_Supplier ,
sum(SupplierContact is null)as null_SupplierContac,
sum(LeadTime is null)as null_LeadTime,
sum(StorageLocation is null)as null_StorageLocation,
sum(UnitCost is null)as null_UnitCost
from `inventory-tracking`;                                     -- finding null values

alter table `inventory-tracking` change column ï»¿ProductID ProductID varchar(100);   -- change the productid column name

select distinct (ProductName) from `inventory-tracking` ;   -- finding unique ProductName
select distinct ProductID from `inventory-tracking` ;       -- finding unique ProductID

select ProductName ,
Supplier,
count(*) as count ,
group_concat(ProductID order by ProductID) as product_ids
from `inventory-tracking`
group by ProductName,Supplier having count > 1;

select * from `inventory-tracking`
where ProductName='Monitor'
and Supplier='Global Parts';

select  ProductID, ProductName ,
count(*) as count 
from `inventory-tracking`
group by ProductID,ProductName having count > 1;

select * from `inventory-tracking`         -- finding duplicates
where (ProductID,ProductName) in
 (
 select  ProductID, ProductName 
from `inventory-tracking`
group by ProductID,ProductName having count(*) > 1
)
order by ProductID,ProductName;

update `inventory-tracking`
set ProductName = concat(upper(left(trim(ProductName),1)),     -- trim spaces and proper cases(First letter capital)
lower(substring(trim(ProductName),2))
);


update `inventory-tracking`
set ProductID = upper (regexp_replace(trim(ProductID),          -- remove spaces , strange characters and uppercases
 '[^0-9A-Za-z]', ''));

update `inventory-tracking`
set ProductID = trim(ProductID);

select * from `inventory-tracking`
where QuantityInStock < 0
or ReorderPoint < 0
or LeadTime < 0
or UnitCost < 0;        -- finding obvious bad numeric values


update `inventory-tracking`
set SupplierContact =  lower(trim(SupplierContact));        -- supplier contact trim and lowercase(emails)


update `inventory-tracking`
set StorageLocation =  upper(trim(StorageLocation));        -- storage location trim and uppercase


update  `inventory-tracking`
set QuantityInStock = trim(QuantityInStock),                -- Remove leading and trailing
 ReorderPoint = trim(ReorderPoint),
 LeadTime = trim(LeadTime),
 UnitCost = trim(UnitCost);

select * from `inventory-tracking`
limit  20 ;

select * from `inventory-tracking`;

-- Business Analysis
select * from `inventory-tracking`            -- Find product that need immediate reorder
where QuantityInStock <= ReorderPoint
order by QuantityInStock;

Select                                        -- Finding which item hold more money
ProductID,
ProductName,
Supplier,
QuantityInStock,
UnitCost,
QuantityInStock*UnitCost AS 
InventoryValue from `inventory-tracking` 
ORDER BY  InventoryValue DESC;

SELECT Supplier ,                                          -- Finding totalinventory value and which supplier have longer avg Leadtime
COUNT(*) AS NumberOfProducts,
SUM(QuantityInStock * UnitCost) AS TotalInventorValue,
AVG(leadTime) AS AvgLeadTimeDays
FROM `inventory-tracking` 
GROUP BY Supplier
ORDER BY TotalInventorValue DESC;

SELECT SUM(QuantityInStock) AS total_units,                      -- Find Total unit and Total value
SUM(QuantityInStock * UnitCost) AS total_value
FROM `inventory-tracking`;


SELECT ProductName,
 SUM(QuantityInStock) AS total_units,                      -- Find Total unit and value by Product
SUM(QuantityInStock * UnitCost) AS total_value
FROM `inventory-tracking`
GROUP BY ProductName
ORDER BY total_value DESC;

SELECT Supplier,
 SUM(QuantityInStock) AS total_units,                      -- Find Total unit and value by Supplier
SUM(QuantityInStock * UnitCost) AS total_value
FROM `inventory-tracking`
GROUP BY Supplier
ORDER BY total_value DESC;

Select                                        -- This shows individual low inventoryvalue items and storage location
ProductID,
ProductName,
StorageLocation,
QuantityInStock,
UnitCost,
QuantityInStock*UnitCost AS 
InventoryValue from `inventory-tracking` 
WHERE QuantityInStock*UnitCost < 1000
ORDER BY  StorageLocation,InventoryValue ASC ;

Select                                        -- Finding highest priority to reorder
ProductID,
ProductName,
QuantityInStock,
ReorderPoint,
UnitCost,
QuantityInStock*UnitCost AS 
InventoryValue,Supplier,StorageLocation from `inventory-tracking` 
WHERE QuantityInStock <= ReorderPoint
ORDER BY  InventoryValue DESC;

select                                        -- Finding highest priority to reorder
ProductID,
ProductName,
QuantityInStock,
ReorderPoint,
UnitCost,
QuantityInStock*UnitCost AS 
InventoryValue,Supplier,StorageLocation from `inventory-tracking` 
WHERE QuantityInStock <= ReorderPoint
OR QuantityInStock >= ReorderPoint * 2
ORDER BY  InventoryValue DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------
-- "-:CONCLUSION:-"
-- The products like Desk,chair,Monitor,Tablet have low stock compared to reorderponit
-- very high inventory values
-- in case sku go out of the stock ,the business will lose sales and disappoint customers
-- The business is exposed to stockout risk on small number of very high value sku
-- these sku contribute large share of inventory value,so must monitor more strictly than normal items
-- -----------------------------------------------------------------------------------------------------
-- "-:For improving Business:-"
-- "Analysis shows that a few high value SKUs (desks, chairs, monitors, tablets from key suppliers)  are at or below their reorder point, exposing the business to high impact stockout risk.
-- The company should immediately reorder these SKUs, adjust reorder points and safety stock, and work with suppliers to secure faster and more reliable delivery for these critical items.





