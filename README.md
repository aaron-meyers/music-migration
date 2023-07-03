# music-migration
Scripts and tools for migrating music to Apple iCloud Music Library

## Prerequisites
- ffmpeg: ```scoop install ffmpeg```
- AtomicParsley: ```scoop install atomicparsley```

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

Download vgmdb.net album info and artwork:
```powershell
DownloadVgmdbAlbumInfo.ps1 -AlbumId <id>
```

View and apply album/track info from vgmdb.net:
```powershell
GetVgmdbAlbumInfo.ps1
GetVgmdbTrackInfo.ps1
GetVgmdbTrackInfo.ps1 | ApplyVgmdbTrackInfo.ps1 -Tag -Rename
```

## Target folder structure
- collection
  - apple-music-matches[-lossy]
  - icloud-music-pending-rerip
  - icloud-music-pending-tags
  - icloud-music-uploads[-lossy]
  - itunes-store-matches[-lossy]
  - itunes-store-purchases
- downloads
  - apple-music-matches[-lossy]
  - icloud-music-pending-tags
  - icloud-music-uploads[-lossy]
  - itunes-store-matches[-lossy]
  - itunes-store-pending
- out-of-print
  - icloud-music-pending-tags
  - icloud-music-uploads[-lossy]

## Migration tasks/flows
- [x] Change iTunes Import Settings (Edit > Preferences) to use ALAC instead of AAC

- [ ] Check that ffmpeg can convert between ALAC<->FLAC without corrupting Japanese metadata tags
- [x] Download existing iTunes purchases into itunes-store-purchases
- [ ] Migrate existing lossless albums
    - [ ] Identify lossless files (wma, alac, flac)
    - [ ] Import into iTunes (converts to ALAC)
    - [ ] Determine whether album is matched or not [how to tell this?]
    - [ ] If matched:
        - [ ] Copy ALAC files into itunes-store-matches
    - [ ] If not matched:
        - [ ] Clean up tags/artwork if needed
        - [ ] Add to iCloud Music Library
        - [ ] Copy ALAC files into icloud-music-uploads
    - [ ] Delete original files
- [ ] Migrate existing lossy (WMA) albums
    - [ ] Import into iTunes
    - [ ] Determine whether album is matched or not
    - [ ] If matched:
        - [ ] Copy ALAC files into itunes-store-matches-lossy
        - [ ] Delete original files
    - [ ] If not matched:
        - [ ] Move original files to icloud-music-pending-rerip
        - [ ] Rerip using <?>
        - [ ] Copy existing metadata over using <?>
        - [ ] Copy ALAC files into icloud-music-uploads
        - [ ] Delete original files from icloud-music-pending-rerip
    - [ ] Migrate content downloaded from other sources
        - [ ] Import into iTunes
        - [ ] Determine whether album is matched or not
        - [ ] If matched:
        - [ ] If not matched: