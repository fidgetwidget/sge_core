import massive.munit.TestSuite;

import sge.GameTest;
import sge.shapes.CircleTest;
import sge.shapes.PathTest;
import sge.shapes.PolygonTest;
import sge.shapes.RayTest;
import sge.shapes.ShapeTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(sge.GameTest);
		add(sge.shapes.CircleTest);
		add(sge.shapes.PathTest);
		add(sge.shapes.PolygonTest);
		add(sge.shapes.RayTest);
		add(sge.shapes.ShapeTest);
	}
}
