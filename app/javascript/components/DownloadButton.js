import React, { Fragment, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCloudDownloadAlt } from "@fortawesome/free-solid-svg-icons";
import { download } from "../api";
import Button from "@mui/material/Button";
import InputUnstyled from "@mui/base/InputUnstyled";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";

function DownloadButton() {
  const [open, setOpen] = useState(false);
  const [disabled, setDisabled] = useState(false);
  const [value, setValue] = useState("");

  const onClick = async () => {
    await setDisabled(true);
    const response = await download(value);
    const { job_id: jobId } = await response.json();
    window.location = `/downloads/${jobId}`;
    await setValue("");
    await handleClose();
    await setDisabled(false);
  };

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleChange = (ev) => {
    setValue(ev.target.value);
  };

  return (
    <Fragment>
      <button className="btn-floating green" onClick={handleClickOpen}>
        {" "}
        <FontAwesomeIcon icon={faCloudDownloadAlt} />{" "}
      </button>
      <Dialog open={open} onClose={handleClose} maxWidth="md" fullwidth="true">
        <DialogTitle>Download...</DialogTitle>
        <DialogContent>
          <InputUnstyled
            autoFocus
            disabled={disabled}
            margin="dense"
            id="name"
            label="folder url"
            placeholder="https://..."
            type="url"
            fullwidth="true"
            value={value}
            onChange={handleChange}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClick}>Download</Button>
        </DialogActions>
      </Dialog>
    </Fragment>
  );
}

export default DownloadButton;
