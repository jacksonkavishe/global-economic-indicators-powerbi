# Open, refresh and reproduce

## Open the report

1. Download the repository using **Code → Download ZIP**, or clone it.
2. Extract the download and open `report/Global-Economic-Indicators.pbix` in a current version of **Power BI Desktop** on Windows.
3. Explore the embedded data first. In Overview, right-click a country and select **Drill through → Country detail**. The back arrow returns to Overview; the Metadata navigation opens source definitions.

The screenshots in the README show the overview and Tanzania detail page supplied by the author. GitHub previews those images; it does not execute the PBIX.

## Point the queries to the downloaded files

The PBIX preserves the author's original local CSV paths. Before selecting Refresh:

1. Open **Home → Transform data**.
2. Select **Source-indicators**. In its Source step, browse to your extracted repository's `data/indicators.csv`. If editing Advanced Editor, change only the `File.Contents(...)` path to that file. Keep the existing transformations.
3. Select **nasa-global-temp-data** and point its Source step to `data/annual-temperature.csv`.
4. Leave **Source-Countries** and the three **Source_metadata_...** queries on the World Bank API. Choose **Anonymous** authentication for the public World Bank domain if requested.
5. Select **Close & Apply**, then **Refresh**. An internet connection is needed for the country and metadata API queries.
6. Confirm the two active relationships remain in place, inspect a country with 2025 GDP, and test drillthrough/back navigation.

`data/countries.csv` preserves the supplied country snapshot for inspection. The PBIX's Source-Countries query uses live API metadata, so a later refresh can reflect provider revisions and updated country classifications.

## Verify the snapshot without Power BI

Python 3.9+ is sufficient; the validation script uses only the standard library.

```bash
python scripts/validate_project.py
```

It checks the source-file hashes, country/series/year keys, source coverage, year boundaries, country references, image/PBIX presence, and the figures quoted in the README. Its JSON output includes known model-scope differences. It does not replace Power BI Desktop interaction tests.

## Source definitions

`src/dax/measures.dax` contains the eleven measures extracted from this PBIX. `src/power-query/` contains its M definitions, with the exact model query names mapped in `query-index.json`. These exports are reference source, not a second runnable PBIP project or a batch DAX deployment script.

The published version uses a **2025** headline year and a **2020** land-area lookup. Updating beyond this snapshot requires deliberately replacing the input data and reviewing both those fixed-year calculations. It is not an automatic live-data report.

## Storage choices

The repository retains one PBIX, two report images, three input CSVs and one set of source definitions. It omits the uploaded working archive, redundant screenshots, derived latest-value CSVs and superseded update plans. GitHub can create a ZIP on download, so committing another ZIP would duplicate the same project.
