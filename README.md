# music-migration
Scripts and tools for migrating music to Apple iCloud Music Library

# Folder structure
- collection
  - apple-music-matches
  - apple-music-matches-lossy
  - icloud-music-pending-rerip
  - icloud-music-pending-tags
  - icloud-music-uploads
  - ~~itunes-store-matches~~
  - ~~itunes-store-matches-lossy~~
  - itunes-store-purchases
- downloads
  - icloud-music-pending-tags
  - icloud-music-uploads
  - itunes-store-pending
- out-of-print
  - icloud-music-pending-tags
  - icloud-music-uploads
	
TBD - what to do with lossy formats that are not in Apple Music and I don't have physical media

# Tasks/flows
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

# Identify lossless files
```Get-MusicCodec.ps1``` in scripts

```
ffprobe 'file.wma' -print_format json -show_format -show_streams -v quiet
```

# Obsolete (convert to ALAC in iTunes instead) - Music transcoding to FLAC
Transcode WMA lossless files to FLAC in a single directory:
```
ls *.wma|%{$f = split-path $_ -leafbase; ffmpeg -i $_ -c:v copy "$f.flac"}
```
To ALAC:
```
ls *.wma|%{$f = split-path $_ -leafbase; ffmpeg -i $_ -c:a alac -c:v copy "$f.m4a"} # -c:v copy should copy embedded artwork in theory
```

## Notes
- ffmpeg doesn't seem to handle Japanese characters correctly in some (but not all, strangely) of the WMA metadata
- Moving tags from WMA files to FLAC files is multi-step process in Tag&Rename and could be lossy because titles must be derived from filenames (which could be missing invalid path chars like */ etc)
- Try out Mp3tag or build PS script using taglib-sharp

# Resources
## Apps
- [Mp3tag - the universal Tag Editor (ID3v2, MP4, OGG, FLAC, ...)](https://www.mp3tag.de/en/)
- [Bulk moving of MP3 tag info to WMA/FLAC files - Support - Mp3tag Community](https://community.mp3tag.de/t/bulk-moving-of-mp3-tag-info-to-wma-flac-files/14833/6)
- [Copy tags from FLAC to MP3 and/or Tag API (hydrogenaud.io)](https://hydrogenaud.io/index.php?topic=98637.0)

## Libraries
- [mono/taglib-sharp: Library for reading and writing metadata in media files (github.com)](https://github.com/mono/taglib-sharp)
    - [NuGet Gallery | TagLibSharp 2.2.0](https://www.nuget.org/packages/TagLibSharp)

## Scripts
- [flac-to-alac/flac-to-alac.sh at master · sheldonkwoodward/flac-to-alac · GitHub](https://github.com/sheldonkwoodward/flac-to-alac/blob/master/flac-to-alac.sh) - copy metadata and embed album artwork with atomicparsley]

## VGMDB API
https://vgmdb.info/
- Supports JSON and YAML formats
- Replace "vgmdb.net" in URL with "vgmdb.info" and append "?format=json"

# Legacy flow - Rip and tag albums
1. Rip approx. 10 discs at a time, lossless WMA in WMP (no changes to tagging)
    - Use Apple Lossless instead (using … MusicMonkey? iTunes?)
2. Fill out tag entry spreadsheet from vgmdb.net or other source
    - Copy/paste track list through Word
3. Download album art (scan if needed)
    - Consider using musicbrainz.org for high quality album art
4. Tag&Rename: Export metadata to Excel
5. Excel: Copy tags to metadata xls
6. Tag&Rename
    1. Import metadata xls
    2. Rename files [Action]
    3. Apply album art to folder
    4. Apply album art to files
    5. Add comment if applicable
7. Delete metadata xls
8. Rename folders
9. Move to OneDrive

