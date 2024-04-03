use chess::models::player::Color;
use starknet::ContractAddress;

#[derive(Model, Drop, Serde)]
struct Piece {
    #[key]
    game_id: u32,
    #[key]
    position: Vec2,
    color: Color,
    piece_type: PieceType,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32
}

#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum PieceType {
    Pawn,
    Knight,
    Bishop,
    Rook,
    Queen,
    King,
    None,
}

trait PieceTrait {
    fn is_out_of_board(next_position: Vec2) -> bool;
    fn is_right_piece_move(self: @Piece, next_position: Vec2) -> bool;
}

impl PieceImpl of PieceTrait {
    fn is_out_of_board(next_position: Vec2) -> bool {
        next_position.x > 7 || next_position.y > 7 || next_position.x < 0 || next_position.y < 0
    }

    fn is_right_piece_move(self: @Piece, next_position: Vec2) -> bool {
        let n_x = next_position.x;
        let n_y = next_position.y;
        assert(!(n_x == *self.position.x && n_y == *self.position.y), 'Cannot move same position');
        match self.piece_type {
            PieceType::Pawn => {
                match self.color {
                    Color::White => {
                        (n_x == *self.position.x && n_y == *self.position.y + 1)
                            || (n_x == *self.position.x && n_y == *self.position.y + 2)
                            || (n_x == *self.position.x + 1 && n_y == *self.position.y + 1)
                            || (n_x == *self.position.x - 1 && n_y == *self.position.y + 1)
                    },
                    Color::Black => {
                        (n_x == *self.position.x && n_y == *self.position.y - 1)
                            || (n_x == *self.position.x && n_y == *self.position.y - 2)
                            || (n_x == *self.position.x + 1 && n_y == *self.position.y - 1)
                            || (n_x == *self.position.x - 1 && n_y == *self.position.y - 1)
                    },
                    Color::None => panic(array!['Should not move empty piece']),
                }
            },
            PieceType::Knight => { 
                (diff(*self.position.x, n_x) == 2 && diff(*self.position.y, n_y) == 1)
                || (diff(*self.position.x, n_x) == 1 && diff(*self.position.y, n_y) == 2)
             },
            PieceType::Bishop => {
                diff(*self.position.x, n_x) == diff(*self.position.y, n_y)
            },
            PieceType::Rook => {
                (n_x == *self.position.x || n_y != *self.position.y)
                    || (n_x != *self.position.x || n_y == *self.position.y)
            },
            PieceType::Queen => {
                (n_x == *self.position.x)
                || (n_y == *self.position.y)
                || (diff(*self.position.x, n_x) == diff(*self.position.y, n_y))
            },
            PieceType::King => {
                (diff(*self.position.x, n_x) <= 1 && diff(*self.position.y, n_y) <= 1)
            },
            PieceType::None => panic(array!['Should not move empty piece']),
        }
    }
}

fn diff(a: u32, b: u32) -> u32 {
    if a < b { return b - a; }
    return a - b;
}