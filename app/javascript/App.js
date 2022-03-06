import React, { useState } from "react";
import Folder from "./components/Folder";
import Slideshow from "./components/Slideshow";
import ComicStrip from "./components/ComicStrip";
import MergeButton from "./components/MergeButton";
import BundleButton from "./components/BundleButton";
import TrashButton from "./components/TrashButton";
import DownloadStatus from "./components/DownloadStatus";
import { getFolders, deleteFolder, bundleFolder } from "./api";
import { List, Map } from "immutable";
import {
  HashRouter as Router,
  Switch,
  Route,
  Link,
} from "react-router-dom";
import Folders from "./Folders"


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

  const trash = (key, title) => {
    const toBeDeleted = window.confirm(`Delete folder ${title}?`);
    if (toBeDeleted) {
      deleteFolder(key).then(refresh);
    }
  };

  const bodyLinks = folders.toArray().map(([k, { name, avatar }]) => (
    <li key={k} className="collection-item avatar">
      <img src={avatar} alt="" className="circle" />
      <Link to={"/folders/" + k} className="title">
        {name}
      </Link>
      <div className="secondary-content">
        <MergeButton folderId={k} onClick={refresh} />
        <BundleButton onClick={() => bundleFolder(k)} />
        <TrashButton onClick={() => trash(k, name)} />
      </div>
    </li>
  ));

  return (
    <Router>
      <div>
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
