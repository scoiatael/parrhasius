import React, { useCallback, useState } from "react";
import Photos from "./Photos";
import { getPhotos, deletePhoto, likePhoto } from "../api";
import InfiniteScroll from "react-infinite-scroller";
import { List } from "immutable";
import Loader from "./Loader";

function Folder({ apiPath }) {
  const [pages, setPages] = useState(List.of());
  const [paging, setPaging] = useState({ has_next: true });

  const loadFunc = (index) => {
    getPhotos(apiPath, index)
      .then(({ records, page }) => {
        setPages((p) => p.push(List.of(...records)));
        setPaging(page);
      })
      .catch(console.error.bind(console));
  };

  const onDelete = useCallback(
    (currentPage) => async (photoIndex) => {
      const currentPhoto = pages.get(currentPage).get(photoIndex);
      await deletePhoto(currentPhoto.id);
      setPages(pages.set(currentPage, pages.get(currentPage).delete(photoIndex)));
    },
    [pages]
  );

  const onLike = useCallback(
    (photo) => likePhoto(photo.id).catch(console.error.bind(console)),
    []
  );

  const items = pages.map((items, index) => (
    <Photos
      key={index}
      photos={items.toArray()}
      onDelete={onDelete(index)}
      onLike={onLike}
    />
  ));

  return (
    <InfiniteScroll
      loadMore={loadFunc}
      hasMore={paging.has_next}
      loader={
        <div className="loader" key={0}>
          <Loader />
        </div>
      }
    >
      {items}
    </InfiniteScroll>
  );
}

export default Folder;
