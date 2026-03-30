CREATE VIEW v_house_sales_clean_test
AS
SELECT id
	,to_timestamp(DATE, 'YYYYMMDD"T"HH24MISS')::DATE AS sale_date
	,price
	,bedrooms
	,bathrooms
	,sqft_living
	,sqft_lot
	,floors
	,waterfront
	,view 
	,condition
	,grade
	,sqft_above
	,sqft_basement
	,yr_built
	,yr_renovated
	,zipcode
	,lat
	,long
	,sqft_living15
	,sqft_lot15
	,CASE 
		WHEN price < 300000
			THEN 'entry level'
		WHEN price < 650000
			THEN 'mid range'
		WHEN price < 1000000
			THEN 'upper mid'
		ELSE 'luxury'
		END AS price_segment
	,CASE 
		WHEN waterfront = 1
			THEN 'waterfront'
		ELSE 'standard'
		END AS waterfront_status
	,CASE 
		WHEN sqft_basement > 0
			THEN 'has basement'
		ELSE 'no basement'
		END AS basement_status
	,CASE 
		WHEN yr_renovated > 0
			THEN 'renovated'
		ELSE 'not renovated'
		END AS renovation_status
	,EXTRACT(YEAR FROM to_timestamp(DATE, 'YYYYMMDD"T"HH24MISS')) - yr_built AS property_age
FROM house_sales;
