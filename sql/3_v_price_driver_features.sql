CREATE VIEW v_price_driver_features
AS
SELECT price
	,price_segment
	,bedrooms
	,bathrooms
	,sqft_living
	,ROUND((price / NULLIF(sqft_living, 0))::NUMERIC, 2) AS price_per_sqft
	,condition
	,grade
	,waterfront_status
	,basement_status
	,renovation_status
	,property_age
	,zipcode
FROM v_house_sales_clean;
