class FolderController < ApplicationController
  def index; end

  SLIDESHOW_PAGE_SIZE = 200
  def slideshow
    @folder = Folder.find(params.fetch('folder_id'))
    @images = @folder.images.page.per(SLIDESHOW_PAGE_SIZE)
    with_format :json do
      @json = render_to_string partial: 'folder/images', locals: { images: @images }
    end
  end
end
