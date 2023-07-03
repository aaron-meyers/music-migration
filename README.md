# music-migration
Scripts and tools for migrating music to Apple iCloud Music Library.

## Workflow
See [workflow.gv](/workflow.gv) ([svg](/artifacts/workflow.gv.svg))

## Prerequisites
- ffmpeg: ```scoop install ffmpeg```
- AtomicParsley: ```scoop install atomicparsley```
- ImageMagick: ```scoop install imagemagick```

## Usage
Initialize environment (adds scripts/ to PATH):
```powershell
scripts/InitEnvironment.ps1
```

Dump codec and other metadata to a codecs.csv file:
```powershell
GetAllMusicCodecs.ps1

# Remove any paths from codecs.csv that no longer exist
CleanMusicCodecCsv.ps1
```

Convert all lossless media files in a directory to ALAC:
```powershell
ConvertToAlac.ps1
```

Download [vgmdb.net](https://vgmdb.net) album info and artwork (via [vgmdb.info](https://vgmdb.info)):
```powershell
DownloadVgmdbAlbumInfo.ps1 -AlbumId <id>
```

View and apply album/track info from vgmdb.net:
```powershell
GetVgmdbAlbumInfo.ps1
GetVgmdbTrackInfo.ps1
GetVgmdbTrackInfo.ps1 | ApplyVgmdbTrackInfo.ps1 -Tag -Rename
```

Copy to iTunes Media folder:
```powershell
CopyToiTunesMedia.ps1
```

Move to target folder under artist/album directory:
```
TODO - refactor CopyToiTunesMedia script
```

## Configuring iTunes for migration
- Change iTunes Import Settings (Edit > Preferences) to use ALAC instead of AAC

## Other potential resources
### Apps
- [Mp3tag - the universal Tag Editor (ID3v2, MP4, OGG, FLAC, ...)](https://www.mp3tag.de/en/)

### Libraries
- [mono/taglib-sharp: Library for reading and writing metadata in media files (github.com)](https://github.com/mono/taglib-sharp)
    - [NuGet Gallery | TagLibSharp 2.2.0](https://www.nuget.org/packages/TagLibSharp)
