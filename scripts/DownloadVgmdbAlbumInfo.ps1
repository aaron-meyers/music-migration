param(
    [Parameter(Mandatory=$true)]
    [int]
    $AlbumId
)

$uri = "https://vgmdb.info/album/$($AlbumId)?format=json"
$outFile = "vgmdb-album-$AlbumId.json"
Write-Verbose "Downloading $AlbumId from $uri"
Invoke-WebRequest -Uri $uri -OutFile $outFile
if (-not (Test-Path $outFile)) {
    Write-Error "Failed to download $uri to $outFile"
}