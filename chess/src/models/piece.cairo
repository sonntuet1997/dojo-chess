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

#[derive(Copy, Drop, Serde, Introspect, Eq, PartialEq)]
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
    fn get_distance(curr_position: Vec2, next_position: Vec2) -> u32;
    fn get_direction(curr_position: Vec2, next_position: Vec2) -> (i32, i32);
    fn diff(a: u32, b: u32) -> u32;
}

impl PieceImpl of PieceTrait {
    fn is_out_of_board(next_position: Vec2) -> bool {
        next_position.x > 7 || next_position.y > 7 || next_position.x < 0 || next_position.y < 0
    }

    fn is_right_piece_move(self: @Piece, next_position: Vec2) -> bool {
        let n_x = next_position.x;
        let n_y = next_position.y;
        if (n_x == *self.position.x && n_y == *self.position.y) { return false; }
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
                (PieceTrait::diff(*self.position.x, n_x) == 2 && PieceTrait::diff(*self.position.y, n_y) == 1)
                || (PieceTrait::diff(*self.position.x, n_x) == 1 && PieceTrait::diff(*self.position.y, n_y) == 2)
             },
            PieceType::Bishop => {
                PieceTrait::diff(*self.position.x, n_x) == PieceTrait::diff(*self.position.y, n_y)
            },
            PieceType::Rook => {
                (n_x == *self.position.x || n_y != *self.position.y)
                || (n_x != *self.position.x || n_y == *self.position.y)
            },
            PieceType::Queen => {
                (n_x == *self.position.x) || (n_y == *self.position.y)
                || (PieceTrait::diff(*self.position.x, n_x) == PieceTrait::diff(*self.position.y, n_y))
            },
            PieceType::King => {
                (PieceTrait::diff(*self.position.x, n_x) <= 1 && PieceTrait::diff(*self.position.y, n_y) <= 1)
            },
            PieceType::None => panic(array!['Should not move empty piece']),
        }
    }

    fn diff(a: u32, b: u32) -> u32 {
         if a < b { return b - a; }
         return a - b;
    }

    fn get_distance(curr_position: Vec2, next_position: Vec2) -> u32 {
        let x: u32 = PieceTrait::diff(curr_position.x, next_position.x);
        let y: u32 = PieceTrait::diff(curr_position.y, next_position.y);
        if x > y {
            return x;
        } else {
            return y;
        }
    }

    fn get_direction(curr_position: Vec2, next_position: Vec2) -> (i32, i32) {
        let curr_x: i32 = curr_position.x.try_into().unwrap(); let next_x: i32 = next_position.x.try_into().unwrap();
        let x: i32 = curr_x - next_x;
        let curr_y: i32 = curr_position.y.try_into().unwrap(); let next_y: i32 = next_position.y.try_into().unwrap();
        let y: i32 = curr_y - next_y;
        let mut tup: (i32, i32) = (0, 0);
        if (x > 0 && y > 0) {
            tup = (1, 1);
        }
        if (x < 0 && y > 0) {
            tup = (-1, 1);
        }
        if (x < 0 && y < 0) {
            tup = (-1, -1);
        }
        if (x > 0 && y < 0) {
            tup = (1, -1);
        }
        if y == 0 {
            if x < 0 {
                tup = (-1, 0);
            } else {
                tup = (1, 0);
            }
        }
        if x == 0 {
            if y < 0 {
                tup = (0, -1);
            } else {
                tup = (0, 1);
            }
        }
        return tup;
    }
}

