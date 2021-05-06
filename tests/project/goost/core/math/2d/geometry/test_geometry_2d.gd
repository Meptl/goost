extends "res://addons/gut/test.gd"

var testbed

const SIZE = 50.0

var poly_base = PoolVector2Array([Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)])
var poly_a = Transform2D(0, Vector2.ONE).scaled(Vector2.ONE * SIZE).xform(poly_base)
var poly_b = Transform2D(0, Vector2.ONE * SIZE).xform(poly_a)
var poly_boundary = GoostGeometry2D.regular_polygon(8, SIZE * 2)

var solution = []


func before_each():
	testbed = preload("geometry_2d_testbed.tscn").instance()
	add_child_autofree(testbed)


func after_each():
	testbed.solution = solution
	testbed.test = gut._current_test.name
	testbed.update()


func test_merge_polygons():
	solution = GoostGeometry2D.merge_polygons(poly_a, poly_b)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 8)


func test_clip_polygons():
	solution = GoostGeometry2D.clip_polygons(poly_a, poly_b)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 6)


func test_intersect_polygons():
	solution = GoostGeometry2D.intersect_polygons(poly_a, poly_b)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 4)


func test_exclude_polygons():
	solution = GoostGeometry2D.exclude_polygons(poly_a, poly_b)
	assert_eq(solution.size(), 2)
	assert_eq(solution[0].size(), 6)
	assert_eq(solution[1].size(), 6)


func test_clip_polyline_with_polygon():
	solution = GoostGeometry2D.clip_polyline_with_polygon(poly_a, poly_b)
	assert_eq(solution.size(), 2)
	assert_eq(solution[0].size(), 2)
	assert_eq(solution[1].size(), 3)


func test_intersect_polyline_with_polygon():
	solution = GoostGeometry2D.intersect_polyline_with_polygon(poly_a, poly_b)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 3)


func test_inflate_polygon():
	solution = GoostGeometry2D.inflate_polygon(poly_a, SIZE / 2.0)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 4)


func test_deflate_polygon():
	solution = GoostGeometry2D.deflate_polygon(poly_a, SIZE / 2.0)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 8)


func test_deflate_polyline():
	solution = GoostGeometry2D.deflate_polyline(poly_a, SIZE / 2.0)
	assert_eq(solution.size(), 1)
	assert_eq(solution[0].size(), 10)


func test_triangulate_polygon():
	solution = GoostGeometry2D.triangulate_polygon(poly_boundary)
	assert_eq(solution.size(), 6)
	assert_eq(solution[0].size(), 3)
	assert_eq(solution[1].size(), 3)
	assert_eq(solution[2].size(), 3)
	assert_eq(solution[3].size(), 3)
	assert_eq(solution[4].size(), 3)
	assert_eq(solution[5].size(), 3)


func test_decompose_polygon():
	solution = GoostGeometry2D.decompose_polygon(poly_boundary)
	assert_eq(solution.size(), 1)


func test_polygon_centroid():
	solution = GoostGeometry2D.polygon_centroid(poly_a)
	assert_eq(solution, Vector2(50, 50))


func test_polygon_perimeter():
	solution = GoostGeometry2D.polygon_perimeter(poly_a)
	assert_eq(solution, 400.0)


func test_polyline_length():
	solution = GoostGeometry2D.polyline_length(poly_a)
	assert_eq(solution, 300.0)


func test_point_in_polygon():
	solution = GoostGeometry2D.point_in_polygon(Vector2(50, 50), poly_a)
	assert_eq(solution, 1) # inside
	solution = GoostGeometry2D.point_in_polygon(Vector2(-50, 50), poly_a)
	assert_eq(solution, 0) # outside
	solution = GoostGeometry2D.point_in_polygon(Vector2(0, 50), poly_a)
	assert_eq(solution, -1) # exactly


func test_regular_polygon():
	solution = GoostGeometry2D.regular_polygon(64, SIZE)
	assert_eq(solution.size(), 64)


func test_circle():
	solution = GoostGeometry2D.circle(SIZE, 0.25)
	assert_eq(solution.size(), 32)


