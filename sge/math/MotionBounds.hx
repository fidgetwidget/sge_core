package sge.math;

// 
// 2D Motion
// velocity and acceleration
// 
@:publicFields
class MotionBounds
{

  var velocity:           Bounds2;
  var velocityLength:     Bounds;
  var acceleration:       Bounds2;
  var acceelrationLength: Bounds;
  var aVelocity:          Bounds;
  var aAcceleration:      Bounds;


  function new()
  {
    velocity            = Bounds2.get();
    velocityLength      = Bounds.get();
    acceleration        = Bounds2.get();
    acceelrationLength  = Bounds.get();
    aVelocity           = Bounds.get();
    aAcceleration       = Bounds.get();
  }

  function clear():MotionBounds
  {
    velocity.clear();
    velocityLength.clear();
    acceleration.clear();
    acceelrationLength.clear();
    aVelocity.clear();
    aAcceleration.clear();
    return this;
  }

  function dispose():Void
  {
    Bounds2.put(velocity);
    Bounds.put(velocityLength);
    Bounds2.put(acceleration);
    Bounds.put(acceelrationLength);
    Bounds.put(aVelocity);
    Bounds.put(aAcceleration);
    velocity = null;
    velocityLength = null;
    acceleration = null;
    acceelrationLength = null;
    aVelocity = null;
    aAcceleration = null;
  }

  function toString():String
    return 'MotionBounds[
      vel:${velocity}, 
      vLen:${velocityLength}, 
      accel:${acceleration}, 
      aLen:${acceelrationLength} 
      aVel:${aVelocity}, 
      aAccel:${aAcceleration}
    ]';

} //MotionBounds
