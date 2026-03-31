CREATE VIEW v_master_dashboard
AS
SELECT h.id
	,h.sale_date
	,h.price
	,h.price_segment
	,h.bedrooms
	,h.bathrooms
	,h.sqft_living
	,h.sqft_lot
	,h.floors
	,h.waterfront_status
	,h.condition
	,h.grade
	,h.yr_built
	,h.yr_renovated
	,h.property_age
	,h.zipcode
	,INITCAP(z.city) AS city
	,h.lat
	,h.long
	,h.basement_status
	,h.renovation_status
	,ROUND((h.price / NULLIF(h.sqft_living, 0))::NUMERIC, 2) AS price_per_sqft
	,l.avg_price AS zip_avg_price
	,l.avg_price_per_sqft AS zip_avg_price_per_sqft
	,l.avg_grade AS zip_avg_grade
	,l.total_sales AS zip_total_sales
FROM v_house_sales_clean h
LEFT JOIN v_location_analysis l ON h.zipcode = l.zipcode
LEFT JOIN zip_lookup z ON h.zipcode = z.zipcode;
