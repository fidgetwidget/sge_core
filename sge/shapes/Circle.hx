package sge.shapes;

import sge.math.Vector2;


class Circle extends Shape
{

  // parent properties
  // transform:Transform
  // offset:Vector2
  // _aabb:AABB
  
  public var radius (get, never) :Float;

  public var transformedRadius (get, never) :Float;


  public function new( x :Float, y :Float, radius :Float ) 
  { 
    super(x, y);
    _radius = radius;
    _aabb.width  = _radius * 2;
    _aabb.height = _radius * 2;
  }

  override function clear():Shape
  {
    super.clear();
    _radius = 0;
    return this;
  }


  public override function toString():String  return 'Circle[$_id transform:$transform, offset:$offset, radius:$radius]';


  var _radius:Float = 0;

  inline function get_radius():   Float return _radius;

  inline function get_transformedRadius():Float return _radius * (transform != null ? transform.scaleX : 1);

  override function get_width():  Float return radius * 2;

  override function get_height(): Float return radius * 2;

  

}