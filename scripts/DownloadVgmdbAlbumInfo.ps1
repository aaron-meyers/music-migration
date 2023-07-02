param(
    [Parameter(Mandatory=$true)]
    [int]
    $AlbumId
)

$uri = "https://vgmdb.info/album/$($AlbumId)?format=json"
$outFile = "vgmdb-album-$AlbumId.json"
Write-Host "Downloading $AlbumId from $uri"
Invoke-WebRequest -Uri $uri -OutFile $outFile
if (-not (Test-Path $outFile)) {
    Write-Error "Failed to download $uri to $outFile"
    return
}

$info = Get-Content $outFile | ConvertFrom-Json
$coverUri = $info.picture_full
if ($coverUri) {
    Write-Host "Downloading cover art to folder.jpg from $coverUri"
    Invoke-WebRequest -Uri $coverUri -OutFile folder.jpg
}