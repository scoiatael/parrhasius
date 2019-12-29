// @flow
// @jsx glam
/*eslint no-unused-vars: ["warn", { "varsIgnorePattern": "glam" }]*/

import glam from 'glam';
import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faTimes, faTrashAlt } from '@fortawesome/free-solid-svg-icons'

export const Header = (onDelete) => ({ modalProps: {onClose}, data: {title} }) => (
    <div
      css={{
        alignItems: 'center',
        backgroundColor: 'rgba(255, 255, 255, 0.5)',
        boxShadow: '0 1px 0 rgba(0, 0, 0, 0.1)',
        display: 'flex ',
        flex: '0 0 auto',
        height: 54,
        justifyContent: 'space-between',
        marginLeft: 'auto',
        position: 'absolute',
        right: '0px',
        width: '100%'
      }}
    >
      <div css={{
        alignItems: 'center',
        display: 'flex ',
        zIndex: 1,
        backgroundColor: 'rgba(255, 255, 255, 0.5)',
        borderRadius: '0.1em',
      }}>
    {title}
      </div>
      <div css={{
        alignItems: 'center',
        display: 'flex ',
        zIndex: 1,
      }}>
        <Button
          onClick={onDelete}
        >
          <FontAwesomeIcon icon={faTrashAlt} />
        </Button>
        <Button
          onClick={onClose}
        >
          <FontAwesomeIcon icon={faTimes} />
        </Button>
      </div>
    </div>
);

const Button = ({ css, ...props }) => (
  <div
    css={{
      alignItems: 'center',
      cursor: 'pointer',
      display: 'flex ',
      fontWeight: 300,
      height: 32,
      justifyContent: 'center',
      marginLeft: 10,
      position: 'relative',
      textAlign: 'center',
      minWidth: 32,
      zIndex: 2,
      backgroundColor: 'rgba(255, 255, 255, 0.5)',
      borderRadius: '0.5em',

      ...css,
    }}
    role="button"
    {...props}
  />
);

export default Header;
