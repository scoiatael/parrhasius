json.folders(@folders.to_h { |f| [f.id, { name: f.name, avatar: image_url(f.avatar!.path) }] })
