# Airline SQL Analytics
End-to-End Data Engineering & Analytics System (120M+ Records)

## Problem Statement

Airline operations generate massive volumes of data, but raw flight records alone do not answer critical business questions such as:

- Which airlines truly perform best after accounting for scale?
- Which routes are most unreliable?
- Which airports consistently cause congestion?
- How does performance change over time?

Naively computing averages on large datasets often produces biased and misleading insights.

This project builds a full-scale analytical system to transform 120M+ raw flight records into statistically correct, business-ready KPIs using modern data engineering and analytics best practices.

## Why This Project Matters

Most SQL projects stop at writing queries.

This project demonstrates:

- Large-scale ETL design
- Analytical schema modeling
- Correct KPI engineering
- Weighted aggregations
- Query performance optimization
- Materialized analytics
- BI-ready outputs

It reflects how real-world analytical data warehouses are designed.

## Dataset

**Source**: US Airline On-Time Performance Data

**Coverage**: October 1987 – April 2008

#### Scale:
- ~120 million flight records
- ~12 GB uncompressed

#### Raw Files

- airline.csv – flight-level facts
- carriers.csv – airline metadata

Due to the dataset size, the entire pipeline is designed to run on limited hardware using chunk-based ingestion and SQL-side aggregation.

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
Weighted KPI Queries
     ↓
Materialized KPI Tables
     ↓
Parquet Exports
     ↓
Streamlit Dashboard
```

This design mimics a modern analytics warehouse architecture.

## Data Modeling (MySQL)

The core analytical model follows a star schema design with centralized fact tables and conformed dimensions.

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

- v_airline_performance
- v_route_performance
- v_airport_performance

This semantic layer ensures consistency and reproducibility of metrics.

## Data Engineering Pipeline
### 1. Data Exploration & Schema Understanding

Explored the raw dataset using Pandas to understand:

- Column semantics
- Data quality
- Missing values
- Scale constraints

> Notebook: python/01_explore_data.ipynb

### 2. Analytics-Oriented Schema Design

Designed a normalized star-schema-based model optimized for aggregation-heavy workloads:

- Fact tables for flight-level data
- Dimension tables for airlines and airports

> SQL: sql/schema/

### 3. Data Cleaning & Transformation

- Standardized dates
- Derived analytics-specific features
- Resolved encoding and missing values
- Converted raw data into SQL-ready format

> Notebook: python/02_load_to_staging.ipynb

### 4. Chunk-Based ETL (120M+ Rows)

- Implemented chunk-based ingestion to avoid memory overflows
- Safely handled long-running jobs
- Loaded ~123M records into MySQL in ~4 hours on a personal machine

> Notebook: python/03_generate_etl_sql.ipynb
> SQL: sql/staging/

### 5. Fact Table Construction & Aggregation

- Built daily fact tables
- Auto-generated monthly aggregation SQL
- Added indexes for query acceleration

## KPI Engineering (Statistical Correctness)
### Why Weighted KPIs?

Simple averages are misleading when entities have different volumes.

This system uses weighted aggregations to ensure fairness and statistical correctness.

### Airline Performance KPIs

- Total flights (volume-aware ranking)
- Weighted avg departure delay
- Weighted avg arrival delay
- Cancellation rate (%)
- Diversion rate (%)
- Composite performance score
- Monthly performance trends

> SQL: sql/kpis/airline_performance_kpis.sql

### Route & Airport KPIs

- Busiest routes
- Most delayed routes (weighted)
- Route reliability
- Busiest airports
- Worst airports by arrival delay

> SQL: sql/kpis/route_&_airport_performance_kpis.sql

## Validation & Reliability

To ensure correctness:

- Validation queries were written
- Aggregates were cross-checked
- Views ensured reproducibility
- KPIs were manually verified before materialization

## KPI Materialization & Optimization

- KPIs initially computed using ad-hoc SQL
- Final KPIs materialized into summary tables
- Results exported to Parquet for fast downstream access

Folders:
> sql/materialization/
> data/parquet/

## Visualization & Dashboard
### Static Visualizations

- Airline KPIs
- Route KPIs
- Airport KPIs
- Monthly trends

Built using Matplotlib, Seaborn, and Plotly.

### Streamlit Dashboard

An interactive dashboard displaying:

- Airline performance
- Route performance
- Airport congestion
- Monthly trends

The dashboard reads only Parquet files for instant load times.

## Tech Stack
### Data Engineering & Analytics

- Python (Pandas)
- MySQL
- SQL (views, indexing, materialization)
- Chunk-based ETL

### Visualization

- Matplotlib
- Seaborn
- Plotly

### Dashboard

- Streamlit

### Storage

- Parquet (PyArrow)

## Key Learnings

- Designing analytical schemas at scale
- Avoiding biased KPIs
- Why weighted metrics matter
- Chunk-based ETL strategies
- Building BI-ready analytics layers
- Separating OLTP vs OLAP workloads

## Author

Adnan Momin

LinkedIn: https://www.linkedin.com/in/adnanmomin/

GitHub: https://github.com/muhammadadnanmomin
