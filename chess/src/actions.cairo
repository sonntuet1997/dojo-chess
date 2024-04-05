use starknet::ContractAddress;
use chess::models::piece::Vec2;

#[dojo::interface]
trait IActions {
    fn is_legal_move(curr_position: Vec2, next_position: Vec2, caller: ContractAddress, game_id: u32) -> bool;
    fn is_in_check(caller: ContractAddress, game_id: u32) -> bool;
    fn is_in_checkmate(caller: ContractAddress, game_id: u32) -> bool;
    fn is_not_block(curr_position: Vec2, next_position: Vec2, game_id: u32) -> bool;
    fn spawn(white_address: ContractAddress, black_address: ContractAddress) -> u32;
}

#[dojo::contract]
mod actions {
    use chess::models::player::{Player, Color, PlayerTrait};
    use chess::models::piece::{Piece, PieceType, PieceTrait};
    use chess::models::game::{Game, GameTurn, GameTurnTrait};
    use super::{ContractAddress, IActions, Vec2};

    #[abi(embed_v0)]
    impl IActionsImpl of IActions<ContractState> {
        fn is_in_check(world: IWorldDispatcher, caller: ContractAddress, game_id: u32) -> bool {
            true
        }

        fn is_in_checkmate(world: IWorldDispatcher, caller: ContractAddress, game_id: u32) -> bool {
            true
        }

        fn is_not_block(world: IWorldDispatcher, curr_position: Vec2, next_position: Vec2, game_id: u32) -> bool {
            if PieceTrait::is_out_of_board(next_position) {
                return false;
            }
            let mut curr_piece = get!(world, (game_id, curr_position), (Piece));
            if curr_piece.piece_type == PieceType::Pawn || curr_piece.piece_type == PieceType::Knight || curr_piece.piece_type == PieceType::King {
                return true;
            }
            if curr_piece.piece_type == PieceType::Queen || curr_piece.piece_type == PieceType::Bishop || curr_piece.piece_type == PieceType::Rook {
                let (a, b): (i32, i32) = PieceTrait::get_direction(curr_position, next_position);
                let mut d: i32 = PieceTrait::get_distance(curr_position, next_position).try_into().unwrap();
                let mut i: i32 = 1;
                let result: bool = loop
                {
                    if i > d
                    {
                        break true;
                    }
                    let mut x_i32: i32 = curr_position.x.try_into().unwrap(); let mut y_i32: i32 = curr_position.y.try_into().unwrap();
                    x_i32 += i * a; y_i32 += i * b;
                    let mut x_u32: u32 = x_i32.try_into().unwrap(); let mut y_u32: u32 = y_i32.try_into().unwrap();
                    let mut pos = Vec2 {x: x_u32, y: y_u32};
                    let mut piece = get!(world, (game_id, pos), (Piece));
                    if piece.piece_type != PieceType::None
                    {
                        break false;
                    }
                    i += 1;
                };
                return result;
            }
            return false;
        }

        fn spawn(
            world: IWorldDispatcher,
            white_address: ContractAddress,
            black_address: ContractAddress
        ) -> u32 {
            let game_id: u32 = world.uuid();

            // set Players
            set!(
                world,
                (
                    Player { game_id, address: black_address, color: Color::Black },
                    Player { game_id, address: white_address, color: Color::White },
                )
            );

            // set Game and GameTurn
            set!(
                world,
                (
                    Game {
                        game_id, winner: Color::None, white: white_address, black: black_address
                    },
                    GameTurn { game_id, player_color: Color::White },
                )
            );

            // set white Pieces
            // set white Rook
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 0, y: 0 },
                    piece_type: PieceType::Rook
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 7, y: 0 },
                    piece_type: PieceType::Rook
                })
            );

            //set white pawn
            let mut i: u32 = 0;
            while i <= 7 {
                set!(
                     world,
                     (Piece {
                         game_id,
                         color: Color::White,
                         position: Vec2 { x: i, y: 1 },
                         piece_type: PieceType::Pawn
                    })
                );
                i += 1;
            };
 
            // set white Knight
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 1, y: 0 },
                    piece_type: PieceType::Knight
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 6, y: 0 },
                    piece_type: PieceType::Knight
                })
            );

            //set white Bishop
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 2, y: 0 },
                    piece_type: PieceType::Bishop,
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 5, y: 0 },
                    piece_type: PieceType::Bishop,
                })
            );

            //set white Queen
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 3, y: 0 },
                    piece_type: PieceType::Queen
                })
            );

            // set white King
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::White,
                    position: Vec2 { x: 4, y: 0 },
                    piece_type: PieceType::King
                })
            );

            // set black Rook
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 0, y: 7 },
                    piece_type: PieceType::Rook
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 7, y: 7 },
                    piece_type: PieceType::Rook
                })
            );

            //set black pawn
            let mut i: u32 = 0;
            while i <= 7 {
                set!(
                     world,
                     (Piece {
                         game_id,
                         color: Color::Black,
                         position: Vec2 { x: i, y: 6 },
                         piece_type: PieceType::Pawn
                    })
                );
                i += 1;
            };
 
            // set black Knight
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 1, y: 7 },
                    piece_type: PieceType::Knight
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 6, y: 7 },
                    piece_type: PieceType::Knight
                })
            );

            //set black Bishop
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 2, y: 7 },
                    piece_type: PieceType::Bishop,
                })
            );
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 5, y: 7 },
                    piece_type: PieceType::Bishop,
                })
            );

            //set black Queen
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 3, y: 7 },
                    piece_type: PieceType::Queen
                })
            );

            // set black King
            set!(
                world,
                (Piece {
                    game_id,
                    color: Color::Black,
                    position: Vec2 { x: 4, y: 7 },
                    piece_type: PieceType::King
                })
            );

            game_id
        }

        fn is_legal_move(
            world: IWorldDispatcher,
            curr_position: Vec2,
            next_position: Vec2,
            caller: ContractAddress, //player
            game_id: u32
        ) -> bool {
            let mut current_piece = get!(world, (game_id, curr_position), (Piece));
            // check if next_position is out of board or not
            if (!PieceTrait::is_out_of_board(next_position)) { return false; }

            // check if this is the right move for this piece type
            if (!current_piece.is_right_piece_move(next_position)) { return false; }

            // Get piece data from to next_position in the board
            let mut next_position_piece = get!(world, (game_id, next_position), (Piece));

            let player = get!(world, (game_id, caller), (Player));

            // check if there is already a piece in next_position
            if (!player.is_not_my_piece(next_position_piece.color)) { return false; }

            // check if path is blocked by another piece

            next_position_piece.piece_type = current_piece.piece_type;
            next_position_piece.color = player.color;
            // make current_piece piece none
            current_piece.piece_type = PieceType::None;
            current_piece.color = Color::None;
            set!(world, (next_position_piece));
            set!(world, (current_piece));

            // change turn
            let mut game_turn = get!(world, game_id, (GameTurn));
            game_turn.player_color = game_turn.next_turn();
            set!(world, (game_turn));
            return true;
        }
    }
}