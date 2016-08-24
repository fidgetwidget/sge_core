package sge.collision;

import sge.shapes.Ray;

// 
// Collision between Ray and Ray
// 
@:publicFields
class Collision_RayRay
{
 
  var ray1 :Ray;
  var ray2 :Ray;
  var u1   :Float = 0.0; // u value for ray1
  var u2   :Float = 0.0; // u value for ray2


  @:noCompletion
  inline function new() {}

  inline function clear() 
  {
    ray1 = null;
    ray2 = null;
    u1 = 0.0;
    u2 = 0.0;

    return this;
  } //clear

  inline function copy_from(other:Collision_RayRay) 
  {
    ray1 = other.ray1;
    ray2 = other.ray2;
    u1 = other.u1;
    u2 = other.u2;
  } //copy_from

  inline function clone() 
  {
    var _clone = new Collision_RayRay();

    _clone.copy_from(this);

    return _clone;
  } //copy_from

}
