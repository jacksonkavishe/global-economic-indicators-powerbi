// Query name in Power BI: Source-Countries
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = Json.Document(Web.Contents("https://api.worldbank.org/v2/country/all?format=JSON&per_page=500")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Changed Type" = Table.TransformColumnTypes(#"Converted to Table",{{"Column1", type any}}),
    Column1 = #"Changed Type"{1}[Column1],
    #"Converted to Table1" = Table.FromList(Column1, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table1", "Column1", {"id", "iso2Code", "name", "region", "capitalCity", "longitude", "latitude"}, {"id", "iso2Code", "name", "region", "capitalCity", "longitude", "latitude"}),
    #"Expanded region" = Table.ExpandRecordColumn(#"Expanded Column1", "region", {"value"}, {"value"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded region",{{"value", "region"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each [region] <> "Aggregates"),
    #"Changed Type1" = Table.TransformColumnTypes(#"Filtered Rows",{{"name", type text}, {"region", type text}, {"capitalCity", type text}, {"longitude", type number}, {"latitude", type number}})
in
    #"Changed Type1"
