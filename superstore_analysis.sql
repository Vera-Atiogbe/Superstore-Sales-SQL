-- EXPLORATORY DATA ANALYSIS  
 SELECT  * FROM superstore_copy2;

/* **Sales & Business Analysis** */
 -- Q1:What is the total revenue and total profit? 
 -- Finding: The total revenue is '2,292,476.07' and total profit is '285,708.3'
 SELECT ROUND(SUM(sales),2) AS total_sales FROM superstore_copy2;
 SELECT ROUNd(SUM(profit),2) AS total_profit FROM superstore_copy2;

 -- Q2:Which region generates the most sales and profit?
 /* Finding: The West region leads in both sales ($720,031.45) and profit ($107,304.02),followed by East in both metrics with $679,086.15 in sales and $91,603.08 in profit.
Interestingly Central ranks 3rd in sales at $502,475.88 but drops to 4th in profit at $40,150.55, while South ranks 4th in sales at $390,882.59 but jumps to 3rd 
in profit at $46,650.65.
This means Central generates more revenue than South but is less efficient at converting sales to profit, suggesting higher costs or heavier discounting 
in the Central region.
The West and East regions are the strongest performers overall while Central underperforms relative to its sales volume. */
 WITH sales_cte AS
 (SELECT Region, ROUND(SUM(sales),2) total_sales,ROW_NUMBER() OVER(ORDER BY ROUND(SUM(sales),2) DESC) AS sales_rank
  FROM superstore_copy2 GROUP BY Region),
 profit_cte AS
 (SELECT Region,ROUND(SUM(profit),2) total_profit,ROW_NUMBER() OVER(ORDER BY ROUND(SUM(profit),2) DESC) AS profit_rank  FROM superstore_copy2 GROUP BY Region) 
 SELECT p.Region,s.total_sales,s.sales_rank,p.total_profit,p.profit_rank FROM sales_cte s
 JOIN profit_cte p ON s.Region =p.Region ORDER BY sales_rank ASC;
 
 -- Q3:Which product category performs best in sales and profit?
 /* Finding: Technology ranks 1st in both sales ($835,900.14) and profit ($145,389.01), making it the strongest category overall.
 Furniture ranks 2nd in sales ($733,047.06) but drops to 3rd in profit ($19,686.37), suggesting high costs or heavy discounting are eating into Furniture margins.
 Office Supplies ranks 3rd in sales ($723,528.87) but jumps to 2nd in profit ($120,632.92),showing it is more efficient at converting sales to profit than Furniture.
 This means Technology and Office Supplies are the most profitable categories while Furniture underperforms despite strong sales. */
 WITH sales_cte AS
 (SELECT category,ROUND(SUM(sales),2) sum_sales, ROW_NUMBER() OVER(ORDER BY ROUND(SUM(sales),2) DESC) AS sales_rank FROM superstore_copy2 GROUP BY 1
 ),
 profit_cte AS
 (SELECT category,ROUND(SUM(profit),2) sum_profit, ROW_NUMBER() OVER(ORDER BY ROUND(SUM(profit),2) DESC) AS profit_rank FROM superstore_copy2 GROUP BY 1
 )
  SELECT s.category,s.sum_sales,s.sales_rank,p.sum_profit,p.profit_rank FROM sales_cte s 
  JOIN profit_cte p ON s.category=p.category ORDER BY sales_rank ASC;
  
-- Q4: What are the top 10 best selling products?
  /* Finding: Technology products dominate the top sellers list.
   Canon imageCLASS 2200 Advanced Copier leads with $61,599.83 in sales,followed by Fellowes PB500 Binding Machine ($27,453.38) and Cisco TelePresence System EX90 ($22,638.48).
   Technology accounts for 4 of the top 10 products, Office Supplies accounts for 5 and Furniture accounts for 1. */
 SELECT product_name, category, ROUND(SUM(sales),2) total_sales FROM superstore_copy2 GROUP BY product_name,Category ORDER BY 3 desc LIMIT 10;
 
