package sge.math;

import sge.Pool;
import sge.Recyclable;

// 
// 2D Boundries
// maxX, minX, maxY, minY
// 
class Bounds2 implements Recyclable<Bounds2>
{

  public static function get():Bounds2 return pool.pop();

  public static function put(item:Bounds2):Void pool.push(item);

  public static var pool:Pool<Bounds2> = new Pool<Bounds2>( function() { return new Bounds2(); });


  public var minX(get, set):Null<Float>;
  public var minY(get, set):Null<Float>;
  public var maxX(get, set):Null<Float>;
  public var maxY(get, set):Null<Float>;

  public function new() 
  {
    x = Bounds.get();
    y = Bounds.get();
  }

  public function clear():Bounds2
  {
    x.clear();
    y.clear();
    return this;
  }

  public function toString():String  return 'Bounds2[x:${x}, y:${y}]';


  var x:Bounds;
  var y:Bounds;

  inline function get_minX():Null<Float> return x.min;
  inline function set_minX(value:Null<Float>):Null<Float> return x.min = value;

  inline function get_maxX():Null<Float> return x.max;
  inline function set_maxX(value:Null<Float>):Null<Float> return x.max = value;

  inline function get_minY():Null<Float> return y.min;
  inline function set_minY(value:Null<Float>):Null<Float> return y.min = value;

  inline function get_maxY():Null<Float> return y.max;
  inline function set_maxY(value:Null<Float>):Null<Float> return y.max = value;


} //Bounds2
