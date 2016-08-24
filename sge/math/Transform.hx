package sge.math;

import sge.Sge;
import sge.Pool;

// 
// 2D Transform
// Position, Rotation, Scale
// 
// - has accessors both a radian and degree value of the angle
// - 
class Transform implements HasPosition implements Recyclable<Transform>
{

  // Static

  public static function get():Transform return pool.pop();

  public static function put(item:Transform):Void pool.push(item.clear());

  public static var pool:Pool<Transform> = new Pool<Transform>( function() { return new Transform(); });

  // Factory function
  public static function create(x:Float = 0, y:Float = 0, r:Float = 0, scaleX:Float = 1, scaleY:Float = 1):Transform
  {
    var transform = Transform.get();
    transform.x = x;
    transform.y = y;
    transform.scaleX = scaleX;
    transform.scaleY = scaleY;
    transform.angle = r;
    return transform;
  }

  // Instance

  public var x:                     Float;
  public var y:                     Float;
  public var scaleX:                Float;
  public var scaleY:                Float;
  public var angle(get, set):       Float;
  public var radianAngle(get, set): Float;
  public var matrix(get, never):    TransformMatrix;


  public function new()
  {
    x = y = 0;
    scaleX = scaleY = 1;
    _degrees = _radians = 0;
    _matrix = TransformMatrix.get();
  }

  public function clear():Transform
  {
    x = y = 0;
    scaleX = scaleY = 1;
    _degrees = _radians = 0;
    return this;
  }

  public function toString():String return 'Transform[x:$x, y:$y, scaleX:$scaleX, scaleY:$scaleY, angle:$_degrees]';


  var _degrees:Float;
  var _radians:Float;
  var _matrix:TransformMatrix;

  inline function get_angle():Float return _degrees;
  inline function set_angle(value:Float):Float
  {
    _degrees = value;
    _radians = value * Sge.DEGREES_TO_RADIANS_CONST;
    return value;
  }

  inline function get_radianAngle():Float return _radians;
  inline function set_radianAngle(value:Float):Float
  {
    _radians = value;
    _degrees = value * Sge.RADIANS_TO_DEGREES_CONST;
    return value;
  }

  inline function get_matrix():TransformMatrix
  {
    _matrix.compose(x, y, _radians, scaleX, scaleY);
    return _matrix;
  }

} //Transform
