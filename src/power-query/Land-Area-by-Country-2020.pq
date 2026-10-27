// Query name in Power BI: Land Area by Country (2020)
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = #"Source-indicators",
    #"Filtered Rows" = Table.SelectRows(Source, each ([Series Code] = "AG.LND.TOTL.K2") and ([Year] = 2020)),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Series Name", "Series Code", "Year"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"IndicatorValue", "Land Area"}})
in
    #"Renamed Columns"
