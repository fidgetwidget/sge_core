package sge.display;

import sge.Pool;
import sge.Recyclable;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import sge.math.Transform;
import sge.math.Vector2;

// 
// A (mostly) Static Image
// 
class Label implements Recyclable<Label>
{

  // Static

  public static function get():Label return pool.pop();

  public static function put(item:Label):Void pool.push(item);

  public static var pool:Pool<Label> = new Pool<Label>( function() { return new Label(); });

  // 
  // Static Unique Id
  // 
  static var uid:Int = 1;
  static function getNextId():Int
  {
    return Label.uid++;
  }


  // Instance

  public var id(get, never):Int;

  public var name:String;

  public var text(get, set):String;

  public var transform:Transform;

  public var sprite(get, never):Sprite;

  public var renderTarget(get, set):Sprite;

  public var textfield(get, set):TextField;

  public var backgroundColor(get, set):Int;

  public var visible(get, set):Bool;

  public var opactiy(get, set):Float;

  public var x(get, set):Float;

  public var y(get, set):Float;

  public var width(get, never):Float;

  public var height(get, never):Float;


  // Because we do the recycling, we don't want to have any arguments in the constructor
  public function new() 
  {
    _id = Label.getNextId();
    _sprite = new Sprite();
    
    _bgColor = 0xffffffff;
    _background = new Shape();
    _textfield = new TextField();
    _textfield.autoSize = TextFieldAutoSize.LEFT;

    _sprite.addChild(_background);
    _sprite.addChild(_textfield);

    transform = Transform.get();
    renderTarget = null;
  }

  public function clear():Label
  {
    renderTarget = null; // pointer set after construction
    
    // TODO: reset background and textfield to defaults
    _textfield.autoSize = TextFieldAutoSize.LEFT;

    _sprite.removeChild(_background);
    _sprite.removeChild(_textfield);

    transform.clear();
    return this;
  }


  public function render():Void
  {
    if (transform == null || _sprite == null) return;
    // TODO: find a better way to ensure the sprite and transform are in sync
    _sprite.x         = transform.x;
    _sprite.y         = transform.y;
    _sprite.scaleX    = transform.scaleX;
    _sprite.scaleY    = transform.scaleY;
    _sprite.rotation  = transform.angle;
  }

  public function toString():String  return 'Label[$_id text:$text]';


  // 
  // Internal
  // 

  inline function redrawBackground():Void
  {
    if (_background == null || _textfield == null) return;

    var g = _background.graphics;
    g.clear();
    g.beginFill(_bgColor);
    g.drawRect(0, 0, _textfield.width, _textfield.height);
    g.endFill();
  }


  // Properties

  var _id:Int;
  // var _name:String;
  var _renderTarget:Sprite;
  var _sprite:Sprite;
  var _background:Shape;
  var _textfield:TextField;
  var _bgColor:Int;

  inline function get_id():Int return _id;

  inline function get_text():String return _textfield != null ? _textfield.text : '$name';
  inline function set_text(value:String):String
  {
    if (_textfield == null) return '$name:';
    _textfield.text = '$name: $value';
    redrawBackground();
    return _textfield.text;
  }

  inline function get_sprite():Sprite return _sprite;

  inline function get_renderTarget():Sprite return _renderTarget;
  inline function set_renderTarget(value:Sprite):Sprite
  {
    // do we need to remove the bitmap from the old renderTarget?
    if (_renderTarget != null && _renderTarget != value && _sprite != null)
      _renderTarget.removeChild(_sprite);

    // do we need to add the bitmap to the new renderTarget?
    if (value != null && _sprite != null) {
      value.addChild(_sprite);
    }

    return _renderTarget = value;
  }

  inline function get_textfield():TextField return _textfield;
  inline function set_textfield(value:TextField) 
  {
    if (_renderTarget != null)
    {
      if (value == null)
        renderTarget.removeChild(value);
      else
        renderTarget.addChild(value);
    }
    
    return _textfield = value;
  }

  inline function get_backgroundColor():Int return _bgColor;
  inline function set_backgroundColor(value:Int):Int 
  {
    _bgColor = value;
    redrawBackground();
    return _bgColor;
  }

  inline function get_visible():Bool return _sprite.visible;
  inline function set_visible(value:Bool):Bool return _sprite.visible = value;

  inline function get_opactiy():Float return _sprite.alpha;
  inline function set_opactiy(value:Float):Float return _sprite.alpha = value;

  inline function get_x():Float return transform.x;
  inline function set_x(value:Float):Float 
  {
    _sprite.x = transform.x = value;
    return transform.x;
  }

  inline function get_y():Float return transform.y;
  inline function set_y(value:Float):Float
  {
    _sprite.y = transform.y = value;
    return transform.y;
  }

  inline function get_width():Float return _textfield.textWidth;

  inline function get_height():Float return _textfield.textHeight;

} //Bounds
