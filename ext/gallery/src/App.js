import React, { useState, useCallback, useEffect } from "react";
import Gallery from "react-photo-gallery";
import Carousel, { Modal, ModalGateway } from "react-images";

async function photos(page) {
    const server = process.env.NODE_ENV === 'production' ? '' : "http://localhost:9393"
    const response = await fetch(server + '/all?page=' + page);
    const all = await response.json();
    return all;
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
      })
  }, [currentPage]);

  const openLightbox = useCallback((event, { photo, index }) => {
    setCurrentImage(index);
    setViewerIsOpen(true);
  }, []);

  const closeLightbox = () => {
    setCurrentImage(0);
    setViewerIsOpen(false);
  };

  return (
    <div>
      <Gallery photos={currentPhotos} onClick={openLightbox} />
      <ModalGateway>
        {viewerIsOpen ? (
          <Modal onClose={closeLightbox}>
            <Carousel
              currentIndex={currentImage}
              views={currentPhotos.map(x => ({
                ...x,
                src: x.original,
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
