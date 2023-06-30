param(
    [Parameter()]
    [String]
    $Path,

    [Parameter()]
    [Switch]
    $Force
)

if ($Force -and (Test-Path "$Path.bak")) {
    Remove-Item "$Path.bak"
}
$bakPath = Move-Item $Path "$Path.bak" -PassThru
Import-Csv $bakPath |
    ForEach-Object { if (Test-Path -LiteralPath $_.Path) { $_ } } |
    Export-Csv $Path
