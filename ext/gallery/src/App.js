import React, { useState } from "react";
import Folder from './components/Folder';
import DownloadButton from './components/DownloadButton';
import MergeButton from './components/MergeButton';
import TrashButton from './components/TrashButton';
import DownloadStatus from './components/DownloadStatus';
import { getFolders, mergeFolders, deleteFolder } from './api';
import { List, Map } from 'immutable';
import {
  HashRouter as Router,
  Switch,
  Route,
  Link,
  useRouteMatch,
  useParams,
} from "react-router-dom";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faList } from '@fortawesome/free-solid-svg-icons'

function FolderProxy() {
  const { folderId } = useParams();

  return <Folder folderId={folderId} key={folderId} />;
}

function Folders() {
  let match = useRouteMatch();
  return (
    <div>
      <Switch>
        <Route path={`${match.path}/:folderId`}>
          <FolderProxy />
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
  if (!loaded) {
    if (!loading) {
      setLoading(true);
      getFolders().then((folders) => {
        setLoaded(true);
        const sorted = Map(folders).toSeq().sortBy(({name}) => name);
        setFolders(sorted);
      })
    }
  }
  const [downloading, setDownload] = useState(null);
  const [folders, setFolders] = useState(List.of());

  const download = () => {
    const url = prompt('URL?', 'https://boards.4chan.org/wg/...');
    setDownload(url);
  }

  const refresh = () => {
    setLoading(false);
    setLoaded(false);
  }

  const merge = (key) => {
    const target = prompt('Merge with?', 'wallpapers');
    mergeFolders(key, target).then(refresh);
  }

  const trash = (key, title) => {
    const toBeDeleted = window.confirm(`Delete folder ${title}?`)
    if (toBeDeleted) {
      deleteFolder(key).then(refresh)
    }
  }

  const links = folders.toArray().map(([k, {name}]) => <li key={k}><Link to={"/folders/" + k}>{name}</Link></li>);
  const bodyLinks = folders.toArray().map(([k, {name, avatar}]) =>
                                          <li key={k} className="collection-item avatar">
                                            <img src={avatar} alt="" className="circle" />
                                            <Link to={"/folders/" + k} className="title">{name}</Link>
                                            <div className="secondary-content">
                                              <MergeButton onClick={() => merge(k)}/>
                                              <TrashButton onClick={() => trash(k, name)}/>
                                            </div>
                                          </li>
                                         );

  return (
    <Router>
      <div>
        <nav>
          <div className="nav-wrapper">
            <div data-target="sidenav" className="sidenav-trigger"><FontAwesomeIcon icon={faList} /></div>
            <Link to="/" className="brand-logo">Parrhasius</Link>
            <ul id="nav-mobile" className="right hide-on-med-and-down">
              {links.slice(-6)}
            </ul>
            <ul className="right">
              <li><DownloadButton onClick={download}/></li>
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

          <Route path="/downloads">
            <DownloadStatus url={downloading} onDone={refresh}/>
          </Route>

          <Route path="/">
            <div className="container">
              <div className="row">
                <div className="col s12 collection">
                  {bodyLinks}
                </div>
              </div>
            </div>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}
export default App;