-- Q5:  Which sub-category has the highest profit margin?
/* Finding: Labels have the highest profit margin at 44.42%, followed by Envelopes at 40.03% and Paper at 37.25%.
  Interestingly these are all low cost Office Supply items, suggesting that smaller cheaper products yield higher margins than expensive technology products. */
SELECT sub_category, ROUND(((SUM(profit) / SUM(sales)) * 100),2) profit_margin FROM superstore_copy2 GROUP BY sub_category ORDER BY 2 DESC LIMIT 10;

-- Q6: Which customer segment generates the most revenue?
-- Finding: The Consumer segment generates the most revenue($1,157,993.18), followed by Corporate($703,418.6) and Home Office(431,064.29) 
SELECT segment, ROUND(SUM(sales),2) top_revenue FROM superstore_copy2 GROUP BY segment ORDER BY 2 DESC LIMIT 10;


-- **Finance & Operations**
-- Q7:What is the average discount given and how does it affect profit?
 /*Finding: The average discount given across all orders is 35% and the average profit is $28.59
 The average discount given is 35%. When no discount is applied, average profit is highest at $68.11. As discounts increase, profit steadily declines. 
 Orders with high discounts above 40% result in negative profit meaning the business is losing money on those orders. 
 This shows that heavy discounting is hurting profitability. */
-- Overall average for both profit and discount
SELECT  ROUND(AVG(Discount),2) avg_discount,ROUND(AVG(profit),2) avg_profit FROM superstore_copy2;
-- Group by discount levels to see the impact
SELECT
CASE 
    WHEN Discount = 0 THEN 'No Discount'
    WHEN Discount <= 0.2 THEN 'Low (1-20%)'
    WHEN Discount <= 0.4 THEN 'Medium (21-40%)'
    ELSE 'High (41%+)'
END AS discount_range, 
COUNT(*) AS num_orders, ROUND(AVG(Profit), 2) AS avg_profit FROM superstore_copy2 GROUP BY discount_range ORDER BY 3 DESC;

-- Q8:Which orders had a loss (negative profit)?
 /* Finding: 1808 orders out of 9994(about 18%) generated a loss. The biggest losses are concentrated in the Technology category, particularly 
  printers. Some individual orders lost as much as $6599.98 */
SELECT count(*) AS loss_orders FROM superstore_copy2 WHERE profit <0;
SELECT order_id,product_name,category,ROUND(profit,2) profit_loss FROM superstore_copy2 WHERE profit <0 ORDER BY 4 ASC LIMIT 10;

-- Q9:What is the profit margin by category?
 /* Finding: Technology has the highest profit margin at 17.39%, followed by Office Supplies at 16.67% and Furniture at 2.69% 
 Interestingly,although Technology leads in losses, it also leads in profits*/
SELECT category, ROUND(((SUM(profit) / SUM(sales)) * 100),2) profit_margin FROM superstore_copy2 GROUP BY category ORDER BY 2 DESC;

-- Q10:Which shipping mode is most used and most profitable?
/* Finding: Standard Class is the most used shipping mode with 5,968 orders and the most profitable at $164,085.09, ranking 1st in both metrics.
Second Class ranks 2nd in both usage (1,945 orders) and profit ($56,724.16),followed by First Class 3rd in both with 1,538 orders and $48,788.64 profit.
Same Day is the least used at only 543 orders and least profitable at $16,110.41.Interestingly all four shipping modes rank identically in both usage and 
profitability, suggesting that shipping mode choice is directly driven by order volume rather than profit margins.
Standard Class dominates with 59.7% of all orders, confirming customers strongly prefer standard delivery over premium shipping options. */
WITH shipping_mode AS
(SELECT ship_mode,count(ship_mode) most_used,ROW_NUMBER() OVER(ORDER BY count(ship_mode) DESC) AS ship_mode_rank FROM superstore_copy2 GROUP BY ship_mode),
profitability AS
(SELECT ship_mode,ROUND(SUM(profit),2) most_profitable,ROW_NUMBER() OVER(ORDER BY ROUND(SUM(profit),2) DESC) AS profit_rank FROM superstore_copy2 GROUP BY ship_mode)
SELECT s.ship_mode,s.most_used,s.ship_mode_rank,p.most_profitable,p.profit_rank FROM shipping_mode s
JOIN profitability p  ON p.ship_mode=s.ship_mode ORDER BY s.ship_mode_rank ASC;

