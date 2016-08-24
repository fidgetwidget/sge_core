package sge;


@:publicFields
class Directions
{

  static inline var NONE:Int        = 0;

  static inline var NORTH:Int       = 1 << 0; // 1  
  static inline var EAST:Int        = 1 << 1; // 2
  static inline var SOUTH:Int       = 1 << 2; // 4
  static inline var WEST:Int        = 1 << 3; // 8
  
  static inline var N:Int = NORTH;
  static inline var E:Int = EAST;
  static inline var S:Int = SOUTH;
  static inline var W:Int = WEST;

  static inline var NE:Int          = 1 << 4; // 16
  static inline var SE:Int          = 1 << 5; // 32
  static inline var SW:Int          = 1 << 6; // 64
  static inline var NW:Int          = 1 << 7; // 128

  static inline var UP:Int          = NORTH;
  static inline var DOWN:Int        = SOUTH;
  static inline var RIGHT:Int       = EAST;
  static inline var LEFT:Int        = WEST;

  static inline var TOP:Int         = NORTH;
  static inline var BOTTOM:Int      = SOUTH;

  static inline var HORIZONTAL:Int  = RIGHT | LEFT;
  static inline var VERTICAL:Int    = UP | DOWN; 

  static inline var SIDES:Int       = TOP | RIGHT | BOTTOM | LEFT; 

  static inline var ALL:Int         = N | NE | E | SE | S | SW | W | NW;

} //TileCollider
