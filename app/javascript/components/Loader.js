import React from "react";

function Loader({ progress }) {
  let child = <div className="indeterminate"></div>;
  if (progress) {
    child = (
      <div
        className="determinate"
        style={{ width: `${100 * progress}%`, transitionDuration: "0.01s" }}
      ></div>
    );
  }
  return <div className="progress">{child}</div>;
}

export default Loader;
