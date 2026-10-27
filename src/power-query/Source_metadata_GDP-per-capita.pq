// Query name in Power BI: Source_metadata_GDP-per-capita
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = Json.Document(Web.Contents("https://api.worldbank.org/v2/sources/2/series/NY.GDP.PCAP.KD/metadata?format=JSON")),
    #"Converted to Table" = Table.FromRecords({Source}),
    #"Expanded source" = Table.ExpandListColumn(#"Converted to Table", "source"),
    #"Expanded source1" = Table.ExpandRecordColumn(#"Expanded source", "source", {"id", "name", "concept"}, {"source.id", "source.name", "source.concept"}),
    #"Expanded source.concept" = Table.ExpandListColumn(#"Expanded source1", "source.concept"),
    #"Expanded source.concept1" = Table.ExpandRecordColumn(#"Expanded source.concept", "source.concept", {"id", "variable"}, {"source.concept.id", "source.concept.variable"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded source.concept1",{{"page", Int64.Type}, {"pages", Int64.Type}, {"per_page", Int64.Type}, {"total", Int64.Type}, {"source.id", Int64.Type}, {"source.name", type text}, {"source.concept.id", type text}, {"source.concept.variable", type any}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Changed Type",{"source.concept.variable"}),
    #"Expanded source.concept.variable" = Table.ExpandListColumn(#"Removed Other Columns", "source.concept.variable"),
    #"Expanded source.concept.variable1" = Table.ExpandRecordColumn(#"Expanded source.concept.variable", "source.concept.variable", {"id", "metatype"}, {"id", "metatype"}),
    #"Expanded metatype" = Table.ExpandListColumn(#"Expanded source.concept.variable1", "metatype"),
    #"Expanded metatype1" = Table.ExpandRecordColumn(#"Expanded metatype", "metatype", {"id", "value"}, {"id.1", "value"})
in
    #"Expanded metatype1"
