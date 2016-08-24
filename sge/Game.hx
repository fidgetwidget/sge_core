package sge;

import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

import sge.scene.SceneManager;
import sge.input.InputManager;


class Game {

  // 
  // Static
  // 

  public static var instance (get, never) :Game;
  static var _instance:Game;

  static inline function get_instance():Game 
  {
    if (_instance == null)
    {
      _instance = new Game();
    }
    return _instance;
  }
  

  // 
  // Instance
  // 
  
  public var root(get, never):DisplayObjectContainer;

  public var stage(get, never):Stage;

  public var sceneLayer(get, never):Sprite;

  public var uiLayer(get, never):Sprite;

  public var debugLayer(get, never):Sprite;


  public var frameRate(get, never):Float;

  public var delta(get, never):Float;

  public var isPaused(get, never):Bool;

  public var frameStep(get, never):Float; // the desired delta


  public function ready():Void
  {
    if (!_isReady) init();
  }

  public function resume():Void _isPaused = false;

  public function pause():Void  _isPaused = true;

  public function update():Void
  {
    // if the Game is Paused, don't update.
    update_updateDelta();
    if (_isPaused) return;

    InputManager.instance.update();

    SceneManager.instance.update();
    
    SceneManager.instance.render();

  }


  // 
  // Internal
  // 

  function new() 
  { 
    _isReady = false; 
  }

  // 
  // Init
  // 
  
  function init():Void
  {
    _root = openfl.Lib.current;
    _startTimestamp = _currentTimestamp = _prevTimestamp = haxe.Timer.stamp();
    _delta = 0;
    _frameStep = 1 / frameRate;

    init_events();

    // make sure the instances are ready
    var sm = SceneManager.instance;
    var im = InputManager.instance;

    _sceneLayer = new Sprite();
    _uiLayer    = new Sprite();
    _debugLayer = new Sprite();

    Game.instance.stage.addChild(_sceneLayer);
    Game.instance.stage.addChild(_uiLayer);
    Game.instance.stage.addChild(_debugLayer);

    _isReady = true;
  }

  function init_events():Void
  {
    // Force Pause/Resume of Game
    _root.stage.addEventListener( Event.ACTIVATE,    function(_) resume() );

    _root.stage.addEventListener( Event.DEACTIVATE,  function(_) pause() );

    _root.stage.addEventListener( Event.ENTER_FRAME, function(_) update() );
  }

  // 
  // Update
  // 

  function update_updateDelta():Void
  {
    _prevTimestamp = _currentTimestamp;
    _currentTimestamp = haxe.Timer.stamp();
    _delta = _currentTimestamp - _prevTimestamp;
  }


  // 
  // Properties
  // 

  var _root:DisplayObjectContainer;
  var _sceneLayer:Sprite;
  var _uiLayer:Sprite;
  var _debugLayer:Sprite;
  
  var _startTimestamp:Float;
  var _currentTimestamp:Float;
  var _prevTimestamp:Float;
  var _delta:Float;
  var _frameStep:Float;
  
  var _isReady:Bool;
  var _isPaused:Bool;

  inline function get_root():DisplayObjectContainer return _root;
  
  inline function get_stage():Stage return _root.stage;

  inline function get_sceneLayer():Sprite return _sceneLayer;

  inline function get_uiLayer():Sprite return _uiLayer;

  inline function get_debugLayer():Sprite return _debugLayer;


  inline function get_frameRate():Float return Lib.application.frameRate;
  
  inline function get_delta():Float return _delta;

  inline function get_frameStep():Float return _frameStep;

  inline function get_isPaused():Bool return _isPaused;
 

}