import React, { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash } from "@fortawesome/free-solid-svg-icons";
import { deleteFolder } from "../api";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogTitle from "@mui/material/DialogTitle";

function TrashButton({ folderId, name }) {
  const [open, setOpen] = useState(false);
  const onAction = async () => {
    await deleteFolder(folderId);
    window.location.reload();
  };
  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <span>
      <button className="btn-floating red" onClick={handleClickOpen}>
        <FontAwesomeIcon icon={faTrash} />
      </button>

      <Dialog open={open} onClose={handleClose} maxWidth="md" fullwidth="true">
        <DialogTitle>Confirm delete {name}</DialogTitle>
        <DialogActions>
          <Button onClick={onAction}>OK</Button>
        </DialogActions>
      </Dialog>
    </span>
  );
}

export default TrashButton;
