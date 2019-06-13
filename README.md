# 4chan-downloader
Simple ruby script to download images from 4chan thread

## Download

1. Find a nice wallpaper thread to download from. e.g.: `http://boards.4chan.org/wg/thread/7412420`
2. Decide on a nice suffix (some links have them by default), e.g.: `http://boards.4chan.org/wg/thread/7412420/nature`
3. Run `ruby run.rb http://boards.4chan.org/wg/thread/7412420/nature`
4. Wait a little...
5. ...Enjoy all new images in `imgs/nature`.

## De-duplicate

1. Download tons of wallpapers.
2. There are duplicates.
3. Run `ruby dedup.rb`.
4. No more duplicates.
5. Move images elsewhere, e.g. background folder.
6. Download new images.
7. Run dedup again - it remembers old downloads, so even if new batch has duplicates, they'll get deleted.
8. If you want to forget about old downloads, `rm index.pstore`.
