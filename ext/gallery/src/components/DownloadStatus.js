import React, { useState, useEffect } from "react";
import { useHistory, useParams } from "react-router-dom";
import { Map } from "immutable";
import { downloadStatus } from "../api";

function ProgressBar({ stage, width }) {
  const style = {
    width: width + "%",
  };
  return (
    <div>
      <div className="col s4">{stage}</div>
      <div className="col s8">
        <div className="progress">
          <div className="determinate" style={style}></div>
        </div>
      </div>
    </div>
  );
}

function DownloadStatus({ onDone }) {
  const { jobId } = useParams();
  const history = useHistory();
  const [status, setStatus] = useState(Map());

  useEffect(() => {
    const download = downloadStatus(jobId);
    const listener = (node) => {
      const {
        status: { status, step, progress, total },
      } = node;
      if (status === "completed" || status === "failed") {
        history.push("/");
        onDone();
      }
      setStatus((st) => st.set(step, Math.floor((100 * progress) / total)));
    };
    download.on("node", "events.{status}", listener);
    download.fail((err) => console.error("E", err));
    return () => {
      download.removeListener(listener);
    };
  }, [history, setStatus, jobId, onDone]);

  const statusPs = status
    .toArray()
    .map(([s, i]) => <ProgressBar key={s} width={i} stage={s} />);

  return (
    <div className="container">
      <div className="row">
        <div className="col s12">
          <p>
            Job: <code>{jobId}</code>
          </p>
        </div>
        {statusPs}
      </div>
    </div>
  );
}

export default DownloadStatus;
