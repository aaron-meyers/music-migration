param(
    [Parameter()]
    [String]
    $Path = '*.m4a',

    [Parameter()]
    [String]
    $iTunesMediaPath = "~/Music/iTunes/iTunes Media/Music",

    [Parameter()]
    [Switch]
    $OpenInExplorer
)

Import-Module "$PSScriptRoot/modules/utils.psm1" -Scope Local

# Get AlbumArtist and Album from first file
$mediaPath = Get-Item $Path | Select-Object -First 1
if (-not $mediaPath) {
    throw "Cannot find any files matching $Path"
}
$mediaInfo = GetMediaInfo $mediaPath

# Convert to clean directory names
$artistDirName = CleanInvalidFileNameChars $mediaInfo.AlbumArtist
$albumDirName = CleanInvalidFileNameChars $mediaInfo.Album

# Create directory if not exists
$targetDir = Join-Path $iTunesMediaPath $artistDirName $albumDirName
if (-not (Test-Path $targetDir)) {
    [void] (New-Item $targetDir -Type Directory)
}

$targetPath = Convert-Path $targetDir

# Copy files to target folder
Write-Host "Copying from $Path to $targetPath"
Copy-Item $Path $targetPath

if ($OpenInExplorer) {
    Start-Process $targetPath
}