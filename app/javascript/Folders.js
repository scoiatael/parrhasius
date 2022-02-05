import React, { useState } from "react";
import Folder from "./components/Folder";
import Slideshow from "./components/Slideshow";
import ComicStrip from "./components/ComicStrip";
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

export default Folders;
