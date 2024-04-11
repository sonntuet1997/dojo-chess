import React from 'react';

// @ts-ignore
const Button = ({ children, onClick, variant = "primary" }) => {
    const buttonClass = `button button-${variant}`;

    return (
        <button className={buttonClass} onClick={onClick}>
            {children}
        </button>
    );
};

export default Button;
