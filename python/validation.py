"""
Sales Data Engineering Project
Automated Data Quality Validation

Purpose:
- Validate processed sales data
- Detect missing values
- Detect duplicate records
- Check invalid numeric values
- Generate a validation report
"""

import pandas as pd
from pathlib import Path
from datetime import datetime


# =====================================================
# 1. CONFIGURATION
# =====================================================

INPUT_FILE = Path(
    "data/processed/sales_cleaned.csv"
)

REPORT_DIR = Path(
    "data/output"
)

REPORT_FILE = REPORT_DIR / "validation_report.csv"

REPORT_DIR.mkdir(
    parents=True,
    exist_ok=True
)


# =====================================================
# 2. LOAD DATA
# =====================================================

def load_data(file_path):
    """Load processed dataset."""

    print("Loading processed dataset...")

    df = pd.read_csv(file_path)

    print(
        f"Loaded {len(df):,} rows "
        f"and {len(df.columns)} columns."
    )

    return df


# =====================================================
# 3. DATA QUALITY CHECKS
# =====================================================

def run_validation_checks(df):

    print("\nRunning data quality checks...")

    results = []

    # -----------------------------------------------
    # Check 1: Total Records
    # -----------------------------------------------

    results.append({
        "check_name": "Total Records",
        "result": len(df),
        "status": "PASS"
    })


    # -----------------------------------------------
    # Check 2: Duplicate Records
    # -----------------------------------------------

    duplicate_count = int(
        df.duplicated().sum()
    )

    results.append({
        "check_name": "Duplicate Records",
        "result": duplicate_count,
        "status": (
            "PASS"
            if duplicate_count == 0
            else "FAIL"
        )
    })


    # -----------------------------------------------
    # Check 3: Missing Values
    # -----------------------------------------------

    missing_count = int(
        df.isnull().sum().sum()
    )

    results.append({
        "check_name": "Missing Values",
        "result": missing_count,
        "status": (
            "PASS"
            if missing_count == 0
            else "WARNING"
        )
    })


    # -----------------------------------------------
    # Check 4: Negative Sales
    # -----------------------------------------------

    if "sales" in df.columns:

        negative_sales = int(
            (df["sales"] < 0).sum()
        )

        results.append({
            "check_name": "Negative Sales",
            "result": negative_sales,
            "status": (
                "PASS"
                if negative_sales == 0
                else "WARNING"
            )
        })


    # -----------------------------------------------
    # Check 5: Invalid Quantity
    # -----------------------------------------------

    if "quantity" in df.columns:

        invalid_quantity = int(
            (df["quantity"] <= 0).sum()
        )

        results.append({
            "check_name": "Invalid Quantity",
            "result": invalid_quantity,
            "status": (
                "PASS"
                if invalid_quantity == 0
                else "FAIL"
            )
        })


    # -----------------------------------------------
    # Check 6: Missing Order IDs
    # -----------------------------------------------

    if "order_id" in df.columns:

        missing_order_ids = int(
            df["order_id"].isnull().sum()
        )

        results.append({
            "check_name": "Missing Order IDs",
            "result": missing_order_ids,
            "status": (
                "PASS"
                if missing_order_ids == 0
                else "FAIL"
            )
        })


    return pd.DataFrame(results)


# =====================================================
# 4. SAVE VALIDATION REPORT
# =====================================================

def save_report(validation_results):

    validation_results["validation_timestamp"] = (
        datetime.now()
    )

    validation_results.to_csv(
        REPORT_FILE,
        index=False
    )

    print(
        f"\nValidation report saved to: "
        f"{REPORT_FILE}"
    )


# =====================================================
# 5. MAIN PIPELINE
# =====================================================

def main():

    print("=" * 50)
    print("AUTOMATED DATA QUALITY VALIDATION")
    print("=" * 50)

    # Load processed data
    df = load_data(INPUT_FILE)

    # Run validation
    validation_results = (
        run_validation_checks(df)
    )

    # Display results
    print("\nValidation Results")
    print("-" * 30)

    print(
        validation_results.to_string(
            index=False
        )
    )

    # Save report
    save_report(
        validation_results
    )

    print("\nValidation process completed.")


# =====================================================
# 6. RUN SCRIPT
# =====================================================

if __name__ == "__main__":
    main()
