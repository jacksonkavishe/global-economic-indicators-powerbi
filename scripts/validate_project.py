#!/usr/bin/env python3
"""Check the published snapshot and reproduce the README's numerical examples.

Run from any working directory: python scripts/validate_project.py
Uses the Python standard library only. Does not run Power BI Desktop.
"""
import csv
import hashlib
import json
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read_csv(name):
    with (ROOT / 'data' / name).open(encoding='utf-8-sig', newline='') as stream:
        return list(csv.DictReader(stream))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    provenance = json.loads((ROOT / 'data/provenance.json').read_text())
    for name, expected in provenance['sha256'].items():
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        require(actual == expected, 'File differs from the published snapshot: ' + name)

    countries = read_csv('countries.csv')
    country_keys = {row['id'] for row in countries}
    require(len(countries) == len(country_keys) == 217, 'Unexpected country-key count')
    require(all(row['region'].strip() != 'Aggregates' for row in countries), 'Aggregate country in snapshot')
    require(any(row['iso2Code'] == 'NA' for row in countries), 'Namibia ISO2 code was lost')

    rows = read_csv('indicators.csv')
    observations = {}
    counts = {}
    latest = {}
    coverage_2025 = {}
    for row in rows:
        code, series, year = row['Country Code'], row['Series Code'], int(row['Year'])
        value = float(row['IndicatorValue'])
        key = (code, series, year)
        require(key not in observations, 'Duplicate observation: ' + str(key))
        require(code in country_keys, 'Unmapped source economy: ' + code)
        require(math.isfinite(value), 'Non-finite observation: ' + str(key))
        require(1973 <= year <= 2025, 'Year outside the published range')
        if series in ('SP.POP.TOTL', 'AG.LND.TOTL.K2'):
            require(value > 0, 'Invalid population or land area')
        observations[key] = value
        counts[series] = counts.get(series, 0) + 1
        latest[series] = max(year, latest.get(series, 0))
        if year == 2025:
            coverage_2025[series] = coverage_2025.get(series, 0) + 1
    require(len(rows) == 31860, 'Unexpected source observation count')
    require(counts == {'AG.LND.TOTL.K2': 10403, 'NY.GDP.MKTP.KD': 9973, 'SP.POP.TOTL': 11484}, 'Series counts differ')
    require(latest['AG.LND.TOTL.K2'] == 2024, 'Land vintage changed; review density documentation')
    require(coverage_2025 == {'NY.GDP.MKTP.KD': 186, 'SP.POP.TOTL': 217}, '2025 coverage differs')

    temperatures = read_csv('annual-temperature.csv')
    temp_years = [int(row['Year']) for row in temperatures]
    require(len(set(temp_years)) == len(temp_years) == 53, 'Invalid temperature year keys')
    require(min(temp_years) == 1973 and max(temp_years) == 2025, 'Temperature range differs')
    require(all(math.isfinite(float(row['TempC'])) for row in temperatures), 'Invalid annual temperature')

    def value(country, series, year):
        return observations[(country, series, year)]

    def gdp(country, year):
        return value(country, 'NY.GDP.MKTP.KD', year)

    def population(country, year):
        return value(country, 'SP.POP.TOTL', year)

    def per_capita(country, year):
        return gdp(country, year) / population(country, year)

    def growth(country, year):
        return (gdp(country, year) / gdp(country, year - 1) - 1) * 100

    insights = {
        'tanzania_gdp_2025_constant_2015_usd': gdp('TZA', 2025),
        'tanzania_population_2025': population('TZA', 2025),
        'tanzania_gdp_per_capita_2025': per_capita('TZA', 2025),
        'tanzania_growth_2025_percent': growth('TZA', 2025),
        'tanzania_growth_2024_percent': growth('TZA', 2024),
        'tanzania_gdp_change_2020_2025_percent': (gdp('TZA', 2025) / gdp('TZA', 2020) - 1) * 100,
        'tanzania_population_change_2020_2025_percent': (population('TZA', 2025) / population('TZA', 2020) - 1) * 100,
        'tanzania_gdp_per_capita_change_2020_2025_percent': (per_capita('TZA', 2025) / per_capita('TZA', 2020) - 1) * 100,
        'algeria_gdp_2025_constant_2015_usd': gdp('DZA', 2025),
        'algeria_gdp_per_capita_2025': per_capita('DZA', 2025),
        'andorra_gdp_2025_constant_2015_usd': gdp('AND', 2025),
        'andorra_gdp_per_capita_2025': per_capita('AND', 2025),
        'tanzania_2025_density_using_2020_land': population('TZA', 2025) / value('TZA', 'AG.LND.TOTL.K2', 2020),
    }
    require(round(insights['tanzania_growth_2025_percent'], 2) == 5.85, '2025 growth claim differs')
    require(round(insights['tanzania_gdp_change_2020_2025_percent'], 2) == 28.03, 'GDP change claim differs')
    require(round(insights['tanzania_population_change_2020_2025_percent'], 2) == 15.70, 'Population change claim differs')
    require(round(insights['tanzania_gdp_per_capita_change_2020_2025_percent'], 2) == 10.65, 'Per-capita change claim differs')
    require(population('TZA', 2025) == 70545865, 'Population headline differs')

    for document in ROOT.rglob('*.md'):
        for target in re.findall(r'\]\(([^)]+)\)', document.read_text()):
            if target.startswith(('http://', 'https://', '#', 'mailto:')):
                continue
            path = target.split('#', 1)[0]
            require((document.parent / path).exists(), 'Broken documentation link: ' + target)

    model = provenance['published_model']
    result = {
        'status': 'passed',
        'input_rows': len(rows),
        'economic_fact_rows_matching_pbix': counts['NY.GDP.MKTP.KD'] + counts['SP.POP.TOTL'],
        'source_economies': len(country_keys),
        'year_range': [1973, 2025],
        'source_coverage_2025': coverage_2025,
        'insights': insights,
        'documented_model_scope': {
            'country_dimension_rows': model['country_dimension_rows'],
            'unmatched_country_codes': model['unmatched_country_codes'],
            'land_area_vintage_for_density': model['land_area_vintage_used_for_density'],
        },
        'desktop_interactions_tested_by_this_script': False,
    }
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
