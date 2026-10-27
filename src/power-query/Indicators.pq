// Query name in Power BI: Indicators
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = #"Source-indicators",
    #"Filtered Rows" = Table.SelectRows(Source, each [Series Code] <> "AG.LND.TOTL.K2")
in
    #"Filtered Rows"
