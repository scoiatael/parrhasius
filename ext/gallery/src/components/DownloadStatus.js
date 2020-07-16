import React, { useState } from "react";
import { Redirect } from "react-router-dom";
import { Map } from 'immutable';
import { download } from '../api';

function ProgressBar({stage, width}) {
    const style = {
        width: width + "%"
    };
    return (<div>
         <div className="col s4">
           {stage}
         </div>
         <div className="col s8">
           <div className="progress">
             <div className="determinate" style={style}></div>
           </div>
         </div>
       </div>
      );
}

function DownloadStatus({url, onDone}) {
    const [connection, setConnection] = useState(null);
    const [status, setStatus] = useState(Map());
    const [done, setDone] = useState(false);

    if (!url) {
        return (<Redirect to="/"/>)
    }

    if (done) {
        return (<Redirect to="/"/>)
    }

    if(!connection) {
        setConnection(true);
        download(
            url
        ).on('node', 'events.{stage}', node => {
            const {stage, progress, total} = node;
            setStatus(st => st.set(stage, Math.floor(100 * progress / total)));
        }).on('node', 'events.{done}', node => {
            onDone();
            setDone(true);
        }).fail(err => console.error("E", err));
    }

    const status_ps = status.toArray().map(([s, i]) => (
        <ProgressBar key={s} width={i} stage={s}/>
    ));

    return (
        <div className="container">
          <div className="row">
            <div className="col s12">
              <p>Downloading {url}</p>
            </div>
            {status_ps}
          </div>
        </div>
    );
}

export default DownloadStatus;
