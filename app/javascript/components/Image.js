import React from "react";
import { SimpleImg } from "react-simple-img";

const cont = {
  cursor: "pointer",
  margin: "2px",
};

const Image =
  (onClick) =>
  ({
    index,
    left,
    top,
    key,
    photo: { title, width, height, src, ...imgStyle },
  }) =>
    (
      <div
        key={key}
        onClick={() => onClick(index)}
        style={{ height: height, width: width, ...cont }}
      >
        <SimpleImg
          width={width}
          height={height}
          src={src}
          imgStyle={{
            alt: title,
            ...imgStyle,
          }}
        />
      </div>
    );

export default Image;
