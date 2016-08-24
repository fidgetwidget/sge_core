package sge.collision;

import sge.math.Transform;
import sge.math.Bitwise;

// 
// Collider: Tilemap
// 
class TilemapCollider extends Collider
{

  public var tileWidth  (get, never):Int;
  public var tileHeight (get, never):Int;

  public function new( transform:Transform, width:Float, height:Float, tileWidth:Int, tileHeight:Int ) 
  {
    super(transform, width, height);

    _tileWidth  = tileWidth;
    _tileHeight = tileHeight;
    _colCount = Math.floor(width / _tileWidth);
    _rowCount = Math.floor(height / _tileHeight);
    _tiles = new Map();
    _collisions = new Map();

    resetTiles();
  }
  

  override public function test( collider:Collider  ):Bool
  {
    return false;
  }


  public function addCollision(c:Int, r:Int):Void
  {
    _collisions.set( tileKey(c, r), true );
    _tiles.set( tileKey(c, r), TileCollider.SIDES );
    updateWithNeighbors(c, r);
  }

  public function removeCollision(c:Int, r:Int):Void
  {
    _collisions.set( tileKey(c, r), false );
    _tiles.set( tileKey(c, r), TileCollider.NONE );
    updateWithNeighbors(c, r);
  }


  public function hasCollision(c:Int, r:Int):Bool
  {
    if ( !_tiles.exists(tileKey(c,r)) ) 
      return false;

    return _collisions.get(tileKey(c, r));
  }

  public function hasCollision_position(x:Float, y:Float):Bool
  {
    var c, r;
    c = Math.floor(x/tileWidth);
    r = Math.floor(y/tileHeight);
    return hasCollision(c, r);
  }


  // SetTile by column (x) and row (y)
  // Assign a specific TileCollision value
  public function setTile(c:Int, r:Int, type:Int, ignoreBounds:Bool = false):Void
  {
    if ( !_tiles.exists(tileKey(c,r)) )
    {
      if (ignoreBounds)
        return;
      else
        throw new openfl.errors.RangeError('TilemapCollider.setTile [${tileKey(c,r)}] out of range.');
    }
    var exists = type != TileCollider.NONE;
    _collisions.set(tileKey(c, r), exists);
    _tiles.set(tileKey(c,r), type);
  }

  public function setTile_position(x:Float, y:Float, type:Int, ignoreBounds:Bool = false):Void
  {
    var c, r;
    c = Math.floor(x/tileWidth);
    r = Math.floor(y/tileHeight);
    setTile(c, r, type, ignoreBounds);
  }


  // GetTile by column (x) and row (y)
  public function getTile(c:Int, r:Int, ignoreBounds:Bool = false):Int
  {
    if ( !_tiles.exists(tileKey(c,r)) )
    {
      if (ignoreBounds)
        return TileCollider.NONE;
      else
        throw new openfl.errors.RangeError('TilemapCollider.getTile [${tileKey(c,r)}] out of range.');
    }

    return _tiles.get( tileKey(c,r) );
  }

  public function getTile_position(x:Float, y:Float, ignoreBounds:Bool = false):Int
  {
    var c, r;
    c = Math.floor(x/tileWidth);
    r = Math.floor(y/tileHeight);
    return getTile(c, r, ignoreBounds);
  }


  public inline function resetTiles():Void
  {
    var r, c;
    r = c = 0;

    while (r < _rowCount)
    {
      while (c < _colCount)
      {
        _tiles.set(tileKey(c,r), TileCollider.NONE);
        c++;
      }
      c = 0;
      r++;
    }
  }


  inline function getTileCollisionWithNeighbors(c:Int, r:Int):Int
  {
    var top, right, bottom, left, type;

    top     = hasCollision(c, r - 1);
    right   = hasCollision(c + 1, r);
    bottom  = hasCollision(c, r + 1);
    left    = hasCollision(c - 1, r);

    type = TileCollider.NONE;
    if (!top)    type = Bitwise.add(type, TileCollider.TOP);
    if (!right)  type = Bitwise.add(type, TileCollider.RIGHT);
    if (!bottom) type = Bitwise.add(type, TileCollider.BOTTOM);
    if (!left)   type = Bitwise.add(type, TileCollider.LEFT);

    return type;
  }

  inline function updateWithNeighbors(c:Int, r:Int):Void
  {
    var top, right, bottom, left, hasTop, hasRight, hasBottom, hasLeft, tile, has;
    
    top       = getTile(c, r - 1, true);
    hasTop    = hasCollision(c, r - 1);
    right     = getTile(c + 1, r, true);
    hasRight  = hasCollision(c + 1, r);
    bottom    = getTile(c, r + 1, true);
    hasBottom = hasCollision(c, r + 1);
    left      = getTile(c - 1, r, true);
    hasLeft   = hasCollision(c - 1, r);
    tile      = getTile(c, r, true);
    has       = hasCollision(c, r);

    top     = has ? Bitwise.remove(top, TileCollider.BOTTOM) : hasTop ? Bitwise.add(top, TileCollider.BOTTOM) : top;
    tile    = has && hasBottom ? Bitwise.remove(tile, TileCollider.BOTTOM) : tile;

    if (has) 
    {
      top     = Bitwise.remove(top, TileCollider.BOTTOM); // trace('top removed BOTTOM collider.');
      right   = Bitwise.remove(right, TileCollider.LEFT); // trace('right removed LEFT collider.');
      bottom  = Bitwise.remove(bottom, TileCollider.TOP); // trace('bottom removed TOP collider.');
      left    = Bitwise.remove(left, TileCollider.RIGHT); // trace('left removed RIGHT collider.');

      if (hasTop)     tile = Bitwise.remove(tile, TileCollider.TOP);    // trace('tile removed TOP collider.');
      if (hasRight)   tile = Bitwise.remove(tile, TileCollider.RIGHT);  // trace('tile removed RIGHT collider.');
      if (hasBottom)  tile = Bitwise.remove(tile, TileCollider.BOTTOM); // trace('tile removed BOTTOM collider.');
      if (hasLeft)    tile = Bitwise.remove(tile, TileCollider.LEFT);   // trace('tile removed LEFT collider.');
    }
    else 
    {
      if (hasTop)     top = Bitwise.add(top, TileCollider.BOTTOM);
      if (hasRight)   right = Bitwise.add(right, TileCollider.LEFT);
      if (hasBottom)  bottom = Bitwise.add(bottom, TileCollider.BOTTOM);
      if (hasLeft)    left = Bitwise.add(left, TileCollider.RIGHT);
    }  

    setTile(c, r - 1, top, true);
    setTile(c + 1, r, right, true);
    setTile(c, r + 1, bottom, true);
    setTile(c - 1, r, left, true);
    setTile(c, r, tile, true);
  }

  inline function tileKey(c:Int, r:Int):String return '${c}|${r}';

  var _collisions:Map<String, Bool>; // if it has a collision tile in place
  var _tiles:Map<String, Int>; // what the resulting collision will be
  var _tileWidth:Int;
  var _tileHeight:Int;
  var _colCount:Int;
  var _rowCount:Int;

  
  inline function get_tileWidth():Int   return _tileWidth;
  inline function get_tileHeight():Int  return _tileHeight;


  public function toString():String return '$_tiles';

} //TilemapCollider
