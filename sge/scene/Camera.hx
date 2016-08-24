package sge.scene;

import sge.collision.AABB;
import sge.math.HasPosition;

// 
// Camera
// - a bounding box with:
// scale: the zoom level of the camera
// (optional) target: a position to follow
// 
class Camera extends AABB
{

  var target:HasPosition;
  // TODO: make this a property (getter, setter) to prevent 0 value
  //       and support max/min zoom levels
  public var scale(get, set):Float;


  public function new() 
  {
    super();
  }

  public function moveTo( x:Float, y:Float ):Void
  {
    _center.x = x;
    _center.y = y;
  }

  public function follow( ?position:HasPosition ):Void
  {
    _target = position;
  }

  public function update():Void
  {
    if (_target == null) return;
    _center.x = _target.x;
    _center.y = _target.y;
  }

  override public function toString():String return 'Camera[top:$top, right:$right, bottom:$bottom, left:$left]';


  var _target:HasPosition = null;
  var _scale:Float = 1;
  var one_over_scale:Float = 1;

  inline function get_scale():Float return _scale;
  inline function set_scale(value:Float):Float
  {
    _scale = value;
    one_over_scale = 1 / value;
    return _scale;
  }


  override function get_x():Float return _center.x - (width * 0.5);

  override function get_y():Float return _center.y - (height * 0.5);

  override function get_width():Float return _halves.x * 2 * one_over_scale;

  override function get_height():Float return _halves.y * 2 * one_over_scale;


} //Camera
