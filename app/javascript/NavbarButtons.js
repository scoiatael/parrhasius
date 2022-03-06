import React from "react";
import { faCameraRetro, faPlay } from "@fortawesome/free-solid-svg-icons";

import DownloadButton from "./components/DownloadButton";
import RouteButton from "./components/RouteButton";
const style = { marginRight: "0.2em" };
const NavbarButtons = () => (
  <div style={style}>
    <RouteButton
      icon={faPlay}
      suffix="/slideshow"
      style={style}
    />
    <RouteButton
      style={style}
      className="purple lighten-1"
      icon={faCameraRetro}
      suffix="/comicstrip"
    />
    <DownloadButton />
  </div>
);

export default NavbarButtons;
