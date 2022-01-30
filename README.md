# Parrhasius

Simple ruby script to download images from 4chan thread, organize and browse through them.

![](https://dl.dropbox.com/s/govczedukxgkonx/2019-12-05-141631_1920x1080_scrot.png)

## Requirements

Needs: ruby (^3), Golang (^1.17), Node (^17), yarn (^1.22).

    bundle install
    rake build

## Usage

1. Run web: `rake run`.
2. Navigate to `127.0.0.1:4567` in your browser.
3. Find a thread with nice wallpapers.
4. Download it via web interface.
5. ...Enjoy all new images in `db/`. Each download is prefixed with current timestamp. Let's say current is `1575551060`.
6. All are de-duplicated already via [Dhash algorithm](https://github.com/devedge/imagehash).
7. Browser also gives you option for deleting images.
8. Enjoy :)
