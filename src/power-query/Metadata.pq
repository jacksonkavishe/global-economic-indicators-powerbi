// Query name in Power BI: Metadata
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = Table.Combine({Source_metadata_population, Source_metadata_GDP, #"Source_metadata_GDP-per-capita"}),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"id.1", type text}, {"id", type text}, {"value", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"id", "Series"}, {"id.1", "Metadata"}, {"value", "Metadata Value"}})
in
    #"Renamed Columns"
