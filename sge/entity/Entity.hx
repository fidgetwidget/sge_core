package sge.entity;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import sge.Game;
import sge.collision.AABB;
import sge.collision.ShapeCollider;
import sge.collision.HasBounds;
import sge.display.Image;
import sge.display.Sprite;
import sge.display.TileFrame;
import sge.math.Transform;
import sge.math.Motion;
import sge.math.HasPosition;
import sge.scene.Scene;
import sge.shapes.Shape;

// 
// A Complex Game Object
// - transformation
// - motion
// - collision*
// - graphics*
// * default null
// 
class Entity implements HasBounds
{

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Entity.uid++;
  }


  // Instance
  
  public var id(get, never):Int;

  public var name:String;

  public var scene:Scene;

  public var transform:Transform;

  public var motion:Motion;


  // Optional
  public var collider:ShapeCollider;
  public var shape:Shape;
  public var routine:Routine;

  // the basic transform
  public var x(get, set):               Float;
  public var y(get, set):               Float;
  public var ix(get, never):            Int;
  public var iy(get, never):            Int;
  public var scaleX(get, set):          Float;
  public var scaleY(get, set):          Float;
  public var angle(get, set):           Float;
  // the basic motion
  public var velocityX(get, set):       Float;
  public var velocityY(get, set):       Float;
  public var accelerationX(get, set):   Float;
  public var accelerationY(get, set):   Float;
  public var drag(get, set):            Float;
  public var inMotion(get, never):      Bool;
  // angular motion
  public var aVelocity(get, set):       Float;
  public var aAcceleration(get, set):   Float;
  public var aDrag(get, set):           Float;
  // collider/bounds
  public var bounds(get, never):        AABB;
  public var hasCollider(get, never):   Bool;
  // sprite
  public var sprite(get, set):          Sprite;
  public var hasSprite(get, never):     Bool;

  
  public function new() 
  {
    _id       = Entity.getNextId();
    transform = Transform.get();
    // NOTE: maybe motion should be optional...
    motion    = Motion.get();

    shape = null;
    collider = null;
    routine = null;

    _sprite = null;
  }

  public function clear():Entity
  {
    // NOTE: the _id doesn't change.
    transform.clear();
    motion.clear();
    shape = null;
    collider = null;
    routine = null;
    _sprite = null;
    return this;
  }

  // Create a Collider from a Shape
  public function createCollider( shape:Shape ):Void 
  {
    this.shape = shape;
    this.collider = new ShapeCollider( this.transform, this.shape );
  }

  public function createSprite( source:Dynamic ):Void
  {
    if (Std.is(source, Sprite)) {
      sprite = cast(sprite, Sprite);
    } else {
      sprite = new Sprite();
    }

    if (Std.is(source, Image)) {
      sprite.copyImage( cast(source, Image) );
    }

    if (Std.is(source, TileFrame)) {
      sprite.copyTileFrame( cast(source, TileFrame) );
    }

    if (Std.is(source, Bitmap)) {
      sprite.bitmap = cast(source, Bitmap);
    }

    if (Std.is(source, BitmapData)) {
      sprite.bitmap = new Bitmap( cast(source, BitmapData) );
    }

    sprite.transform = transform; // because one or more of these might set the transform to something passed in.
  }

  // Base Update function
  public function update():Void 
  {
    update_routine(Game.instance.delta);
    update_motion(Game.instance.delta);
  }


  public function toString():String return 'Entity($_id)[x:$x y:$y]';

  // 
  // Internal
  // 

  inline function update_routine( delta:Float ):Void
  {
    if (routine == null) return; // in case they for some reason nulled the motion
    routine.update( delta, scene, this );
  }

  inline function update_motion( delta:Float ):Void
  {
    if (motion == null) return; // in case they for some reason nulled the motion
    motion.update( delta, transform );
  }


  var _id:Int;
  var _sprite:Sprite;
  
  // 
  // Properties
  // 

  inline function get_id():Int return _id;


  // Transform
  inline function get_x():Float return transform.x;
  inline function set_x(value:Float):Float return transform.x = value;

  inline function get_y():Float return transform.y;
  inline function set_y(value:Float):Float return transform.y = value;

  inline function get_ix():Int return Math.floor(transform.x);
  inline function get_iy():Int return Math.floor(transform.y);

  inline function get_scaleX():Float return transform.scaleX;
  inline function set_scaleX(value:Float):Float return transform.scaleX = value;

  inline function get_scaleY():Float return transform.scaleY;
  inline function set_scaleY(value:Float):Float return transform.scaleY = value;

  inline function get_angle():Float return transform.angle;
  inline function set_angle(value:Float):Float return transform.angle = value;


  // Motion
  inline function get_velocityX():Float return motion.velocity.x;
  inline function set_velocityX(value:Float):Float return motion.velocity.x = value;
  
  inline function get_velocityY():Float return motion.velocity.y;
  inline function set_velocityY(value:Float):Float return motion.velocity.y = value;

  inline function get_accelerationX():Float return motion.acceleration.x;
  inline function set_accelerationX(value:Float):Float return motion.acceleration.x = value;

  inline function get_accelerationY():Float return motion.acceleration.y;
  inline function set_accelerationY(value:Float):Float return motion.acceleration.y = value;

  inline function get_drag():Float return motion.drag;
  inline function set_drag(value:Float):Float return motion.drag = value;
  
  inline function get_inMotion():Bool return motion.inMotion;

  inline function get_aVelocity():Float return motion.aVelocity;
  inline function set_aVelocity(value:Float):Float return motion.aVelocity = value;

  inline function get_aAcceleration():Float return motion.aAcceleration;
  inline function set_aAcceleration(value:Float):Float return motion.aAcceleration = value;

  inline function get_aDrag():Float return motion.aDrag;
  inline function set_aDrag(value:Float):Float return motion.aDrag = value;


  // Shape
  inline function get_hasCollider():Bool return collider != null;

  // Sprite
  inline function get_sprite():Sprite return _sprite;
  inline function set_sprite(value:Sprite):Sprite
  {
    // connect the sprite to the transform & render target 
    if (value != null)  {
      value.transform = this.transform;
    }
    else {
      _sprite.transform = null;
    }
    return _sprite = value;
  } 
  inline function get_hasSprite():Bool return _sprite != null;


  // Public getter
  public function get_bounds():AABB return (shape == null ? null : shape.get_bounds());


}
