package sge.math;

import openfl.geom.Point;
import sge.Sge;
import sge.Pool;

// 
// 2D Vector
// (using this instead of the lime one purely for the recyclability)
// 
class Vector2 implements Recyclable<Vector2> implements HasPosition
{

  public static function get():Vector2 return pool.pop();

  public static function put(item:Vector2):Void pool.push(item.clear());

  public static var pool:Pool<Vector2> = new Pool<Vector2>( function() { return new Vector2(); });


  public static function fromPoint( point:Point ):Vector2
  {
    var vec = Vector2.get();
    vec.x = point.x;
    vec.y = point.y;
    return vec;
  }

  public static function setVector( target:Vector2, direction:Float, magnitude:Float ):Void
  {
    target.x = Math.cos(direction) * magnitude;
    target.y = Math.sin(direction) * magnitude;
  }

  public static function lerp( a:Vector2, b:Vector2, f:Float, ?result:Vector2 = null ):Vector2
  {
    if (result == null) result = Vector2.get();
    result.x = b.x + f * (a.x - b.x);
    result.y = b.y + f * (a.y - b.y);
    return result;
  }

  public static function distanceBetween( a:Vector2, b:Vector2 ):Float
  {
    return Sge.distanceBetween(a.x, a.y, b.x, b.y);
  }

  // Instance

  public var x:                     Float = 0;
  public var y:                     Float = 0;
  public var length(get, set):      Float;
  public var lengthsq(get, never):  Float;

  public function new( x :Float = 0, y :Float = 0 ) 
  {
    this.x = x;
    this.y = y;
  }

  public function clear():Vector2
  {
    x = y = 0.0;
    return this;
  }

  // clone (new vector) or copy (by passing a target)
  public function clone(?target:Vector2 = null):Vector2
  {
    if (target == null) target = Vector2.get();
    target.x = x;
    target.y = y;
    return target;
  }


  public function toString():String  return 'Vector[x:$x, y:$y]';

  public function toPoint():Point return new Point(x, y);


  // Scale, Rotate, and Translate
  public function transform( matrix:TransformMatrix ):Void
  {
    var tx;
    tx = x * matrix.a + y * matrix.c + matrix.tx;
    y = x * matrix.b + y * matrix.d + matrix.ty;
    x = tx;
  } 

  // Scale and Rotate using a Transform Matrix
  public function scaleAndRotate( matrix:TransformMatrix ):Void
  {
    var tx;
    tx = (x * matrix.a) + (y * matrix.c);
    y = (x * matrix.b) + (y * matrix.d);
    x = tx;
  }

  // Rotate vector around origin (0,0)
  public function rotate( theta:Float ):Void
  {
    var cos, sin, tx;
    cos = Math.cos(theta);
    sin = Math.sin(theta);
    tx = x * cos - y * sin;
    y = x * sin + y * cos;
    x = tx;
  }

  // Translate the vector by the given values
  public function translate( tx:Float, ty:Float ):Void
  {
    x += tx;
    y += ty;
  }

  public function normalize():Void
  {
    var l:Float = length;
    if (l == 0) 
    {
      x = 1;
      return;
    }
    x /= l;
    y /= l;
  } 

  public function truncate( max:Float ):Void
  {
    length = Math.min(max, length);
  }

  public function invert():Void
  {
    x = -x;
    y = -y;
  }

  public function dot( other:Vector2 ):Float 
  {
    return x * other.x + y * other.y;
  } 

  public function cross( other:Vector2 ):Float 
  {
    return x * other.y - y * other.x;
  }

  public function add( other:Vector2 ):Void
  {
    x += other.x;
    y += other.y;
  }

  public function subtract( other:Vector2 ):Void
  {
    x -= other.x;
    y -= other.y;
  }

  public function multiply_single( value:Float ):Void
  {
    x *= value;
    y *= value;
  }

  // We only store the x and y values of the vector, 
  // so changing the length (the magnatude) is more 
  // costly than changing the indivudual axies values.
  inline private function set_length( value :Float ):Float 
  {
    var ep:Float = 0.00000001;
    var _angle:Float = Math.atan2(y, x);

    x = Math.cos(_angle) * value;
    y = Math.sin(_angle) * value;

    if (Math.abs(x) < ep) x = 0;
    if (Math.abs(y) < ep) y = 0;

    return value;
  }

  inline private function get_length():   Float return Math.sqrt(lengthsq);
  inline private function get_lengthsq(): Float return x * x + y * y;


} //Vector2