func test_bresenham_line():
	var line = GoostGeometry2D.bresenham_line(Vector2(0, 0), Vector2(5, 0))
	assert_eq(line.size(), 6)
	for x in 6:
		assert_eq(line[x], Vector2(x, 0))

	line = GoostGeometry2D.bresenham_line(Vector2(0, 0), Vector2(-10, 0))
	assert_eq(line.size(), 11)
	for x in 11:
		assert_eq(line[x], Vector2(-x, 0))

	line = GoostGeometry2D.bresenham_line(Vector2(0, 0), Vector2(0, 5))
	assert_eq(line.size(), 6)
	for x in 6:
		assert_eq(line[x], Vector2(0, x))

	line = GoostGeometry2D.bresenham_line(Vector2(0, 0), Vector2(0, -10))
	assert_eq(line.size(), 11)
	for x in 11:
		assert_eq(line[x], Vector2(0, -x))

	line = GoostGeometry2D.bresenham_line(Vector2(-5, -5), Vector2(5, 5))
	assert_eq(line.size(), 11)
	assert_eq(line[0], Vector2(-5, -5))
	assert_eq(line[5], Vector2(0, 0))
	assert_eq(line[10], Vector2(5, 5))

	line = GoostGeometry2D.bresenham_line(Vector2(5, -5), Vector2(-5, 5))
	assert_eq(line.size(), 11)
	assert_eq(line[0], Vector2(5, -5))
	assert_eq(line[5], Vector2(0, 0))
	assert_eq(line[10], Vector2(-5, 5))

	line = GoostGeometry2D.bresenham_line(Vector2(5, -5), Vector2(-5, 5))
	assert_eq(line.size(), 11)
	assert_eq(line[0], Vector2(5, -5))
	assert_eq(line[5], Vector2(0, 0))
	assert_eq(line[10], Vector2(-5, 5))

	line = GoostGeometry2D.bresenham_line(Vector2(-5, -5), Vector2(10, 3))
	assert_eq(line[0], Vector2(-5, -5))
	assert_eq(line[1], Vector2(-4, -4))
	assert_eq(line[2], Vector2(-3, -4))
	assert_eq(line[3], Vector2(-2, -3))
	assert_eq(line[4], Vector2(-1, -3))
	assert_eq(line[5], Vector2(0, -2))
	assert_eq(line[6], Vector2(1, -2))
	assert_eq(line[7], Vector2(2, -1))
	assert_eq(line[8], Vector2(3, -1))
	assert_eq(line[9], Vector2(4, 0))
	assert_eq(line[10], Vector2(5, 0))
	assert_eq(line[11], Vector2(6, 1))
	assert_eq(line[12], Vector2(7, 1))
	assert_eq(line[13], Vector2(8, 2))
	assert_eq(line[14], Vector2(9, 2))
	assert_eq(line[15], Vector2(10, 3))


func test_simplify_polyline():
	var input = [Vector2(20, 51), Vector2(32, 13), Vector2(34, 13), Vector2(37, 13), Vector2(40, 18), Vector2(47, 46)]
	var control = [Vector2(20, 51), Vector2(32, 13), Vector2(40, 18), Vector2(47, 46)]
	var simplified = GoostGeometry2D.simplify_polyline(input, 10.0)

	if simplified.size() != control.size():
		assert_eq(simplified.size(), control.size(), "Point count mismatch")
		return
	for i in simplified.size():
		assert_eq(simplified[i], control[i])


func test_smooth_polygon_approx():
	var input = [Vector2(25, 83), Vector2(49, 16), Vector2(66, 79)]
	var control = [Vector2(31, 66.25), Vector2(43, 32.75), Vector2(53.25, 31.75), Vector2(61.75, 63.25), Vector2(55.75, 80), Vector2(35.25, 82)]
	var smoothed = GoostGeometry2D.smooth_polygon_approx(input)
	
	if smoothed.size() != control.size():
		assert_eq(smoothed.size(), control.size(), "Point count mismatch")
		return
	for i in smoothed.size():
		assert_eq(smoothed[i], control[i])


func test_smooth_polyline_approx():
	var input = [Vector2(25, 83), Vector2(49, 16), Vector2(66, 79)]
	var control = [Vector2(25, 83), Vector2(31, 66.25), Vector2(43, 32.75), Vector2(53.25, 31.75), Vector2(61.75, 63.25), Vector2(66, 79)]
	var smoothed = GoostGeometry2D.smooth_polyline_approx(input)
	
	if smoothed.size() != control.size():
		assert_eq(smoothed.size(), control.size(), "Point count mismatch")
		return

	# Always includes first and last points from input polyline.
	assert_eq(smoothed[0], input[0])
	assert_eq(smoothed[smoothed.size() - 1], input[input.size() - 1])

	for i in smoothed.size():
		assert_eq(smoothed[i], control[i])
