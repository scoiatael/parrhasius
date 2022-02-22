import React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useHistory, useRouteMatch } from "react-router-dom";

function RouteButton({ suffix, icon, className, style, external }) {
  const classes = `btn-floating default ${className}`;
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
      <button className="btn-floating disabled" style={style}>
        <FontAwesomeIcon icon={icon} />
      </button>
    );
  }
  const {
    params: { folderId },
  } = match;

  const navigate = () => {
    let location = "";
    if (likedMatch) {
      location =`/liked${suffix}`;
    } else {
      location = `/folders/${folderId}${suffix}`;
    }
    if (external) {
      window.location = location;
    } else{
      history.push(location)
    }
  };

  return (
    <button className={classes} onClick={navigate} style={style}>
      <FontAwesomeIcon icon={icon} />
    </button>
  );
}

export default RouteButton;
