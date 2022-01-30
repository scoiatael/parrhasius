import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faTrash } from '@fortawesome/free-solid-svg-icons'

function TrashButton({onClick}) {
    return (
        <button className="btn-floating red" onClick={onClick}><FontAwesomeIcon icon={faTrash} /></button>
    );
}

export default TrashButton;
