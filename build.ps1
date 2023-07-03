if (-not (Test-Path ./artifacts)) {
    [void] (New-Item ./artifacts -Type Directory)
}

# Update workflow.gv.svg
dot ./workflow.gv -Tsvg -o./artifacts/workflow.gv.svg
