json.id image.id
json.title File.basename(image.path)
json.width image.width
json.height image.height
json.src image_url(image.thumbnail.path)
json.original image_url(image.path)
json.liked image.liked?
