import React, {useEffect, useState} from "react";
import Button from "./Components/Button/Button";
import { setupNetwork } from "./dojo/setupNetwork";
import Chessboard from "./Components/Chessboard/Chessboard";

export enum State {
    Init,
    Spawn,
    Playing,
    End,
}

export function Body() {
    const [state, setState] = useState<State>(State.Init);

    useEffect(() => {
        if (state === State.Spawn) setupNetwork().callSpawn().then(r => setState(State.Playing))
    }, [state]);

    const handleClick = () => {
        setState(State.Spawn);
    };

    console.log(state);

    return (
        <div>
            {state === State.Init && (
                <Button onClick={handleClick}>Start Game</Button>
            )}
            {state === State.Spawn &&
                <div>
                    Loading board...
                </div>}
            {state === State.Playing && <Chessboard />}
            {state === State.End && <p>
                Checkmate! Game Over.
                <Button onClick={() => setState(State.Init)}>Play one more time!</Button>
            </p>}
        </div>
    );
}
