// @flow
// @jsx glam
/*eslint no-unused-vars: ["warn", { "varsIgnorePattern": "glam" }]*/

import glam from 'glam';
import React from 'react';

export const Header = (onDelete) => ({ currentView, modalProps }) => {
  const { onClose } = modalProps;

  return (
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
        zIndex: 1
      }}
    >
      <div css={{
        alignItems: 'center',
        display: 'flex ',
      }}>
        <Button
          onClick={onDelete}
        >
          <Heart />
        </Button>
        <Button
          onClick={onClose}
          css={{
            borderLeft: `1px solid`,
            paddingLeft: 10,
          }}
        >
          <Close />
        </Button>
      </div>
    </div>
  );
};

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

      ...css,
    }}
    role="button"
    {...props}
  />
);

type SvgProps = { size: number };

const Svg = ({ size, ...props }: SvgProps) => (
  <svg
    role="presentation"
    viewBox="0 0 24 24"
    css={{
      display: 'inline-block',
      fill: 'currentColor',
      height: size,
      stroke: 'currentColor',
      strokeWidth: 0,
      width: size,
    }}
    {...props}
  />
);

export const Close = ({ size = 24, ...props }: SvgProps) => (
  <Svg size={size} {...props}>
    <path d="M18.984 6.422l-5.578 5.578 5.578 5.578-1.406 1.406-5.578-5.578-5.578 5.578-1.406-1.406 5.578-5.578-5.578-5.578 1.406-1.406 5.578 5.578 5.578-5.578z" />
  </Svg>
);
export const Heart = ({ size = 24, ...props }: SvgProps) => (
  <Svg size={size} {...props}>
    <path d="M12.094 18.563c4.781-4.313 7.922-7.172 7.922-10.078 0-2.016-1.5-3.469-3.516-3.469-1.547 0-3.047 0.984-3.563 2.344h-1.875c-0.516-1.359-2.016-2.344-3.563-2.344-2.016 0-3.516 1.453-3.516 3.469 0 2.906 3.141 5.766 7.922 10.078l0.094 0.094zM16.5 3c3.094 0 5.484 2.391 5.484 5.484 0 3.797-3.375 6.844-8.531 11.531l-1.453 1.313-1.453-1.266c-5.156-4.688-8.531-7.781-8.531-11.578 0-3.094 2.391-5.484 5.484-5.484 1.734 0 3.422 0.844 4.5 2.109 1.078-1.266 2.766-2.109 4.5-2.109z" />
  </Svg>
);

export default Header;