/* **Marketing & Customer Analysis** */
-- Q11:How many unique customers are there?
/* Finding:There are 793 unique customers in the dataset.*/
SELECT COUNT(DISTINCT(customer_name)) FROM superstore_copy2 ;

-- Q12: Who are the top 10 customers by sales?
/* Finding: The top 10 customers by sales are led by Sean Miller at $25,043.07 ranking 1st, followed by Tamara Chand at $19,017.85 and Raymond Buch at $15,117.35.
The gap between Sean Miller and 2nd place Tamara Chand is $6,025.22 suggesting Sean Miller is an exceptionally high value customer significantly ahead of others.
All top 10 customers have spent above $12,000 confirming they are consistently high value customers worth prioritizing for retention.
These 10 customers out of 793 total represent only 1.26% of the customer base but contribute disproportionately to total revenue, a classic example of the 
Pareto Principle in action. */
WITH customer_sales_cte AS
 (SELECT customer_name, ROUND(SUM(sales),2) AS customer_sales,ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS sales_rank
    FROM superstore_copy2 GROUP BY customer_name)
SELECT customer_name, customer_sales, sales_rank FROM customer_sales_cte WHERE sales_rank <= 10;

-- Q13:Which customer segment gets the highest discounts?
/* Finding: The Consumer segment receives the highest average discount at 39%, followed by Corporate at 34% and Home Office at 27%. 
This suggests that Consumer customers are being given the most discounts which could be impacting overall profitability.*/
SELECT segment,ROUND(AVG(Discount),2) avg_discount,ROUND(SUM(Discount),2) total_discount,count(*) num_orders
 FROM superstore_copy2 GROUP BY segment ORDER BY 2 DESC;

-- Q14:Which customers have spent more than $10,000 in total sales
/* Finding: 20 customers out of 793 unique customers have spent more than $10,000 in total sales, representing only 2.5% of the customer base.
Sean Miller leads with $25,043.07 followed by Tamara Chand at $19,017.85 and Raymond Buch at $15,117.35.
These 20 high value customers represent a significant concentration of revenue and should be prioritized for retention and loyalty programs.
The gap between Sean Miller ($25,043) and the 20th customer Edward Hooks ($10,105) is $14,937, showing a wide range in spending among top customers.
Identifying and retaining these high value customers should be a key business priority as losing even one could significantly impact revenue. */
SELECT customer_name, ROUND(SUM(sales),2) AS total_sales FROM superstore_copy2 GROUP BY customer_name HAVING total_sales > 10000 ORDER BY 2 DESC;


/* **Time Series & Trend Analysis** */
-- Q15:What are the monthly and yearly sales trends?
/* Finding: Sales show a consistent seasonal pattern across all years.
  November, September and December are consistently the strongest months with November 2014 being the single best month at $112,062.
  January and February are consistently the weakest months. While sales generally grow year over year, 2012 saw dips in some months
  compared to 2011, particularly in March and June. The Q4 spike suggests strong end of year demand driven by holiday season purchasing. */
SELECT MONTH(order_date), YEAR(order_date),ROUND(SUM(sales),2) sum_sales FROM superstore_copy2 GROUP BY 1,2 ORDER BY 1,2,3 ASC;

