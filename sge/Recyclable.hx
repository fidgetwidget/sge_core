package sge; 

@:generic
interface Recyclable<T> 
{

  // Resetting the item to it's defaults
  public function clear():T;

}
