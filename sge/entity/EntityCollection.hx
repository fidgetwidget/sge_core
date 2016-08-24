package sge.entity;

import openfl.display.Graphics;
import sge.scene.Scene;

// implements Iterable<Entity>
@:generic
class EntityCollection<T:Entity> 
{
  

  public var length(get, never):Int;
  public var scene(get, never):Scene;

  public function new( scene:Scene ) 
  {
    _scene = scene;
    entities = new Map();
  }

  // Add an entity to the collection
  public function add( e:T ):Void
  {
    e.scene = _scene;
    entities.set(e.id, e);
    count++;
  }

  // Remove an entity from the collection
  public function remove( e:T ):Bool
  {
    if (entities.exists(e.id))
    {
      count--;
      if (e.scene == _scene) e.scene = null;
      return entities.remove(e.id);
    }
    return false;
  }

  // call update on all of the entities
  public function update():Void
  {
    for(e in entities)
    {
      e.update();
    }
  }

  // pass each entity to the given function
  public function call(func:T->Void):Void
  {
    for(e in entities)
    {
      func(e);
    }
  }

  // get an iterator of the entities near the given entity
  public function near(e:T):Iterator<T>
  {
    return iterator();
  }


  // get an iterator of all the entities
  // Iterable<T>
  public function iterator():Iterator<T>
  {
    return entities.iterator();
  }


  public function debugRender(g:Graphics):Void return;


  var count:Int = 0;
  var entities:Map<Int, T>;
  var _scene:Scene;

  public inline function get_length():Int return count;
  public inline function get_scene():Scene return _scene;

}
