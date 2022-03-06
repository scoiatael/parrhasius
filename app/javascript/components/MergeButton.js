import React, { useState } from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit } from '@fortawesome/free-solid-svg-icons'
import {  mergeFolders } from "../api";
import Button from '@mui/material/Button';
import InputUnstyled from '@mui/base/InputUnstyled';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';

function MergeButton({folderId}) {
 const [open, setOpen] = useState(false);
 const [value, setValue] = useState('');

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };
  const handleChange = (ev) => {
      setValue(ev.target.value);
  };
    const merge = async () => {
        await mergeFolders(folderId, value)
      window.location.reload();
    };
    const style = {
        marginRight: '0.2em'
    }

  return (
    <span>
      <button className="btn-floating blue" onClick={handleClickOpen} style={style}><FontAwesomeIcon icon={faEdit} /></button>
      <Dialog
        open={open}
        onClose={handleClose}
        maxWidth="md"
        fullwidth="true">
        <DialogTitle>Merge with...</DialogTitle>
        <DialogContent>
          <InputUnstyled
            autoFocus
            margin="dense"
            id="name"
            label="folder name"
            type="text"
            fullwidth="true"
            value={value}
            onChange={handleChange}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={merge}>Merge</Button>
        </DialogActions>
      </Dialog>
    </span>
  );
}

export default MergeButton;
