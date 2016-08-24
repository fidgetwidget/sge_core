package sge.scene;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.display.Shape;
import sge.display.Image;
import sge.display.ImageCollection;
import sge.entity.Entity;
import sge.entity.EntityCollection;


// 
// Base Scene
// 
class Scene {

  // 
  // Static Unique Id
  // 
  static var uid :Int = 0;
  static function getNextId() :Int 
  {
    return Scene.uid++;
  }

  // Instance

  public var id(get, never):Int;

  public var name:String;

  public var camera:Camera;

  public var renderTarget(get, never):Sprite;

  public var graphics(get, never):Graphics;

  public var entities:EntityCollection<Entity>;

  public var images:ImageCollection<Image>;

  // Does this scene make all lower scenes invisible?
  // default: no
  public var opaque:Bool = false;

  public var paused:Bool = false;

  // Is the scene currently visible?
  public var visible(get, set):Bool;

  // Does the scene currently have focus?
  public var focus(get, set):Bool;
  

  public function new() 
  {
    _id = Scene.getNextId();
    name = 'Scene-$_id';

    init_renderTarget();

    init_camera();

    init_entities();

    init_images();
  }


  public function update():Void
  {
    if (focus && !paused) update_input();

    if (!paused) 
    {
      update_camera();

      update_entities();
    }
  }

  public function render():Void
  {
    render_images();
  }


  // 
  // Internal
  // 


  // Initaliziers (made available for override)
  
  function init_renderTarget():Void
  {
    _renderTarget = new Sprite();
    _shape = new Shape();
  }

  function init_camera():Void
  {
    var w, h;
    w = Game.instance.stage.stageWidth;
    h = Game.instance.stage.stageHeight;
    camera = new Camera();
    camera.setRect(0, 0, w, h);
  }

  function init_entities():Void entities = new EntityCollection<Entity>(this);

  function init_images():Void images = new ImageCollection<Image>(this);

  // Update Steps

  function update_input():Void return;

  function update_entities():Void entities.update();

  function update_camera():Void
  {
    // Update the camera
    camera.update();

    // update the renderTarget position to match the camera
    _renderTarget.x = _shape.x = -camera.left * camera.scale;
    _renderTarget.y = _shape.y = -camera.top * camera.scale;
    // update the renderTarget scale to match the camera
    _renderTarget.scaleX = _shape.scaleX = camera.scale;
    _renderTarget.scaleY = _shape.scaleY = camera.scale;
  }

  // Render Steps

  function render_images():Void images.render();

  // Events

  function on_visibleChanged():Void return;

  function on_focusChanged():Void return;

  
  var _id:Int;
  var _visible:Bool = false;
  var _focus:Bool = false;
  // The DisplayObjectContainer all images in this scene belong to
  @:allow(sge.scene.SceneManager)
  var _renderTarget:Sprite;
  // A shape for vector drawing (debug_rendering)
  @:allow(sge.scene.SceneManager)
  var _shape:Shape;

  inline function get_id():Int return _id;

  inline function get_renderTarget():Sprite return _renderTarget;

  inline function get_graphics():Graphics return _shape.graphics;

  inline function get_visible():Bool return _visible;
  inline function set_visible(value:Bool):Bool
  {
    _visible = value;
    on_visibleChanged();
    return _visible;
  }

  inline function get_focus():Bool return _focus;
  inline function set_focus(value:Bool):Bool 
  {
    _focus = value;
    on_focusChanged();
    return _focus;
  }
  

} //Scene
