"""
Sales Data Engineering Project
Python + Pandas ETL Pipeline

Pipeline:
Raw CSV
    ↓
Extract
    ↓
Clean & Transform
    ↓
Validate
    ↓
Load Processed Data
"""

import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime


# =====================================================
# 1. CONFIGURATION
# =====================================================

INPUT_FILE = "data/raw/superstore_sales_for_datastudio.csv"

OUTPUT_DIR = Path("data/processed")
OUTPUT_FILE = OUTPUT_DIR / "sales_cleaned.csv"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


# =====================================================
# 2. EXTRACT
# =====================================================

def extract_data(file_path):
    """Read raw CSV data into a Pandas DataFrame."""

    print("Starting data extraction...")

    df = pd.read_csv(file_path)

    print(f"Extracted {len(df):,} rows and {len(df.columns)} columns.")

    return df


# =====================================================
# 3. CLEAN AND TRANSFORM
# =====================================================

def clean_data(df):
    """Clean and transform raw sales data."""

    print("Starting data cleaning and transformation...")

    # Create a copy to avoid modifying original data
    df = df.copy()

    # Standardize column names
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace("-", "_")
    )

    # Remove completely empty rows
    df = df.dropna(how="all")

    # Remove duplicate records
    df = df.drop_duplicates()

    # Convert date columns
    if "order_date" in df.columns:
        df["order_date"] = pd.to_datetime(
            df["order_date"],
            errors="coerce"
        )

    if "ship_date" in df.columns:
        df["ship_date"] = pd.to_datetime(
            df["ship_date"],
            errors="coerce"
        )

    # Convert numeric columns
    numeric_columns = [
        "sales",
        "profit",
        "quantity",
        "discount"
    ]

    for column in numeric_columns:
        if column in df.columns:
            df[column] = pd.to_numeric(
                df[column],
                errors="coerce"
            )

    # Remove records with missing critical values
    critical_columns = [
        "order_id",
        "customer_id",
        "product_id"
    ]

    existing_critical_columns = [
        column
        for column in critical_columns
        if column in df.columns
    ]

    if existing_critical_columns:
        df = df.dropna(
            subset=existing_critical_columns
        )

    # Create profit margin field
    if "sales" in df.columns and "profit" in df.columns:

        df["profit_margin"] = np.where(
            df["sales"] != 0,
            (df["profit"] / df["sales"]) * 100,
            0
        )

    # Create order year
    if "order_date" in df.columns:
        df["order_year"] = df["order_date"].dt.year

    # Create order month
    if "order_date" in df.columns:
        df["order_month"] = (
            df["order_date"]
            .dt.to_period("M")
            .astype(str)
        )

    print(
        f"Cleaned dataset contains "
        f"{len(df):,} rows."
    )

    return df


# =====================================================
# 4. DATA VALIDATION
# =====================================================

def validate_data(df):
    """Perform basic data-quality checks."""

    print("Running data validation checks...")

    validation_results = {}

    # Check duplicate records
    validation_results["duplicate_rows"] = int(
        df.duplicated().sum()
    )

    # Check missing values
    validation_results["missing_values"] = int(
        df.isnull().sum().sum()
    )

    # Check negative sales
    if "sales" in df.columns:
        validation_results["negative_sales"] = int(
            (df["sales"] < 0).sum()
        )

    # Check negative profit
    if "profit" in df.columns:
        validation_results["negative_profit"] = int(
            (df["profit"] < 0).sum()
        )

    # Check invalid quantities
    if "quantity" in df.columns:
        validation_results["invalid_quantity"] = int(
            (df["quantity"] <= 0).sum()
        )

    print("\nData Validation Results")
    print("-" * 30)

    for check, result in validation_results.items():
        print(f"{check}: {result}")

    return validation_results


# =====================================================
# 5. LOAD
# =====================================================

def load_data(df, output_file):
    """Save processed data to CSV."""

    print("\nLoading processed dataset...")

    df.to_csv(
        output_file,
        index=False
    )

    print(
        f"Processed dataset saved to: "
        f"{output_file}"
    )


# =====================================================
# 6. PIPELINE EXECUTION
# =====================================================

def main():

    pipeline_start = datetime.now()

    print("=" * 50)
    print("SALES DATA ETL PIPELINE")
    print("=" * 50)

    # Extract
    df = extract_data(INPUT_FILE)

    # Transform
    df_cleaned = clean_data(df)

    # Validate
    validation_results = validate_data(
        df_cleaned
    )

    # Load
    load_data(
        df_cleaned,
        OUTPUT_FILE
    )

    pipeline_end = datetime.now()

    print("\n" + "=" * 50)
    print("ETL PIPELINE COMPLETED SUCCESSFULLY")
    print("=" * 50)

    print(
        f"Start Time: {pipeline_start}"
    )

    print(
        f"End Time: {pipeline_end}"
    )

    print(
        f"Final Row Count: "
        f"{len(df_cleaned):,}"
    )

    print(
        f"Final Column Count: "
        f"{len(df_cleaned.columns)}"
    )


if __name__ == "__main__":
    main()
