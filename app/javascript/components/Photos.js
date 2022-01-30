import React, { useState, useCallback } from "react";
import Gallery from "react-photo-gallery";
import Carousel, { Modal, ModalGateway } from "react-images";
import Header from './Header';
import Image from './Image';

function Photos({photos, onDelete, onLike}) {
  const [currentImage, setCurrentImage] = useState(0);
  const [viewerIsOpen, setViewerIsOpen] = useState(false);

  const openLightbox = useCallback(index => {
    setCurrentImage(index);
    setViewerIsOpen(true);
  }, []);

  const closeLightbox = useCallback(() => {
    setCurrentImage(0);
    setViewerIsOpen(false);
  }, []);

  const deleteCurrentPhoto = useCallback(() => {
    onDelete(currentImage);
    closeLightbox();
  }, [currentImage, closeLightbox, onDelete]);

  const likeCurrentPhoto = useCallback(() => {
    onLike(photos[currentImage]);
    closeLightbox();
  }, [currentImage, closeLightbox, onLike, photos]);

  const viewer = viewerIsOpen ? (
    <Modal onClose={closeLightbox}>
      <Carousel
        components={{ Footer: null, NavigationPrev: null, Navigation: null, Header: Header(deleteCurrentPhoto, likeCurrentPhoto) }}
        currentIndex={currentImage}
        views={photos.map((x, idx) => ({
          ...x,
          src: idx === currentImage ? x.original : x.src,
          srcset: x.srcSet,
          caption: x.title
        }))}
        />
    </Modal>
  ) : null

  return (
    <div>
      <Gallery photos={photos} onClick={openLightbox} renderImage={Image(openLightbox)}/>
      <ModalGateway>
        {viewer}
      </ModalGateway>
    </div>
  );
}
export default Photos;
