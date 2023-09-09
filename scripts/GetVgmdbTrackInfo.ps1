param(
    [Parameter()]
    [String]
    $TrackExtension = '*',

    [Parameter()]
    [String]
    $PrimaryTrackName = 'English',

    [Parameter()]
    [String]
    $AlternateTrackName = 'Japanese',

    [Parameter()]
    [String]
    $PrimaryLanguage = 'en',

    [Parameter()]
    [String]
    $AlternateLanguage = 'ja',

    # Album value overrides - these are not typed because default should be $null

    [Parameter()]
    $Artist,

    [Parameter()]
    $Album,

    [Parameter()]
    $AlbumArtist,

    [Parameter()]
    $Composer,

    [Parameter()]
    $Genre,

    [Parameter()]
    $Year,

    [Parameter()]
    $Artwork
)

function GetTrackNames($obj) {
    $pri = $obj.names."$PrimaryTrackName"
    $alt = $obj.names."$AlternateTrackName"
    $combined = ($pri -and $alt) ?
        (($pri -ne $alt) ?  "$pri　$alt" : $pri) :
        "$pri$alt"
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

$albumInfo = GetVgmdbAlbumInfo -PrimaryLanguage $PrimaryLanguage -AlternateLanguage $AlternateLanguage

$info = Get-Content -LiteralPath $infoPath | ConvertFrom-Json

$multiDisc = ($info.discs.Count -gt 1)
$discNo = 1
foreach ($disc in $info.discs) {
    $trackNo = 1
    foreach ($track in $disc.tracks) {
        $discFmt = $multiDisc ? "$discNo(-?)" : ''
        $trackFmt = '{0:#00}' -f $trackNo
        $trackRegex = "^$discFmt$trackFmt.*"
        $matchingTrack = Get-ChildItem -Filter "*.$TrackExtension" |
            Where-Object Name -match $trackRegex
        if ($matchingTrack.Count -ne 1) {
            Write-Error "Expecting single track to match $trackRegex"
            return
        }

        $trackNames = GetTrackNames $track

        [PSCustomObject] @{
            Disc = $multiDisc ? $discNo : $null
            Track = $trackNo
            Title = $trackNames.Combined
            AllTitles = $track.names
            Artist = $Artist ?? $albumInfo.Artist
            Album = $Album ?? $albumInfo.Album
            AlbumArtist = $AlbumArtist ?? $albumInfo.AlbumArtist
            Composer = $Composer ?? $albumInfo.Composer
            Genre = $Genre ?? $albumInfo.Genre
            Year = $Year ?? $albumInfo.ReleaseYear
            Artwork = $Artwork ?? $albumInfo.Artwork
            Path = $matchingTrack
        }

        $trackNo++
    }

    $discNo++
}