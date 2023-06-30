# Add scripts directory to the PATH
$env:PATH = '{0}{1}{2}' -f $PSScriptRoot,[IO.Path]::PathSeparator,$env:PATH

