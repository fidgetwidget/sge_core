package sge.display;

import openfl.display.Bitmap;
import sge.Pool;
import sge.Recyclable;
import sge.math.Transform;

// 
// Display Thing
// - has a transform position
// - can have an animation
// 
// TODO: make it have children/parent
//       make it's transformation relative
//       update the bitmaps position/rotation/scale appropriately
// 
class Sprite extends Image implements Recyclable<Sprite>
{

  public static function get():Sprite return pool.pop();

  public static function put(item:Sprite):Void pool.push(item);

  public static var pool:Pool<Sprite> = new Pool<Sprite>( function() { return new Sprite(); });


  // Instance

  public var animation(get, set):Animation;

  public var isAnimated(get, never):Bool;


  // Because we do the recycling, we don't want to have any arguments in the constructor
  public function new() 
  {
    super();
    _animation = null;
  }

  override public function clear():Sprite
  {
    super.clear();
    _animation = null; // should only ever be a pointer
    return this;
  }

  public function copyTileFrame( tileFrame:TileFrame ):Void
  {
    if (bitmap == null)
      bitmap = new Bitmap( tileFrame.bitmapData );
    else
      bitmapData = tileFrame.bitmapData;
    
    anchor = tileFrame.anchor;
  }

  public function copyImage( image:Image ):Void
  {
    bitmap = image.bitmap;
    anchor = image.anchor;
    renderTarget = image.renderTarget;
    transform = image.transform;
  }

  override public function render():Void
  {
    super.render();

    if (isAnimated) {
      _animation.update(Game.instance.delta);
      _bitmap.bitmapData = _animation.bitmapData;
    }
  }

  override public function toString():String return 'Sprite[$_id]';


  var _animation:Animation;

  inline function get_animation():Animation return _animation;
  inline function set_animation(value:Animation)
  {
    // TODO: if the animation changed, we need to do stuff...
    return _animation = value;
  }

  inline function get_isAnimated():Bool return _animation != null;

} //Bounds
