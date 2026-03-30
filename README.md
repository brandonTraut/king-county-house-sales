# King County House Sales

## Overview

This project examines 21,000+ residential home sales in King County, WA (Seattle metropolitan area), using [Kaggle data](https://www.kaggle.com/datasets/harlfoxem/housesalesprediction) with [USPS zip code reference data](https://postalpro.usps.com/ZIP_Locale_Detail) to provide geographic context. Using PostgreSQL for data modeling, Python for data ingestion and enrichment, and Tableau Public for data visualization, this project seeks to answer three core questions: Where do we see the highest property value concentrations? How do we see prices trend in relation to market segments? And what is the influence of construction grade on prices? The results of the project are visualized using an interactive Tableau Public dashboard.

Live Dashboard: [VIEW on Tableau Public](https://public.tableau.com/app/profile/brandon.trautner/viz/KingCountyHouseSalesAnalysis_17748082547560/OverviewDashboard)

---

### Tech Stack
- PostgreSQL — relational database and analytical layer  
- pgAdmin — database management and query interface  
- Python (pandas, SQLAlchemy, psycopg2) — data ingestion from CSV/Excel to Postgres  
- Tableau Public — interactive dashboard and visualizations  

---

## Data Source
[House Sales in King County, USA](https://www.kaggle.com/datasets/harlfoxem/housesalesprediction)

21,613 home sales in King County, Washington from May 2014 to May 2015. Includes price, physical features, condition, grade, location coordinates, and zip code.

[USPS ZIP Code Reference Data](https://postalpro.usps.com/ZIP_Locale_Detail)

A comprehensive set of data provided by the United States Postal Service that maps zip codes with their corresponding physical city names, filtered using Python for the 70 King County zip codes contained in the house sales data.

---

### Data Pipeline
1. Download — Single CSV downloaded from Kaggle & Zip Code Excell file from USPS.
2. Enrich — USPS zip code data filtered to King County zip codes and loaded as a lookup table.
3. Ingest — Python/pandas script loads CSV/Excel into Postgres.
4. Model— SQL views built on top of raw table to create a clean analytical layer.
5. Visualize — Master view exported as CSV and loaded into Tableau Public.

---

### Data Modeling Decisions

1. **Property age at time of sale:**<br>
   Rather than calculating property age relative to the current date, I calculated the age of the property at the time of each transaction:
````EXTRACT(YEAR FROM TO_TIMESTAMP(date, 'YYYYMMDD"T"HH24MISS')) - yr_built AS property_age````

2. **Price segmentation:**<br>
   Properties were segmented into four tiers to enable market segment analysis:
   ````
   CASE
      WHEN price < 300000  THEN 'entry level'
      WHEN price < 650000  THEN 'mid range'
      WHEN price < 1000000 THEN 'upper mid'
      ELSE 'luxury'
   END AS price_segment
   ````
3. **Median vs average price:**<br>
Median price is used in the analysis, as this helps to avoid skewing the results from ultra-luxury properties, a standard practice in real estate analysis.

4. **External data enrichment:**<br>
  The raw Kaggle dataset only contained zip codes with no attached location names. In order to make my Tableau dashboard more approachable to viewers not from the Seattle area, I made the decision to use an external USPS Zip Code dataset to attach city names to zip codes from our original Kaggle dataset. After downloading the USPS dataset, I filtered the 70 King County zip codes using Python and loaded it as a lookup table, allowing me to use a join to connect it to the master view.

---

### SQL VIEWS
<ins>v_orders_complete</ins></br>
Base view that parses dates, adds calculated columns including price segment, waterfront status, basement status, renovation status, and property age at time of sale.

<ins>v_monthly_trends</ins></br>
Monthly average, min, and max price broken down by price segment and waterfront status. Powers the price trend dashboard.

<ins>v_price_driver_features</ins></br>
Property level view adding price per sqft and all feature flags. Used for feature analysis.

<ins>v_location_analysis</ins></br>
Zip code level aggregations including average price, price per sqft, average grade, and average condition. One row per zip code ordered by average price descending.

<ins>v_master_dashboard</ins></br>
Single denormalized view combining all key fields and city names from the lookup table. Used for Tableau export.

---
### Key Findings
1. **Grade is the strongest price predictor**
   
King County utilizes a grade system from 1-13 to determine the level of construction and design quality. From the analysis, it is evident that there is a positive correlation between the grade and the price of the property in all market segments. At the luxury segment, the properties that fall within the grade 10+ category are more expensive compared to those in the grade 7 category. In the entry level and mid-range segments, the majority of the properties fall within the grade 6-8 category, and the price differences are relatively small between the grades.<br>

**Business implication:** Grade is a reliable predictor of the price of the property in each market segment. Buyers in the mid-range segment experience little variance in the price of grade 7 and grade 8 properties, whereas the price of grade 10 and above properties is substantially higher in the luxury segment.

### 2. Extreme geographic price variation
Average sale prices range from $234k in Auburn (zip 98002) to $2.16M in Bellevue (zip 98039), nearly a 10x difference across King County. The most expensive zip codes cluster around Bellevue and Mercer Island on the eastern shore of Lake Washington.

Price per sq ft tells an even clearer story, with Bellevue averaging $568/sq ft vs. $151/sq ft in Auburn, confirming that location commands a significant premium independent of property size..

### 3. Market segmentation is clearly defined
The four price segments show distinct and stable price bands throughout the entire observation period with minimal overlap. The luxury segment shows the most price volatility month to month, while entry-level through upper-mid segments remain relatively stable, consistent with broader real estate market dynamics where luxury is more sensitive to market conditions.

---

### How to Run Locally
Prerequisites:
- PostgreSQL installed and running
- Python 3 with pip
- Tableau Public

````
# Clone the repo
https://github.com/brandonTraut/king-county-house-sales.git
cd king-county-house-sales

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Dependencies
pip install pandas sqlalchemy psycopg2-binary

# Create a PostgreSQL Database in pgAdmin
Right-click "Databases"
Click "Create->Database"
Name it: king_county_db

# Add Required Data Files
place these files in data/raw/
  - kc_house_data.csv - 'Kaggle Dataset'
  - zip_codes.xls - 'USPS Dataset'

# Configure Database Connection
Update your PostgreSQL credentials and run:
scripts/load_data.py
scripts/load_zip_lookup.py

# Create Views
run sql/views.sql in pgAdmin to create the views

# Load zip lookup table
update your password in scripts/load_zip_lookup.py and run it.

# Export Master Dataset for Tableau
Run the following query in pgAdmin:
SELECT * FROM v_master_dashboard;
Then:
Click the download/export icon
Export as CSV
Load into Tableau Public

````

---

### Future Analysis

The project focused on three fundamental questions: where are prices highest? How do prices trend by segment? And how does grade impact price? There are several additional fields in the master data set that open the door to further analysis:

* **Property size and layout analysis:** <br>
  Sqft_living, sqft_lot, bedrooms, and bathrooms are available for future exploration. A natural next step would be understanding the relationship between living space and price per sq ft. Does the cost per sq ft go down with larger homes, or is there a premium paid? Is there an optimal bedroom/bathroom ratio per price segment?

* **Renovation and age ROI:** <br>
The variables yr_renovated, renovation_status, and property_age can be used to pose an interesting question: Do renovated properties command a premium over unrenovated properties of similar age and grade? This is an extremely practical question for both buyers and sellers.

* **Condition vs grade analysis:** <br>
Condition rates the maintenance state of the property (1-5), and grade rates the quality of the build (1-13). Comparing these two factors against the price could answer the question of whether buyers are willing to pay more for an old, well-maintained home or a new, poorly maintained one.

* **Waterfront deep dive:** <br>
A dedicated waterfront analysis could quantify the exact price premium waterfront properties command by grade, size, and zip code.

---


Build by: Brandon Trautner | [Tableau Public](https://public.tableau.com/app/profile/brandon.trautner/viz/KingCountyHouseSalesAnalysis_17748082547560/OverviewDashboard)









