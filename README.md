# Superstore Sales - SQL Data Cleaning & Analysis

## Project Overview
End-to-end SQL project covering data cleaning and exploratory 
data analysis of 9,994 superstore sales transactions across 
the United States from 2011 to 2014.

## Tools Used
- MySQL
- MySQL Workbench

## Skills Demonstrated
- Data Cleaning
- Duplicate Removal
- Data Type Conversion
- Date Formatting
- Exploratory Data Analysis
- Aggregate Functions
- Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, SUM OVER)
- CTEs (Common Table Expressions)
- Subqueries
- JOINs
- CASE Statements
- HAVING Clause

## Database Structure
Single table: `superstore` with 21 columns including:
- Order and shipping details
- Customer information
- Product details
- Financial metrics (Sales, Profit, Discount)

## Data Cleaning Steps
1. Created working copy of original table
2. Renamed columns to remove spaces and special characters
3. Removed duplicate rows using ROW_NUMBER() and CTEs
4. Checked and handled NULL and blank values
5. Trimmed whitespace from text columns
6. Converted data types (TEXT to DATE, DOUBLE, INT)
7. Fixed date format from DD-MM-YYYY to DATE type

## Analysis Questions Answered

### Sales & Business Analysis
- Total revenue: $2,292,476.07 | Total profit: $285,708.30
- West region leads in both sales and profit
- Technology is the top category in sales and profit
- Canon imageCLASS 2200 Copier is the best selling product
- Labels have the highest profit margin at 44.42%
- Consumer segment generates the most revenue

### Finance & Operations
- Average discount is 35%, high discounts above 40% result in losses
- 1,808 orders (18%) generated a loss
- Technology has highest profit margin at 17.39%
- Standard Class is most used and most profitable shipping mode

### Marketing & Customer Analysis
- 793 unique customers
- Sean Miller is top customer at $25,043.07
- Consumer segment receives highest average discount at 39%
- 20 customers have spent above $10,000 (Pareto Principle)

### Time Series & Trend Analysis
- 2014 was the strongest year in both sales and profit
- November leads in sales, December leads in profit
- Q4 accounts for 65.2% of annual sales
- Sales grow consistently year over year from 2011 to 2014

### Geographic Analysis
- California leads in state sales at $454,407.63
- New York City is the most profitable city at $62,061.37
- West region has the most orders at 3,203

## Key Business Insights
1. Heavy discounting above 40% is hurting profitability
2. Furniture has strong sales but very low profit margin (2.69%)
3. Q4 holiday season drives 65.2% of annual revenue
4. Top 2.5% of customers contribute disproportionate revenue
5. West region consistently outperforms all other regions

## Author
**Vera Dede Atiogbe**
Entry Level Data Analyst | Excel | SQL | Power BI
[Portfolio](https://vera-atiogbe.github.io) | 
[LinkedIn](https://www.linkedin.com/in/vera-atiogbe-5499a020b)
