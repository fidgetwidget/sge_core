package sge.collision;


import sge.shapes.Shape;
import sge.shapes.Circle;
import sge.shapes.Polygon;
import sge.shapes.Ray;
import sge.math.Vector2;
import sge.math.TransformMatrix;

// 
// Separation Axiom Theorem Math
// used for testing collisions between:
//   cirlces, polygons, and rays
// 
// this code comes from haxe differ (originally)
// https://github.com/underscorediscovery/differ/blob/master/differ/sat/SAT2D.hx
// 
// TODO: optimize for lower memory usage (recylced objects {Vector2, Collision, etc})
// 
class SAT2D {

  
  public static function testCircleVsPolygon( circle:Circle, polygon:Polygon, ?into:Collision, flip:Bool=false ):Collision 
  {
    into = into == null ? Collision.get() : into.clear();

    var verts = polygon.transformedVertices;

    var circleX = circle.x;
    var circleY = circle.y;

    var testDistance : Float = 0x3FFFFFFF;
    var distance = 0.0, closestX = 0.0, closestY = 0.0;
    for(i in 0 ... verts.length) {

      distance = vec_lengthsq(circleX - verts[i].x, circleY - verts[i].y);

      if(distance < testDistance) {
        testDistance = distance;
        closestX = verts[i].x;
        closestY = verts[i].y;
      }

    } //for

    var normalAxisX = closestX - circleX;
    var normalAxisY = closestY - circleY;
    var normAxisLen = vec_length(normalAxisX, normalAxisY);
      normalAxisX = vec_normalize(normAxisLen, normalAxisX);
      normalAxisY = vec_normalize(normAxisLen, normalAxisY);

      //project all its points, 0 outside the loop
    var test = 0.0;
    var min1 = vec_dot(normalAxisX, normalAxisY, verts[0].x, verts[0].y);
    var max1 = min1;

    for(j in 1 ... verts.length) {
      test = vec_dot(normalAxisX, normalAxisY, verts[j].x, verts[j].y);
      if(test < min1) min1 = test;
      if(test > max1) max1 = test;
    } //each vert

      // project the circle
    var max2 = circle.transformedRadius;
    var min2 = -circle.transformedRadius;
    var offset = vec_dot(normalAxisX, normalAxisY, -circleX, -circleY);
      
    min1 += offset;
    max1 += offset;

    var test1 = min1 - max2;
    var test2 = min2 - max1;

      //if either test is greater than 0, there is a gap, we can give up now.
    if(test1 > 0 || test2 > 0) return null;

      // circle distance check
    var distMin = -(max2 - min1);
    if(flip) distMin *= -1;

    into.overlap = distMin;
    into.unitVectorX = normalAxisX;
    into.unitVectorY = normalAxisY;
    var closest = Math.abs(distMin);

      // find the normal axis for each point and project
    for(i in 0 ... verts.length) {

      normalAxisX = findNormalAxisX(verts, i);
      normalAxisY = findNormalAxisY(verts, i);
      var aLen = vec_length(normalAxisX, normalAxisY);
      normalAxisX = vec_normalize(aLen, normalAxisX);
      normalAxisY = vec_normalize(aLen, normalAxisY);

        // project the polygon(again? yes, circles vs. polygon require more testing...)
      min1 = vec_dot(normalAxisX, normalAxisY, verts[0].x, verts[0].y);
      max1 = min1; //set max and min

      //project all the other points(see, cirlces v. polygons use lots of this...)
      for(j in 1 ... verts.length) {
        test = vec_dot(normalAxisX, normalAxisY, verts[j].x, verts[j].y);
        if(test < min1) min1 = test;
        if(test > max1) max1 = test;
      }

      // project the circle(again)
      max2 = circle.transformedRadius; //max is radius
      min2 = -circle.transformedRadius; //min is negative radius

      //offset points
      offset = vec_dot(normalAxisX, normalAxisY, -circleX, -circleY);
      min1 += offset;
      max1 += offset;

      // do the test, again
      test1 = min1 - max2;
      test2 = min2 - max1;

        //failed.. quit now
      if(test1 > 0 || test2 > 0) {
        return null;
      }

      distMin = -(max2 - min1);
      if(flip) distMin *= -1;

      if(Math.abs(distMin) < closest) {
        into.unitVectorX = normalAxisX;
        into.unitVectorY = normalAxisY;
        into.overlap = distMin;
        closest = Math.abs(distMin);
      }

    } //for

    //if you made it here, there is a collision!!!!!

    into.thing1 = if(flip) polygon else circle;
    into.thing2 = if(flip) circle else polygon;
    into.separationX = into.unitVectorX * into.overlap;
    into.separationY = into.unitVectorY * into.overlap;

    if(!flip) {
      into.unitVectorX = -into.unitVectorX;
      into.unitVectorY = -into.unitVectorY;
    }

    return into;

  } //testCircleVsPolygon

  
  public static function testCircleVsCircle( circleA:Circle, circleB:Circle, ?into:Collision, flip:Bool = false ):Collision 
  {
    
    var circle1 = flip ? circleB : circleA;
    var circle2 = flip ? circleA : circleB;

      //add both radii together to get the colliding distance
    var totalRadius = circle1.transformedRadius + circle2.transformedRadius;
      //find the distance between the two circles using Pythagorean theorem. No square roots for optimization
    var distancesq = vec_lengthsq(circle1.x - circle2.x, circle1.y - circle2.y);

      //if your distance is less than the totalRadius square(because distance is squared)
    if(distancesq < totalRadius * totalRadius) {

      into = (into == null) ? Collision.get() : into.clear();
        //find the difference. Square roots are needed here.
      var difference = totalRadius - Math.sqrt(distancesq);

      into.thing1 = circle1;
      into.thing2 = circle2;

      var unitVecX = circle1.x - circle2.x;
      var unitVecY = circle1.y - circle2.y;
      var unitVecLen = vec_length(unitVecX, unitVecY);

      unitVecX = vec_normalize(unitVecLen, unitVecX);
      unitVecY = vec_normalize(unitVecLen, unitVecY);

      into.unitVectorX = unitVecX;
      into.unitVectorY = unitVecY;

        //find the movement needed to separate the circles
      into.separationX = into.unitVectorX * difference;
      into.separationY = into.unitVectorY * difference;

        //the magnitude of the overlap
      into.overlap = vec_length(into.separationX, into.separationY);

      return into;

    } //if distancesq < r^2

    return null;

  } //testCircleVsCircle

