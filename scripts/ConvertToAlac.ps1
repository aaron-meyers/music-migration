param(
    [Parameter()]
    [String]
    $Path,

    [Parameter()]
    [Switch]
    $Force
)

# Only include (potentially) lossless extensions
$extensions = @(
    '*.wma',
    '*.flac',
    '*.wav'
)

foreach ($filter in $extensions) {
    Get-ChildItem $Path -Filter $filter | ForEach-Object {
        $ext = Split-Path $_ -Extension
        if ($ext -eq '.wma') {
            Write-Warning "Some WMA metadata may be corrupted when converting via ffmpeg"

            $codec = (GetMediaInfo $_).codec
            if ($codec -ne 'wmalossless') {
                if ($Force) {
                    Write-Warning "Found non-lossless codec $codec, converting anyway"
                } else {
                    Write-Error "Found non-lossless codec $codec, aborting"
                    return
                }
            }
        }

        $parent = Split-Path $_ -Parent
        $f = Split-Path $_ -LeafBase
        $target = Join-Path $parent "$f.m4a"

        # -c:v copy should copy embedded artwork in theory
        ffmpeg -i $_ -c:a alac -c:v copy $target

        $bakPath = Join-Path $parent 'bak'
        if (-not (Test-Path $bakPath)) {
            [void] (New-Item $bakPath -Type Directory)
        }
        Move-Item $_ $bakPath
    }
}