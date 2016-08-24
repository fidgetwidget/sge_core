package sge.collision;

import openfl.display.Graphics;
import sge.shapes.Circle;
import sge.shapes.Polygon;
import sge.shapes.Shape;
import sge.math.Transform;
import sge.math.TransformMatrix;

// 
// Collider: Shape
// 
class ShapeCollider extends Collider
{
  
  public var shape(get, set):Shape;


  public function new( transform:Transform, shape:Shape ) 
  {
    super(transform, shape.width, shape.height);

    _shape = shape;
    _shape.transform = this.transform;
  }

  override public function test( collider:Collider ):Bool
  {
    if (collider == null) return false;

    _collision = _collision == null ? Collision.get() : _collision.clear();

    if (Std.is(collider, ShapeCollider))
      return testShapeCollider( cast(collider, ShapeCollider) );
    else
      return false;
  }

  function testShapeCollider( collider:ShapeCollider ):Bool
  {
    if (Std.is(_shape, Circle))
    {
      var _this = cast(_shape, Circle);
      if ( Std.is(collider.shape, Circle) )
      {
        var _other = cast(collider.shape, Circle);
        return SAT2D.testCircleVsCircle( _this, _other, _collision) != null;
      }
      else if ( Std.is(collider.shape, Polygon) )
      {
        var _other = cast(collider.shape, Polygon); 
        return SAT2D.testCircleVsPolygon( _this, _other, _collision) != null;
      }
    }
    else if (Std.is(_shape, Polygon))
    {
      var _this = cast(_shape, Polygon);
      if ( Std.is(collider.shape, Circle) )
      {
        var _other = cast(collider.shape, Circle);
        return SAT2D.testCircleVsPolygon( _other, _this, _collision, true) != null;
      }
      else if ( Std.is(collider.shape, Polygon) )
      {
        var _other = cast(collider.shape, Polygon);
        return SAT2D.testPolygonVsPolygon( _this, _other, _collision) != null;
      }
    }
    return false;
  }

  var _shape:Shape;

  // inline function get_transform():Transform return _transform;
  override function set_transform(value:Transform):Transform 
  {
    _transform = value;
    _shape.transform = _transform;
    return _transform;
  }

  inline function get_shape():Shape  return _shape;
  inline function set_shape(value:Shape):Shape
  {
    _shape = value;
    _shape.transform = _transform;
    return _shape;
  }

}