  // 
  // TODO: improve this: 
  //       there is no reason to create so many Shape Collisions 
  //       that just get thrown away
  // 
  public static function testPolygonVsPolygon( polygon1:Polygon, polygon2:Polygon, ?into:Collision, flip:Bool=false ):Collision 
  {

    into = (into == null) ? Collision.get() : into.clear();
    var tmp1 = Collision.get();
    var tmp2 = Collision.get();
    
    if(checkPolygons(polygon1, polygon2, tmp1, flip) == null) {
      return null;
    }

    if(checkPolygons(polygon2, polygon1, tmp2, !flip) == null) {
      return null;
    }

    var result = null, other = null;
    if(Math.abs(tmp1.overlap) < Math.abs(tmp2.overlap)) {
      result = tmp1;
      other = tmp2;
    } else {
      result = tmp2;
      other = tmp1;
    }
    
    result.other = Collision.get();
    result.other.overlap      = other.overlap;
    result.other.separationX  = other.separationX;
    result.other.separationY  = other.separationY;
    result.other.unitVectorX  = other.unitVectorX;
    result.other.unitVectorY  = other.unitVectorY;
    into.copy_from(result);

    // cleanup
    Collision.put(tmp1);
    Collision.put(tmp2);
    Collision.put(result);
    Collision.put(other);

    return into;

  } //testPolygonVsPolygon

