# Required for correct UTF-8 output from ffprobe
[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Add scripts directory to the PATH
$env:PATH = '{0}{1}{2}' -f $PSScriptRoot,[IO.Path]::PathSeparator,$env:PATH

