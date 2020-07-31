import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit } from '@fortawesome/free-solid-svg-icons'

function MergeButton({onClick}) {
    const style = {
        marginRight: '0.2em'
    }
    return (
        <button className="btn-floating blue" onClick={onClick} style={style}><FontAwesomeIcon icon={faEdit} /></button>
    );
}

export default MergeButton;
