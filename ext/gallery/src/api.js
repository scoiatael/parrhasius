function server() {
  return process.env.NODE_ENV === 'production' ? '' : "http://localhost:9393"
}

export async function getPhotos(page) {
  const response = await fetch(server() + '/all?page=' + page);
  const all = await response.json();
  return all;
}

export async function deletePhoto(img) {
  const response = await fetch(img.src, { method: 'DELETE'});
  return response;
}

export async function likePhoto(img) {
  const response = await fetch(img.src, { method: 'PUT'});
  return response;
}

export async function getPages() {
  const response = await fetch(server() + '/pages');
  const all = await response.json();
  return all;
}
