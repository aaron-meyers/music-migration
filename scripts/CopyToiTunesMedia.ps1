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

function CleanInvalidFileNameChars([String] $name, [String] $replaceWith = '_') {
    return ($name.Split([IO.Path]::GetInvalidFileNameChars()) -join $replaceWith).Trim()
}

# Get AlbumArtist and Album from first m4a file
$mediaPath = Get-Item *.m4a | Select-Object -First 1
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

# Copy *.m4a files to target folder
Write-Host "Copying from $Path to $targetPath"
Copy-Item $Path $targetPath

if ($OpenInExplorer) {
    Start-Process $targetPath
}