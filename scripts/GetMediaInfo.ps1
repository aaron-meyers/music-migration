param(
    [Parameter()]
    [String]
    $Path = '.',

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
    if ($Recurse) {
        $items = Get-ChildItem -LiteralPath $Path -Directory -Recurse |
            Foreach-Object {
                Get-ChildItem -LiteralPath $_ -Filter $Filter | Select-Object -First 1
            }
    } else {
        $items = Get-ChildItem -LiteralPath $Path -Filter $Filter | Select-Object -First 1
    }
} else {
    $items = Get-ChildItem -LiteralPath $Path -Filter $Filter -Recurse:$Recurse
}
$relativeTo = (Convert-Path .)

$items | Foreach-Object {
    $itemPath = $_
    if ($SkipProbe) {
        $itemPath
    } else {
        $probe = ffprobe $itemPath -print_format json -show_format -show_streams -v quiet |
            ConvertFrom-Json
        $tags = $probe.format.tags
        $probe.streams |
            Where-Object codec_type -eq audio |
            ForEach-Object {
                [PSCustomObject] @{
                    RelativePath = [System.IO.Path]::GetRelativePath($relativeTo, $itemPath)
                    Title = $tags.title
                    Artist = $tags.artist
                    Album = $tags.album
                    AlbumArtist = $tags.album_artist
                    Composer = $tags.composer
                    Genre = $tags.genre
                    Year = $tags.date
                    Codec = $_.codec_name
                    SampleRate = $_.sample_rate
                    Channels = $_.channels
                    ChannelLayout = $_.channel_layout
                    Duration = $_.duration
                    BitRate = $_.bit_rate
                    Path = $itemPath
                }
            }
    }
}
