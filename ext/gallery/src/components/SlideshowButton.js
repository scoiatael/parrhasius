import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPlay, faPause } from '@fortawesome/free-solid-svg-icons'
import {
    useHistory,
    useRouteMatch
} from "react-router-dom";

function SlideshowButton() {
    const history = useHistory();
    const match = useRouteMatch("/folders/:folderId");
    const isSlideshow = useRouteMatch("/folders/:folderId/slideshow");
    if (!match) {
        return (
            <button
              className="btn-floating disabled">
              <FontAwesomeIcon icon={faPlay} />
            </button>
        );
    }
    const {params: { folderId }} = match;

    const navigate = (slideshow) => {
        history.push(`/folders/${folderId}${slideshow}`);
    }

    if (isSlideshow) {
        return (
            <button
              className="btn-floating default"
              onClick={() => navigate("")}>
              <FontAwesomeIcon icon={faPause} />
            </button>
        );
        
    }
    return (
        <button
          className="btn-floating default"
          onClick={() => navigate("/slideshow")}>
          <FontAwesomeIcon icon={faPlay} />
        </button>
    );
}

export default SlideshowButton;
