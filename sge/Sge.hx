package sge;

import openfl.geom.Point;
import sge.math.Random;
import sge.math.Vector2;

@:publicFields
class Sge
{

  // 
  // Helper Values
  // 

  // Zero Point
  public static var zero(get, never):Point;
  static var _zero:Point;
  inline static function get_zero():Point 
  {
    if (_zero == null) _zero = new Point();
    return _zero;
  }

  // 
  // Array Helpers
  // 

  // remove all the items from the given array, (optional) perform func on each item as it's removed
  static inline function cleanArray<T>(array:Array<T>, func:T->Void = null):Void
  {
    while (array.length > 0) 
    {
      if (func != null) func(array.pop());
      else array.pop();
    }
  }

  // shuffle the given arrays content;
  static inline function shuffleArray<T>(array:Array<T>):Void
  {
    var j:Int, l:Int, a:T, b:T;
    l = array.length;
    for (i in 0...l) {
      j = randomInt(0, l);
      a = array[i];
      b = array[j];
      array[i] = b;
      array[j] = a;
    }
  }

  // get a random item from the first given array using the second arrays weight table
  // NOTE: given arrays must be of equal lengths
  // eg.
  // ['common', 'uncommon', 'rare', 'legendary'], [9, 5, 3, 1];
  // - the higher the value, the more likely it will be chosen
  static inline function getRandomValue<T>( array :Array<T>, weights :Array<Int> ) :T
  {
    if (array.length != weights.length) 
      throw new openfl.errors.Error("Values Array and Weights Array don't have matching lengths.");

    var weightsSum:Int, randomValue:Int, index:Int;
    weightsSum = index = 0;
    // get the sum of all weights
    for (w in weights) weightsSum += w;
    // get a random number between 0 and the total sum of weights
    randomValue = Sge.randomInt(0, weightsSum);
    // loop through
    // - reduce the random value by the weight table value
    //   until the random value is less than 0
    // - return the index where we reached 0
    while (randomValue > 0)
    {
      randomValue -= weights[index];
      if (randomValue <= 0) break;
      index++;
    }
    return array[index];
  }

  // 
  // Math Helpers
  // 

  static inline var DEGREES_TO_RADIANS_CONST:Float = 3.141592653589793 / 180;
  static inline var RADIANS_TO_DEGREES_CONST:Float = 180 / 3.141592653589793;

  static inline function clamp(val:Float, ?min:Float, ?max:Float):Float
  {
    if (min != null && min > val) val = min;
    if (max != null && val > max) val = max;
    return val;
  }

  static inline function distanceBetween( x1:Float, y1:Float, x2:Float, y2:Float ):Float
  {
    var dx:Float = x1 - x2;
    var dy:Float = y1 - y2;
    return Math.sqrt(dx * dx + dy * dy);
  }

  static inline function remainder(a:Float, n:Float):Float return a - (n * Math.floor(a/n));

  static inline function remainder_int(a:Int, n:Int):Int return a - (n * Math.floor(a/n));

  // 
  // Random
  // 

  private static var _random:Random;

  private static inline function _initRandom():Void
  {
    if (_random == null) _random = Random.instance;
  }


  static function randomInt(min:Int, max:Int):Int
  {
    _initRandom();
    return _random.randomInt(min, max);
  }

  static function randomFloat(min:Float, max:Float):Float
  {
    _initRandom();
    return _random.randomFloat(min, max);
  }

  static function randomDirection(?vector:Vector2):Vector2
  {
    vector = vector == null ? Vector2.get() : vector.clear();
    vector.x = Sge.randomFloat(-100, 100);
    vector.y = Sge.randomFloat(-100, 100);
    vector.normalize();
    return vector;
  }

}
