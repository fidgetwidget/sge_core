package sge.display;

import sge.scene.Scene;

// implements Iterable<Image>
@:generic
class ImageCollection<T:Image> 
{
  

  public var length(get, never):Int;
  public var scene(get, never):Scene;

  public function new(scene:Scene) 
  {
    _scene = scene;
    images = new Map();
  }

  // Add an entity to the collection
  public function add( img:T ):Void
  {
    img.renderTarget = _scene.renderTarget;
    images.set(img.id, img);
    count++;
  }

  // Remove an entity from the collection
  public function remove( img:T ):Bool
  {
    if (images.exists(img.id))
    {
      count--;
      if (img.renderTarget == _scene.renderTarget) img.renderTarget = null;
      return images.remove(img.id);
    }
    return false;
  }

  // call update on all of the entities
  public function render():Void
  {
    for(img in images)
    {
      img.render();
    }
  }

  // pass each entity to the given function
  public function call(func:T->Void):Void
  {
    for(img in images)
    {
      func( img );
    }
  }


  // get an iterator of all the entities
  // Iterable<T>
  public function iterator():Iterator<T>
  {
    return images.iterator();
  }


  var count:Int = 0;
  var images:Map<Int, T>;
  var _scene:Scene;

  public inline function get_length():Int return count;
  public inline function get_scene():Scene return _scene;

}
