package sge.input;

// 
// 
class InputManager {

  // 
  // Static
  // 

  public static var instance(get, never):InputManager;
  static var _instance:InputManager;

  static inline function get_instance():InputManager 
  {
    if (_instance == null)
    {
      _instance = new InputManager();
    }
    return _instance;
  }
  

  // 
  // Instance
  // 

  public var keyboard:KeyboardInput;
  public var mouse:MouseInput;
  public var gamepads:Array<GamepadInput>;


  function new() 
  {
    keyboard = new KeyboardInput();
    mouse = new MouseInput();
    gamepads = [];
  }


  public function update():Void
  {
    keyboard.update();
    mouse.update();
  }


} //InputManager