-- Q16: Month over month sales growth
/* Finding: Sales show significant month over month fluctuations across the year.
The biggest growth jump was from October to November with an increase of $152,990.39,followed by August to September with $147,664 growth.
January starts strong at $95,298.48 but drops sharply in February by $35,159.26, confirming February is the weakest month.
March sees the strongest recovery with a $138,638.57 jump from February.
October sees the biggest single month drop at -$111,667.03 after the September peak, before recovering strongly into November.
December shows a slight decline of $18,309.59 from November suggesting the holiday rush peaks in November rather than December.
Overall the second half of the year consistently outperforms the first half, with Q4 driving the majority of annual revenue. */
WITH monthly_sales AS
(SELECT MONTH(order_date) sale_month,ROUND(SUM(sales),2) sum_sales FROM superstore_copy2 GROUP BY 1 ),
lag_cte AS
(SELECT sale_month,sum_sales, LAG(sum_sales) OVER(ORDER BY sale_month) AS previous_month_sales FROM monthly_sales)
SELECT sale_month,sum_sales, previous_month_sales,ROUND(sum_sales - previous_month_sales, 2) AS month_over_month_growth 
FROM lag_cte;

-- Q17: What are the projected sales for the following month?
/* Finding: The LEAD analysis shows projected sales for the following month.
January projects a drop of $35,159.26 into February, confirmed by February being the weakest month in the dataset.
The biggest projected growth is from October into November at $152,990.39, signaling the start of the holiday season surge.
August projects the second largest growth into September at $147,664, suggesting a mid year recovery period.
September projects a significant drop of $111,667.03 into October,showing October is a transitional slow month before the Q4 surge.
December shows NULL for next month projection as it is the final month,confirming there is no data beyond the current year.
The variance column shows positive values mean sales will DROP next month and negative values mean sales will RISE next month. */
With monthly_sales AS
(SELECT MONTH(order_date) sale_month,ROUND(SUM(sales),2) sum_sales FROM superstore_copy2 GROUP BY sale_month),
lead_cte AS
(SELECT sale_month, sum_sales,LEAD(sum_sales) OVER(ORDER BY sale_month) AS leading_month FROM monthly_sales)
SELECT sale_month AS current_month,sum_sales AS current_month_sales,leading_month AS next_month_projected_sales,ROUND(leading_month - sum_sales , 2) AS sales_variance
FROM lead_cte ORDER BY 1 ASC;

-- Q18: What is the cumulative sales growth throughout the year?
/* Finding: Cumulative sales grow steadily throughout the year reaching $2,292,476.07 by December, confirming consistent business activity all year.
The business reaches its first $500,000 milestone in April at $494,495.31 and crosses $1,000,000 in August at $1,107,551.69.
The steepest cumulative growth happens between August and November where sales jump from $1,107,551.69 to $1,961,398.73, an increase of $853,847
in just 3 months, confirming Q4 is the most critical period for the business.
The first half of the year January to June accounts for $798,752.53 which is only 34.8% of annual sales, while the second half accounts 
for 65.2%, showing a strong second half bias in business performance. */
WITH monthly_sales AS
(SELECT MONTH(order_date) sale_month, ROUND(SUM(sales),2) sum_sales FROM  superstore_copy2 GROUP BY 1)
SELECT sale_month, SUM(sum_sales) OVER(ORDER BY sale_month) AS cumulative_sales FROM monthly_sales;

-- Q19: How do sub-categories rank by sales and what happens when there are ties?
/* Finding: Phones lead sub-category sales at $329,753.14 followed closely by Chairs at $328,449.13, a difference of only $1,304.01 making them 
virtually tied as the top two sub-categories. Storage ranks 3rd at $216,803.20 and Tables 4th at $206,965.68.
Fasteners is the lowest performing sub-category at only $3,008.63, significantly behind all other sub-categories.
RANK() and DENSE_RANK() show identical results here because no two sub-categories have exactly the same total sales.
In a dataset with tied values RANK() would skip numbers after a tie while DENSE_RANK() would not skip, making DENSE_RANK() more useful
when you want consecutive rankings without gaps. */
SELECT sub_category, ROUND(SUM(sales),2) AS total_sales,RANK() OVER(ORDER BY SUM(sales) DESC) AS sales_rank,
DENSE_RANK() OVER(ORDER BY SUM(sales) DESC ) AS sales_dense_rank FROM superstore_copy2 GROUP BY sub_category ORDER BY 2 DESC;

