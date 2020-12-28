import React, { useState, useEffect } from "react";
import {getAllPhotos} from '../api';
import {List} from 'immutable';
import Loader from './Loader';
import Carousel, { Modal, ModalGateway } from "react-images";

function ComicStrip({ folderId }) {
    const [items, setItems] = useState(List.of());
    const [loading, setLoading] = useState(false);
    const [loaded, setLoaded] = useState(false);
    if (!loaded) {
        if (!loading) {
            setLoading(true);
            getAllPhotos(folderId).then(records => {
                setItems(List(records).sortBy(({title}) => title));
                setLoaded(true);
            }).catch(console.error.bind(console));
        }
        return (<Loader />);
    }

    const style = {
        width: '98%',
        borderRadius: "2px"
    }
    const gridTemplateColumns = `1fr 1fr 1fr 1fr 1fr`
    const photos = items.toJS().map(({original}, idx) => ( <img key={idx} src={original} alt="" style={{...style}}/>))
    return (
        <div style={{display: 'grid', gridTemplateColumns, maxHeight: '80% - 64px', width: '100%'}}>
         {photos}    
        </div>
    );
}

export default ComicStrip;
