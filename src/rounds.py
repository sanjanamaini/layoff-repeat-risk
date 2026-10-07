"""Layoff rounds in Python, mirroring sql/queries/03 and 04, so the survival analysis in
notebooks/repeat_risk.ipynb starts from exactly the companies and rounds the SQL produces.

Rules (decisions 0006 and 0008): company names are merged as in the loader; events from the same
company within `merge_days` of the previous event belong to the same round (gap measured between
consecutive events, as SQL's LAG does).
"""
from __future__ import annotations

from pathlib import Path

import pandas as pd

NAME_FIXES = {"Tiktok": "TikTok", "theGist": "The Gist"}
DATA_END = pd.Timestamp("2026-09-20")


def load(csv_path: Path) -> pd.DataFrame:
    d = pd.read_csv(csv_path, dtype=str).fillna("")
    d["company"] = d["company"].str.strip().map(lambda c: NAME_FIXES.get(c, c))
    d["date"] = pd.to_datetime(d["date"].str.strip(), format="%m/%d/%Y")
    d["num_laid_off"] = pd.to_numeric(d["num_laid_off"].str.replace(",", "").str.strip(), errors="coerce")
    d["pct"] = pd.to_numeric(d["pct_workforce"].str.rstrip("%").str.strip(), errors="coerce") / 100
    for c in ("country", "industry", "location_hq"):
        d[c] = d[c].str.strip()
    return d.sort_values(["company", "date"]).reset_index(drop=True)


def rounds(d: pd.DataFrame, merge_days: int = 14) -> pd.DataFrame:
    """One row per event with its round number within the company."""
    e = d.sort_values(["company", "date"]).copy()
    gap = e.groupby("company")["date"].diff().dt.days
    e["new_round"] = (gap.isna() | (gap > merge_days)).astype(int)
    e["round"] = e.groupby("company")["new_round"].cumsum()
    return e


def companies(e: pd.DataFrame) -> pd.DataFrame:
    """One row per company: first and second round dates and the first round's characteristics."""
    first = e[e["round"] == 1].groupby("company").agg(first_round=("date", "min"), first_pct=("pct", "max"),
                                                      first_count=("num_laid_off", "sum"), events_in_first=("date", "size"),
                                                      industry=("industry", "first"), country=("country", "first"))
    first["first_count"] = first["first_count"].where(e[e["round"] == 1].groupby("company")["num_laid_off"].count() > 0)
    second = e[e["round"] == 2].groupby("company")["date"].min().rename("second_round")
    c = first.join(second)
    c["rounds"] = e.groupby("company")["round"].max()
    c["days_to_second"] = (c["second_round"] - c["first_round"]).dt.days
    c["follow_up_days"] = (DATA_END - c["first_round"]).dt.days
    c["event"] = c["second_round"].notna().astype(int)
    c["duration"] = c["days_to_second"].where(c["event"] == 1, c["follow_up_days"])
    return c
