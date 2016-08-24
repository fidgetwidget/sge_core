package sge.math;

// 
// Transformation Matrix
// for storing and adjusting Position, Rotation and Scale
// 
// [x1] [a  b  *0]
// [y1] [c  d  *0]
// [z1] [tx ty *1] 
// we don't need the 3rd column 
// 
class TransformMatrix implements Recyclable<TransformMatrix>
{

  // Static

  public static function get():TransformMatrix return pool.pop();

  public static function put(item:TransformMatrix):Void pool.push(item.clear());

  public static var pool:Pool<TransformMatrix> = new Pool<TransformMatrix>( function() { return new TransformMatrix(); });
  
  // Instance

  public var a:   Float;
  public var b:   Float;
  public var c:   Float;
  public var d:   Float;
  public var tx:  Float;
  public var ty:  Float;

  // Constructor with default values (default: identity matrix)
  public function new( a: Float = 1, b: Float = 0, c: Float = 0, d: Float = 1, tx: Float = 0, ty: Float = 0 ) 
  {
    this.a  = a;
    this.b  = b;
    this.c  = c;
    this.d  = d;
    this.tx = tx;
    this.ty = ty;
  }

  public inline function clear():TransformMatrix
  {
    this.identity();
    return this;
  }

  public inline function clone(?target:TransformMatrix = null):TransformMatrix
  {
    if (target == null) target = TransformMatrix.get();
    target.a  = this.a;
    target.b  = this.b;
    target.c  = this.c;
    target.d  = this.d;
    target.tx = this.tx;
    target.ty = this.ty;
    return target;
  }


  public inline function toString():String return 'TransformMatrix[a:$a, b:$b, c:$c, d:$d, tx:$tx, ty:$ty]';


  public inline function identity():Void
  {
    a = d = 1;
    b = c = tx = ty = 0;
  }


  public inline function translate( x:Float, y:Float ):Void 
  {
    tx += x;
    ty += y;
  }

  public inline function setPosition( x:Float, y:Float ):Void
  {
    tx = x;
    ty = y;
  }


  public inline function rotate( angle:Float ):Void 
  {
    var cos, sin, a1, c1, tx1;
    
    cos = Math.cos(angle);
    sin = Math.sin(angle);
    
    a1 = a * cos - b * sin;
    b  = a * sin + b * cos;
    a  = a1;
    
    c1 = c * cos - d * sin;
    d  = c * sin + d * cos;
    c  = c1;
    
    tx1 = tx * cos - ty * sin;
    ty  = tx * sin + ty * cos;
    tx  = tx1;
  }

  public inline function setRotation( angle:Float ):Void
  {
    a = Math.cos(angle);
    c = Math.sin(angle);
    b = -c;
    d = a;
  }


  public inline function scale( x:Float, y:Float ):Void 
  {
    a  *= x;
    b  *= y;
    c  *= x;
    d  *= y;
    tx *= x;
    ty *= y;
  }


  public inline function compose( x:Float, y:Float, theta:Float, scaleX:Float, scaleY:Float ):Void
  {
    identity();
    scale( scaleX, scaleY );
    rotate( theta );
    tx = x;
    ty = y;
  }


  public inline function decompose( transform:Transform ):Void
  {
    var px:Float    = 1 * a + 0 * c;
    var py:Float    = 1 * b + 0 * d;
    var theta:Float = Math.atan2(b, a);

    if (transform == null) transform = new Transform();

    transform.scaleX = Math.sqrt(a * a + b * b);
    transform.scaleY = Math.sqrt(c * c + d * d);

    transform.radianAngle = theta;

    transform.x = tx;
    transform.y = ty;
  }


  public inline function equal( other:TransformMatrix ):Bool
  {
    return (
      other.a  == this.a  &&
      other.b  == this.b  &&
      other.c  == this.c  &&
      other.d  == this.d  &&
      other.tx == this.tx &&
      other.ty == this.ty);
  }

} //TransformMatrix
