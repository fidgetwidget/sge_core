package sge.math;

// 
// 2D Motion
// x,y velocity and acceleration
// rotation velocity and acceleration
// drag
// rotation drag (optional)
// 
class Motion
{

  public var velocity:              Vector2;
  public var acceleration:          Vector2;
  public var aVelocity:             Float;
  public var aAcceleration:         Float;
  public var drag:                  Float; // 0 -> 1
  public var aDrag:                 Null<Float>; // use drag when null
  public var bounds(get, set):      MotionBounds;
  public var inMotion(get, never):  Bool;


  public function new()
  {
    velocity = Vector2.get();
    acceleration = Vector2.get();
    aVelocity = aAcceleration = 0;
    drag = 1 / Game.instance.frameRate;
    aDrag = null;
    _bounds = null;
  }

  public function clear():Motion
  {
    velocity.clear();
    acceleration.clear();
    aVelocity = aAcceleration = 0;
    drag = 1 / Game.instance.frameRate;
    aDrag = null;
    _bounds = null;
    return this;
  }

  public function toString():String return 'Motion[vel:$velocity, accel:$acceleration, aVel:$aVelocity, aAccel:$aAcceleration, drag:$drag]';


  public function setBounds( bounds:MotionBounds ):Void
  {
    _bounds = bounds;
  }


  public function update( delta:Float = 1, transform:Transform = null ):Void
  {
    if (_bounds != null) clampAccelerations();
    update_motion(delta);
    if (_bounds != null) clampVelocities();
    if (transform != null) update_transform(transform);
  }

  // 
  // Internal
  // 

  var CLOSE_TO_ZERO = 0.01;

  inline function update_motion( delta:Float ):Void
  {
    aVelocity   = computeVelocity( aVelocity, aAcceleration, (aDrag == null ? drag : aDrag), delta);
    velocity.x  = computeVelocity( velocity.x, acceleration.x, drag, delta);
    velocity.y  = computeVelocity( velocity.y, acceleration.y, drag, delta);
  }


  inline function update_transform( t:Transform ):Void
  {
    t.x += velocity.x;
    t.y += velocity.y;
    t.radianAngle += aVelocity;
  }


  inline function clampAccelerations():Void
  {
    aAcceleration  = Sge.clamp(aAcceleration,  _bounds.aAcceleration.min, _bounds.aAcceleration.max);
    acceleration.x = Sge.clamp(acceleration.x, _bounds.acceleration.minX, _bounds.acceleration.maxX);
    acceleration.y = Sge.clamp(acceleration.y, _bounds.acceleration.minY, _bounds.acceleration.maxY);
  }


  inline function clampVelocities():Void
  {
    aVelocity  = Sge.clamp(aVelocity, _bounds.aVelocity.min, _bounds.aVelocity.max);
    velocity.x = Sge.clamp(velocity.x, _bounds.velocity.minX, _bounds.velocity.maxX);
    velocity.y = Sge.clamp(velocity.y, _bounds.velocity.minY, _bounds.velocity.maxY);
  }


  inline function computeVelocity( v:Float, a:Float, drag:Float, delta:Float ):Float
  {
    if (Math.abs(a) > drag)
    {
      v += a * delta;
    }
    
    if (drag > 0)
    {
      var appliedDrag = v * drag; // * delta;
      // drag should only move velocity closer to zero
      if (Math.abs(v - appliedDrag) < Math.abs(v)) 
      { 
        v -= appliedDrag; 
      }
      else 
      { 
        v += appliedDrag; 
      }
    }

    if (Math.abs(v) < CLOSE_TO_ZERO) v = 0;

    return v;
  }


  var _bounds:MotionBounds;

  inline function get_bounds():MotionBounds return _bounds;
  inline function set_bounds(value:MotionBounds):MotionBounds return _bounds = value;

  inline function get_inMotion():Bool 
  {
    return (velocity.x != 0 || velocity.y != 0 || aVelocity != 0);
  }

} //Motion
