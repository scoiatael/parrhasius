import React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCloudDownloadAlt } from "@fortawesome/free-solid-svg-icons";
import { useHistory } from "react-router-dom";
import { download } from "../api";

function DownloadButton() {
  const history = useHistory();

  const onClick = async () => {
    const url = prompt("URL?", "https://boards.4chan.org/wg/...");
    const response = await download(url);
    console.log({ response });
    const { queued, job_id: jobId } = await response.json();
    console.log({ queued, jobId });
    history.push(`/downloads/${jobId}`);
  };

  return (
    <button className="btn-floating green" onClick={onClick}>
      <FontAwesomeIcon icon={faCloudDownloadAlt} />
    </button>
  );
}

export default DownloadButton;
