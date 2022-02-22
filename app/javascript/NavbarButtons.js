import React from "react";
import { createPortal } from "react-dom";
import {
  faCameraRetro,
  faPlay,
} from "@fortawesome/free-solid-svg-icons";

import DownloadButton from "./components/DownloadButton"
import RouteButton from "./components/RouteButton";
const style = { 'marginRight': '0.2em' }
const Buttons = () =>
      (<div style={style}>
        <RouteButton icon={faPlay} suffix="/slideshow" style={style} external={true} />
        <RouteButton
          style={style}
          className="purple lighten-1"
          icon={faCameraRetro}
          suffix="/ordered"
          external={false}
        />
        <DownloadButton/>
      </div>)

const NavbarButtons = () => createPortal(<Buttons/>, document.getElementById("navbar-buttons"));

export default NavbarButtons;
