package sge.math;

// 
// Singlular Boundries
// min, max
// 
class Bitwise
{

  public static function remove( bits:Int, mask:Int ):Int
  {
    return bits & ~mask;
  }

  public static function add( bits:Int, mask:Int ):Int
  {
    return bits | mask;
  }

  public static function contains( bits:Int, mask:Int ):Bool
  {
    return bits & mask != 0;
  }

} //Bitwise
