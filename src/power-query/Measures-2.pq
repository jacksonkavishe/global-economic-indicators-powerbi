// Query name in Power BI: Measures (2)
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i44FAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [_ = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"_", type text}})
in
    #"Changed Type"
