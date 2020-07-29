import oboe from "oboe";

function server() {
  return process.env.NODE_ENV === 'production' ? '' : "http://localhost:9393"
}

export async function getFolders() {
  const response = await fetch(server() + '/all');
  const all = await response.json();
  return all;
}

export async function mergeFolders(folder_id, target) {
  const response = await fetch(server() + '/folder/' + folder_id + '/merge', { method: 'POST', body: JSON.stringify({target: target}) });
  if (response.status !== 200) {
    throw new Error(`HTTP returned: ${response.status}`)
  }
}

export async function deleteFolder(folder_id) {
  const response = await fetch(server() + '/folder/' + folder_id, { method: 'DELETE' });
  if (response.status !== 200) {
    throw new Error(`HTTP returned: ${response.status}`)
  }
}

export async function getPhotos(folder_id, page) {
  const response = await fetch(server() + '/folder/' + folder_id + '?page=' + page);
  if (response.status !== 200) {
    console.error(response);
    throw new Error(`HTTP returned: ${response.status}`)
  }
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

export function download(url) {
  const data = {
    url: url
  };
  return oboe({
    url: server() + "/downloads",
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: data,
  });
}
