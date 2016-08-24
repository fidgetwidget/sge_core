package sge.display;

import openfl.geom.Rectangle;
import sge.Pool;
import sge.Recyclable;
import sge.math.Transform;

// 
// A BitmapData source and Rectangle segments
// 
class Spritesheet
{

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Spritesheet.uid++;
  }

  // Instance

  public var id(get, never):Int;

  public var source(get, set):BitmapData;

  public var rectangles(get, set):Array<Rectangle>;


  public function new( source:BitmapData ) 
  { 
    _id = Tile.getNextId();
    _source = source;
    _rectangles = [];
  }

  public function add(x:Float, y:Float, w:Float, h:Float):Int
  {
    var r = new Rectangle(x, y, w, h);
    return _rectangles.push(r);
  }

  // assumes the target is the same size as the requestedRectangle
  public function draw(index:Int, target:BitmapData):Void
  {
    target.copyPixels(source, _rectangles[index], Sge.zero);
  }

  public function copyPixels(index:Int, targetData:BitmapData, ?targetPoint:Point, ?alphaData:BitmapData, ?alphaPoint:Point, mergeAlpah:Bool = false ):Void
  {
    target.copyPixels(source, _rectangles[index], targetPoint == null ? Sge.zero, targetPoint, alphaData, alphaPoint, mergeAlpah);
  }

  public function toString():String  return 'Spritesheet[$_id]';


  var _id:Int;
  var _source:BitmapData;
  var _rectangles:Array<Rectangle>;

  inline function get_id():Int return _id;

  inline function get_source():BitmapData return _source;
  inline function set_source(value:BitmapData):BitmapData return _source = value;

  inline function get_rectangles():Array<Rectangle> return _rectangles;
  inline function set_rectangles(value:Array<Rectangle>):Array<Rectangle> return _rectangles = value;



} //Spritesheet

