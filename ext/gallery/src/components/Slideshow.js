import React, { useState, useEffect } from "react";
import {getAllPhotos} from '../api';
import {List} from 'immutable';
import Gallery from "react-photo-gallery";

const numItems = 6;
const timeout = 5 * 1000;

function next(cur, total) {
    let nextNext = cur + 2*numItems;
    if (nextNext < total) {
        return cur + numItems;
    }
    return nextNext % total;
}

function Slideshow({ folderId }) {
    const [items, setItems] = useState(List.of());
    const [loading, setLoading] = useState(false);
    const [loaded, setLoaded] = useState(false);
    const [offset, setOffset] = useState(0);
    useEffect(() => {
        const interval = setInterval(() => {
            setOffset(i => next(i, items.size))
        }, timeout);
        return () => clearInterval(interval);
    }, [items]);
    if (!loaded) {
        if (!loading) {
            setLoading(true);
            getAllPhotos(folderId).then(records => {
                setLoaded(true);
                setItems(records);
            }).catch(console.error.bind(console));
        }
        return (<p>loading...</p>);
    }

    const photos = items.slice(offset, offset+numItems).toArray();
    return (
        <Gallery
          photos={photos.map((x) => ({src: x.original, height: x.originalHeight, width: x.originalWidth}))}
          direction={"column"}
          columns={2}/>
    );
}

export default Slideshow;
