package sge.entity;

// 
// Basic AI Routine for entities
// 
class Routine
{

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Routine.uid++;
  }


  public var id(get, never):Int;
  public var name:String;
  public var hasState(get, never):Bool;
  public var currentBehaviour(get, never):Behaviour;
  public var currentIndex:Int;
  public var states:Array<Behaviour>;


  public function new()
  {
    _id = getNextId();
    currentState = 0;
    states = [];
  }


  public function update( delta:Float = 1, entity:Entity, scene:Scene ):Void
  {
    if (hasState) currentBehaviour.update(delta, entity, scene);
  }


  public function toString():String return 'Routine[id:$id, name:$name]';


  var _id:Int;

  inline function get_id():Int return _id;

  inline function get_hasState():Bool return currentIndex < states.length;

  inline function get_currentBehaviour():Behaviour return hasState ? states[currentIndex] : null;

} //Routine
