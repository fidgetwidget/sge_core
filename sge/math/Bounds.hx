package sge.math;

import sge.Pool;
import sge.Recyclable;

// 
// Singlular Boundries
// min, max
// 
class Bounds implements Recyclable<Bounds>
{

  public static function get():Bounds return pool.pop();

  public static function put(item:Bounds):Void pool.push(item);

  public static var pool:Pool<Bounds> = new Pool<Bounds>( function() { return new Bounds(); });


  public var min:Null<Float>;
  public var max:Null<Float>;

  public function new() 
  {
    min = max = null;
  }

  public function clear():Bounds
  {
    min = max = null;
    return this;
  }

  public function toString():String  return 'Bounds[min:$min, max:$max]';


} //Bounds
