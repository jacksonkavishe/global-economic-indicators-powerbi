// Query name in Power BI: nasa-global-temp-data
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = Csv.Document(File.Contents("D:\Desktop\PowerBI\global-economic-indicators\data\annual-temperature.csv"),[Delimiter=",", Columns=2, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Year", Int64.Type}, {"TempC", type number}})
in
    #"Changed Type"
