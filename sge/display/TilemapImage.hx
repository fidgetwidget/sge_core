package sge.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sge.math.Transform;

// 
// Display thing
// 
class TilemapImage extends Image
{

  public var tileset:Tileset;

  public var tileWidth(get, never):Int;

  public var tileHeight(get, never):Int;

  public var colCount(get, never):Int;

  public var rowCount(get, never):Int;


  public function new( width:Int, height:Int, tileset:Tileset ) 
  {
    super();
    createBitmap(width, height); // see Image.createBitmap
    setTileset(tileset);
  }

  public function clone(target:TilemapImage = null):TilemapImage
  {
    if (target == null) 
      target = new TilemapImage(Std.int(width), Std.int(height), tileset);
    else
    {
      target.clear();
      target.createBitmap(Std.int(width), Std.int(height));
      target.setTileset(tileset);
    }
    target.transform = transform;
    return target;
  }

  override public function clear():TilemapImage
  {
    super.clear();
    transform = null;
    setTileset(null);
    return this;
  }


  public function setTileset( tileset:Tileset ):Void
  {
    if (tileset == null)
    {
      this.tileset = tileset;
      _colCount = 0;
      _rowCount = 0;
      return;
    }

    if (!tileset.hasFixedTileSize)
      throw new openfl.errors.ArgumentError('[tileset] must have a fixed tile size.');

    this.tileset = tileset;

    _colCount = Math.floor(width  / tileWidth);
    _rowCount = Math.floor(height / tileHeight);

    if (rowCount - height / tileHeight != 0 || colCount - width / tileWidth != 0) 
      throw new openfl.errors.ArgumentError('[tileset w:$tileWidth h:$tileHeight] doesn\'t devide evenly into [w:$width h:$height]');
  }


  // Assign an individual tile
  public function setTile(col:Int, row:Int, tileId:Int):Void
  {
    if (!inBounds(col, row)) throw new openfl.errors.RangeError('TilemapImage.setTile [$col|$row] out of range.');
    tileChanged(col, row, tileId);
  }


  public inline function inBounds(col:Int, row:Int):Bool
  {
    return !(row > rowCount || row < 0 || col > colCount || col < 0);
  }


  override public function toString():String  return 'Tilemap[$_id]';


  // draw the tile (tileset[tileId]) onto the image at the given col|row
  inline function tileChanged(col:Int, row:Int, tileId:Int):Void
  {
    _point.x = col * tileWidth;
    _point.y = row * tileHeight;

    if (tileset.exists(tileId))
      tileset.drawTile(tileId, _point, bitmapData);
    else
      tileset.eraseTile(_point, bitmapData);
  }


  // var _tileIds:Map<String, Int>;
  var _point:Point = new Point();
  var _colCount:Int;
  var _rowCount:Int;


  inline function get_tileWidth():Int return tileset.tileWidth;

  inline function get_tileHeight():Int return tileset.tileHeight;

  inline function get_colCount():Int return _colCount;

  inline function get_rowCount():Int return _rowCount;


} //Tilemap
