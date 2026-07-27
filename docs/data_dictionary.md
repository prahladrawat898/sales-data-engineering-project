# Data Dictionary

## Dataset Overview

The dataset contains transactional sales records used for data engineering, data validation, exploratory data analysis, and business reporting.

The raw dataset is stored as a CSV file and contains information related to orders, customers, products, sales, discounts, quantities, and profitability.

---

## Column Definitions

| Column | Description | Data Type | Business Purpose |
|---|---|---|---|
| Row ID | Unique identifier for each row/transaction record | Integer | Record-level identification |
| Order ID | Unique identifier for a customer order | String | Order tracking and order-level analysis |
| Order Date | Date when the order was placed | Date | Time-series and trend analysis |
| Ship Date | Date when the order was shipped | Date | Shipping and fulfilment analysis |
| Ship Mode | Shipping method used for the order | String | Shipping performance analysis |
| Customer ID | Unique identifier for the customer | String | Customer-level analysis |
| Customer Name | Name of the customer | String | Customer reporting |
| Segment | Customer segment classification | String | Segment-level analysis |
| Country | Country associated with the order | String | Geographic analysis |
| City | City associated with the order | String | Geographic analysis |
| State | State associated with the order | String | Regional analysis |
| Postal Code | Postal code associated with the location | Integer | Geographic identification |
| Region | Business region associated with the order | String | Regional performance analysis |
| Product ID | Unique identifier for the product | String | Product-level analysis |
| Category | High-level product category | String | Category performance analysis |
| Sub-Category | Detailed product classification | String | Sub-category analysis |
| Product Name | Name of the product | String | Product-level reporting |
| Sales | Revenue generated from the transaction | Decimal | Revenue and sales analysis |
| Quantity | Number of units sold | Integer | Volume analysis |
| Discount | Discount applied to the transaction | Decimal | Discount impact analysis |
| Profit | Profit generated from the transaction | Decimal | Profitability analysis |

---

## Data Quality Considerations

The following data-quality checks are applied during the project:

- Missing values in critical fields
- Duplicate records
- Missing Order IDs
- Missing Customer IDs
- Missing Product IDs
- Negative sales values
- Negative profit values
- Invalid quantity values
- Invalid or missing dates
- Data type consistency

---

## Derived Fields

The Python ETL pipeline creates additional analytical fields where applicable.

| Derived Field | Description |
|---|---|
| Profit Margin | Profit as a percentage of sales |
| Order Year | Year extracted from Order Date |
| Order Month | Month extracted from Order Date |

---

## Data Flow

```text
Raw Sales Dataset
       ↓
Python / Pandas
       ↓
Data Cleaning
       ↓
Data Transformation
       ↓
Data Validation
       ↓
Processed Dataset
       ↓
SQL Analysis
       ↓
Dashboard Reporting
