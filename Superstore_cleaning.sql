-- ============================================
-- SUPERSTORE SALES - DATA CLEANING
-- ============================================

/* -- 1.STEP 1: VIEW ORIGINAL TABLE
SELECT * FROM superstore ;

-- STEP 2: CREATE COPY TABLE
CREATE table superstore_copy like superstore;
SELECT * FROM superstore;

-- STEP 3: INSERT DATA INTO COPY
INSERT INTO superstore_copy
SELECT *  FROM superstore;

SELECT * FROM superstore_copy;

-- STEP 4: RENAME COLUMNS
ALTER TABLE superstore_copy
RENAME COLUMN `Row ID` TO row_id,
RENAME COLUMN `Order ID` TO order_id,
RENAME COLUMN `Order Date` TO order_date,
RENAME COLUMN `Ship Date` TO ship_date,
RENAME COLUMN `Ship Mode` TO ship_mode,
RENAME COLUMN `Customer ID` TO customer_id,
RENAME COLUMN `Customer Name` TO customer_name,
RENAME COLUMN `Postal Code` TO postal_code,
RENAME COLUMN `Product ID` TO product_id,
RENAME COLUMN `Product Name` TO product_name;

-- STEP 5: VERIFY RENAMED COLUMNS
SELECT * FROM superstore_copy;

-- STEP 6:CREATE CTES TO CHECK DUPLICATES
WITH duplicate_CTE AS
 (
SELECT *, ROW_NUMBER() OVER (PARTITION BY row_id,order_date,ship_date,customer_id,customer_name,product_id,category) AS row_num 
FROM  superstore_copy

)
SELECT * FROM duplicate_CTE WHERE row_num >1;  

-- STEP 6:CREATE TABLE TO DELETE ROWS FROM
CREATE TABLE `superstore_copy2` (
  `row_id` text,
  `order_id` text,
  `order_date` text,
  `ship_date` text,
  `ship_mode` text,
  `customer_id` text,
  `customer_name` text,
  `Segment` text,
  `Country` text,
  `City` text,
  `State` text,
  `postal_code` text,
  `Region` text,
  `product_id` text,
  `Category` text,
  `Sub-Category` text,
  `product_name` text,
  `Sales` text,
  `Quantity` text,
  `Discount` text,
  `Profit` text,
  `row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;  

SELECT * FROM superstore_copy2;

-- STEP 8: INSERT DATA WITH ROW NUMBERS
INSERT INTO  superstore_copy2
  (
SELECT *, ROW_NUMBER() OVER (PARTITION BY row_id,order_date,ship_date,customer_id,customer_name,product_id,category) AS row_num 
FROM  superstore_copy

);

-- STEP 9: CHECK DUPLICATES
SELECT * FROM superstore_copy2 WHERE row_num >1 ; 

-- STEP 10: DELETE DUPLICATES
DELETE FROM superstore_copy2 WHERE row_num >1;

-- STEP 11: VERIFY DUPLICATES REMOVED
SELECT * FROM superstore_copy2 WHERE row_num >1;
SELECT * FROM superstore_copy2 WHERE row_num =1; 
*/

/* -- 2.REMOVING NULLS AND BLANKS
-- Looking for Nulls and Blanks 
SELECT * FROM superstore_copy2;
SELECT * FROM superstore_copy2 WHERE row_id is  NULL or row_id ='' or row_id =0;
SELECT * FROM superstore_copy2 WHERE order_id is NULL or order_id ='' or order_id =0;
SELECT * FROM superstore_copy2 WHERE order_date is NULL or order_date ='' or order_date =0;
SELECT * FROM superstore_copy2 WHERE ship_date is NULL or ship_date='' or ship_date =0;
SELECT * FROM superstore_copy2 WHERE ship_mode is NULL or ship_mode='';
SELECT * FROM superstore_copy2 WHERE customer_id is NULL or customer_id ='' or customer_id =0;
SELECT * FROM superstore_copy2 WHERE customer_name is NULL or customer_name ='';
SELECT * FROM superstore_copy2 WHERE Segment is NULL or Segment='';
SELECT * FROM superstore_copy2 WHERE country is NULL or country='';
SELECT * FROM superstore_copy2 WHERE city is NULL or city ='';
SELECT * FROM superstore_copy2 WHERE state is NULL or state ='';
SELECT * FROM superstore_copy2 WHERE postal_code is NULL or postal_code='' or postal_code =0;
SELECT * FROM superstore_copy2 WHERE Region is NULL or Region ='';
SELECT * FROM superstore_copy2 WHERE product_id is NULL or product_id='' or product_id =0;
SELECT * FROM superstore_copy2 WHERE Category is NULL or Category='';
SELECT * FROM superstore_copy2 WHERE sub_category is NULL or sub_category='';
SELECT * FROM superstore_copy2 WHERE product_name is NULL or product_name='';
SELECT * FROM superstore_copy2 WHERE sales is NULL or sales='' or sales =0;
SELECT * FROM superstore_copy2 WHERE Quantity is NULL or Quantity='' or Quantity =0;
SELECT * FROM superstore_copy2 WHERE Discount is NULL or Discount='' or Discount =0;
SELECT * FROM superstore_copy2 WHERE profit is NULL or profit='' or Profit =0;
SELECT * FROM superstore_copy2 WHERE row_num is NULL or row_num='' or row_num =0;

-- no nulls or blanks found ,only zeros in the Discount and Profit columns ,which are necessary for insight analysis
 */

