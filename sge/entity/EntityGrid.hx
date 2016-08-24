package sge.entity;

import openfl.display.Graphics;
import sge.collision.AABB;
import sge.scene.Scene;

// implements Iterable<Entity>
@:generic
class EntityGrid<T:Entity> extends EntityCollection<T> 
{
  
  // public static inline var DEFAULT_CELL_WIDTH:  Int = 256;
  // public static inline var DEFAULT_CELL_HEIGHT: Int = 256;


  public var cellWidth(get, never):Int;
  public var cellHeight(get, never):Int;


  public function new(scene:Scene, ?cellWidth:Int, ?cellHeight:Int) 
  {
    super(scene);
    entityIds_cell = new Map();
    cells_entityId = new Map();

    _cellWidth  = (cellWidth == null  ? _cellWidth  : cellWidth);
    _cellHeight = (cellHeight == null ? _cellHeight : cellHeight);
    cellWidthOverOne  = 1 / _cellWidth;
    cellHeightOverOne = 1 / _cellHeight;
  }

  // Add an entity to the collection
  override public function add( e:T ):Void
  {
    var id = e.id;
    entities.set(id, e);
    relocate(e);
    count++;
  }

  // Remove an entity from the collection
  override public function remove( e:T ):Bool
  {
    var id = e.id;
    if (entities.exists(id))
    {
      count--;
      removeFromCells(id);
      return entities.remove(id);
    }
    return false;
  }

  // call update on all of the entities
  override public function update():Void
  {
    for(e in entities)
    {
      e.update();
      relocate(e);
    }
  }

  // get an iterator of the entities near the given entity
  override public function near(e:T):Iterator<T>
  {
    var n, bounds, cells, ids;

    bounds = e.get_bounds();
    cells = getCells(bounds);
    n = new Array<T>();

    for (cell in cells)
    {
      if (!entityIds_cell.exists(cell)) entityIds_cell.set(cell, []);
      ids = entityIds_cell.get(cell);
      for (id in ids)
      {
        n.push( entities.get(id) );
      }
    }
    return n.iterator();
  }


  override public function debugRender(g:Graphics):Void
  {
    for(cell in entityIds_cell.keys()) 
    {
      var xy = cell.split('|').map( function(val) { return Std.parseInt(val); });
      g.drawRect(xy[0] * _cellWidth, xy[1] * _cellHeight, _cellWidth, _cellHeight);
    }
  }


  // 
  // Reasign the entities position in the cells
  // 
  public inline function relocate( e:T ):Void
  {
    var id, bounds, cells, ids;
    id = e.id;
    
    // remove the entity from where it was
    removeFromCells(id);
    
    // figure out where the entity should go
    bounds = e.get_bounds();
    if (!cells_entityId.exists(id)) cells_entityId.set(id, []);
    cells = cells_entityId.get(id);
    
    // update it's position
    cells = getCells(bounds, cells);
    
    // update the list of ids for each of the locations the entity exists in
    for (cell in cells)
    {
      if (!entityIds_cell.exists(cell)) entityIds_cell.set(cell, []);
      ids = entityIds_cell.get(cell);
      ids.push(id);
    }
  }


  // 
  // Internal
  // 


  inline function cellString(xi:Int, yi:Int):String return '$xi|$yi';


  inline function getCell(x:Float, y:Float):String
  {
    var xi, yi;
    xi = Math.floor(x * cellWidthOverOne);
    yi = Math.floor(y * cellHeightOverOne);
    return cellString(xi, yi);
  }


  inline function getCells(bounds:AABB, ?results:Array<String>):Array<String>
  {
    var xx:Float, yy:Float, tlx:Int, tly:Int, brx:Int, bry:Int;
    results = (results != null ? results : []);

    xx = bounds.left;
    yy = bounds.top;

    tlx = Math.floor(xx * cellWidthOverOne);
    tly = Math.floor(yy * cellHeightOverOne);

    xx = bounds.right;
    yy = bounds.bottom;

    brx = Math.floor(xx * cellWidthOverOne);
    bry = Math.floor(yy * cellHeightOverOne);

    for (xi in tlx...brx + 1)
    {
      for (yi in tly...bry + 1)
      {
        results.push(cellString(xi, yi));
      }
    }

    return results;
  }


  inline function removeFromCells( id:Int ):Void
  {
    if (!cells_entityId.exists(id)) return;

    var cells, ids;
    cells = cells_entityId.get(id);
    for (cell in cells)
    {
      if (!entityIds_cell.exists(cell)) entityIds_cell.set(cell, []);
      ids = entityIds_cell.get(cell);
      ids.remove(id);
    }
    cells_entityId.remove(id);
  }


  var entityIds_cell:Map<String, Array<Int>>;
  var cells_entityId:Map<Int, Array<String>>;
  var cellWidthOverOne:Float;
  var cellHeightOverOne:Float;
  var _cellWidth:  Int = 256;
  var _cellHeight: Int = 256;

  inline function get_cellWidth():Int return _cellWidth;
  inline function get_cellHeight():Int return _cellHeight;

}
