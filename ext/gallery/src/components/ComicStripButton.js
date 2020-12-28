import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faCameraRetro } from '@fortawesome/free-solid-svg-icons'
import {
    useHistory,
    useRouteMatch
} from "react-router-dom";

function ComicStripButton() {
    const history = useHistory();
    const match = useRouteMatch("/folders/:folderId");
    if (!match) {
        return (
            <button
              className="btn-floating disabled">
              <FontAwesomeIcon icon={faCameraRetro} />
            </button>
        );
    }
    const {params: { folderId }} = match;

    const navigate = (slideshow) => {
        history.push(`/folders/${folderId}${slideshow}`);
    }

    return (
        <button
          className="btn-floating purple lighten-1"
          onClick={() => navigate("/ordered")}>
          <FontAwesomeIcon icon={faCameraRetro} />
        </button>
    );
}

export default ComicStripButton;
