package sge.shapes;


import sge.math.Transform;
import sge.math.Vector2;
import sge.collision.AABB;
import sge.collision.HasBounds;

// 
// The Body for a transform (position)
// 
// 
class Shape implements HasBounds implements Recyclable<Shape>
{

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Shape.uid++;
  }

  // Instance
  
  public var id(get, never):Int;

  public var transform:Transform;
  public var offset:Vector2;
  public var offsetX (get, set):Float;
  public var offsetY (get, set):Float;

  // ReadOnly
  public var x (get, never):Float;
  public var y (get, never):Float;
  public var width  (get, never):Float;
  public var height (get, never):Float;

  public var bounds (get, never):AABB;

  public function new(x:Float = 0, y:Float = 0) 
  { 
    _id = Shape.getNextId();
    offset = Vector2.get();
    offset.x = x;
    offset.y = y;
    _aabb = AABB.get();
    // Default shape is a 1px box
    _aabb.width = _aabb.height = 1;
  }

  public function clear():Shape
  {
    offset.clear();
    _aabb.clear();
    transform = null;
    return this;
  }

  public function dispose():Void
  {
    clear();
    Vector2.put(offset);
    AABB.put(_aabb);
    offset = null;
    _aabb = null;
  }

  public function toString():String  return 'Shape[$_id transform:$transform, offset:$offset, aabb:$_aabb]';

  var _id:Int;
  var _aabb:AABB;

  inline function get_id():Int return _id;

  inline function get_offsetX():Float return offset.x;
  inline function set_offsetX(value:Float):Float return offset.x = value;

  inline function get_offsetY():Float return offset.y;
  inline function set_offsetY(value:Float):Float return offset.y = value;

  inline function get_x():Float return ( (transform != null) ? transform.x + offset.x : offset.x );

  inline function get_y():Float return ( (transform != null) ? transform.y + offset.y : offset.y );

  function get_width():Float  return _aabb.width * ((transform != null) ? transform.scaleX : 1);

  function get_height():Float return _aabb.height * ((transform != null) ? transform.scaleY : 1);

  public function get_bounds():AABB 
  {
    if (_aabb == null) return null;

    var bounds:AABB = _aabb.clone();
    bounds.centerX = x;
    bounds.centerY = y;
    bounds.halfWidth = width * 0.5;
    bounds.halfHeight = height * 0.5;
    return bounds;
  }

}