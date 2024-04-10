import './Chessboard.css'
import Tile from "../Tile/Tile";
import React, {useEffect, useRef, useState} from "react";

interface Piece {
    image: string
    x: number
    y: number
}

const initialBoardState: Piece[] = [];
for (let i = 0; i < 8; i++) {
    initialBoardState.push({image: "/Assets/Images/black-pawn.png", x: i, y: 6})
}

for (let i = 0; i < 8; i++) {
    initialBoardState.push({image: "/Assets/Images/white-pawn.png", x: i, y: 1})
}

for (let p = 0; p < 2; p++) {
    const type = p === 0 ? "black" : "white";
    const y = p === 0 ? 7 : 0;
    initialBoardState.push({image: `/Assets/Images/${type}-rook.png`, x: 0, y});
    initialBoardState.push({image: `/Assets/Images/${type}-rook.png`, x: 7, y});
    initialBoardState.push({image: `/Assets/Images/${type}-knight.png`, x: 1, y});
    initialBoardState.push({image: `/Assets/Images/${type}-knight.png`, x: 6, y});
    initialBoardState.push({image: `/Assets/Images/${type}-bishop.png`, x: 2, y});
    initialBoardState.push({image: `/Assets/Images/${type}-bishop.png`, x: 5, y});
    initialBoardState.push({image: `/Assets/Images/${type}-king.png`, x: 3, y});
    initialBoardState.push({image: `/Assets/Images/${type}-queen.png`, x: 4, y});
}

export function Chessboard() {
    const [board, setBoard] = useState<any[] | null>(null);
    const [activePiece, setActivePiece] = useState<HTMLElement | null>(null);
    const [gridX, setGridX] = useState(0);
    const [gridY, setGridY] = useState(0);
    const [pieces, setPieces] = useState<Piece[]>(initialBoardState);
    const chessBoardRef = useRef<HTMLDivElement>(null);

    const grabPiece = (e: React.MouseEvent) => {
        const chessboard = chessBoardRef.current;
        const element = e.target as HTMLElement;
        if (element.classList.contains("chess-piece") && chessboard) {
            setGridX(Math.floor((e.clientX - chessboard.offsetLeft) / 100));
            setGridY(7 - Math.floor((e.clientY - chessboard.offsetTop) / 100));
            const x = e.clientX - 50;
            const y = e.clientY - 50;
            element.style.position = 'absolute';
            element.style.left = `${x}px`;
            element.style.top = `${y}px`;
            setActivePiece(element);
        }
    }

    const movePiece = (e: React.MouseEvent) => {
        const chessBoard = chessBoardRef.current;
        if (activePiece && chessBoard) {
            const minX = chessBoard.offsetLeft - 25;
            const minY = chessBoard.offsetTop - 25;
            const maxX = chessBoard.offsetLeft + chessBoard.clientWidth - 75;
            const maxY = chessBoard.offsetTop + chessBoard.clientHeight - 75;

            const x = e.clientX - 50;
            const y = e.clientY - 50;
            activePiece.style.position = 'absolute';

            if (x < minX) {
                activePiece.style.left = `${minX}px`;
            } else if (x > maxX) {
                activePiece.style.left = `${maxX}px`
            } else {
                activePiece.style.left = `${x}px`
            }

            if (y < minY) {
                activePiece.style.top = `${minY}px`;
            } else if (y > maxY) {
                activePiece.style.top = `${maxY}px`
            } else {
                activePiece.style.top = `${y}px`
            }
        }
    }

    const dropPiece = (e: React.MouseEvent) => {
        const chessboard = chessBoardRef.current;
        console.log(chessboard);
        if (activePiece && chessboard) {
            const x = Math.floor((e.clientX - chessboard.offsetLeft) / 100);
            const y = 7 - Math.floor((e.clientY - chessboard.offsetTop) / 100);
            setPieces((value) => {
                return value.map((p) => {
                    if (p.x === gridX && p.y === gridY) {
                        p.x = x;
                        p.y = y;
                    }
                    return p;
                });
            });
            setActivePiece(null);
        }
    }

    const drawBoard = () => {
        let board = [];
        for (let j = 7; j >= 0; j--) {
            for (let i = 0; i < 7; i++) {
                const number = j + i - 2;
                let image = undefined;
                pieces.forEach(p => {
                    if (p.x === i && p.y === j) {
                        image = p.image;
                    }
                })
                if (image !== undefined) {
                    board.push(<Tile
                        image={image}
                        number={number}/>);
                } else {
                    board.push(<Tile
                        number={number}/>);
                }
            }
        }
        setBoard(board);
    }

    return {
        drawBoard,
        grabPiece,
        movePiece,
        dropPiece,
        chessBoardRef,
        board,
    }
}