/* --3.STANDARDIZING DATA 
SELECT * FROM superstore_copy2;
-- 1. Checking for spaces
SELECT * FROM superstore_copy2 WHERE order_id != trim(order_id);
SELECT * FROM superstore_copy2 WHERE order_date != trim(order_date);
SELECT * FROM superstore_copy2 WHERE ship_date != trim(ship_date);
SELECT * FROM superstore_copy2 WHERE ship_mode != trim(ship_mode);
SELECT * FROM superstore_copy2 WHERE customer_id != trim(customer_id);
SELECT * FROM superstore_copy2 WHERE customer_name != trim(customer_name);
SELECT * FROM superstore_copy2 WHERE Segment != trim(segment);
SELECT * FROM superstore_copy2 WHERE Country != trim(country);
SELECT * FROM superstore_copy2 WHERE State != trim(State);
SELECT * FROM superstore_copy2 WHERE postal_code != trim(postal_code);
SELECT * FROM superstore_copy2 WHERE Region != trim(Region);
SELECT * FROM superstore_copy2 WHERE product_id != trim(product_id);
SELECT * FROM superstore_copy2 WHERE Category != trim(category);
SELECT * FROM superstore_copy2 WHERE sub_category != trim(sub_category);
SELECT * FROM superstore_copy2 WHERE product_name != trim(product_name);
SELECT * FROM superstore_copy2 WHERE Sales != trim(Sales);
SELECT * FROM superstore_copy2 WHERE Quantity != trim(Quantity);
SELECT * FROM superstore_copy2 WHERE Discount != trim(Discount);
SELECT * FROM superstore_copy2 WHERE Profit != trim(Profit);
SELECT * FROM superstore_copy2 WHERE row_num != trim(row_num);

-- 2.Updating Untrimmed columns
UPDATE superstore_copy2 SET product_name = trim(product_name);
UPDATE superstore_copy2 SET Sales = trim(Sales);
UPDATE superstore_copy2 SET Quantity = trim(Quantity);
UPDATE superstore_copy2 SET Discount = trim(Discount);
*/

/*-- CHANGING DATA TYPES
-- 1.Checking data types
 DESCRIBE superstore_copy2; 
-- 2.Changing Data types
select * from superstore_copy2;
 
 -- Updating date before conversion
UPDATE superstore_copy2 SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');
UPDATE superstore_copy2 SET ship_date = STR_TO_DATE(ship_date, '%d-%m-%Y');
 
  -- Updating quantity before conversion
UPDATE superstore_copy2 SET quantity = ROUND(quantity);

ALTER TABLE superstore_copy2 MODIFY COLUMN row_id INT;
ALTER TABLE superstore_copy2 MODIFY COLUMN order_date DATE;
ALTER TABLE superstore_copy2 MODIFY COLUMN ship_date DATE;
ALTER TABLE superstore_copy2 MODIFY COLUMN postal_code INT;
ALTER TABLE superstore_copy2 MODIFY COLUMN sales DOUBLE;
ALTER TABLE superstore_copy2 MODIFY COLUMN quantity INT;
ALTER TABLE superstore_copy2 MODIFY COLUMN Discount DOUBLE;
ALTER TABLE superstore_copy2 MODIFY COLUMN profit DOUBLE;

-- 3.Verifying data type changes
DESCRIBE superstore_copy2; 
 */

