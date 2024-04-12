use starknet::ContractAddress;
use chess::models::piece::Vec2;

#[dojo::interface]
trait IActions {
    fn is_in_check(caller: ContractAddress, game_id: u32) -> bool;
    fn is_in_checkmate(caller: ContractAddress, game_id: u32) -> bool;
    fn is_legal_move(curr_position: Vec2, next_position: Vec2, game_id: u32, caller: ContractAddress) -> bool;
    fn spawn() -> u32;
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

        fn is_legal_move(world: IWorldDispatcher,
                        curr_position: Vec2,
                        next_position: Vec2,
                        game_id: u32,
                        caller: ContractAddress) -> bool {
            let mut result: bool = true;
            //check if next position is not out of board
            if PieceTrait::is_out_of_board(next_position) {
                result = false;
            }
            assert!(!PieceTrait::is_out_of_board(next_position), "Should be inside board");


            //check if this piece move right
            let mut curr_piece = get!(world, (game_id, curr_position), (Piece));
            if !curr_piece.is_right_piece_move(next_position) {
                result = false;
            }
            assert!(curr_piece.is_right_piece_move(next_position), "Illegal move for type of piece");


            //check if next position have same color piece
            let mut next_position_piece = get!(world, (game_id, next_position), (Piece));
            let player = get!(world, (game_id, caller), (Player));
            if !player.is_not_my_piece(next_position_piece.color) {
                result = false;
            }
            assert!(!player.is_not_my_piece(next_position_piece.color),
                    "Already same color piece exist"
            );

            //check if this piece have a clear part from current position to next position
            if curr_piece.piece_type == PieceType::Pawn || curr_piece.piece_type == PieceType::Knight || curr_piece.piece_type == PieceType::King {
                result = true;
            }
            if curr_piece.piece_type == PieceType::Queen || curr_piece.piece_type == PieceType::Bishop || curr_piece.piece_type == PieceType::Rook {
                let mut d = PieceTrait::get_distance(curr_position, next_position);
                let (top, right, down, left) = PieceTrait::get_direction(curr_position, next_position);
                let mut i = 1;
                result = loop {
                    if i > d { break true; }

                    let mut x: u32 = 0;
                    if left != 0 { x = curr_position.x - i * left; }
                    if right != 0 { x = curr_position.x + i * right; }
                    if left == 0 && right == 0 { x = curr_position.x ;}

                    let mut y: u32 = 0;
                    if down != 0 { y = curr_position.y - i * down; }
                    if top != 0 { y = curr_position.y + i * top; }
                    if down == 0 && top == 0 { y = curr_position.y; }

                    let mut pos = Vec2 {x: x, y: y};
                    let mut piece = get!(world, (game_id, pos), (Piece));
                    if piece.piece_type != PieceType::None {
                        break false;
                    }
                    i += 1;
                }
            }

            if result == true {
                // turn next position piece into current piece
                next_position_piece.piece_type = curr_piece.piece_type;
                next_position_piece.color = player.color;

                // make current_piece piece none
                curr_piece.piece_type = PieceType::None;
                curr_piece.color = Color::None;
                set!(world, (next_position_piece));
                set!(world, (curr_piece));

                // change turn
                let mut game_turn = get!(world, game_id, (GameTurn));
                game_turn.player_color = game_turn.next_turn();
                set!(world, (game_turn));
            } else {
                assert!(result == true, "Failed to moved");
            }
            return result;
        }

        fn spawn(
            world: IWorldDispatcher) -> u32 {
            0
        }
    }
}