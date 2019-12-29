import React, { useCallback, useState } from "react";
import Photos from './components/Photos';
import {getPhotos, deletePhoto, likePhoto} from './api';
import InfiniteScroll from 'react-infinite-scroller';
import {List} from 'immutable';

function App() {
  const [pages, setPages] = useState(List.of());
  const [paging, setPaging] = useState({has_next: true});

  const loadFunc = (index) => {
    console.log("Called", {index})
    getPhotos(index).then(({records, page}) => {
      setPages(p => p.push(List.of(...records)));
      setPaging(page);
    }).catch(console.error.bind(console));
  }

  const onDelete = useCallback((currentPage) => (photoIndex) => {
    const currentPhoto = pages.get(currentPage).get(photoIndex);
    const toBeDeleted = window.confirm(`Delete photo ${currentPhoto.title}?`)
    if (toBeDeleted) {
      deletePhoto(currentPhoto).then(() => {
        setPages(pages.set(currentPage, pages.get(currentPage).delete(photoIndex)));
      }).catch(console.error.bind(console));
    }
  }, [pages]);


  const items = pages.map((items, index) => <Photos key={index} photos={items.toArray()} onDelete={onDelete(index)} onLike={likePhoto} />);

  return (
    <InfiniteScroll
      pageStart={-1}
      loadMore={loadFunc}
      hasMore={paging.has_next}
      loader={<div className="loader" key={0}>Loading ...</div>}
    >
      {items}
    </InfiniteScroll>
  );
}
export default App;
