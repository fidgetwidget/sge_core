package sge.math;

import sge.Pool;
import sge.Recyclable;

// 
// Singlular Boundries
// min, max
// 
class Sides implements Recyclable<Sides>
{

  public static function get():Sides return pool.pop();

  public static function put(item:Sides):Void pool.push(item);

  public static var pool:Pool<Sides> = new Pool<Sides>( function() { return new Sides(); });


  public var top:Int;
  public var right:Int;
  public var bottom:Int;
  public var left:Int;

  public function new(?a:Int, ?b:Int, ?c:Int, ?d:Int) 
  {
    set(a, b, c, d);
  }

  public function set(?a:Int, ?b:Int, ?c:Int, ?d:Int):Void
  {
    if (a == null) a = 0;
    
    top = a;
    right = (b == null ? a : b);
    bottom = (c == null ? a : c);
    left = (d == null ? (b == null ? a : b) : d);
  }

  public function clear():Sides
  {
    top = right = bottom = left = 0;
    return this;
  }

  public function toString():String  return 'Sides[$top $right $bottom $left]';


} //Sides
