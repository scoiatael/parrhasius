import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit } from '@fortawesome/free-solid-svg-icons'

function MergeButton({onClick}) {
    return (
        <button className="btn-floating blue" onClick={onClick}><FontAwesomeIcon icon={faEdit} /></button>
    );
}

export default MergeButton;