  /** Internal api - test a ray against a circle */
  public static function testRayVsCircle( ray:Ray, circle:Circle, ?into:Collision_RayShape ):Collision_RayShape 
  {

    var deltaX = ray.end.x - ray.start.x;
    var deltaY = ray.end.y - ray.start.y;
    var ray2circleX = ray.start.x - circle.x;
    var ray2circleY = ray.start.y - circle.y;

    var a = vec_lengthsq(deltaX, deltaY);
    var b = 2 * vec_dot(deltaX, deltaY, ray2circleX, ray2circleY);
    var c = vec_dot(ray2circleX, ray2circleY, ray2circleX, ray2circleY) - (circle.radius * circle.radius);
    var d = b * b - 4 * a * c;

    if (d >= 0) {

      d = Math.sqrt(d);

      var t1 = (-b - d) / (2 * a);
      var t2 = (-b + d) / (2 * a);

      if (ray.infinite || (t1 <= 1.0 && t1 >= 0.0)) {
        
        into = (into == null) ? new Collision_RayShape() : into.clear();
          
          into.shape = circle;
          into.ray = ray;
          into.start = t1;
          into.end = t2;

        return into;

      } //

    } //d >= 0

    return null;

  } //testRayVsCircle

  /** Internal api - test a ray against a polygon */
  public static function testRayVsPolygon( ray:Ray, polygon:Polygon, ?into:Collision_RayShape ):Collision_RayShape 
  {

    var min_u = Math.POSITIVE_INFINITY;
    var max_u = 0.0;

    var startX = ray.start.x;
    var startY = ray.start.y;
    var deltaX = ray.end.x - startX;
    var deltaY = ray.end.y - startY;

    var verts = polygon.transformedVertices;
    var v1 = verts[verts.length - 1];
    var v2 = verts[0];

    var ud = (v2.y-v1.y) * deltaX - (v2.x-v1.x) * deltaY;
    var ua = rayU(ud, startX, startY, v1.x, v1.y, v2.x - v1.x, v2.y - v1.y);
    var ub = rayU(ud, startX, startY, v1.x, v1.y, deltaX, deltaY);

    if (ud != 0.0 && ub >= 0.0 && ub <= 1.0) {
      if (ua < min_u) min_u = ua;
      if (ua > max_u) max_u = ua;
    }

    for (i in 1...verts.length) {

      v1 = verts[i - 1];
      v2 = verts[i];

      ud = (v2.y-v1.y) * deltaX - (v2.x-v1.x) * deltaY;
      ua = rayU(ud, startX, startY, v1.x, v1.y, v2.x - v1.x, v2.y - v1.y);
      ub = rayU(ud, startX, startY, v1.x, v1.y, deltaX, deltaY);

      if (ud != 0.0 && ub >= 0.0 && ub <= 1.0) {
        if (ua < min_u) min_u = ua;
        if (ua > max_u) max_u = ua;
      }

    } //each vert

    if(ray.infinite || (min_u <= 1.0 && min_u >= 0.0) ) {
      into = (into == null) ? new Collision_RayShape() : into.clear();
        into.shape = polygon;
        into.ray = ray;
        into.start = min_u; 
        into.end = max_u;
      return into;
    }

    return null;

  } //testRayVsPolygon

  /** Internal api - test a ray against another ray */
  public static function testRayVsRay( ray1:Ray, ray2:Ray, ?into:Collision_RayRay ):Collision_RayRay 
  {

    var delta1X = ray1.end.x - ray1.start.x;
    var delta1Y = ray1.end.y - ray1.start.y;
    var delta2X = ray2.end.x - ray2.start.x;
    var delta2Y = ray2.end.y - ray2.start.y;
    var diffX = ray1.start.x - ray2.start.x;
    var diffY = ray1.start.y - ray2.start.y;
    var ud = delta2Y * delta1X - delta2X * delta1Y;

    if(ud == 0.0) return null;

    var u1 = (delta2X * diffY - delta2Y * diffX) / ud;
    var u2 = (delta1X * diffY - delta1Y * diffX) / ud;

    if ((ray1.infinite || (u1 > 0.0 && u1 <= 1.0)) && (ray2.infinite || (u2 > 0.0 && u2 <= 1.0))) {
      into = (into == null) ? new Collision_RayRay() : into.clear();
        into.ray1 = ray1;
        into.ray2 = ray2;
        into.u1 = u1;
        into.u2 = u2;
      return into;
    }

    return null;

  } //testRayVsRay

