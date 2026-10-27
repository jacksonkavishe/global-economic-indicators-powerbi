# Publication validation

Checked against the newly supplied `Global Economic Data.pbix` and project ZIP on **27 October 2026**. The report and two published images are the author's supplied files. The report binary has not been rewritten by this publication workflow.

## Checks completed

| Check | Result |
| --- | --- |
| Report structure | Three pages: Overview, Country detail and Metadata |
| Model | Five tables; eleven DAX measures; two active single-direction many-to-one relationships |
| Stored GDP/population coverage | 1973–2025; 21,457 observations |
| Source/model reconciliation | All 21,457 GDP/population rows matched on country, series and year; largest numeric difference approximately 1.2×10⁻⁷ from representation |
| Source observation keys | 31,860 unique country/series/year keys; no duplicates |
| Fact null values | None in the supplied economic snapshot or embedded Indicators table |
| Country dimension key | Unique IDs across 216 loaded rows |
| Year dimension key | 53 unique years, 1973–2025 |
| Temperature | Completed annual NASA observations through 2025 |
| Headline values | Tanzania's GDP, population, per-capita GDP and growth independently recalculated from the source CSV |
| README insights | Tanzania changes and Algeria/Andorra comparison independently recalculated |
| Publication files | One canonical PBIX, two screenshots, three CSV inputs; file hashes recorded |
| Source exports | Eleven DAX definitions and twelve M queries extracted from this exact report |
| Navigation definitions | Country ID, ISO2 code and name are bound to the Country detail drillthrough page; a back button is present |

Run `python scripts/validate_project.py` from the repository to recheck the source snapshot, fingerprints, linked files and published numerical examples. The script uses only Python's standard library.

## Recorded model limits

1. **Country mapping:** the input country snapshot contains 217 economies; the PBIX's right join to 2020 land observations retains 216. Kosovo (`XKX`) exists in the economic facts without a country-dimension match. For 2025 GDP, 186 economies have source observations and 185 match the country table. The README reports these distinct scopes.
2. **Density vintage:** the report's 2025 density uses 2025 population and 2020 land area. The denominator's vintage is documented; it has not been represented as 2025 land data.
3. **Presentation:** million-unit rounding can display small populations as `0M`. The detail-table totals accumulate across years and are not a current population count or a single-year GDP. Read annual rows and source data for precise interpretation.
4. **Fixed reporting year:** the four headline measures explicitly use 2025. This is a 2025 snapshot, not an automatically advancing current-year report.
5. **Saved editing state:** the detail page has a saved Kenya filter. Entering the page through another country's drillthrough applies that country context; the supplied screenshot demonstrates Tanzania.

These are documented characteristics of the provided PBIX. The publication does not silently replace it with an untested regenerated model.

## Verification boundary

The model data, source code and report definitions were inspected programmatically, and the report images were supplied by the author. Power BI Desktop was not available in the publishing environment, so a new Desktop refresh, native rendering and end-to-end interaction test were not performed here. The checks above do not claim otherwise.

Future model edits should be checked in Desktop before replacing the published PBIX, with the screenshots and extracted definitions updated at the same time.
