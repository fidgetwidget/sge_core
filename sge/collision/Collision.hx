package sge.collision;

import sge.math.Vector2;
import sge.Recyclable;
import sge.Pool;


// 
// Collision between Shape or Shape-like things
// 
@:publicFields
class Collision implements Recyclable<Collision>
{

  // Static Pool

  public static function get():Collision return pool.pop();

  public static function put(item:Collision):Void pool.push(item);

  public static var pool:Pool<Collision> = new Pool<Collision>( function() { return new Collision(); });


  var overlap:Float; // the overlap amount

  var separation:Vector2; // a vector that when subtracted to shape 1 will separate it from shape 2
  var separationX (get, set):Float;
  var separationY (get, set):Float;

  var unitVector:Vector2; // unit vector on the axis of the collision (the normal of the face that was collided with)
  var unitVectorX (get, set):Float;
  var unitVectorY (get, set):Float;

  var other:Collision;
  var thing1:Dynamic;
  var thing2:Dynamic;

  inline function new() 
  {
    separation = Vector2.get();
    unitVector = Vector2.get();
    overlap = 0;
    other = null;
    thing1 = thing2 = null;
  }

  public function clear():Collision
  {
    overlap = separation.x = separation.y = unitVector.x = unitVector.y = 0.0;
    other = null;
    thing1 = thing2 = null;
    return this;
  } //clear


  public function clone(?target:Collision = null):Collision
  {
    if (target == null) target = Collision.get();
    target.copy_from(this);
    return target;
  } //clone


  public function copy_from( other:Collision ):Collision 
  {
    overlap = other.overlap;
    separation.x = other.separation.x;
    separation.y = other.separation.y;
    unitVector.x = other.unitVector.x;
    unitVector.y = other.unitVector.y;
    return this;
  } //copy_from


  public function toString() return 'Collision[overlap:$overlap separation:$separation unitVector:$unitVector]';


  inline function get_separationX() :Float return separation.x;
  inline function set_separationX( value :Float ) :Float return separation.x = value;

  inline function get_separationY() :Float return separation.y;
  inline function set_separationY( value :Float ) :Float return separation.y = value;

  inline function get_unitVectorX() :Float return unitVector.x;
  inline function set_unitVectorX( value :Float ) :Float return unitVector.x = value;

  inline function get_unitVectorY() :Float return unitVector.y;
  inline function set_unitVectorY( value :Float ) :Float return unitVector.y = value;

}
