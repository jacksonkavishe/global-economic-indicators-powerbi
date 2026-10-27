// Query name in Power BI: Year
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = #"Source-indicators",
    #"Filtered Rows" = Table.SelectRows(Source, each [Series Code] <> "AG.LND.TOTL.K2"),
    Year1 = #"Filtered Rows"[Year],
    #"Removed Duplicates" = List.Distinct(Year1),
    #"Converted to Table" = Table.FromList(#"Removed Duplicates", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Merged Queries" = Table.NestedJoin(#"Converted to Table", {"Column1"}, #"nasa-global-temp-data", {"Year"}, "nasa-global-temp-data", JoinKind.LeftOuter),
    #"Expanded nasa-global-temp-data" = Table.ExpandTableColumn(#"Merged Queries", "nasa-global-temp-data", {"TempC"}, {"TempC"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded nasa-global-temp-data",{{"Column1", Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1", "Year"}})
in
    #"Renamed Columns"
