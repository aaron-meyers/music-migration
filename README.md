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