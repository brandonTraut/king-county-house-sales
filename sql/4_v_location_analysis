CREATE VIEW v_location_analysis
AS
SELECT zipcode
	,COUNT(*) AS total_sales
	,ROUND(AVG(price)::NUMERIC, 2) AS avg_price
	,ROUND(MIN(price)::NUMERIC, 2) AS min_price
	,ROUND(MAX(price)::NUMERIC, 2) AS max_price
	,ROUND(AVG(sqft_living)::NUMERIC, 2) AS avg_sqft
	,ROUND(AVG(price / NULLIF(sqft_living, 0))::NUMERIC, 2) AS avg_price_per_sqft
	,ROUND(AVG(grade)::NUMERIC, 2) AS avg_grade
	,ROUND(AVG(condition)::NUMERIC, 2) AS avg_condition
FROM v_house_sales_clean
GROUP BY zipcode
ORDER BY avg_price DESC;
