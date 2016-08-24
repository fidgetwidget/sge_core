package sge.shapes; 

import massive.munit.Assert;
import sge.math.Transform;


class ShapeTest
{

  @Test public function test_clear()
  {
    var shape, result;
    shape = new Shape();
    result = shape.clear();

    // assert that a new shape and a cleared shape are the same
    Assert.areSame(shape, result);
  }

  @Test public function test_dispose()
  {
    var shape;
    shape = new Shape();
    shape.transform = new Transform();
    shape.dispose();

    // ensure that dispose leaves all properties null
    Assert.isNull(shape.offset);
    Assert.isNull(shape.transform);
    Assert.isNull(shape.bounds);
  }

  @Test public function test_getBounds()
  {
    var ox, oy, shape, t, bounds;
    ox = oy = 0;
    shape = new Shape(ox, oy);
    shape.transform = t = new Transform();

    // Default bounds of a shape is a 1px square at the transform+offset position
    bounds = shape.get_bounds();

    // NOTE: this is a bad test as it relies on the Vector2 toString output
    Assert.areEqual('AABB[ center:Vector[x:${ox+t.x}, y:${oy+t.y}] halves:Vector[x:${1*0.5}, y:${1*0.5}] ]', '$bounds');
  }


} //ShapesTests
