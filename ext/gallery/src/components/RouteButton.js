import React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useHistory, useRouteMatch } from "react-router-dom";

function RouteButton({ suffix, icon, style }) {
  const classes = `btn-floating default ${style}`;
  const history = useHistory();
  // TODO: Weird workaround. Either use ReactDOM portals or migrate to SSR via Rails
  const folderMatch = useRouteMatch("/folders/:folderId");
  const likedMatch = useRouteMatch("/liked");
  const isFolderOn = useRouteMatch(`/folders/:folderId${suffix}`);
  const isLikedOn = useRouteMatch(`/liked${suffix}`);
  const match = folderMatch || likedMatch;
  const isOn = isFolderOn || isLikedOn;
  // ENDOF workaround

  if (!match || isOn) {
    return (
      <button className="btn-floating disabled">
        <FontAwesomeIcon icon={icon} />
      </button>
    );
  }
  const {
    params: { folderId },
  } = match;

  const navigate = () => {
    if (likedMatch) {
      history.push(`/liked${suffix}`);
    } else {
      history.push(`/folders/${folderId}${suffix}`);
    }
  };

  return (
    <button className={classes} onClick={navigate}>
      <FontAwesomeIcon icon={icon} />
    </button>
  );
}

export default RouteButton;
