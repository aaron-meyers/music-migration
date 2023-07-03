param(
    [Parameter(Mandatory=$true)]
    [int]
    $AlbumId
)

$uri = "https://vgmdb.info/album/$($AlbumId)?format=json"
$outFile = "vgmdb-album-$AlbumId.json"
Write-Host "Downloading $AlbumId from $uri"
Invoke-WebRequest -Uri $uri -OutFile $outFile -Retry 10
if (-not (Test-Path $outFile)) {
    Write-Error "Failed to download $uri to $outFile"
    return
}

$info = Get-Content $outFile | ConvertFrom-Json
$coverUri = $info.picture_full
if ($coverUri) {
    $coverExt = Split-Path $coverUri -Extension
    $artworkFile = "vgmdb-album-$AlbumId$coverExt"
    Write-Host "Downloading cover art to $artworkFile from $coverUri"
    Invoke-WebRequest -Uri $coverUri -OutFile $artworkFile
} else {
    Write-Warning "Missing artwork"
}