import {Account, CallData, Contract, RpcProvider} from "starknet";
import {abi} from "./abi";
import {Vec2} from "../Components/Chessboard/Chessboard";

export const KATANA_ACCOUNT_ADDRESS = "0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03";
export const KATANA_ACCOUNT_PRIVATE_KEY = "0x1800000000300000180000000000030000000000003006001800006600";
export const PLAYER_CLASS_HASH = "0x1d6bd75d205c34901674c6e42c282b3bfb8d179a4a60de2b2a4d6329ad1766e";
export const WORLD_CONTRACT_ADDRESS = "0x23907fff4d969aa0f22a0e53842148e65aeebe30448b050b4b71698cf179c97";
export const KATANA_RPC = "http://localhost:5050/";

export function setupNetwork() {
    const provider = new RpcProvider({nodeUrl: KATANA_RPC});

    const signer = new Account(
        provider,
        KATANA_ACCOUNT_ADDRESS,
        KATANA_ACCOUNT_PRIVATE_KEY
    );

    return {
        provider,
        signer,
    }
}

export async function SpawnGame({provider, signer}:{ provider: RpcProvider; signer: Account }) {
    //create call data compiler and connect contract to account
    const contractCallData = new CallData(abi);
    const system_contract = new Contract(abi, WORLD_CONTRACT_ADDRESS, provider);
    system_contract.connect(signer);

    //create a white player contract
    const deploy_white_response = await signer.deployContract({classHash: PLAYER_CLASS_HASH});
    await provider.waitForTransaction(deploy_white_response.transaction_hash);
    const white_contract_address = new Contract(abi, deploy_white_response.contract_address, provider).address;

    //create a black player contract
    const deploy_black_response = await signer.deployContract({classHash: PLAYER_CLASS_HASH});
    await provider.waitForTransaction(deploy_black_response.transaction_hash);
    const black_contract_address = new Contract(abi, deploy_black_response.contract_address, provider).address;

    //call contract method to generate new game
    await system_contract.invoke('spawn',
        contractCallData.compile('spawn', {
            white_address: white_contract_address,
            black_address: black_contract_address,
        }),
        {
            maxFee: 0,
        });

    //export player contract
    const black = black_contract_address;
    const white = white_contract_address;
    return {black, white}
}

export async function callMove(curr_position: Vec2, next_position: Vec2, game_id: number, caller: String, signer: Account) {

    //create call data compiler and connect contract to account
    const contractCallData = new CallData(abi);
    const system_contract = new Contract(abi, WORLD_CONTRACT_ADDRESS, setupNetwork().provider);
    system_contract.connect(signer);

    //call method
    try {
        return await system_contract.invoke('is_legal_move',
            contractCallData.compile('is_legal_move', {
                curr_position: curr_position, // Use destructuring for curr_position
                next_position: next_position,
                game_id: game_id,
                caller: caller
            }), {
                maxFee: 0,
            }); // Return the result directly
    } catch (error) {
        console.error("Error calling is_legal_move:", error);
        return false; // Return false on error
    }
}



