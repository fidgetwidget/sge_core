package sge.entity;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sge.collision.AABB;
import sge.collision.TileCollider;
import sge.collision.TilemapCollider;
import sge.display.TilemapImage;
import sge.display.Tileset;
import sge.math.Transform;

// 
// Display thing
// 
class Tilemap
{

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Tilemap.uid++;
  }


  // Instance
  
  public var id(get, never):Int;
  // public var scene:Scene; // because we aren't an entity... this won't ever get set... :(
  public var transform:Transform;
  public var collider:TilemapCollider;
  public var image:TilemapImage;

  // the basic transform
  public var x(get, set):             Float;
  public var y(get, set):             Float;
  public var ix(get, never):          Int;
  public var iy(get, never):          Int;
  public var scaleX(get, set):        Float;
  public var scaleY(get, set):        Float;
  public var angle(get, set):         Float;


  public var collideAll(get, set):    Bool;
  public var collideTiles(get, set):  Array<Int>;

  // ReadOnly
  public var width(get, never):       Int;
  public var height(get, never):      Int;

  public var tileset(default, null):  Tileset;

  public var tileWidth(get, never):   Int;
  public var tileHeight(get, never):  Int;

  public var colCount(get, never):    Int;
  public var rowCount(get, never):    Int;

  // var tileset:Tileset;
  // "col|row" -> tileId
  var tiles:Map<String, Int>;
  // tileId -> tileCollider value
  // var tileColliderMap:Map<Int, Int>;


  public function new( width:Int, height:Int, tileset:Tileset ) 
  {
    _id             = Tilemap.getNextId();
    transform       = new Transform();
    tiles           = new Map();
    // tileColliderMap = new Map();

    _width          = width;
    _height         = height;
    this.tileset    = tileset;
    _colCount = Math.floor(_width  / tileWidth);
    _rowCount = Math.floor(_height / tileHeight);
    _aabb.setRect(0, 0, _width, _height);

    image    = new TilemapImage(_width, _height, tileset);
    image.transform = transform;

    collider = new TilemapCollider(transform, _width, _height, tileWidth, tileHeight);

    resetTiles(); // set all of the tileIds to -1
  }

  public function clear():Tilemap
  {
    resetTiles();
    transform = null;
    tileset = null;
    image = null;
    collider = null;
    _aabb.clear();
    return this;
  }

  // Set tileId->tileCollision map value

  public function addCollisionId(tileId:Int):Void 
  {
    if (_collideTiles.indexOf(tileId) < 0) _collideTiles.push(tileId);
  }

  public function removeCollisionId(tileId:Int):Void 
  {
    _collideTiles.remove(tileId);
  }


  // public function setTileIdCollision(tileId:Int, tileCollider:Int):Void
  // {
  //   tileColliderMap.set(tileId, tileCollider);
  // }


  // Set tileId

  public function setTile(col:Int, row:Int, tileId:Int, ignoreBounds:Bool = false):Void
  {
    if (!inBounds(col, row)) 
    {
      if (ignoreBounds) return;
      else throw new openfl.errors.RangeError('Tilemap.setTile [$col|$row] out of range.');
    }
   
    if (tileId == tiles.get(tileKey(col, row))) return;

    tiles.set(tileKey(col, row), tileId);

    if (tileset.exists(tileId))
      image.setTile(col, row, tileId);
    else
      image.setTile(col, row, -1);

    if (_collideAll || _collideTiles.indexOf(tileId) >= 0)
    {
      if (tileId >= 0)
      {
        collider.addCollision(col, row);
      }
      else
      {
        collider.removeCollision(col, row);
      }
    }
  }

  public function setTile_position(x:Float, y:Float, tileId:Int, ignoreBounds:Bool = false):Void
  {
    var c, r;
    c = Math.floor(x/tileWidth);
    r = Math.floor(y/tileHeight);
    setTile(c, r, tileId, ignoreBounds);
  }

  public function setTiles(top:Float, right:Float, bottom:Float, left:Float, tileId:Int, ignoreBounds:Bool = false):Void
  {
    var xx, yy, c, r;
    xx = left;
    yy = top;
    while (xx <= right)
    {
      while (yy <= bottom)
      {
        c = Math.floor(xx/tileWidth);
        r = Math.floor(yy/tileHeight);
        setTile(c, r, tileId, ignoreBounds);
        yy += tileHeight; 
      }
      xx += tileWidth;
      yy = top;
    }
  }

  public function setTiles_rectangle(x:Float, y:Float, width:Float, height:Float, tileId:Int, ignoreBounds:Bool = false):Void
  {
    setTiles(y, x + width, y + height, x, tileId, ignoreBounds);
  }

  // Get TileId

  public function getTile(col:Int, row:Int):Int
  {
    if (tiles.exists(tileKey(col, row))) return tiles.get(tileKey(col, row));
    return -1;
  }


  public function getTile_position(x:Float, y:Float):Int
  {
    var c, r;
    c = Math.floor(x/tileWidth);
    r = Math.floor(y/tileHeight);
    return getTile(c, r);
  }


  public function getTiles(top:Float, right:Float, bottom:Float, left:Float, ?results:Array<Int> = null):Array<Int>
  {
    var xx, yy, c, r, tileId;
    results = results == null ? [] : results;
    xx = left;
    yy = top;
    while (xx <= right)
    {
      while (yy <= bottom)
      {
        c = Math.floor(xx/tileWidth);
        r = Math.floor(yy/tileHeight);
        tileId = getTile(c, r);
        if (results.indexOf(tileId) < 0) results.push(tileId);
        yy += tileHeight; 
      }
      xx += tileWidth;
      yy = top;
    }
    return results;
  }


  public function getTiles_rectangle(x:Float, y:Float, width:Float, height:Float, ?results:Array<Int> = null):Array<Int>
  {
    return getTiles(y, x + width, y + height, x, results);
  }


  // 
  // Set all tiles to -1 tileId (a non real tile value)
  public inline function resetTiles():Void
  {
    var r, c;
    r = c = 0;

    while (r < _rowCount)
    {
      while (c < _colCount)
      {
        setTile(c, r, -1);
        c++;
      }
      c = 0;
      r++;
    }

  }

  public inline function inBounds(col:Int, row:Int):Bool
  {
    return !(row > rowCount || row < 0 || col > colCount || col < 0);
  }

  public inline function inBounds_position(x:Float, y:Float):Bool
  {
    var c, r;
    c = Math.floor(x/tileWidth);
    r = Math.floor(y/tileHeight);
    return inBounds(c, r);
  }

  
  inline function tileKey(col:Int, row:Int):String return '${col}|${row}';


  public function toString():String  return 'Tilemap[$_id]';

  // property vars
  var _id:Int;
  var _width:Int;
  var _height:Int;
  var _colCount:Int;
  var _rowCount:Int;
  var _aabb:AABB = new AABB();
  var _collideAll:Bool = false;
  var _collideTiles:Array<Int> = [];

  inline function get_id():Int return _id;

  // Transform
  inline function get_x():Float return transform.x;
  inline function set_x(value:Float):Float return transform.x = value;

  inline function get_y():Float return transform.y;
  inline function set_y(value:Float):Float return transform.y = value;

  inline function get_ix():Int return Math.floor(transform.x);
  inline function get_iy():Int return Math.floor(transform.y);

  inline function get_scaleX():Float return transform.scaleX;
  inline function set_scaleX(value:Float):Float return transform.scaleX = value;

  inline function get_scaleY():Float return transform.scaleY;
  inline function set_scaleY(value:Float):Float return transform.scaleY = value;

  inline function get_angle():Float return transform.angle;
  inline function set_angle(value:Float):Float return transform.angle = value;

  inline function get_collideAll():Bool return _collideAll;
  inline function set_collideAll(value:Bool):Bool return _collideAll = value;

  inline function get_collideTiles():Array<Int> return _collideTiles;
  inline function set_collideTiles(value:Array<Int>):Array<Int> return _collideTiles = value;


  inline function get_width():Int return _width;

  inline function get_height():Int return _height;

  inline function get_tileWidth():Int return tileset.tileWidth;

  inline function get_tileHeight():Int return tileset.tileHeight;

  inline function get_colCount():Int return _colCount;

  inline function get_rowCount():Int return _rowCount;


  public inline function get_bounds():AABB 
  {
    _aabb.x = transform.x;
    _aabb.y = transform.y;
    return _aabb;
  }


} //Tilemap
