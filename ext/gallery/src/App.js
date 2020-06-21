import React, {useState} from "react";
import Folder from './components/Folder';
import {getFolders} from './api';
import {List, Map} from 'immutable';
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
        setFolders(Map(folders).toSeq().sortBy(([_, v]) => v));
      })
    }
  }


  const links = folders.toArray().map(([k, v]) => <li key={k}><Link to={"/folders/"+k}>{v}</Link></li>);
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
            <ul>
              {links}
            </ul>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}
export default App;
