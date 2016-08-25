package sge.scene;

import sge.Sge;
import haxe.CallStack;

// 
// Scene Manager
// - handles the adding and removing of scenes to 
//   the active/rendering loops
// 
// TODO: when pushing a scene, wait until it's 
//       transitioned on before giving it focus
//       
// TODO: when removing a scene, wait until it's 
//       transitioned off before removing it from the 
//       render loop
// 
class SceneManager {

  // 
  // Static
  // 

  public static var instance(get, never):SceneManager;
  static var _instance:SceneManager;

  static inline function get_instance():SceneManager 
  {
    if (_instance == null)
    {
      _instance = new SceneManager();
    }
    return _instance;
  }
  

  // 
  // Instance
  // 


  function new() 
  {
    scenes_by_id = new Map();
    sceneId_by_name = new Map();
    activeSceneIds = [];
    visibleSceneIds = [];
    sceneIdsToRemove = [];
  }

  // Add a scene to the manager 
  // (optional) push it to the active list
  public function add( scene:Scene, push:Bool = false ):Void
  {
    scenes_by_id.set(scene.id, scene);
    sceneId_by_name.set(scene.name, scene.id);
    if (push) this.push(scene.id);
  }

  // Push a scene to the top of the active scenes
  // - push happens immediately (because it's durring the update loop)
  public function push( identifier:Dynamic ):Void
  {
    var sceneId:Int, scene:Scene;

    if (Std.is(identifier, Int))
      sceneId = identifier;
    else if (Std.is(identifier, String))
      sceneId = sceneId_by_name.get(identifier);
    else if (Std.instance(identifier, Scene))
      sceneId = Reflect.field(identifier, "id");
    else
    {
      throw {
        message: "SceneManager.push requiers a String or Int identifier",
        callStack: CallStack.callStack(),
      };
    }

    if (activeSceneIds.length > 0)
    {
      var l = activeSceneIds.length;
      var id = activeSceneIds[l - 1];
      scenes_by_id[id].focus = false;
    }

    scene = scenes_by_id[sceneId];
    activeSceneIds.push(sceneId);
    if (scene.opaque) {
      clearVisibleScenes();
    }
    makeVisible(scene);
    scene.focus = true;
  }

  // Remove the top scene from the active scenes
  // - defered removal to prevent overlapping behaviour 
  //   > the next active scene doing something based on the
  //    input intended for the now removed scene)
  public function pop():Void
  {
    var id, l;
    l = activeSceneIds.length;
    id = activeSceneIds[l-1];
    sceneIdsToRemove.push( id );
  }

  // Update the active scenes
  public function update():Void
  {
    var sceneId, index, scene, id, l;

    if (sceneIdsToRemove.length > 0)
    {
      while(sceneIdsToRemove.length > 0)
      {
        id = sceneIdsToRemove.pop();
        scenes_by_id[id].focus = false;
        activeSceneIds.remove(id);
      }

      // if there are still active scenes, give the top one focus
      l = activeSceneIds.length;
      if (l > 0)
      {
        id = activeSceneIds[l-1];
        scenes_by_id[id].focus = true;
      }
      rebuildVisibleList(); 
    }

    index = activeSceneIds.length - 1;
    while (index >= 0)
    {
      sceneId = activeSceneIds[index];
      scene = scenes_by_id.get(sceneId);
      scene.update();
      index--;
    }
  }

  // Render the visible scenes
  public function render():Void
  {
    var scene:Scene;
    // render visible scenes from the front to back
    for (sceneId in visibleSceneIds)
    {
      scene = scenes_by_id.get(sceneId);
      scene.render();
    }
  }

  // 
  // Internal
  // 

  // Rebuild the visible scenes list
  //   if the top item had covered all others, when it's
  //   removed we need to rebuild the visible list.
  inline function rebuildVisibleList():Void
  {
    var sceneId:Int, index:Int, scene:Scene;
    // go through the active scenes in reverse order (newest added, to oldest added)
    index = activeSceneIds.length - 1;
    clearVisibleScenes();
    while (index >= 0)
    {
      sceneId = activeSceneIds[index];
      // push it onto the top (becuase we render from 0+)
      visibleSceneIds.push(sceneId);
      // if the scene is opaque, then don't add anymore below it
      scene = scenes_by_id.get(sceneId);
      makeVisible(scene);
      if (scene.opaque) break;
      index--;
    }
  }

  inline function makeVisible(scene:Scene):Void
  {
    visibleSceneIds.push(scene.id);
    Game.instance.sceneLayer.addChild(scene._renderTarget);
    Game.instance.sceneLayer.addChild(scene._shape);
    scene.visible = true;
  }

  // Clear the visible scenes list 
  //   because we want to tell each scene that it's not 
  //   visible when we remove it.
  inline function clearVisibleScenes():Void 
  {
    var sceneId, scene;
    while (visibleSceneIds.length > 0)
    {
      sceneId = visibleSceneIds.pop();
      scene = scenes_by_id[sceneId];
      Game.instance.sceneLayer.removeChild(scene._renderTarget);
      Game.instance.sceneLayer.removeChild(scene._shape);
      scene.visible = false; 
    }
  }
  
  var scenes_by_id:Map<Int,Scene>;
  var sceneId_by_name:Map<String, Int>;
  var activeSceneIds:Array<Int>;
  var visibleSceneIds:Array<Int>;
  var sceneIdsToRemove:Array<Int>;

} //SceneManager
