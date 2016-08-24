package sge.shapes;

import sge.math.Vector2;
import sge.Pool;


class Ray
{
  
  public var start:Vector2;

  public var end:Vector2;

  public var infinite:Bool;

  public var direction (get, never):Vector2;


  public function new( start:Vector2, end:Vector2, infinite:Bool = false ) 
  { 
    this.start = start;
    this.end = end;
    this.infinite = infinite;
    
    _direction = Vector2.get();
    _direction.x = end.x - start.x;
    _direction.y = end.y - start.y;
  }


  var _direction:Vector2;

  inline function get_direction():Vector2
  {
    _direction.x = end.x - start.x;
    _direction.y = end.y - start.y;

    return _direction;
  }

}
