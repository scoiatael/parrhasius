import "@materializecss/materialize/dist/css/materialize.min.css";
import "@materializecss/materialize/dist/js/materialize.min.js";
import React from "react";
import ReactDOM from "react-dom";
import ReactRailsUJS from "react_ujs";
import MergeButton from "../components/MergeButton";
import BundleButton from "../components/BundleButton";
import TrashButton from "../components/TrashButton";
import NavbarButtons from "../NavbarButtons";
window.MergeButton = MergeButton;
window.BundleButton = BundleButton;
window.TrashButton = TrashButton;
document.addEventListener("DOMContentLoaded", function () {
  var elems = document.querySelectorAll(".sidenav");
  window.M.Sidenav.init(elems, {});
  ReactRailsUJS.detectEvents();
  ReactDOM.render(<NavbarButtons />, document.getElementById("navbar-buttons"));
});
