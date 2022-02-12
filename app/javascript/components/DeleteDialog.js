import React from "react";
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';

function DeleteDialog({onClick, image, isOpen}) {
  const text = image ? `Delete photo ${image.title}?` : ''

  return (
    <Dialog
      open={isOpen}
      onClose={() => onClick(false)}>
      <DialogTitle>{text}</DialogTitle>
      <DialogContent>
      </DialogContent>
      <DialogActions>
        <Button onClick={() => onClick(true)}>Yes</Button>
      </DialogActions>
    </Dialog>
  );
}

export default DeleteDialog;
