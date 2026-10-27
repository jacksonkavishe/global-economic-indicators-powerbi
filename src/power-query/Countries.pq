// Query name in Power BI: Countries
// Exported from the published report; local CSV paths must be changed before refresh.
let
    Source = Table.NestedJoin(#"Source-Countries", {"id"}, #"Land Area by Country (2020)", {"Country Code"}, "Land Area by Country (2020)", JoinKind.RightOuter),
    #"Expanded Land Area by Country (2020)" = Table.ExpandTableColumn(Source, "Land Area by Country (2020)", {"Land Area"}, {"Land Area"})
in
    #"Expanded Land Area by Country (2020)"
