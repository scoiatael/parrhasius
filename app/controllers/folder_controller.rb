class FolderController < ApplicationController
  def app; end

  def index
    @folders = Folder.eager_load(:thumbnail).all
  end

  def folder_gallery
    @folder = Folder.find(params.fetch('folder_id'))
    @api_path = "/folder/#{@folder.id}/images"
    gon.push(routeMatch: folder_gallery_path(folder_id: @folder.id))
  end

  SLIDESHOW_PAGE_SIZE = 200
  def folder_slideshow
    @folder = Folder.find(params.fetch('folder_id'))
    @images = @folder.images.page.per(SLIDESHOW_PAGE_SIZE)
    gon.push(routeMatch: folder_gallery_path(folder_id: @folder.id), slidesPerView: 3)
  end

  def folder_comicstrip
    @folder = Folder.find(params.fetch('folder_id'))
    @images = @folder.images.page.per(SLIDESHOW_PAGE_SIZE)
    gon.push(routeMatch: folder_gallery_path(folder_id: @folder.id), slidesPerView: 1)
  end

  def liked_gallery
    @api_path = '/liked/images'
    gon.push(routeMatch: liked_gallery_path)
  end

  def liked_slideshow
    @images = Image.where(liked: true).page.per(SLIDESHOW_PAGE_SIZE)
    gon.push(routeMatch: liked_gallery_path, slidesPerView: 3)
  end

  def liked_comicstrip
    @images = Image.where(liked: true).page.per(SLIDESHOW_PAGE_SIZE)
    gon.push(routeMatch: liked_gallery_path, slidesPerView: 1)
  end
end
