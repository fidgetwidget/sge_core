package sge.shapes;

import sge.math.Vector2;

// implements Iterable<Vector2>
class Path 
{

  // Static 
  
  static inline var PATH_START:Int = 0;

  static inline var PATH_END:Int = 1;

  

  // Instance

  public var start(get, never):Vector2;

  public var end(get, never):Vector2;

  public var currentPosition(get, never):Vector2;

  public var length(get, never):Float;


  public function new(?points:Array<Vector2> = null) 
  { 
    if (points != null)
    {
      for(p in points) add(p);
    }
    updateLength();
  }

  // add a point to the path (default: end)
  public function add(point:Vector2, side:Int = PATH_END):Void
  {
    if (_startNode == null)
    {
      _startNode = new PahtNode(point);
      _endNode = _startNode;
      return;
    }
    // add a point to the front of the path
    if (side == PATH_START)
    {
      _startNode.prevNode = new PathNode(point, null, _startNode);
      _startNode = _startNode.prevNode;
      return;
    }
    // add a point to the end of the path
    _endNode.nextNode = new PathNode(point, _endNode);
    _endNode = _endNode.nextNode;
    updateLength();
  }

  
  // TODO: Rewrite this... this is janky
  // Travel along the path (supports progressive delta: continues from where it left off)
  // INCOMPLETE: It will only work for > 0 delta values right now
  public function travel(delta:Float, reset:Bool = false):Vector2
  {
    var distToNext:Float, distToTravel:Float;

    // initialize
    if (reset) 
      _currentNode = null;
    
    if (_currentNode == null) 
    {
      _currentNode = (delta > 0 ? _startNode : _endNode);
      _currentDist = 0;
    }

    if (currentPosition == null) 
    {
      _currentPos = Vector2.get();
      _currentNode.position.clone( _currentPos );
    }

    // get the distance from the delta
    _currentDist += (delta * length);
    distToTravel = _currentDist; // <--- INCOMPLETE: I think this is what I need to change
    distToNext = Vector2.distanceBetween(_currentPos, _currentNode.position);
    // if we will move to/past the currentNode's position
    while (distToTravel > distToNext)
    {
      // move to the next position
      distToTravel -= distToNext * (delta > 0 ? 1 : -1);
      _currentNode.position.clone( _currentPos );
      // upate the next pointer
      _currentNode = delta > 0 ? _currentNode.nextNode : _currentNode.prevNode;
      // are we at the end?
      if (_currentNode == null) 
        return _currentPos;
      // update the distance for the next loop step
      distToNext = Vector2.distanceBetween(_currentPos, _currentNode.position);
    }
    // if we have distance left that is less than the whole way to the next point
    if (Math.abs(distToTravel) > 0) 
      Vector2.lerp(_currentPos, _currentNode.position, (distToTravel / distToNext), _currentPos);

    return _currentPos;
  }


  public function iterator():Iterator<Vector2>
  {
    return new PathIterator(_startNode);
  }


  inline function updateLength():Void
  {
    _length = 0;
    var n:PathNode = _startNode;
    while (n.nextNode != null)
    {
      _length += Vector2.distanceBetween(n.position, n.nextNode.position);
      n = n.nextNode;
    }
    n = null;
  }

  
  var _currentPos:  Vector2   = null;
  var _startNode:   PathNode  = null;
  var _endNode:     PathNode  = null;
  var _currentNode: PathNode  = null;
  var _currentDist: Float     = 0;
  var _length:      Float     = 0;

  inline function get_start():Vector2 return (_startNode == null ? null : _startNode.position);

  inline function get_end():Vector2 return (_endNode == null ? null : _endNode.position);

  inline function get_currentPosition():Vector2 return _currentPos;

  inline function get_length():Float return _length;

}

// Itearator for a path's points
// implements Iterator<Vector2>
class PathIterator 
{
  var currNode:PathNode;

  public function new(startNode:PathNode)
  {
    currNode = startNode;
  }

  public function hasNext():Bool
  {
    return currNode != null;
  }

  public function next():Vector2
  {
    var v = currNode.position;
    currNode = currNode.nextNode;
    return v;
  }
}


@:publicFields
class PathNode
{

  var position:Vector2;

  var prevNode:PathNode;

  var nextNode:PathNode;

  public function new(pos:Vector2 = null, prev:PathNode = null, next:PathNode = null) 
  {
    position = pos;
    prevNode = prev;
    nextNode = next;
  }

}
