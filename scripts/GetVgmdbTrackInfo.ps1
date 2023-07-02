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
    $AlternateLanguage = 'ja'
)

function GetTrackNames($obj) {
    $pri = $obj.names."$PrimaryTrackName"
    $alt = $obj.names."$AlternateTrackName"
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

$albumInfo = GetVgmdbAlbumInfo -PrimaryLanguage $PrimaryLanguage -AlternateLanguage $AlternateLanguage

$info = Get-Content $infoPath | ConvertFrom-Json

$multiDisc = ($info.discs.Count -gt 1)
$discNo = 1
foreach ($disc in $info.discs) {
    $trackNo = 1
    foreach ($track in $disc.tracks) {
        $discFmt = $multiDisc ? "$discNo(-?)" : ''
        $trackFmt = '{0:#00}' -f $trackNo
        $trackRegex = "$discFmt$trackFmt.*"
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
            Artist = $albumInfo.Artist
            Album = $albumInfo.Album
            AlbumArtist = $albumInfo.AlbumArtist
            Composer = $albumInfo.Composer
            Genre = $albumInfo.Genre
            Year = $albumInfo.ReleaseYear
            Path = $matchingTrack
        }

        $trackNo++
    }

    $discNo++
}