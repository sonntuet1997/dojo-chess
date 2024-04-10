import {Account, CallData, Contract, RpcProvider} from "starknet";
import {abi} from "./abi";
export const KATANA_ACCOUNT_ADDRESS = "0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03";
export const KATANA_ACCOUNT_PRIVATE_KEY = "0x1800000000300000180000000000030000000000003006001800006600";
export const WORLD_ADDRESS = "0x446f1f19ba951b59935df72974f8ba6060e5fbb411ca21d3e3e3812e3eb8df8";

export const SYSTEM_CLASS_ADDRESS = "0x23907fff4d969aa0f22a0e53842148e65aeebe30448b050b4b71698cf179c97";
export const KATANA_RPC = "http://localhost:5050/";

export function setupNetwork() {
    const provider = new RpcProvider({  nodeUrl: KATANA_RPC  });

    const signer = new Account(
        provider,
        KATANA_ACCOUNT_ADDRESS,
        KATANA_ACCOUNT_PRIVATE_KEY
    );

    const callSpawn = async () => {
        const white_contract_address = new Contract(abi, SYSTEM_CLASS_ADDRESS, setupNetwork().provider).address;
        console.log(white_contract_address);
        const black_contract_address = new Contract(abi, SYSTEM_CLASS_ADDRESS, setupNetwork().provider).address;
        console.log(black_contract_address);
        const contractCallData = new CallData(abi);
        await signer.execute({
            entrypoint: 'spawn',
            contractAddress: SYSTEM_CLASS_ADDRESS,
            calldata: contractCallData.compile('spawn', {
                white_address: white_contract_address,
                black_address: black_contract_address,
            })
        })
    }

    const callMove = () => {

    }

    const callCheckmate = () => {

    }
    return {
        provider,
        signer,
        callSpawn,
        callMove,
        callCheckmate,
    }
}



