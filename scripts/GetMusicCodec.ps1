param(
    [Parameter()]
    [String]
    $Path,

    [Parameter()]
    [String]
    $Filter,

    [Parameter()]
    [Switch]
    $Recurse,

    [Parameter()]
    [Switch]
    $First,

    [Parameter()]
    [Switch]
    $SkipProbe
)

if ($First) {
    $items = Get-ChildItem $Path -Directory -Recurse:$Recurse |
        Foreach-Object {
            Get-ChildItem -LiteralPath $_ -Filter $Filter | Select-Object -First 1
        }
} else {
    $items = Get-ChildItem $Path -Filter $Filter -Recurse:$Recurse
}

$items | Foreach-Object {
    $itemPath = $_
    if ($SkipProbe) {
        $itemPath
    } else {
        $probe = ffprobe $itemPath -print_format json -show_format -show_streams -v quiet |
            ConvertFrom-Json
        $probe.streams |
            Where-Object codec_type -eq audio |
            ForEach-Object {
                [PSCustomObject] @{
                    Path = $itemPath
                    Codec = $_.codec_name
                }
            }
    }
}
