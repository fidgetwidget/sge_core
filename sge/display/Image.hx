package sge.display;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import sge.Pool;
import sge.Recyclable;
import sge.Sge;
import sge.math.Transform;
import sge.math.Vector2;

// 
// A (mostly) Static Image
// 
class Image implements Recyclable<Image>
{

  public static function get():Image return pool.pop();

  public static function put(item:Image):Void pool.push(item);

  public static var pool:Pool<Image> = new Pool<Image>( function() { return new Image(); });

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Image.uid++;
  }

  // Create an image from a TileFrame
  public static function fromTileFrame( tileFrame:TileFrame, image:Image = null ):Image
  {
    image = image == null ? Image.get() : image;

    if (image.bitmap == null) 
      image.bitmap = new Bitmap(tileFrame.bitmapData);
    
    image.bitmapData = tileFrame.bitmapData;
    image.anchor.x = tileFrame.anchor.x;
    image.anchor.y = tileFrame.anchor.y;

    return image;
  }

  public static function fromFrameData( data:FrameData, image:Image = null ):Image
  {
    var rect;
    image = image == null ? Image.get() : image;

    if (image.bitmap == null)
      image.createBitmap(data.rect_w, data.rect_h, 0xffffffff);
    
    rect = new Rectangle(data.rect_x, data.rect_y, data.rect_w, data.rect_h);
    image.bitmapData.copyPixels(Assets.getBitmapData(data.sourcePath), rect, Sge.zero);

    return image;
  }


  // Instance

  public var id(get, never):Int;

  public var name:String;

  public var transform:Transform;

  public var renderTarget(get, set):Sprite;

  public var bitmap(get, set):Bitmap;

  public var bitmapData(get, set):BitmapData;


  public var x(get, set):Float;

  public var y(get, set):Float;

  public var width(get, never):Float;

  public var height(get, never):Float;

  public var anchor:Vector2;


  // Because we do the recycling, we don't want to have any arguments in the constructor
  public function new() 
  {
    _id = Image.getNextId();
    _bitmap = null;
    renderTarget = null;
    transform = null;
    anchor = Vector2.get();
  }

  public function clear():Image
  {
    _bitmap = null;
    renderTarget = null;
    transform = null;
    anchor.clear();
    return this;
  }

  // TODO: setup recycling for bitmapData and bitmap
  public function createBitmap( width:Int, height:Int, color:Int = 0x00ffffff ):Void
  {
    var data = new BitmapData(width, height, true, color);
    bitmap = new Bitmap(data);
  }


  public function render():Void
  {
    if (transform != null && _bitmap != null) {
      _bitmap.x         = transform.x - anchor.x;
      _bitmap.y         = transform.y - anchor.y;
      _bitmap.scaleX    = transform.scaleX;
      _bitmap.scaleY    = transform.scaleY;
      _bitmap.rotation  = transform.angle;
    }
  }

  public function toString():String  return 'Image[$_id]';


  var _id:Int;
  var _renderTarget:Sprite;
  var _bitmap:Bitmap;

  inline function get_id():Int return _id;

  inline function get_renderTarget():Sprite return _renderTarget;
  inline function set_renderTarget(value:Sprite):Sprite
  {
    // do we need to remove the bitmap from the old renderTarget?
    if (_renderTarget != null && _renderTarget != value && _bitmap != null)
      _renderTarget.removeChild(_bitmap);

    // do we need to add the bitmap to the new renderTarget?
    if (value != null && _bitmap != null) {
      value.addChild(_bitmap);
    }

    return _renderTarget = value;
  }

  inline function get_bitmap():Bitmap return _bitmap;
  inline function set_bitmap(value:Bitmap) 
  {
    if (_renderTarget != null)
    {
      if (value == null)
        renderTarget.removeChild(value);
      else
        renderTarget.addChild(value);
    }
    
    return _bitmap = value;
  }

  inline function get_bitmapData():BitmapData return _bitmap.bitmapData;
  inline function set_bitmapData(value:BitmapData):BitmapData return _bitmap.bitmapData = value;

  inline function get_x():Float return transform == null ? _bitmap.x : transform.x - anchor.x;
  inline function set_x(value:Float):Float return transform == null ? _bitmap.x = value : transform.x = value - anchor.x;
  
  inline function get_y():Float return transform == null ? _bitmap.y : transform.y - anchor.y;
  inline function set_y(value:Float):Float return transform == null ? _bitmap.y = value : transform.y = value - anchor.y;

  inline function get_width():Float return _bitmap.width;
  inline function get_height():Float return _bitmap.height;


} //Bounds
