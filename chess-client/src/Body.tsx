import React, {useEffect, useRef, useState} from "react";
import Button from "./Components/Button/Button";
import { setupNetwork } from "./dojo/setupNetwork";
import { Chessboard } from "./Components/Chessboard/Chessboard";

export enum State {
    Init,
    Spawn,
    Playing,
    End,
}

export function Body() {
    const [state, setState] = useState<State>(State.Init);
    const [board, setBoard] = useState<React.ReactElement | any[] | null>(<div>Loading board...</div>);
    const chessBoardRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (state === State.Spawn) {
            setupNetwork().callSpawn()
                .then(() => Chessboard().drawBoard())
                .then(() => setState(State.Playing))
                .catch((error) => console.error("Error spawning board:", error))
                .finally(() => setState(State.Playing))
        }
    }, [state]);

    const Playing = ({ chessBoardRef }: { chessBoardRef: React.RefObject<HTMLDivElement> }) => {
        return (
            <div onMouseUp={(e) => Chessboard().dropPiece(e)}
                onMouseMove={(e) => Chessboard().movePiece(e)}
                onMouseDown={(e) => Chessboard().grabPiece(e)}
                ref={chessBoardRef}
                 id="chessboard">
                {board}
            </div>
        );
    };

    const handleClick = () => {
        setState(State.Spawn);
    };

    return (
        <div>
            {state === State.Init && (
                <Button onClick={handleClick}>Start Game</Button>
            )}
            {state === State.Spawn &&
                <div>
                    Loading board...
                </div>}
            {state === State.Playing && chessBoardRef.current && <Playing chessBoardRef={chessBoardRef} />}
            {state === State.End && <p>
                Checkmate! Game Over.
                <Button onClick={() => setState(State.Init)}>Play one more time!</Button>
            </p>}
        </div>
    );
}
