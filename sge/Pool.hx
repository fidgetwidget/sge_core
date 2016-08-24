package sge;

import sge.Recyclable;


// 
// Generic Pool for recycling objects
// - keeps track of how many of an item were created 
//   & how many are available in the pool
// 
class Pool<T:Recyclable<T>>
{

  public var available(get, never):Int;

  public var made(get, never):Int;


  public function new(construct:Void->T)
  {
    _construct = construct;
    _available = [];
    _made = 0;
  }

  public function fill(count:Int):Void
  {
    while (available < count) push(make());
  }

  public function pop():T
  {
    if (_available.length > 0) return _available.pop();
    return make();
  }

  public function push(item:T):Void
  {
    _available.push(item.clear());
  }


  function make():T
  {
    _made++;
    return _construct();
  }


  var _construct:Void->T;
  var _available:Array<T>;
  var _made:Int;

  inline function get_available():Int return _available.length;

  inline function get_made():Int return _made;

}
