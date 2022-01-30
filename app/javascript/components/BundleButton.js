import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faFileArchive } from '@fortawesome/free-solid-svg-icons'

function BundleButton({onClick}) {
    const style = {
        marginRight: '0.2em'
    }
    return (
        <button className="btn-floating green" onClick={onClick} style={style}><FontAwesomeIcon icon={faFileArchive} /></button>
    );
}

export default BundleButton;
