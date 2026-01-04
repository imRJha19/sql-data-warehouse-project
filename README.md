# Data Warehouse and Analytics Project

This project demonstrates an end-to-end data warehousing and analytics solution.
It is built as a portfolio project to showcase practical skills in data engineering,
ETL pipelines, data modeling, and SQL-based analytics.

---

## Data Architecture

The project follows the **Medallion Architecture** with three layers:

### Bronze Layer
- Stores raw data as received from source systems
- Data ingested from CSV files into SQL Server
- No transformations applied

### Silver Layer
- Data cleansing and standardization
- Handling missing values and duplicates
- Normalization and validation

### Gold Layer
- Business-ready analytical data
- Star schema design (fact and dimension tables)
- Optimized for reporting and analytics

---

## Project Overview

This project covers the complete lifecycle of a data warehouse:

- Designing a modern data warehouse architecture
- Building ETL pipelines from ERP and CRM source systems
- Cleaning and integrating data from multiple sources
- Creating analytical data models
- Generating insights using SQL queries

---

## Analytics and Reporting

The analytics layer provides insights into:

- Customer behavior
- Product performance
- Sales trends

These insights help stakeholders make data-driven decisions.

---

## Skills Demonstrated

- SQL Development
- Data Engineering
- Data Architecture
- ETL Pipeline Development
- Data Modeling (Star Schema)
- Data Analytics and Reporting

---

## Tools and Technologies

- SQL Server Express
- SQL Server Management Studio (SSMS)
- CSV datasets (ERP and CRM)
- Git and GitHub
- Draw.io (architecture and data modeling diagrams)
- Notion (project planning and documentation)

---

## Project Requirements

### Building the Data Warehouse

**Objective**
- Develop a modern data warehouse to consolidate sales data for analytics.

**Specifications**
- Data Sources: ERP and CRM data provided as CSV files
- Data Quality: Data cleansing before analysis
- Integration: Unified analytical data model
- Scope: Latest data only (no historization)
- Documentation: Clear data model documentation

---

## Repository Structure

data-warehouse-project/
- datasets/        Raw ERP and CRM datasets
- docs/            Architecture and documentation files
- scripts/
  - bronze/        Raw data ingestion scripts
  - silver/        Data cleaning and transformation scripts
  - gold/          Analytical model scripts
- tests/           Data quality and validation scripts
- README.md
- LICENSE
- .gitignore
- requirements.txt
