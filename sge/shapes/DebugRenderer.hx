package sge.shapes;

import openfl.display.Graphics;
import sge.collision.TileCollider;
import sge.entity.Tilemap;
import sge.math.Bitwise;
import sge.math.Vector2;

// 
// The Body for a transform (position)
// 

@:publicFields
class DebugRenderer
{

  static function drawShape( shape:Shape, g:Graphics ):Void
  {
    if (Std.is(shape, Circle)) drawCircle( cast( shape, Circle ), g ) ;
    if (Std.is(shape, Polygon)) drawPolygon( cast( shape, Polygon ), g );
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

  static function drawTilemap( map:Tilemap, g:Graphics ):Void
  {
    var c, r, xx, yy, collision, hasCollision;
    c = r = 0;
    xx = yy = 0.0;

    while (c < map.colCount)
    {
      while (r < map.rowCount)
      {
        // hasCollision = map.collider.hasCollision(c, r);
        collision = map.collider.getTile(c, r, true);
        xx = map.x + c * map.tileWidth;
        yy = map.y + r * map.tileHeight;

        switch collision
        {
          case TileCollider.SIDES:
            g.drawRect(xx, yy, map.tileWidth, map.tileHeight);

          default:
            if (Bitwise.contains(collision, TileCollider.TOP))
            {
              g.moveTo(xx, yy);
              g.lineTo(xx + map.tileWidth, yy);  
            }
            if (Bitwise.contains(collision, TileCollider.RIGHT))
            {
              g.moveTo(xx + map.tileWidth, yy);
              g.lineTo(xx + map.tileWidth, yy + map.tileHeight);
            }
            if (Bitwise.contains(collision, TileCollider.BOTTOM))
            {
              g.moveTo(xx, yy + map.tileHeight);
              g.lineTo(xx + map.tileWidth, yy + map.tileHeight);
            }
            if (Bitwise.contains(collision, TileCollider.LEFT))
            {
              g.moveTo(xx, yy);
              g.lineTo(xx, yy + map.tileHeight);
            }
        }
        r++;
      }
      c++;
      r = 0;
    }
  }

}