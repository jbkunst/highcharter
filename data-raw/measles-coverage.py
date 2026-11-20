from pathlib import Path
from io import BytesIO
from urllib.request import Request, urlopen
import csv
from openpyxl import load_workbook

# WHO/UNICEF Estimates of National Immunization Coverage, 2025 revision.
url = "https://data.unicef.org/wp-content/uploads/2025/07/wuenic2025rev_web-update.xlsx"
with urlopen(Request(url, headers={"User-Agent": "Mozilla/5.0"})) as response:
    workbook = load_workbook(BytesIO(response.read()), read_only=True, data_only=True)
rows = workbook["country"].values
fields = next(rows)
selected = {"AUS", "BRA", "CHL", "DEU", "IND", "JPN", "KEN", "MEX", "ZAF"}
records = []
for row in rows:
    entry = dict(zip(fields, row))
    if entry["iso3c"] in selected and entry["vaccine"] == "mcv1" and 2000 <= entry["year"] <= 2025:
        records.append((entry["iso3c"], entry["country"], entry["year"], entry["coverage"]))
assert len({(iso, year) for iso, _, year, _ in records}) == len(records) == len(selected) * 26
assert all(coverage is None or 0 <= coverage <= 100 for _, _, _, coverage in records)
with Path("vignettes/data/measles-coverage.csv").open("w", newline="", encoding="utf-8") as output:
    writer = csv.writer(output, lineterminator="\n")
    writer.writerow(["iso3", "country", "year", "coverage"])
    writer.writerows(sorted(records))
