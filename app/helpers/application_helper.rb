# frozen_string_literal: true

module ApplicationHelper # rubocop:todo Style/Documentation
  def image_url(path)
    path = Pathname.new(path)
    rel = path.relative_path_from(Parrhasius::DIR)
    ext = rel.extname
    Rails.application.routes.url_helpers.static_image_url(path: rel.to_s.gsub(/#{ext}$/, ''),
                                                          format: ext.delete_prefix('.'),
                                                          only_path: true)
  end
end
