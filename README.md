# E-commerce sales Data Cleaning with SQL

## About the project
This project focused on cleaning a messy e_commerce sales dataset using SQL.

## Tools used
- MySQL
- CASE statements
- String functions
- Data type convertsion

## Cleaning steps
- Created a backup table
- Removed duplicates
- Standardized dates
- Calculated discount
- Recalculated total

## Assumptions

- Rows where `price = 0` and `discount` is `NULL` or `0` were treated as potential free transactions.
