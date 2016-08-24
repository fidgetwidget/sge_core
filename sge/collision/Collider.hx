package sge.collision;

import openfl.display.Graphics;
import sge.shapes.Circle;
import sge.shapes.Polygon;
import sge.shapes.Shape;
import sge.math.Transform;
import sge.math.TransformMatrix;

// 
// Collider (abstract?)
// 
class Collider
{

  public var isActive:Bool;

  public var transform  (get, set):Transform;

  public var left       (get, never):Float;
  public var right      (get, never):Float;
  public var top        (get, never):Float;
  public var bottom     (get, never):Float;

  public var width      (get, never):Float;
  public var height     (get, never):Float;

  public var collision  (get, never):Collision;


  public function new( transform:Transform, width:Float, height:Float ) 
  {
    _transform = transform;
    _width = width;
    _height = height;
  }

  public function test( collider:Collider ):Bool
  {
    return false;
  }


  var _transform:Transform;
  var _transformMatrix:TransformMatrix;
  var _width:Float;
  var _height:Float;
  var _collision:Collision;

  inline function get_transform():Transform return _transform;
  function set_transform(value:Transform):Transform return _transform = value;

  inline function get_left():Float   return _transform.x - (width * 0.5);
  inline function get_right():Float  return _transform.x + (width * 0.5);
  inline function get_top():Float    return _transform.y - (height * 0.5);
  inline function get_bottom():Float return _transform.y + (height * 0.5);

  inline function get_width():Float  return _width  * _transform.scaleX;
  inline function get_height():Float return _height * _transform.scaleY;

  inline function get_collision():Collision return _collision;

}
