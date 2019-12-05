# Parrhasius
Simple ruby script to download images from 4chan thread, organize and browse through them.

![](https://dl.dropbox.com/s/govczedukxgkonx/2019-12-05-141631_1920x1080_scrot.png)

## Requirements

### Ruby

`bundle install`

### Golang

`cd ext/parrhasius && go install .`

### Javascript

`cd ext/gallery && npm install && npm run build`

## Usage

1. Find a nice wallpaper thread to download from. e.g.: `http://boards.4chan.org/wg/thread/7412420`
3. Run `ruby run.rb 4chan http://boards.4chan.org/wg/thread/7412420/nature`
4. Wait a little...
5. ...Enjoy all new images in `db/`. Each download is prefixed with current timestamp. Let's say current is `1575551060`.
6. Original (full-size) images can be found in `db/1575551060/original`.
7. Thumbnails are in `db/1575551060/thumbnail`.
8. All are de-duplicated already via [Dhash algorithm](https://github.com/devedge/imagehash).
9. You can browse by running `env APP_ENV=production SERVE=db/1575551060 ruby serve.rb` and opening `localhost:4567` in browser.
10. Browser also gives you option for deleting images.
11. Enjoy :)
