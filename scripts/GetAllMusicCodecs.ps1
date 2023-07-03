param(
    [Parameter()]
    [String]
    $Path = 'codecs.csv',

    [Parameter()]
    [Switch]
    $Force
)

if (Test-Path $Path) {
    # Backup existing codecs.csv first
    if ($Force -and (Test-Path "$Path.bak")) {
        Remove-Item "$Path.bak"
    }
    Move-Item $Path "$Path.bak"
}

$extensions = @(
    '*.wma',
    '*.m4a',
    '*.flac',
    '*.mp3',
    '*.ogg'
)

$output = foreach ($ext in $extensions) {
    GetMediaInfo -Filter $ext -First -Recurse
}
$output | Export-Csv $Path
