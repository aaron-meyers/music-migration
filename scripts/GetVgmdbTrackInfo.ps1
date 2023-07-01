param(
    [Parameter()]
    [String]
    $TrackExtension = '*',

    [Parameter()]
    [String]
    $PrimaryLanguage = 'en',

    [Parameter()]
    [String]
    $SecondaryLanguage = 'ja',

    [Parameter()]
    [String]
    $PrimaryTrackName = 'English',

    [Parameter()]
    [String]
    $SecondaryTrackName = 'Japanese'
)

$infoPath = Get-Item "vgmdb-album-*.json"
if ($infoPath.Count -ne 1) {
    Write-Error "Expecting single vgmdb-album-####.json file"
    return
}

$info = Get-Content $infoPath | ConvertFrom-Json

# TODO - Get album names

# TODO - Get composers, performers

# Get track titles and merge with album/artist info
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

        [PSCustomObject] @{
            Path = $matchingTrack
            Title1 = $track.names."$PrimaryTrackName"
            Title2 = $track.names."$SecondaryTrackName"
        }

        $trackNo++
    }

    $discNo++
}