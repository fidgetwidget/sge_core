package sge.shapes;

import openfl.display.Graphics;
import sge.math.TransformMatrix;
import sge.math.Vector2;


class Polygon extends Shape
{

  // Static Factory Methods

  static public function create( x:Float, y:Float, sides:Int, radius:Float ):Polygon
  {
    var rotation:Float = (Math.PI * 2) / sides;
    var vertices:Array<Vector2> = [];

    for(i in 0 ... sides) {

      var angle = (i * rotation) + ((Math.PI - rotation) * 0.5);
      var vector = Vector2.get();
      vector.x = Math.cos(angle) * radius;
      vector.y = Math.sin(angle) * radius;
      vertices.push(vector);

    }

    return new Polygon( x, y, vertices );
  }

  static public function rectangle( x:Float, y:Float, width:Float, height:Float, centered:Bool = false ):Polygon
  {
    var vertices:Array<Vector2> = new Array<Vector2>();

    if (centered) {

      vertices.push( Polygon.getVector(-width * 0.5, -height * 0.5) );
      vertices.push( Polygon.getVector( width * 0.5, -height * 0.5) );
      vertices.push( Polygon.getVector( width * 0.5,  height * 0.5) );
      vertices.push( Polygon.getVector(-width * 0.5,  height * 0.5) );

    } else {

      vertices.push( Polygon.getVector(0, 0) );
      vertices.push( Polygon.getVector(width, 0) );
      vertices.push( Polygon.getVector(width, height) );
      vertices.push( Polygon.getVector(0, height) );

    }

    return new Polygon( x, y, vertices );
  }

  static public function square( x:Float, y:Float, width:Float, centered:Bool = true ):Polygon
  {
    return rectangle( x, y, width, width, centered );
  }

  static public function triangle( x:Float, y:Float, radius:Float ):Polygon 
  {
    return create(x, y, 3, radius);
  }

  // Internal Helper
  static inline function getVector( x:Float = 0.0, y:Float = 0.0 ):Vector2
  {
    var vec = Vector2.get();
    vec.x = x;
    vec.y = y;
    return vec;
  }


  // Instance

  // parent properties
  // transform:Transform
  // offset:Vector2
  // _aabb:AABB

  public var vertices(get, never):Array<Vector2>;

  public var transformedVertices(get, never):Array<Vector2>;


  public function new( x:Float, y:Float, vertices:Array<Vector2> ) 
  { 
    super(x, y);
    _vertices = vertices;
    // clone the verticies into the transformed
    _transformedVertices = [];
    for(vert in _vertices) _transformedVertices.push(vert.clone());
    _setSize();
  }

  public override function toString():String  return 'Polygon[$_id transform:$transform, offset:$offset, width:$width, height:$height]';


  function _setSize():Void
  {
    var minX:Float = Math.POSITIVE_INFINITY;
    var minY:Float = Math.POSITIVE_INFINITY;
    var maxX:Float = Math.NEGATIVE_INFINITY;
    var maxY:Float = Math.NEGATIVE_INFINITY;

    for (v in _vertices)
    {
      minX = Math.min(v.x, minX);
      minY = Math.min(v.y, minY);
      maxX = Math.max(v.x, maxX);
      maxY = Math.max(v.y, maxY);
    }

    _aabb.width = maxX - minX;
    _aabb.height = maxY - minY;
  }

  var _testMatrix:TransformMatrix;
  var _currentMatrix:TransformMatrix;
  var _appliedMatrix:TransformMatrix = new TransformMatrix();
  var _vertices:Array<Vector2>;
  var _transformedVertices:Array<Vector2>;

  inline function get_vertices():Array<Vector2> return _vertices;

  inline function get_transformedVertices():Array<Vector2>
  {
    _testMatrix = transform.matrix;

    if( _currentMatrix == null || ! _currentMatrix.equal(_testMatrix) ) {
      _currentMatrix = _testMatrix.clone();
      _testMatrix = null;
      _appliedMatrix.identity();
      _appliedMatrix.translate(offsetX, offsetY);
      _appliedMatrix.scale(transform.scaleX, transform.scaleY);
      _appliedMatrix.rotate(transform.radianAngle);

      var len = _vertices.length;
      for (i in 0...len) {
        var v = _transformedVertices[i];
        _vertices[i].clone(v);
        // scale and rotation around the origin
        v.scaleAndRotate( _appliedMatrix );
        v.translate(transform.x, transform.y);
      }
    }

    return _transformedVertices;
  }

  function _returnVector(item:Vector2):Void
  {
    Vector2.put(item);
  }

}