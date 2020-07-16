import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faCloudDownloadAlt } from '@fortawesome/free-solid-svg-icons'
import {
    useHistory
} from "react-router-dom";

function DownloadButton({onClick}) {
    const history = useHistory();

    const download = () => {
        history.push("/downloads");
        onClick();
    }
    return (
        <button className="btn-floating green" onClick={download}><FontAwesomeIcon icon={faCloudDownloadAlt} /></button>
    );
}

export default DownloadButton;
