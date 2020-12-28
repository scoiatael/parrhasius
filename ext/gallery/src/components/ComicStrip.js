import React, { useState } from "react";
import { getAllPhotos } from '../api';
import { List } from 'immutable';
import Loader from './Loader';
import Carousel, { Modal, ModalGateway } from "react-images";
import {
    useHistory
} from "react-router-dom";

function ComicStrip({ folderId }) {
    const [items, setItems] = useState(List.of());
    const [loading, setLoading] = useState(false);
    const [loaded, setLoaded] = useState(false);
    const history = useHistory();
    if (!loaded) {
        if (!loading) {
            setLoading(true);
            getAllPhotos(folderId).then(records => {
                setItems(List(records).sortBy(({ title }) => title));
                setLoaded(true);
            }).catch(console.error.bind(console));
        }
        return (<Loader />);
    }


    return (
        <ModalGateway>
            <Modal onClose={history.goBack.bind(history)}>
                <Carousel
                    views={items.toJS().map((x) => ({
                        ...x,
                        src: x.original,
                        srcset: x.srcSet,
                        caption: x.title
                    }))}
                />
            </Modal>
        </ModalGateway>
    );
}

export default ComicStrip;
