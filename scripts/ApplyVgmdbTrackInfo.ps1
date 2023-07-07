param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    $InputObject,

    [Parameter()]
    [Switch]
    $Tag,

    [Parameter()]
    [Switch]
    $Rename,

    [Parameter()]
    [int]
    $MaxFileNameLength = 80
)

begin {
    Import-Module "$PSScriptRoot/modules/utils.psm1" -Scope Local
}

process {
    $path = $InputObject.Path
    if (-not $path) {
        Write-Warning "Missing Path property on InputObject, skipping"
        return
    }
    if (-not (Test-Path $path)) {
        Write-Warning "The specified Path does not exist, skipping"
        return
    }

    $fileName = Split-Path $path -Leaf
    $ext = Split-Path $path -Extension

    if (-not $Tag -and -not $Rename) {
        Write-Warning "Neither -Tag nor -Rename is specified, nothing to do"
        return
    }

    if ($Tag) {
        if ($ext -ne '.m4a') {
            Write-Warning "Cannot apply tags to non-m4a file currently, skipping"
            return
        }

        Write-Host "Writing tags to $fileName"

        $cmdargs = @($path)

        if ($InputObject.Title) {
            $cmdargs += ArgsToArray --title $InputObject.Title
        }
        if ($InputObject.Artist) {
            $cmdargs += ArgsToArray --artist $InputObject.Artist
        }
        if ($InputObject.Album) {
            $cmdargs += ArgsToArray --album $InputObject.Album
        }
        if ($InputObject.AlbumArtist) {
            $cmdargs += ArgsToArray --albumArtist $InputObject.AlbumArtist
        }
        if ($InputObject.Composer) {
            $cmdargs += ArgsToArray --composer $InputObject.Composer
        }
        if ($InputObject.Genre) {
            $cmdargs += ArgsToArray --genre $InputObject.Genre
        }
        if ($InputObject.Year) {
            $cmdargs += ArgsToArray --year $InputObject.Year
        }
        if ($InputObject.Track) {
            $cmdargs += ArgsToArray --tracknum $InputObject.Track
        }
        if ($InputObject.Disc) {
            $cmdargs += ArgsToArray --disk $InputObject.Disc
        }
        if ($InputObject.Artwork) {
            $cmdargs += ArgsToArray --artwork $InputObject.Artwork

            # Delete any existing artwork first
            atomicparsley $path --artwork REMOVE_ALL --overWrite
        }

        $cmdargs += '--overWrite'

        Write-Verbose "atomicparsley $cmdargs"
        & 'atomicparsley' $cmdargs
        Write-Host ''
    }

    if ($Rename) {
        $targetName = '{0}{1:#00} {2}' -f $InputObject.Disc,$InputObject.Track,$InputObject.Title
        $targetName = CleanInvalidFileNameChars $targetName
        if ($targetName.Length -gt $MaxFileNameLength) {
            $targetName = $targetName.Substring(0, $MaxFileNameLength)
        }
        $targetName += $ext
        if ($targetName -ne $fileName) {
            Write-Host "Renaming $fileName to $targetName"
            $targetPath = Join-Path (Split-Path $path -Parent) $targetName
            Move-Item $path $targetPath
        }
    }
}
