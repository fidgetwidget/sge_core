package sge.display;

import openfl.display.BitmapData;
import sge.Pool;
import sge.Recyclable;

// 
// Singlular Boundries
// min, max
// 
class Animation implements Recyclable<Animation>
{

  public static function get():Animation return pool.pop();

  public static function put(item:Animation):Void pool.push(item);

  public static var pool:Pool<Animation> = new Pool<Animation>( function() { return new Animation(); });


  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Animation.uid++;
  }

  // Instance

  public var name:String;
  
  public var frames:Array<TileFrame> = [];
  
  public var frameLengths:Array<Float> = [];

  public var loop:Bool = true;

  public var loops(get, never):Int;

  public var bitmapData(get, never):BitmapData;

  public var currentFrame(get, never):Int;

  public var isPaused(get, never):Bool;

  public var isComplete(get, never):Bool;


  public function new() 
  {
    _id = Animation.getNextId();
    name = 'animation_$_id';
    restart();
  }


  public function restart():Void
  {
    _complete = _paused = false;
    _delta = _currentFrame = 0;
    _loops = 0;
  }

  public function pause():Bool
  {
    return _paused = !_paused;
  }

  public function play(fromFrame:Int = 0):Void
  {
    restart();
    _currentFrame = fromFrame;
  }


  public function clear():Animation
  {
    restart();
    name = 'animation_$_id';
    Sge.cleanArray(frames);
    Sge.cleanArray(frameLengths);
    loop = true;
    return this;
  }


  public function addFrame( frame:TileFrame, length:Float ):Void
  {
    var i = frames.length;
    frames[i] = frame;
    frameLengths[i] = length;
  }

  public function copyFrame( animation:Animation, frame:Int ):Void
  {
    var i = frames.length;
    frames[i] = animation.frames[frame];
    frameLengths[i] = animation.frameLengths[frame];
  }

  public function removeFrame( frame:Int ):Void
  {
    frames.splice(frame, 1);
    frameLengths.splice(frame, 1);
  }


  public function update( delta:Float ):Void
  {
    if (isPaused || isComplete) return;

    _delta += delta;
    var f = frameLengths[_currentFrame];
    // if we are going to go past a frame
    while (_delta - f > 0)
    {
      _delta -= f;
      _currentFrame++;
      if (_currentFrame >= frames.length) break;

      f = frameLengths[_currentFrame];
    }

    // we've passed the last frame, loop or done
    if (_currentFrame >= frames.length) {

      if (loop)
      {
        _loops++;
        _currentFrame = 0;
      }
      else
      {
        _complete = true;
        _currentFrame = frames.length - 1;
        _delta = 0;
      }

    }
  }


  public function toString():String  return 'Animation[id:$_id]';


  var _id:Int;
  var _delta:Float;
  var _currentFrame:Int = 0;
  var _loops:Int = 0;
  var _paused:Bool = false;
  var _complete:Bool = false;

  inline function get_loops():Int return _loops;

  inline function get_bitmapData():BitmapData
  {
    if (frames.length <= currentFrame) {
      return null;
    } else {
      return frames[currentFrame].bitmapData;
    }
  }

  inline function get_currentFrame():Int return _currentFrame;

  inline function get_isPaused():Bool return _paused;

  inline function get_isComplete():Bool return _complete;

} //Animation
