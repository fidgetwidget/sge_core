package sge.collision;

import openfl.display.Graphics;
import sge.math.Vector2;


class AABB implements Recyclable<AABB>
{

  // Static
  
  public static function get():AABB return pool.pop();

  public static function put(item:AABB):Void pool.push(item);

  public static var pool:Pool<AABB> = new Pool<AABB>( function() { return new AABB(); });

  
  public static function create( centerX :Float, centerY :Float, halfWidth :Float, halfHeight :Float ):AABB
  {
    var aabb:AABB = AABB.get();

    aabb.centerX = centerX;
    aabb.centerY = centerY;
    aabb.halfWidth = halfWidth;
    aabb.halfHeight = halfHeight;

    return aabb;
  }

  public static function fromRectangleValues( x :Float, y :Float, width :Float, height: Float ):AABB
  {
    var aabb:AABB = AABB.get();
    
    aabb.setRect(x, y, width, height);

    return aabb;
  }


  public static function aabb_point_collision( aabb:AABB, x:Float, y:Float, ?collision:Collision = null ):Bool 
  {    
    var dx = x - aabb.centerX;
    if (Math.abs(dx) < aabb.halfWidth)
    {
      var dy = y - aabb.centerY;
      if (Math.abs(dy) < aabb.halfHeight)
      {

        // if (collision == null) return true;
        // collision.px = dx;
        // collision.py = dy;
        return true;

      } 
    }
    return false;
  }

  public static function aabb_aabb_collision( aabb1:AABB, aabb2:AABB, ?collsion:Collision = null ):Bool
  {
    var dx = aabb2.centerX - aabb1.centerX;
    var px = (aabb2.halfWidth + aabb1.halfWidth) - Math.abs(dx);
    if (px > 0)
    {
      var dy = aabb2.centerY - aabb1.centerY;
      var py = (aabb2.halfHeight + aabb1.halfHeight) - Math.abs(dy);
      if (py > 0)
      {

        // if (collision == null) return true;
        // if (dx < 0) px *= -1; 
        // if (dy < 0) py *= -1;
        // collision.px = px;
        // collision.py = py;
        return true;

      } 
    }
    return false; 
  }
  
  public static function aabb_circle_collision( aabb:AABB, x:Float, y:Float, radius:Float, ?collision:Collision = null ):Bool 
  {
    var dx = x - aabb.centerX;
    var px = (radius + aabb.halfWidth) - Math.abs(dx);
    if (px > 0)
    {
      var dy = y - aabb.centerY;
      var py = (radius + aabb.halfHeight) - Math.abs(dy);
      if (py > 0)
      {

        // if (collision == null) return true;
        // if (dx < 0) px *= -1; 
        // if (dy < 0) py *= -1;
        // collision.px = px;
        // collision.py = py;
        return true;

      } 
    }
    return false;
  }


  // Instance

  public var x          (get, set):Float;
  public var y          (get, set):Float;
  public var width      (get, set):Float;
  public var height     (get, set):Float;

  public var top        (get, never):Float;
  public var right      (get, never):Float;
  public var bottom     (get, never):Float;
  public var left       (get, never):Float;

  public var centerX    (get, set):Float;
  public var centerY    (get, set):Float;
  
  public var halfWidth  (get, set):Float;
  public var halfHeight (get, set):Float;


  public function new() 
  { 
    _center = Vector2.get();
    _halves = Vector2.get();
  }

  public function setRect(x:Float, y:Float, w:Float, h:Float):Void
  {
    _halves.x = w * 0.5;
    _halves.y = h * 0.5;
    _center.x = x + _halves.x;
    _center.y = y + _halves.y;
  }

  public function clear():AABB
  {
    _center.x = _center.y = 0.0;
    _halves.x = _halves.y = 0.0;
    return this;
  }

  public function clone(?target:AABB):AABB
  {
    if (target == null) target = AABB.get();
    this._center.clone(target._center);
    this._halves.clone(target._halves);
    return target;
  }

  public function toString():String return 'AABB[ center:$_center halves:$_halves ]';
  

  public function debugRender(g:Graphics):Void
  {
    g.drawRect(x, y, width, height);
  }


  public function contains( aabb:AABB ):Bool
  {
    if (aabb == null) 
      throw new openfl.errors.Error("AABB.contains called against a null object.");
    return (this.left   <= aabb.left  &&
            this.right  >= aabb.right &&
            this.top    <= aabb.top   &&
            this.bottom >= aabb.bottom);
  }

  public function containsPoint( x:Float, y:Float ):Bool 
  {
    return (x > left && x < right) && (y > top && y < bottom);
  }

  public function collides( aabb:AABB ):Bool
  {
    return AABB.aabb_aabb_collision(this, aabb);
  }


  // 
  // collision
  // 

  public function collision_point( x:Float, y:Float, ?collision:Collision ):Bool
  {
    return AABB.aabb_point_collision( this, x, y, collision );
  }

  public function collision_aabb( aabb:AABB, ?collision:Collision ):Bool
  {
    return AABB.aabb_aabb_collision( this, aabb, collision );
  }

  public function collision_circle( x:Float, y:Float, radius:Float, ?collision:Collision ):Bool
  {
    return AABB.aabb_circle_collision( this, x, y, radius, collision );
  }


  var _center:Vector2;
  var _halves:Vector2;

  
  function get_x():Float return _center.x - _halves.x;
  inline function set_x( value:Float ):Float {
    _center.x = value + _halves.x; 
    return get_x();
  }
  function get_y():Float return _center.y - _halves.y;
  inline function set_y( value:Float ):Float {
    _center.y = value + _halves.y; 
    return get_y();
  }

  function get_width():Float return _halves.x * 2;
  inline function set_width( value:Float ):Float {
    _halves.x = value * 0.5; 
    return get_width();
  }
  function get_height():Float return _halves.y * 2;
  inline function set_height( value:Float ):Float {
    _halves.y = value * 0.5; 
    return get_height();
  }

  inline function get_top():    Float return get_y();
  inline function get_right():  Float return get_x() + get_width();
  inline function get_bottom(): Float return get_y() + get_height();
  inline function get_left():   Float return get_x();

  inline function get_centerX():Float return _center.x;
  inline function set_centerX( value:Float ):Float return _center.x = value;
  inline function get_centerY():Float return _center.y;
  inline function set_centerY( value:Float ):Float return _center.y = value;

  inline function get_halfWidth() :Float return _halves.x;
  inline function set_halfWidth( value :Float ) :Float return _halves.x = value;
  inline function get_halfHeight() :Float return _halves.y;
  inline function set_halfHeight( value :Float ) :Float return _halves.y = value;


  
}
