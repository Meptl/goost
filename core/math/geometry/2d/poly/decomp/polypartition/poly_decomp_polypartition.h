#pragma once

#include "../poly_decomp.h"
#include "core/object/ref_counted.h"

class PolyDecompParameters2D;

class PolyDecomp2DPolyPartition : public PolyDecomp2DBackend {
public:
	virtual Vector<Vector<Point2>> triangulate_ec(const Vector<Vector<Point2>> &p_polygons);
	virtual Vector<Vector<Point2>> triangulate_opt(const Vector<Vector<Point2>> &p_polygons);
	virtual Vector<Vector<Point2>> triangulate_mono(const Vector<Vector<Point2>> &p_polygons);
	virtual Vector<Vector<Point2>> decompose_convex_hm(const Vector<Vector<Point2>> &p_polygons);
	virtual Vector<Vector<Point2>> decompose_convex_opt(const Vector<Vector<Point2>> &p_polygons);
};

