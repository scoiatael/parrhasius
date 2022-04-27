import React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

function RouteButton({ suffix, icon, className, style }) {
  const classes = `btn-floating default ${className}`;
  const match = (window.gon && window.gon.routeMatch) || "";
  const isOn = match && window.location.pathname.endsWith(suffix);

  if (!match || isOn) {
    return (
      <button className="btn-floating disabled" style={style}>
        <FontAwesomeIcon icon={icon} />
      </button>
    );
  }

  const navigate = () => {
    window.location = `${match}${suffix}`;
  };

  return (
    <button className={classes} onClick={navigate} style={style}>
      <FontAwesomeIcon icon={icon} />
    </button>
  );
}

export default RouteButton;
