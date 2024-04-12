export const abi = [
    {
        "type": "impl",
        "name": "DojoResourceProviderImpl",
        "interface_name": "dojo::world::IDojoResourceProvider"
    },
    {
        "type": "interface",
        "name": "dojo::world::IDojoResourceProvider",
        "items": [
            {
                "type": "function",
                "name": "dojo_resource",
                "inputs": [],
                "outputs": [
                    {
                        "type": "core::felt252"
                    }
                ],
                "state_mutability": "view"
            }
        ]
    },
    {
        "type": "impl",
        "name": "WorldProviderImpl",
        "interface_name": "dojo::world::IWorldProvider"
    },
    {
        "type": "struct",
        "name": "dojo::world::IWorldDispatcher",
        "members": [
            {
                "name": "contract_address",
                "type": "core::starknet::contract_address::ContractAddress"
            }
        ]
    },
    {
        "type": "interface",
        "name": "dojo::world::IWorldProvider",
        "items": [
            {
                "type": "function",
                "name": "world",
                "inputs": [],
                "outputs": [
                    {
                        "type": "dojo::world::IWorldDispatcher"
                    }
                ],
                "state_mutability": "view"
            }
        ]
    },
    {
        "type": "impl",
        "name": "IActionsImpl",
        "interface_name": "chess::actions::IActions"
    },
    {
        "type": "struct",
        "name": "chess::models::piece::Vec2",
        "members": [
            {
                "name": "x",
                "type": "core::integer::u32"
            },
            {
                "name": "y",
                "type": "core::integer::u32"
            }
        ]
    },
    {
        "type": "enum",
        "name": "core::bool",
        "variants": [
            {
                "name": "False",
                "type": "()"
            },
            {
                "name": "True",
                "type": "()"
            }
        ]
    },
    {
        "type": "interface",
        "name": "chess::actions::IActions",
        "items": [
            {
                "type": "function",
                "name": "move",
                "inputs": [
                    {
                        "name": "curr_position",
                        "type": "chess::models::piece::Vec2"
                    },
                    {
                        "name": "next_position",
                        "type": "chess::models::piece::Vec2"
                    },
                    {
                        "name": "caller",
                        "type": "core::starknet::contract_address::ContractAddress"
                    },
                    {
                        "name": "game_id",
                        "type": "core::integer::u32"
                    }
                ],
                "outputs": [],
                "state_mutability": "view"
            },
            {
                "type": "function",
                "name": "is_in_check",
                "inputs": [
                    {
                        "name": "caller",
                        "type": "core::starknet::contract_address::ContractAddress"
                    },
                    {
                        "name": "game_id",
                        "type": "core::integer::u32"
                    }
                ],
                "outputs": [
                    {
                        "type": "core::bool"
                    }
                ],
                "state_mutability": "view"
            },
            {
                "type": "function",
                "name": "is_in_checkmate",
                "inputs": [
                    {
                        "name": "caller",
                        "type": "core::starknet::contract_address::ContractAddress"
                    },
                    {
                        "name": "game_id",
                        "type": "core::integer::u32"
                    }
                ],
                "outputs": [
                    {
                        "type": "core::bool"
                    }
                ],
                "state_mutability": "view"
            },
            {
                "type": "function",
                "name": "is_legal_move",
                "inputs": [
                    {
                        "name": "curr_position",
                        "type": "chess::models::piece::Vec2"
                    },
                    {
                        "name": "next_position",
                        "type": "chess::models::piece::Vec2"
                    },
                    {
                        "name": "game_id",
                        "type": "core::integer::u32"
                    },
                    {
                        "name": "caller",
                        "type": "core::starknet::contract_address::ContractAddress"
                    }
                ],
                "outputs": [
                    {
                        "type": "core::bool"
                    }
                ],
                "state_mutability": "view"
            },
            {
                "type": "function",
                "name": "spawn",
                "inputs": [

                ],
                "outputs": [
                    {
                        "type": "core::integer::u32"
                    }
                ],
                "state_mutability": "view"
            }
        ]
    },
    {
        "type": "impl",
        "name": "UpgradableImpl",
        "interface_name": "dojo::components::upgradeable::IUpgradeable"
    },
    {
        "type": "interface",
        "name": "dojo::components::upgradeable::IUpgradeable",
        "items": [
            {
                "type": "function",
                "name": "upgrade",
                "inputs": [
                    {
                        "name": "new_class_hash",
                        "type": "core::starknet::class_hash::ClassHash"
                    }
                ],
                "outputs": [],
                "state_mutability": "external"
            }
        ]
    },
    {
        "type": "event",
        "name": "dojo::components::upgradeable::upgradeable::Upgraded",
        "kind": "struct",
        "members": [
            {
                "name": "class_hash",
                "type": "core::starknet::class_hash::ClassHash",
                "kind": "data"
            }
        ]
    },
    {
        "type": "event",
        "name": "dojo::components::upgradeable::upgradeable::Event",
        "kind": "enum",
        "variants": [
            {
                "name": "Upgraded",
                "type": "dojo::components::upgradeable::upgradeable::Upgraded",
                "kind": "nested"
            }
        ]
    },
    {
        "type": "event",
        "name": "chess::actions::actions::Event",
        "kind": "enum",
        "variants": [
            {
                "name": "UpgradeableEvent",
                "type": "dojo::components::upgradeable::upgradeable::Event",
                "kind": "nested"
            }
        ]
    }
];