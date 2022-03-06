import React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useHistory } from "react-router-dom";

function RouteButton({ suffix, icon, className, style, external }) {
  const classes = `btn-floating default ${className}`;
  const history = useHistory();
  const match = window.routeMatch || "";
  const isOn = match.endsWith(suffix);

  if (!match || isOn) {
    return (
      <button className="btn-floating disabled" style={style}>
        <FontAwesomeIcon icon={icon} />
      </button>
    );
  }

  const navigate = () => {
    let location = `${match}/${suffix}`;
    if (external) {
      window.location = location;
    } else {
      history.push(location);
    }
  };

  return (
    <button className={classes} onClick={navigate} style={style}>
      <FontAwesomeIcon icon={icon} />
    </button>
  );
}

export default RouteButton;
