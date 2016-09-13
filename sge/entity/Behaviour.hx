package sge.entity;

// 
// A flexible definition of what an Entity should do
// 
class Behaviour
{

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return uid++;
  }


  public var id(get, never):Int;
  
  public var name:String;


  public function new()
  {
    _id = getNextId();
  }
  

  public function update( delta:Float = 1, entity:Entity, scene:Scene ):Void
  {
    // Behaviour goes here
  }


  public function toString():String return 'Behaviour[id:$id, name:$name]';


  var _id:Int;

  inline function get_id():Int return _id;

} //Behaviour
