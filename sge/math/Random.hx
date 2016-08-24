package sge.math;


//  Seedable Random
//  
// hash, and int are from:
// https://github.com/ncannasse/ld24/blob/master/lib/Rand.hx 
class Random
{

  // Static
  
  public static var instance(get, never):Random;

  static inline function get_instance():Random return new Random();


  // Helpers

  static inline function hash( n:Int ):Int 
  {
    for( i in 0...5 ) {
      n ^= (n << 7) & 0x2b5b2500;
      n ^= (n << 15) & 0x1b8b0000;
      n ^= n >>> 16;
      n &= 0x3FFFFFFF;
      var h:Int = 5381;
      h = (h << 5) + h + (n & 0xFF);
      h = (h << 5) + h + ((n >> 8) & 0xFF);
      h = (h << 5) + h + ((n >> 16) & 0xFF);
      h = (h << 5) + h + (n >> 24);
      n = h & 0x3FFFFFFF;
    }
    return n;
  } 

  static inline function shash( str:String ):Int 
  {
    var n :Int = 5381;
    var c :Int;
    for (i in 0...str.length)
    {
      c = StringTools.fastCodeAt(str, i);
      n = ((n << 5) + n) + c;
    }
    return n;
  }


  // Instance

  var seed:Float;
  
  public function new( ?seed:Dynamic )
  {    
    var intSeed:Int = 0;
    if (seed == null)
    {
      intSeed = openfl.Lib.getTimer();
    }
    else if (Std.is(seed, String))
    {
      intSeed = Random.shash(seed);
    }
    else if (Std.is(seed, Int))
    {
      intSeed = cast(seed, Int);
    }
    else
    {
      intSeed = Random.shash(Std.string(seed));
    }
    // hash the seed
    this.seed = Random.hash( ( ( intSeed < 0 ) ? -intSeed : intSeed ) + 151 );
  }

  // 
  // Dice Roll Random
  // 

  // roll n dice with d sides, and add the results to the given array of values
  public function roll(n:Int = 1, d:Int = 6, ?results:Array<Int>):Array<Int>
  {
    if (results == null) results = [];

    for (i in 0...n) results[i] = Math.ceil(random(d) + 1);

    return results;
  }

  // roll n dice with d sides, and add the result to the given result
  public function sumRoll(n:Int = 1, d:Int = 6, result:Int = 0):Int
  {
    for (i in 0...n) result += Math.ceil(random(d) + 1);

    return result;
  }

  // 
  // Between Random
  // 

  // random number between min(inclusive) and max(exclusive)
  public function randomFloat(min:Float, max:Float):Float
  {
    return int() % (max - min) + min;
  }

  // random number between min(inclusive) and max(exclusive)
  public function randomInt(min:Int, max:Int):Int
  {
    return Std.int( int() % (max - min) ) + min;
  }

  // 
  // Other
  // 

  // gets a random number between 0 and n (excluding n)
  public inline function random(n:Float = 1):Float
  {
    return int() % n;
  }

  // random unsigned integer color value
  public function randomColor():UInt
  {
    return int() * 0xFFFFFF;
  }

  // public function randomOption(options:Array<T>):T
  // {
  //   var i = randomInt(0, options.length);
  //   return options[i];
  // }


  // Internal

  // Get a random value (and increment the seed to make sure the next call gets a new number)
  inline function int():Int
  {
    return Math.floor(seed = (seed * 16807.0) % 2147483647.0) & 0x3FFFFFFF;
  }


} //Random
