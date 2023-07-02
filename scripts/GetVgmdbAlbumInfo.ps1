param(
    [Parameter()]
    [String]
    $PrimaryLanguage = 'en',

    [Parameter()]
    [String]
    $AlternateLanguage = 'ja'
)

function GetNames($obj) {
    if (-not $obj.link) {
        return
    }

    $pri = $obj.names."$PrimaryLanguage"
    $alt = $obj.names."$AlternateLanguage"
    $combined = ($pri -and $alt) ? "$pri　$alt" : "$pri$alt"
    return @{
        Primary = $pri
        Alternate = $alt
        Combined = $combined
    }
}

function MergeNames($names) {
    if ($names) {
        if ($names.Count -eq 1) {
            return $names[0].Combined
        } elseif ($names.Count -eq 2) {
            return ($names | Select-Object -ExpandProperty Primary) -join ' & '
        } elseif ($names.Count -gt 2) {
            $initial = ($names | Select-Object -SkipLast 1 -ExpandProperty Primary) -join ', '
            $last = ($names | Select-Object -Last 1 -ExpandProperty Primary)
            return "$initial & $last"
        }
    }
}

$infoPath = Get-Item "vgmdb-album-*.json"
if ($infoPath.Count -ne 1) {
    Write-Error "Expecting single vgmdb-album-####.json file"
    return
}

$info = Get-Content $infoPath | ConvertFrom-Json

$album = GetNames $info

$composers = $info.composers | Foreach-Object { GetNames $_ }
$performers = $info.performers | Foreach-Object { GetNames $_ }

$composer = MergeNames $composers
$performer = MergeNames $performers

return [PSCustomObject] @{
    Album = $album.Combined
    AlbumArtist = $composer ?? $performer
    Artist = $performer ?? $composer
    Composer = $composer
    Composers = $composers | Select-Object -ExpandProperty Combined
    Performers = $performers | Select-Object -ExpandProperty Combined
    ReleaseDate = $info.release_date
    ReleaseYear = ($info.release_date | Select-String '^(\d\d\d\d)').Matches?[0].Value
}