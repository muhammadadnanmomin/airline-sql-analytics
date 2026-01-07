import pandas as pd
from sqlalchemy import create_engine
import os

# DB CONNECTION
engine = create_engine(
    "mysql+pymysql://root:@localhost/airline_analytics"
)

# OUTPUT DIRECTORY
OUTPUT_DIR = "../data/parquet"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# KPI TABLES TO EXPORT
kpi_tables = {
    "kpi_airline_performance": "kpi_airline_performance.parquet",
    "kpi_route_performance": "kpi_route_performance.parquet",
    "kpi_airport_performance": "kpi_airport_performance.parquet",
    "kpi_monthly_trends": "kpi_monthly_trends.parquet",
}

# EXPORT LOOP
for table, filename in kpi_tables.items():
    print(f"Exporting {table}...")

    df = pd.read_sql(f"SELECT * FROM {table}", engine)

    output_path = os.path.join(OUTPUT_DIR, filename)
    df.to_parquet(output_path, index=False)

    print(f"Saved → {output_path}")

print("All KPI tables exported successfully!")
