import React, { useState } from "react";
import Folder from "./components/Folder";
import Slideshow from "./components/Slideshow";
import ComicStrip from "./components/ComicStrip";
import DownloadButton from "./components/DownloadButton";
import RouteButton from "./components/RouteButton";
import MergeButton from "./components/MergeButton";
import BundleButton from "./components/BundleButton";
import TrashButton from "./components/TrashButton";
import DownloadStatus from "./components/DownloadStatus";
import { getFolders, mergeFolders, deleteFolder, bundleFolder } from "./api";
import { List, Map } from "immutable";
import {
  HashRouter as Router,
  Switch,
  Route,
  Link,
  useRouteMatch,
  useParams,
} from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faList,
  faCameraRetro,
  faPlay,
} from "@fortawesome/free-solid-svg-icons";

function FolderProxy({ slideshow, ordered }) {
  const { folderId } = useParams();
  const apiPath = "/folder/" + folderId + "/images";

  if (ordered) {
    return <ComicStrip apiPath={apiPath} key={folderId} />;
  }
  if (slideshow) {
    return <Slideshow apiPath={apiPath} key={folderId} />;
  }
  return <Folder apiPath={apiPath} key={folderId} />;
}

function Folders() {
  let match = useRouteMatch();
  return (
    <div>
      <Switch>
        <Route path={`${match.path}/:folderId/ordered`}>
          <FolderProxy slideshow={false} ordered={true} />
        </Route>
        <Route path={`${match.path}/:folderId/slideshow`}>
          <FolderProxy slideshow={true} ordered={false} />
        </Route>
        <Route path={`${match.path}/:folderId`}>
          <FolderProxy slideshow={false} ordered={false} />
        </Route>
        <Route path={match.path}>
          <h3>Please select a folder.</h3>
        </Route>
      </Switch>
    </div>
  );
}

function initSidenav(el) {
  if (el) {
    window.M.Sidenav.init(el);
  }
}

function App() {
  const [loading, setLoading] = useState(false);
  const [loaded, setLoaded] = useState(false);
  const [folders, setFolders] = useState(List.of());

  if (!loaded) {
    if (!loading) {
      setLoading(true);
      getFolders().then(({ folders }) => {
        setLoaded(true);
        const sorted = Map(folders)
          .toSeq()
          .sortBy(({ name }) => name);
        setFolders(sorted);
      });
    }
  }

  const refresh = () => {
    setLoading(false);
    setLoaded(false);
  };

  const merge = (key) => {
    const target = prompt("Merge with?", "wallpapers");
    mergeFolders(key, target).then(refresh);
  };

  const trash = (key, title) => {
    const toBeDeleted = window.confirm(`Delete folder ${title}?`);
    if (toBeDeleted) {
      deleteFolder(key).then(refresh);
    }
  };

  const links = folders.toArray().map(([k, { name }]) => (
    <li key={k}>
      <Link to={"/folders/" + k}>{name}</Link>
    </li>
  ));
  const bodyLinks = folders.toArray().map(([k, { name, avatar }]) => (
    <li key={k} className="collection-item avatar">
      <img src={avatar} alt="" className="circle" />
      <Link to={"/folders/" + k} className="title">
        {name}
      </Link>
      <div className="secondary-content">
        <MergeButton onClick={() => merge(k)} />
        <BundleButton onClick={() => bundleFolder(k)} />
        <TrashButton onClick={() => trash(k, name)} />
      </div>
    </li>
  ));

  return (
    <Router>
      <div>
        <nav className="nav-extended">
          <div className="nav-wrapper">
            <div data-target="sidenav" className="sidenav-trigger">
              <FontAwesomeIcon icon={faList} />
            </div>
            <Link to="/" className="brand-logo">
              Parrhasius
            </Link>
            <ul id="nav-mobile" className="right hide-on-med-and-down">
              {links.slice(-6)}
            </ul>
            <ul className="right">
              <li style={{ marginRight: "0.2em" }}>
                <RouteButton icon={faPlay} suffix="/slideshow" />
              </li>
              <li style={{ marginRight: "0.2em" }}>
                <RouteButton
                  style="purple lighten-1"
                  icon={faCameraRetro}
                  suffix="/ordered"
                />
              </li>
              <li>
                <DownloadButton />
              </li>
              <li className="tab">
                <Link to="/liked">LIKED</Link>
              </li>
            </ul>
          </div>
        </nav>

        <ul className="sidenav" ref={initSidenav} id="sidenav">
          {links}
        </ul>

        <Switch>
          <Route path="/folders">
            <Folders />
          </Route>

          <Route path="/downloads/:jobId">
            <DownloadStatus onDone={refresh} />
          </Route>

          <Route path="/liked/ordered">
            <ComicStrip apiPath="/liked_images" />;
          </Route>

          <Route path="/liked/slideshow">
            <Slideshow apiPath="/liked_images" />;
          </Route>

          <Route path="/liked">
            <Folder apiPath="/liked_images" />;
          </Route>

          <Route path="/">
            <div className="container">
              <div className="row">
                <div className="col s12 collection">{bodyLinks}</div>
              </div>
            </div>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}
export default App;
