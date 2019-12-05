import React, { useState, useCallback, useEffect } from "react";
import Gallery from "react-photo-gallery";
import Carousel, { Modal, ModalGateway } from "react-images";

async function photos(page) {
    const server = process.env.NODE_ENV === 'production' ? '' : "http://localhost:9393"
    const response = await fetch(server + '/all?page=' + page);
    const all = await response.json();
    return all;
}

async function deletePhoto(img) {
    const response = await fetch(img.src, { method: 'DELETE'});
    return response;
}

function App() {
  const [currentPage, setCurrentPage] = useState(0);
  const [currentPhotos, setCurrentPhotos] = useState([]);
  const [currentImage, setCurrentImage] = useState(0);
  const [viewerIsOpen, setViewerIsOpen] = useState(false);

  useEffect(() => {
      photos(currentPage).then((data) => {
          setCurrentPhotos(c => c.concat(...data.records));
          if (data.page.has_next) {
              setCurrentPage(p => p+1);
          }
      }).catch(console.error.bind(console));
  }, [currentPage]);

  const openLightbox = useCallback((event, { photo, index }) => {
    setCurrentImage(index);
    setViewerIsOpen(true);
  }, []);

    const closeLightbox = useCallback(() => {
        const currentPhoto = currentPhotos[currentImage];
        const toBeDeleted = window.confirm(`Delete photo ${currentPhoto.title}?`)
        if (toBeDeleted) {
            deletePhoto(currentPhotos[currentImage]).then(() => {
                // Need to create a new array, since Gallery is memoized. Would be an issue for bigger galleries.
                const photosWithoutCurrent = currentPhotos.slice(0, currentImage).concat(...currentPhotos.slice(currentImage+1, currentPhotos.length));
                setCurrentPhotos(photosWithoutCurrent);
            }).catch(console.error.bind(console));
        }
        setCurrentImage(0);
        setViewerIsOpen(false);
    }, [currentImage, currentPhotos]);

  return (
    <div>
      <Gallery photos={currentPhotos} onClick={openLightbox} />
      <ModalGateway>
        {viewerIsOpen ? (
          <Modal onClose={closeLightbox}>
            <Carousel
              components={{ Footer: null, NavigationPrev: null, Navigation: null}}
              currentIndex={currentImage}
              views={currentPhotos.map((x, idx) => ({
                ...x,
                src: idx === currentImage ? x.original : x.src,
                srcset: x.srcSet,
                caption: x.title
              }))}
            />
          </Modal>
        ) : null}
      </ModalGateway>
    </div>
  );
}
export default App;
