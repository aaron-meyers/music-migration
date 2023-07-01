param(
    [Parameter()]
    [String]
    $PrimaryLanguage = 'en',

    [Parameter()]
    [String]
    $AlternateLanguage = 'ja'
)

function GetNames($obj) {
    $pri = $obj.names."$PrimaryLanguage"
    $alt = $obj.names."$AlternateLanguage"
    $combined = ($pri -and $alt) ? "$pri　$alt" : "$pri$alt"
    return @{
        Primary = $pri
        Alternate = $alt
        Combined = $combined
    }
}

$infoPath = Get-Item "vgmdb-album-*.json"
if ($infoPath.Count -ne 1) {
    Write-Error "Expecting single vgmdb-album-####.json file"
    return
}

$info = Get-Content $infoPath | ConvertFrom-Json

$album = GetNames $info

$composers = $info.composers | Foreach-Object {
    if ($_.link) { GetNames $_ } }
$performers = $info.performers | Foreach-Object {
    if ($_.link) { GetNames $_ } }

return [PSCustomObject] @{
    Album = $album.Combined
    AlbumArtist = $composers.Count -gt 1 ?
        ($composers | Select-Object -ExpandProperty Primary) -join ' & ' :
        $composers[0].Combined
    Composers = $composers | Select-Object -ExpandProperty Combined
    Performers = $performers | Select-Object -ExpandProperty Combined
}