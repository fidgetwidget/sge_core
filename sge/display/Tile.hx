package sge.display;

import openfl.geom.Rectangle;
import sge.Pool;
import sge.Recyclable;
import sge.math.Transform;

// 
// A Tile belonging to a Tileset
// 
class Tile implements Recyclable<Tile>
{

  public static function get():Tile return pool.pop();

  public static function put(item:Tile):Void pool.push(item);

  public static var pool:Pool<Tile> = new Pool<Tile>( function() { return new Tile(); });


  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Tile.uid++;
  }

  // Factory
  public static function create( tileset:Tileset, x:Int, y:Int, width:Int, height:Int ):Tile
  {
    var tile:Tile = Tile.get();
    tile.tileset = tileset;
    tile.setRect(x, y, width, height);
    return tile;
  }


  // Instance

  public var id(get, never):Int;

  public var tileset(get, set):Tileset;

  public var rect(get, set):Rectangle;


  public function new() 
  { 
    _id = Tile.getNextId();
    _rect = new Rectangle();
  }

  public function clear():Tile
  {
    setRect(0, 0, 0, 0);
    _tileset = null; // only ever a pointer
    return this;
  }

  public function setRect(x:Float, y:Float, width:Float, height:Float):Void
  {
    _rect.x = x;
    _rect.y = y;
    _rect.width = width;
    _rect.height = height;
  }

  public function toString():String  return 'Tile[$_id]';

  var _id:Int;
  var _tileset:Tileset;
  var _rect:Rectangle;

  inline function get_id():Int return _id;

  inline function get_tileset():Tileset return _tileset;
  inline function set_tileset(value:Tileset):Tileset return _tileset = value;

  inline function get_rect():Rectangle return _rect;
  inline function set_rect(value:Rectangle):Rectangle return _rect = value;



} //TileFrame
