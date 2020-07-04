import React, { useState } from "react";
import Folder from './components/Folder';
import { getFolders } from './api';
import { List, Map } from 'immutable';
import {
  HashRouter as Router,
  Switch,
  Route,
  Link,
  useRouteMatch,
  useParams
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

function App() {
  const [loading, setLoading] = useState(false);
  const [loaded, setLoaded] = useState(false);
  const [folders, setFolders] = useState(List.of());
  if (!loaded) {
    if (!loading) {
      setLoading(true);
      getFolders().then((folders) => {
        setLoaded(true);
        console.log(folders);
        console.log(Map(folders).toSeq());
        const sorted = Map(folders).toSeq().sortBy(({name}) => name);
        setFolders(sorted);
      })
    }
  }

  const links = folders.toArray().map(([k, {name}]) => <li key={k}><Link to={"/folders/" + k}>{name}</Link></li>);
  const bodyLinks = folders.toArray().map(([k, {name, avatar}]) =>
    <li class="collection-item avatar">
      <img src={avatar} alt="" class="circle" />
      <Link to={"/folders/" + k} key={k} className="title">{name}</Link>
    </li>
  );
  const initSidenav = (el) => {
    if (el) {
      window.M.Sidenav.init(el);
    }
  }

  return (
    <Router>
      <div>
        <nav>
          <div className="nav-wrapper">
            <div data-target="sidenav" className="sidenav-trigger"><FontAwesomeIcon icon={faList} /></div>
            <Link to="/" className="brand-logo">Parrhasius</Link>
            <ul id="nav-mobile" className="right hide-on-med-and-down">
              {links}
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

          <Route path="/">
            <div class="container">
              <div class="row">
                <div class="col s12 collection">
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
