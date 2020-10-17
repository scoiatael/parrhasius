import React, { useState, useEffect } from "react";
import {getAllPhotos} from '../api';
import {List} from 'immutable';

const numItems = 3;
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
    const [progress, setProgress] = useState(0);
    const [offset, setOffset] = useState(0);
    useEffect(() => {
        const interval = setInterval(() => {
            setProgress(i => {
                if (i >= timeout) {
                    setOffset(i => next(i, items.size))
                    return 0
                }
                return i+10
            })
        }, 10);
        return () => clearInterval(interval);
    }, [items]);
    if (!loaded) {
        if (!loading) {
            setLoading(true);
            getAllPhotos(folderId).then(records => {
                setItems(records);
                setLoaded(true);
            }).catch(console.error.bind(console));
        }
        return (<p>loading...</p>);
    }

    const sorted = items.slice(offset, offset+numItems).sortBy(({width, height}) => -(width/height)).toArray();
    const [
        {original: original1},
        {original: original2},
        {original: original3}] = sorted;
    const animationDuration = 200;
    let opacity = 1;
    if (progress < animationDuration) {
        opacity = progress / animationDuration;
    }
    if (progress > (timeout - animationDuration)) {
        opacity = (timeout - progress) / animationDuration;
    }
    const style = {
        width: '98%',
        transition: 'all 0.01s ease-in-out',
        opacity: opacity,
    }
    const gridTemplateColumns = `3fr 2fr 1fr`
    return (
        <div>
          <div className="progress">
            <div className="determinate" style={{width: `${100* progress / timeout}%`, transitionDuration: '0.01s'}}></div>
          </div>
          <div style={{display: 'grid', gridTemplateColumns, maxHeight: '80% - 64px', width: '100%'}}>
            <img src={original1} alt="" style={{gridColumn: 1, ...style}}/>
            <img src={original2} alt="" style={{gridColumn: 2, ...style}}/>
            <img src={original3} alt="" style={{gridColumn: 3, ...style}}/>
          </div>
        </div>
    );
}

export default Slideshow;
