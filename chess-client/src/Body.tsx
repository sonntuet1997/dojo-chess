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
    const [gameId, setGameId] = useState(0);

    useEffect(() => {
        if (state === State.Spawn) setupNetwork().callSpawn(setupNetwork().signer, setupNetwork().signer).then(() => {
            setState(State.Playing);
        })
    }, [state]);

    const handleReset = () => {
        setState(State.Init);
        setGameId((prevState) => prevState + 1);
    }

    return (
        <div>
            {state === State.Init && (
                <Button onClick={() => setState(State.Spawn)}>Start Game</Button>
            )}
            {state === State.Spawn &&
                <div className="text-color">
                    Loading board...
                </div>}
            {state === State.Playing && <Chessboard gameId={gameId}/>}
            {state === State.End && <p>
                Checkmate! Game Over.
                <Button onClick={() => handleReset()}>Play one more time!</Button>
            </p>}
        </div>
    );
}
