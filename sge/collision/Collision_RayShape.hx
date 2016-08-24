package sge.collision;

import sge.shapes.Shape;
import sge.shapes.Ray;


// 
// Collision between Ray and Shape
// 
@:publicFields
class Collision_RayShape
{
  
  var shape  :Shape;
  var ray    :Ray;
  var start  :Float = 0.0;  // Distance along ray that the intersection start at
  var end    :Float = 0.0;  // Distance along ray that the intersection ended at
  

  @:noCompletion
  inline function new() {}

  inline function clear() 
  {
    ray = null;
    shape = null;
    start = 0.0;
    end = 0.0;

    return this;
  } //clear

  inline function copy_from( other:Collision_RayShape ) 
  {

    ray = other.ray;
    shape = other.shape;
    start = other.start;
    end = other.end;

  } //copy_from

  inline function clone(?target:Collision_RayShape = null):Collision_RayShape
  {
    if (target == null) target = new Collision_RayShape();

    target.ray    = ray;
    target.shape  = shape;
    target.start  = start;
    target.end    = end;

    return target;
  } //copy_from

}
