# Airline SQL Analytics

End-to-End Data Engineering & Analytics Project (120M+ Records)

## Project Overview

This project is a full-scale airline performance analytics system built on top of the US Airline On-Time Performance dataset (1987–2008).
It demonstrates how large, raw aviation data can be transformed into reliable, business-ready KPIs using SQL, Python, and modern analytics practices.

> **Note:**  
> This project focuses on analytical workloads and KPI generation, not transactional (OLTP) operations.

#### The project goes beyond writing SQL queries and focuses on:

- Scalable ETL design
- Analytical schema modeling
- Statistically correct KPI computation
- Materialized analytics for low-latency dashboards

## Business Problem

Airline operations generate massive volumes of data, but raw flight records alone do not answer critical business questions such as:

- Which airlines perform best after accounting for scale?
- Which routes are most delayed or unreliable?
- Which airports consistently cause congestion?
- How does airline performance change over time?

The challenge is to compute these insights correctly and efficiently on 120M+ flight records, without biased averages or performance bottlenecks.

## Dataset Description

- Source: US Airline On-Time Performance Data

- Coverage: October 1987 – April 2008

- Scale:

     ~120 million flight records

     ~12 GB uncompressed

- Raw Files:

     airline.csv – flight-level data

     carriers.csv – airline metadata

Due to the dataset size, the project is designed to run on limited hardware using chunk-based ETL and SQL-side aggregation.

## System Architecture

```
Raw CSV Data
     ↓
Python (EDA + Cleaning + ETL SQL Generation)
     ↓
MySQL (Staging Tables)
     ↓
Fact & Dimension Tables
     ↓
Analytical Views
     ↓
KPI Queries (Weighted Metrics)
     ↓
Materialized KPI Tables
     ↓
Parquet Exports
     ↓
Streamlit Dashboard
```

## Database Schema (MySQL)

The core analytical model follows a **star schema design**, with centralized fact tables and conformed dimensions.  
Downstream KPI tables are materialized for performance and dashboard efficiency.

### Core Tables

| Type       | Table                                        |
| ---------- | -------------------------------------------- |
| Staging    | `staging_flights`                            |
| Dimensions | `airlines_dim`, `airports_dim`               |
| Facts      | `flights_fact_daily`, `flights_fact_monthly` |

### KPI Tables (Materialized Analytics Layer)

| KPI Level   | Table                     |
| ----------- | ------------------------- |
| Airline     | `kpi_airline_performance` |
| Route       | `kpi_route_performance`   |
| Airport     | `kpi_airport_performance` |
| Time Series | `kpi_monthly_trends`      |

### Analytical Views (Semantic Layer)

- `v_airline_performance`
- `v_route_performance`
- `v_airport_performance`

This design follows dimensional modeling best practices commonly used in analytical data warehouses.

## Data Engineering Pipeline

### 1. Data Exploration & Schema Understanding

Initial exploration using Pandas to understand:
- Column meanings
- Data quality
- Missing values
- Scale constraints

python/01_explore_data.ipynb

### 2. Schema Design (Analytics-Oriented)

Designed a normalized analytical schema consisting of:
- Dimension tables: airlines, airports
- Fact table: daily flight-level facts
- Optimized for aggregation-heavy workloads

sql/schema/

### 3. Data Cleaning & Transformation

- Parsed and standardized dates
- Derived analytics-specific fields
- Resolved encoding and missing-value issues
- Converted raw data into SQL-ready format

python/02_load_to_staging.ipynb

### 4. Chunk-Based ETL (120M+ Rows)

- Implemented chunk-based ingestion to avoid memory overflows
- Handled long-running jobs safely
- Loaded ~123M records into MySQL in ~4 hours on a personal machine

python/03_generate_etl_sql.ipynb
sql/staging/

### 5. Fact Table Construction & Aggregation

- Built daily fact tables
- Generated month-wise aggregation SQL automatically
- Added indexes to support fast analytics queries

sql/staging/

## Analytics & KPI Design
Why Weighted KPIs?

Simple averages produce misleading results when airlines or routes have different flight volumes.

This project uses weighted metrics to ensure fairness and statistical correctness.

### Airline Performance KPIs

- Total flights (volume-aware ranking)
- Weighted average departure delay
- Weighted average arrival delay
- Cancellation rate (%)
- Diversion rate (%)
- Composite performance score (lower = better)
- Monthly performance trends

sql/kpis/airline_performance_kpis.sql

### Route & Airport KPIs

- Busiest routes by volume
- Most delayed routes (weighted)
- Route reliability (cancellation rate)
- Busiest airports
- Worst airports by arrival delay

sql/kpis/route_&_airport_performance_kpis.sql

## Validation & Reliability

To ensure trust in results:

- Validation queries were written to cross-check aggregates
- Analytical views were used for reproducibility
- KPI outputs were manually verified before materialization

sql/validation/
sql/views/

## KPI Materialization & Performance Optimization

- KPIs initially computed using ad-hoc SQL for validation
- Final KPIs were materialized into summary tables
- Results exported to Parquet format for fast downstream access

sql/materialization/
data/parquet/

## Visualization & Dashboard

### Python Visualizations

- Static KPI plots for exploration and reporting
- Built using Matplotlib, Seaborn, and Plotly

python/04_airline_kpi_visuals.ipynb
python/05_route_airport_visuals.ipynb
visuals/

## Streamlit Dashboard

An interactive dashboard showcasing:

- Airline KPIs
- Route KPIs
- Airport KPIs
- Monthly trends

The dashboard reads only Parquet files, ensuring instant load times.

app.py

## Tech Stack

- Data Processing: Pandas
- Database: MySQL
- SQL: Advanced analytics, views, indexing, materialization
- ETL: Python (chunk-based ingestion)
- Visualization: Matplotlib, Seaborn, Plotly
- Dashboard: Streamlit
- Storage Format: Parquet (PyArrow)

## Author

Adnan Momin

LinkedIn: https://www.linkedin.com/in/adnanmomin/

GitHub: https://github.com/muhammadadnanmomin
