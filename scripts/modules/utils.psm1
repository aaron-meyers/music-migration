function ArgsToArray { return $args }

function CleanInvalidFileNameChars([String] $name, [String] $replaceWith = '_') {
    return ($name.Split([IO.Path]::GetInvalidFileNameChars()) -join $replaceWith).Trim()
}

Export-ModuleMember -Function *