  //Internal implementation detail helpers

  /** Internal api - implementation details for testPolygonVsPolygon */
  static function checkPolygons( polygon1:Polygon, polygon2:Polygon, into:Collision, flip:Bool=false ):Collision 
  {

    into.clear();

    var offset = 0.0, test1 = 0.0, test2 = 0.0, testNum = 0.0;
    var min1 = 0.0, max1 = 0.0, min2 = 0.0, max2 = 0.0;
    var closest : Float = 0x3FFFFFFF;

    var axisX = 0.0;
    var axisY = 0.0;
    var verts1 = polygon1.transformedVertices;
    var verts2 = polygon2.transformedVertices;

      // loop to begin projection
    for(i in 0 ... verts1.length) {

      axisX = findNormalAxisX(verts1, i);
      axisY = findNormalAxisY(verts1, i);
      var aLen = vec_length(axisX, axisY);
      axisX = vec_normalize(aLen, axisX);
      axisY = vec_normalize(aLen, axisY);

        // project polygon1
      min1 = vec_dot(axisX, axisY, verts1[0].x, verts1[0].y);
      max1 = min1;

      for(j in 1 ... verts1.length) {
        testNum = vec_dot(axisX, axisY, verts1[j].x, verts1[j].y);
        if(testNum < min1) min1 = testNum;
        if(testNum > max1) max1 = testNum;
      }

        // project polygon2
      min2 = vec_dot(axisX, axisY, verts2[0].x, verts2[0].y);
      max2 = min2;

      for(j in 1 ... verts2.length) {
        testNum = vec_dot(axisX, axisY, verts2[j].x, verts2[j].y);
        if(testNum < min2) min2 = testNum;
        if(testNum > max2) max2 = testNum;
      }

      test1 = min1 - max2;
      test2 = min2 - max1;

      if(test1 > 0 || test2 > 0) return null;

      var distMin = -(max2 - min1);
      if(flip) distMin *= -1;

      if(Math.abs(distMin) < closest) {
        into.unitVectorX = axisX;
        into.unitVectorY = axisY;
        into.overlap = distMin;
        closest = Math.abs(distMin);
      }

    }

    into.thing1 = if(flip) polygon2 else polygon1;
    into.thing2 = if(flip) polygon1 else polygon2;
    into.separationX = -into.unitVectorX * into.overlap;
    into.separationY = -into.unitVectorY * into.overlap;

    if(flip) {
      into.unitVectorX = -into.unitVectorX;
      into.unitVectorY = -into.unitVectorY;
    }

    return into;

  } //checkPolygons


  //Internal helpers

  static inline function rayU(udelta:Float, aX:Float, aY:Float, bX:Float, bY:Float, dX:Float, dY:Float):Float 
  {
    return (dX * (aY - bY) - dY * (aX - bX)) / udelta;
  } //rayU

  static inline function findNormalAxisX(verts:Array<Vector2>, index:Int):Float 
  {
    var v2 = (index >= verts.length - 1) ? verts[0] : verts[index + 1];
    return -(v2.y - verts[index].y);
  }

  static inline function findNormalAxisY(verts:Array<Vector2>, index:Int):Float 
  {
    var v2 = (index >= verts.length - 1) ? verts[0] : verts[index + 1];
    return (v2.x - verts[index].x);
  }

  public static inline function vec_lengthsq( x:Float, y:Float ):Float return x * x + y * y;

  public static inline function vec_length( x:Float, y:Float ):Float return Math.sqrt(vec_lengthsq(x,y));

  public static inline function vec_normalize( length:Float, component:Float ):Float return length == 0 ? 0 : component /= length;

  public static inline function vec_dot( x:Float, y:Float, otherx:Float, othery:Float ):Float return x * otherx + y * othery;

} //SAT2D