-- Q20:Which year had the highest sales and profit?
/* Finding: 2014 had the highest sales at $732,545.29 and highest profit at $93,711.35, 
 followed by 2013 with $606,367.77 in sales and $81,179.05 in profit. 
 Interestingly 2011 generated more sales than 2012 ($485,067.83 vs $468,495.18) but 2012 was more profitable ($61,757.02 vs $49,060.88).
 This suggests that in 2011 higher discounts or costs were eating into profit despite higher sales volume,
 while 2012 was more efficient in converting  sales to profit.*/
WITH sales_cte AS
(SELECT YEAR(order_date) sales_year,ROUND(SUM(sales),2) sum_sales,ROW_NUMBER() OVER(ORDER BY ROUND(SUM(sales),2) DESC) AS sales_rank FROM superstore_copy2 GROUP BY 1 ),
profit_cte AS
(SELECT YEAR(order_date) profit_year,ROUND(SUM(profit),2) sum_profit,ROW_NUMBER() OVER(ORDER BY ROUND(SUM(profit),2) DESC) AS profit_rank FROM superstore_copy2 GROUP BY 1)
SELECT s.sales_year,s.sum_sales,s.sales_rank,p.profit_year,p.sum_profit,p.profit_rank FROM sales_cte s
JOIN profit_cte p ON s.sales_year = p.profit_year ORDER BY sales_rank ASC;

-- Q21:Which month consistently performs best?
/* Finding: When ranked by sales, November leads at $349,386.93, followed by December at $331,077.34 and September at $308,063.57.
  However when ranked by profit, December leads at $43,450.63, followed by September at $36,707.71 and November at $35,786.66.
  This means November drives the most revenue but December and September are more efficient at converting sales to profit.
  January is the worst month for profit at $9,200.62 despite having higher sales than February, suggesting heavy discounting 
  in January possibly due to post holiday sales and promotions. February has the lowest sales at $60,139.22 but slightly higher 
  profit than January, confirming January discounting hurts margins.*/
WITH sales_cte AS 
(SELECT MONTH(order_date) AS sale_month, ROUND(SUM(sales),2) AS sum_sales,ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS sales_rank
 FROM superstore_copy2 GROUP BY 1),
profit_cte AS
 (SELECT MONTH(order_date) AS sale_month, ROUND(SUM(profit),2) AS sum_profit,ROW_NUMBER() OVER(ORDER BY SUM(profit) DESC) AS profit_rank
 FROM superstore_copy2 GROUP BY 1)
SELECT s.sale_month,s.sum_sales,s.sales_rank,p.sum_profit,p.profit_rank FROM sales_cte s
JOIN profit_cte p ON s.sale_month = p.sale_month ORDER BY s.sales_rank ASC;

/* **Geographic Analysis** */
-- Q22:Which state generates the most sales?
 /*Finding: California leads in sales at $454,407.63, followed by  New York at $311,579.56 and Texas at $172,166.58.
 The top 3 states account for a significant portion of total revenue, suggesting the business is heavily concentrated in major US states.*/
SELECT state,ROUND(SUM(sales),2) most_sales FROM superstore_copy2 GROUP BY state ORDER BY 2 DESC LIMIT 10;

-- Q23:Which city is the most profitable?
/*Finding: New York City is the most profitable city at $62,061.37, followed by Los Angeles at $30,404.89 and Seattle at $28,894.43.
 New York City's profit is more than double that of Los Angeles,showing a heavy concentration of profitability in the Northeast.*/
SELECT city,ROUND(SUM(profit),2) most_profitable FROM superstore_copy2 GROUP BY city ORDER BY 2 DESC LIMIT 10;

-- Q24:Which region has the most orders?
/*Finding: The West region has the most orders at 3,203, followed by East at 2,848, Central at 2,323 and South at 1,620.
This is consistent with Q2 where the West also led in sales and profit, confirming that the West is the strongest performing region overall.*/
SELECT count(*) num_orders,Region FROM superstore_copy2 GROUP BY Region ORDER BY 1 DESC;



