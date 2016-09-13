package sge.display;

import openfl.display.Graphics;
import sge.shapes.Shape;
import sge.shapes.Circle;
import sge.shapes.Polygon;

// 
// Drawing Helper for Shapes
// 
@:publicFields
class ShapeRenderer
{

  static function drawShape( shape:Shape, g:Graphics ):Void
  {
    if (Std.is(shape, Circle))  drawCircle(   cast( shape, Circle ),  g );
    if (Std.is(shape, Polygon)) drawPolygon(  cast( shape, Polygon ), g );
  }

  
  static function drawCircle( c:Circle, g:Graphics ):Void
  {
    g.drawCircle(c.x, c.y, c.transformedRadius);
  }


  static function drawPolygon( p:Polygon, g:Graphics ):Void
  {
    var l = p.transformedVertices.length;
    var v = p.transformedVertices[l - 1];
    g.moveTo(v.x, v.y);
    for (i in 0...l)
    {
      v = p.transformedVertices[i];
      g.lineTo(v.x, v.y);
    }
  }

}