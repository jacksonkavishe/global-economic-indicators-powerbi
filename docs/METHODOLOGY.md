# Build process and calculations

## Analytical purpose

The report supports comparison of economic scale, output per person, population and historical GDP growth. The overview supplies context across countries; drillthrough brings the reader into a single country's time series without filling the overview with additional charts.

This is a learning and portfolio project. It documents a working analytical report and does not claim a client deployment or measured operational impact.

## Source preparation

The original learning workflow included CSV import and unpivoting. The current supplied economic CSV is already in long format: Country Code, Series Name, Series Code, Year and IndicatorValue. The published PBIX selects and types these five fields rather than unpivoting them again.

The source CSV contains three World Bank series. `Indicators` filters out land area, leaving GDP and population as facts. A separate `Land Area by Country (2020)` query selects 2020 land observations; `Countries` joins those to live country metadata. `Year` takes distinct economic years and joins annual NASA anomalies using the year key. Three World Bank metadata queries are combined into a standalone metadata table.

## Data model

| Table | Grain | Rows | Purpose |
| --- | --- | ---: | --- |
| Indicators | Country × series × year | 21,457 | GDP and population facts |
| Countries | One row per retained economy | 216 | Country labels, region, coordinates and 2020 land area |
| Year | One row per year | 53 | Historical year filtering and annual temperature |
| Metadata | Indicator × metadata attribute | 45 | Source definitions |
| Measures (2) | Calculation container | 0 data rows | Eleven DAX measures |

Relationships run from the one-side dimensions into the many-side facts: `Countries[id]` → `Indicators[Country Code]` and `Year[Year]` → `Indicators[Year]`. Both are active and single direction. Metadata is independent of those two relationships.

## Core measures

| Measure | Logic | Units |
| --- | --- | --- |
| GDP | Sum IndicatorValue where Series Code = NY.GDP.MKTP.KD | Constant 2015 US$ |
| Population | Sum IndicatorValue where Series Code = SP.POP.TOTL | People |
| GDP per Capita | GDP / Population | Constant 2015 US$ per person |
| GDP Annual Growth % | (GDP for year t − GDP for year t−1) / GDP for year t−1 | Percentage after formatting |
| 2025 Population Density | 2025 Population / sum of country Land Area (2020) | People/km² |
| TEMPERATURE | Sum Year[TempC] within the year context | °C anomaly relative to 1951–1980 |

The overview and detail cards intentionally use the four fixed `2025 ...` measures in this version. They are not controlled by a disconnected reporting-year slicer. No unimplemented replacement measures are presented as the published model.

The annual-growth measure uses readable variables for the current year, current GDP, previous GDP, difference and rate. Its percentage format supplies the ×100 display. The source definition is preserved in `src/dax/measures.dax`.

## Visual choices and interaction

- The country comparison table keeps absolute GDP and GDP per capita close together.
- Conditional formatting directs attention to differences without adding another chart.
- Sparklines retain historical context for each country.
- The country-detail chart pairs yearly growth rates with the GDP level; its annual table supplies exact values.
- Drillthrough is bound to country ID, ISO2 code and country name. Right-click a country in the overview, open Country detail, and use the back arrow to return.
- The metadata page explains the indicators and their origins.

The screenshot is the author's Tanzania demonstration. The PBIX contains a saved Kenya detail-page filter from its editing state; entering the page through Tanzania's drillthrough sets the requested country context.

## Insight calculation

Percentage changes are calculated on the included annual observations using `(end / start − 1) × 100`. The Algeria/Andorra comparison uses GDP divided by same-year population. `scripts/validate_project.py` recomputes these examples and checks their expected values.
