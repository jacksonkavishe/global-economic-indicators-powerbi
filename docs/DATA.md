# Data sources and dictionary

## Included input snapshots

The three CSVs in `data/` are the source files supplied with this project. They are retained once, in the schema used by Power BI. They are normalized source snapshots, not untouched raw JSON responses. The PBIX additionally contains its embedded model cache, which allows the report to be opened before refreshing.

| File | Grain | Coverage |
| --- | --- | --- |
| indicators.csv | Economy × indicator × year | 31,860 non-empty observations for GDP, population and land area; 1973–2025 overall |
| countries.csv | One row per source economy | 217 non-aggregate World Bank economies |
| annual-temperature.csv | One row per completed calendar year | 53 annual observations, 1973–2025 |
| provenance.json | Publication metadata | Source URLs, vintages, model scope, checks and SHA-256 file fingerprints |

GDP has 9,973 observations, population 11,484 and land area 10,403. The model's Indicators table uses the first two series; land is used by the separate country lookup. Land observations stop at 2024. Source histories and country classifications can be revised by providers.

## World Bank indicators

| Code | Indicator | Unit | Use |
| --- | --- | --- | --- |
| NY.GDP.MKTP.KD | GDP (constant 2015 US$) | Constant 2015 US dollars | Economic output and growth |
| SP.POP.TOTL | Population, total | People | Population and per-capita calculations |
| AG.LND.TOTL.K2 | Land area | Square kilometres | Population-density denominator |

GDP per capita is derived as GDP / population. No current-dollar GDP or PPP series is used. The published population-density measure uses land area from **2020**, even though the input CSV also contains more recent land records. Read the `2025 Population Density` label as 2025 population divided by that fixed land vintage.

Economic and population observations were obtained from [World Development Indicators](https://databank.worldbank.org/source/world-development-indicators) using the [World Bank API](https://datahelpdesk.worldbank.org/knowledgebase/articles/898581-api-basic-call-structures). The supplied indicator responses record an update date of **8 October 2026**; the snapshot was retrieved on **27 October 2026**. Full request URLs are retained in provenance.

Country/economy metadata includes World Bank economies and territories, so its row count is not a count of sovereign states. Region names reflect the source classification at retrieval. Aggregate entities such as World and income groups are excluded from the input snapshots.

## Economic file fields

| Field | Type | Meaning |
| --- | --- | --- |
| Country Code | Text | World Bank three-character economy key, including provider-specific keys |
| Series Name | Text | Human-readable indicator name |
| Series Code | Text | Indicator identifier |
| Year | Integer | Annual observation year |
| IndicatorValue | Number | Value in the indicator's own unit |

The unique key is **Country Code + Series Code + Year**. Missing source observations are omitted rather than converted into zero. When parsing CSVs in pandas, retain country codes as strings and use `keep_default_na=False` so Namibia's ISO2 code `NA` is not mistaken for a missing value.

## Country and temperature fields

Country metadata provides `id`, `iso2Code`, `name`, `region`, `capitalCity`, `longitude` and `latitude`. Coordinates describe the source's country/capital location, not country boundaries.

Temperature uses `Year` and `TempC`. It is NASA GISTEMP v4's global land-ocean annual `J-D` anomaly in **degrees Celsius relative to 1951–1980**. The NASA CSV expresses these figures directly in °C. Incomplete annual observations are excluded from the supplied snapshot.

Sources: [NASA GISTEMP v4](https://data.giss.nasa.gov/gistemp/) and [data downloads](https://data.giss.nasa.gov/gistemp/data_v4.html).

## Geographic scope of the PBIX

The source files cover 217 economies. The current PBIX uses a right join to the 216 economies with a 2020 land record, so Kosovo (`XKX`) remains in the economic facts without a matching country-dimension row. Source GDP coverage for 2025 is 186 economies; 185 match the current country table. Population coverage is 217 in the source and 216 in that table.

See [validation](VALIDATION.md) for the recorded counts and interpretation notes. These distinctions explain why the region bars and source coverage counts differ.
