class FolderController < ApplicationController
  def app; end

  def index
    @folders = Folder.eager_load(:thumbnail).all
  end

  SLIDESHOW_PAGE_SIZE = 200
  def folder_slideshow
    @folder = Folder.find(params.fetch('folder_id'))
    @images = @folder.images.page.per(SLIDESHOW_PAGE_SIZE)
  end

  def liked_slideshow
    @images = Image.where(liked: true).page.per(SLIDESHOW_PAGE_SIZE)
  end
end
