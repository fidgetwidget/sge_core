package sge.display;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import sge.math.Sides;

// 
// Tileset: 
// - a named collection of Rectangles that define portions of a larger image
// - easily access the portion of the image for copying/drawing
// 
class Tileset
{

  // 
  // Static
  // 

  // add tiles to a tileset using a fixed tilesize, spacing, margin
  public static function addTiles(tileset:Tileset, 
    columns:Int, rows:Int, ?tileWidth:Int, ?tileHeight:Int,
    spacing:Sides = null, margin:Sides = null):Void
  {
    var row, col, xx, yy;

    row = col = xx = yy = 0;

    tileWidth  = tileWidth == null  ? tileset.tileWidth  : tileWidth;
    tileHeight = tileHeight == null ? tileset.tileHeight : tileHeight;

    while (row < rows)
    {
      while (col < columns)
      {
        xx = (col * tileWidth)  + (spacing == null ? 0 : col * spacing.right)  + (margin == null ? 0 : col * margin.left);
        yy = (row * tileHeight) + (spacing == null ? 0 : row * spacing.bottom) + (margin == null ? 0 : row * margin.top);

        tileset.addTile(xx, yy, tileWidth, tileHeight);
        col++;
      }
      row++;
      col = 0;
    }
  }


  // 
  // Instance
  // 

  public var name(get, never):String;

  public var source(get, never):BitmapData;

  public var ids(get, never):Array<Int>;

  public var hasFixedTileSize(get, never):Bool;

  public var tileWidth:Null<Int>;

  public var tileHeight:Null<Int>;

  public var tileCount(get, never):Int;


  public function new( name:String, source:BitmapData, ?tileWidth:Int, ?tileHeight:Int ) 
  {
    _name = name;
    _source = source;
    _tileCount = 0;

    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    tiles_by_id = new Map<Int, Tile>();
    tileId_by_xy = new Map<String, Int>();
    tileId_by_name = new Map<String, Int>();
  }

  // 
  // Add tiles to the set
  // 
  
  public function addTile( x:Int, y:Int, width:Int, height:Int ):Int
  {
    var tile = Tile.create(this, x, y, width, height);
    tiles_by_id.set(tile.id, tile);
    tileId_by_xy.set('${x}|${y}', tile.id);
    // default name is "<tilesetName>_<orderTileWasAdded>"
    nameTile(tile.id, '${_name}_${_tileCount++}');
    return tile.id;
  }

  public function addNamedTile( x:Int, y:Int, width:Int, height:Int, name:String ):Int
  {
    var tileId = addTile(x, y, width, height);
    nameTile(tileId, name);
    return tileId;
  }

  // naming or renaming a tile by id
  public function nameTile( tileId:Int, name:String ):Void
  {
    tileId_by_name.set(name, tileId);
  }



  // draw a tile to a destination
  public function drawTile( tileId:Int, destPoint:Point, dest:BitmapData ):Void
  {
    if (!exists(tileId)) return eraseTile(destPoint, dest);
    dest.copyPixels(source, getRect(tileId), destPoint);
  }

  public function eraseTile( destPoint:Point, dest:BitmapData ):Void
  {
    var rect = new Rectangle(destPoint.x, destPoint.y, tileWidth, tileHeight);
    dest.fillRect(rect, 0x00ffffff);
  }

  // get a TileFrame from a tile
  public function getTileFrame( tileId:Int, target:TileFrame = null ):TileFrame
  {
    if (!exists(tileId)) return null;
    return TileFrame.fromSourceRectangle(_source, getRect(tileId));
  }

  public function setTileToFrame( tileId:Int, tileframe:TileFrame ):Void
  {
    tileframe.source = _source;
    tileframe.sourceRect = getRect(tileId);
    tileframe.setAnchor();
  }


  public function exists(tileId:Int):Bool  return tiles_by_id.exists(tileId);


  public function toString():String  return 'Tileset[name:$_name]';

  // 
  // Getters
  // 

  // get a tile id from it's top left position in the source
  public function getTileId_sourcePosition( x:Int, y:Int ):Int
  {
    var xy = '$x|$y';
    if (!tileId_by_xy.exists(xy)) return -1; 
    return tileId_by_xy.get(xy);
  }

  public function getTileId_name( name:String ):Int
  {
    if (!tileId_by_name.exists(name)) return -1;
    return tileId_by_name.get(name);
  }

  // Tile

  // REMARK: do we really need these? we can get the tileId from the name
  public function getTileFromName( name:String ):Tile
  {
    var tileId = getTileId_name(name);
    return tiles_by_id.get(tileId);
  }

  // Rectangle

  // get the rectangle of a tile
  public function getRect( tileId:Int ):Rectangle
  {
    if (!tiles_by_id.exists(tileId)) return null;

    return tiles_by_id.get(tileId).rect;
  }

  // BitmapData

  // get the bitmapData of a tile
  public function getBitmapData( tileId:Int ):BitmapData
  {
    if (!tiles_by_id.exists(tileId)) return null;

    var rect = getRect(tileId);
    var bmp = new BitmapData(Math.floor(rect.width), Math.floor(rect.height));

    drawTile(tileId, Sge.zero, bmp);

    return bmp;
  }

  var _name:String;
  var _source:BitmapData;
  var _tileCount:Int;

  var tiles_by_id:Map<Int, Tile>;
  var tileId_by_xy:Map<String, Int>;
  var tileId_by_name:Map<String, Int>;

  public inline function get(tileId:Int):Tile
  {
    if (!tiles_by_id.exists(tileId)) return null;
    return tiles_by_id.get(tileId);
  }

  public inline function set(tileId:Int, tile:Tile):Tile
  {
    tiles_by_id.set(tileId, tile);
    return tile;
  }

  inline function get_name():String return _name;

  inline function get_source():BitmapData return _source;

  inline function get_ids():Array<Int>
  {
    var ids = [];
    for (id in tiles_by_id.keys())
    {
      ids.push(id);
    }
    ids.sort( function(a:Int, b:Int) { return a - b; });
    return ids;
  }

  inline function get_hasFixedTileSize():Bool return tileWidth != null && tileHeight != null;

  inline function get_tileCount():Int return _tileCount;

} //Tileset
