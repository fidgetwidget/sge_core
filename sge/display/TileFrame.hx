package sge.display;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sge.Pool;
import sge.Recyclable;
import sge.math.Transform;
import sge.math.Vector2;

// 
// A Tile indipendent of a Tileset
// 
class TileFrame implements Recyclable<TileFrame>
{

  public static function get():TileFrame return pool.pop();

  public static function put(item:TileFrame):Void pool.push(item);

  public static var pool:Pool<TileFrame> = new Pool<TileFrame>( function() { return new TileFrame(); });


  // Factory
  public static function create( source:BitmapData, x:Float, y:Float, w:Float, h:Float, cache:Bool = false ):TileFrame
  {
    var tileFrame:TileFrame = TileFrame.get();

    tileFrame.source = source;

    tileFrame.setRect(x, y, w, h);

    tileFrame.setAnchor();

    tileFrame.cache = cache;

    return tileFrame;
  }

  public static function fromSourceRectangle( source:BitmapData, rect:Rectangle, cache:Bool = false ):TileFrame
  {
    return create(source, rect.x, rect.y, rect.width, rect.height, cache);
  }


  public static function fromTile( tile:Tile, tileFrame:TileFrame = null ):TileFrame
  {
    tileFrame = tileFrame == null ? TileFrame.get() : tileFrame.clear();

    tileFrame.source = tile.tileset.source;

    tileFrame.setRect(tile.rect.x, tile.rect.y, tile.rect.width, tile.rect.height);

    tileFrame.setAnchor();

    return tileFrame;
  }


  // Instance

  public var source(get, set):BitmapData;

  public var sourceRect(get, set):Rectangle;

  public var destPoint:Point;

  public var width:Int;

  public var height:Int;

  public var anchor(get, set):Vector2;

  public var cache:Bool = false;

  public var bitmapData(get, never):BitmapData;


  public function new() 
  { 
    _sourceRect = new Rectangle();
    _anchor = new Vector2();
    _source = _bitmapData = null;
    destPoint = new Point();
    width = height = 0;
  }

  public function clear():TileFrame
  {
    _anchor.clear();
    _source = _bitmapData = null; // only ever a pointer
    destPoint.x = destPoint.y = 0;
    setRect(0, 0, 0, 0); // this will set width & height
    return this;
  }

  public function setRect(x:Float, y:Float, width:Float, height:Float, fillsFrame:Bool = true):Void
  {
    _sourceRect.x = x;
    _sourceRect.y = y;
    _sourceRect.width = width;
    _sourceRect.height = height;

    if (fillsFrame)
    {
      this.width =  Math.floor( width );
      this.height = Math.floor( height );
    } 
  }

  // Set the anchor position (defaults to center)
  public function setAnchor(?x:Float, ?y:Float):Void
  {
    _anchor.x = x == null ? width * 0.5  : x;
    _anchor.y = y == null ? height * 0.5 : y;
  }

  public function toString():String return 'TileFrame[$width|$height]';


  var _dirty:Bool = false;
  var _source:BitmapData;
  var _sourceRect:Rectangle;
  var _anchor:Vector2;
  var _bitmapData:BitmapData;

  inline function get_source():BitmapData return _source;
  inline function set_source(value:BitmapData)
  {
    _dirty = true;
    return _source = value;
  }

  inline function get_sourceRect():Rectangle return _sourceRect;
  inline function set_sourceRect(value:Rectangle):Rectangle
  {
    _dirty = true;
    return _sourceRect = value;
  }

  inline function get_anchor():Vector2 return _anchor;
  inline function set_anchor(value:Vector2):Vector2 return _anchor = value;

  inline function get_bitmapData():BitmapData
  {
    if (_bitmapData != null && cache && !_dirty) return _bitmapData;
    var bmp = new BitmapData(width, height);
    bmp.copyPixels(_source, _sourceRect, destPoint);

    if (cache)
    {
      _dirty = false;
      _bitmapData = bmp;
    }
    return bmp;
  }


} //TileFrame
