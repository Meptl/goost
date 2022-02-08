extends "res://addons/gut/test.gd"

var graph: Graph

func before_each():
	graph = Graph.new()


func test_add_vertex():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")

	assert_eq(a.value, "a")
	assert_eq(b.value, "b")


func test_find_vertex():
	for i in 100:
		var _v = graph.add_vertex(str(i))

	var v = graph.find_vertex("50")
	assert_eq(v.value, "50")


func test_add_directed_edge():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")

	var e1 = graph.add_directed_edge(a, b)

	assert_eq(graph.find_edge(a, b), e1)
	assert_null(graph.find_edge(b, a), e1)

	var e2 = graph.add_directed_edge("c", "d")

	assert_eq(graph.find_edge(e2.a, e2.b), e2)
	assert_null(graph.find_edge(e2.b, e2.a), e2)


func test_add_edge():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")

	var e1 = graph.add_edge(a, b)

	assert_eq(graph.find_edge(a, b), e1)
	assert_eq(graph.find_edge(b, a), e1)

	var e2 = graph.add_edge("c", "d")

	assert_eq(graph.find_edge(e2.a, e2.b), e2)
	assert_eq(graph.find_edge(e2.b, e2.a), e2)


func test_neighborhood():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var _e1 = graph.add_edge(a, b)
	var _e2 = graph.add_edge(a, c)
	var _e3 = graph.add_edge(b, c)

	var na = a.get_neighbors()
	var nb = b.get_neighbors()
	var nc = c.get_neighbors()

	assert_eq(a.get_neighbor_count(), 2)
	assert_true(b in na)
	assert_true(c in na)

	assert_eq(b.get_neighbor_count(), 2)
	assert_true(a in nb)
	assert_true(c in nb)

	assert_eq(c.get_neighbor_count(), 2)
	assert_true(a in nc)
	assert_true(b in nc)


func test_neighborhood_directed():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var _e1 = graph.add_edge(a, b)
	var _e2 = graph.add_directed_edge(a, c)

	var na = a.get_neighbors()
	var sa = a.get_successors()
	var pc = c.get_predecessors()

	assert_eq(a.get_neighbor_count(), 2)
	assert_true(b in na)
	assert_true(c in na)

	assert_eq(a.get_successor_count(), 1)
	assert_true(c in sa)

	assert_eq(c.get_predecessor_count(), 1)
	assert_true(a in pc)

	var _e3 = graph.add_directed_edge(c, a)
	var _e4 = graph.add_directed_edge(c, b)
	var sc = c.get_successors()

	assert_eq(sc.size(), 2)
	assert_true(a in sc)
	assert_true(b in sc)


func test_edge_list():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var ab1 = graph.add_edge(a, b)
	var ab2 = graph.add_edge(a, b)
	var ac = graph.add_edge(a, c)
	var bc = graph.add_edge(b, c)

	var edges = graph.get_edge_list(a, b)
	assert_eq(edges.size(), 2)
	assert_true(ab1 in edges)
	assert_true(ab2 in edges)

	edges = graph.get_edge_list()
	assert_eq(edges.size(), 4)
	assert_true(ab1 in edges)
	assert_true(ab2 in edges)
	assert_true(ac in edges)
	assert_true(bc in edges)


func test_remove_vertex_one_to_many():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")
	var d = graph.add_vertex("d")

	var _ab = graph.add_edge(a, b)
	var _ac = graph.add_edge(a, c)
	var _ad = graph.add_edge(a, d)

	assert_eq(graph.get_edge_count(), 3)

	graph.remove_vertex(a)

	assert_eq(graph.get_edge_count(), 0)
	assert_eq(b.get_neighbors().size(), 0)
	assert_eq(c.get_neighbors().size(), 0)
	assert_eq(d.get_neighbors().size(), 0)


func test_remove_vertex_many_to_many():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")
	var d = graph.add_vertex("d")

	var _ab = graph.add_edge(a, b)
	var _ac = graph.add_edge(a, c)
	var _ad = graph.add_edge(a, d)
	var _cb = graph.add_edge(c, b)
	var _cd = graph.add_edge(c, d)
	var _bd = graph.add_edge(b, d)

	assert_eq(graph.get_edge_count(), 6)

	graph.remove_vertex(a)

	assert_eq(graph.get_vertex_count(), 3)

	assert_eq(graph.get_edge_count(), 3)
	assert_eq(c.get_neighbors().size(), 2)
	assert_eq(b.get_neighbors().size(), 2)
	assert_eq(d.get_neighbors().size(), 2)

	graph.remove_vertex(b)

	assert_eq(graph.get_edge_count(), 1)
	assert_eq(c.get_neighbors().size(), 1)
	assert_eq(d.get_neighbors().size(), 1)

	graph.remove_vertex(c)

	assert_eq(graph.get_edge_count(), 0)
	assert_eq(d.get_neighbors().size(), 0)


func test_clear_edges():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var _ab = graph.add_edge(a, b)
	var _ac = graph.add_edge(a, c)
	var _bc = graph.add_edge(b, c)

	assert_eq(graph.get_vertex_count(), 3)
	assert_eq(graph.get_edge_count(), 3)
	assert_eq(a.get_neighbors().size(), 2)
	assert_eq(b.get_neighbors().size(), 2)
	assert_eq(c.get_neighbors().size(), 2)

	graph.clear_edges()

	assert_eq(graph.get_vertex_count(), 3)
	assert_eq(graph.get_edge_count(), 0)
	assert_eq(a.get_neighbors().size(), 0)
	assert_eq(b.get_neighbors().size(), 0)
	assert_eq(c.get_neighbors().size(), 0)


func test_has_edge():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var _ab = graph.add_edge(a, b)
	var _ac = graph.add_edge(a, c)

	assert_true(graph.has_edge(a, b))
	assert_true(graph.has_edge(a, c))
	assert_true(graph.has_edge(b, a))
	assert_false(graph.has_edge(b, c))
	assert_false(graph.has_edge(c, b))


func test_remove_edge():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var ab = graph.add_edge(a, b)
	var ac = graph.add_edge(a, c)
	var bc = graph.add_edge(b, c)

	assert_eq(graph.get_edge_count(), 3)

	graph.remove_edge(ab)
	assert_eq(graph.get_edge_count(), 2)

	graph.remove_edge(ac)
	assert_eq(graph.get_edge_count(), 1)

	graph.remove_edge(bc)
	assert_eq(graph.get_edge_count(), 0)

	assert_eq(graph.get_vertex_count(), 3)


func test_self_loop():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")

	var _e1 = graph.add_edge(a, a)
	var _e2 = graph.add_edge(b, a)

	assert_eq(a.get_neighbors()[0], a)

	graph.remove_vertex(a)
	graph.remove_vertex(b)
	# Should not crash...


func test_connected_component_tree():
	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")
	var d = graph.add_vertex("d")
	var e = graph.add_vertex("e")

	var _ab = graph.add_edge(a, b)
	var _bc = graph.add_edge(b, c)
	var _bd = graph.add_edge(b, d)
	var ae = graph.add_edge(a, e)

	var abcde = graph.find_connected_component(a)
	assert_eq(abcde.size(), 5)
	assert_true(a in abcde)
	assert_true(b in abcde)
	assert_true(c in abcde)
	assert_true(d in abcde)
	assert_true(e in abcde)

	assert_true(graph.is_strongly_connected())

	graph.remove_edge(ae)

	assert_false(graph.is_strongly_connected())


func test_connected_component_cycle():
	var V = []
	for i in 4:
		V.push_back(graph.add_vertex(i))

	var _e = null
	_e = graph.add_edge(V[0], V[1])
	_e = graph.add_edge(V[0], V[2])
	_e = graph.add_edge(V[0], V[3])
	_e = graph.add_edge(V[1], V[2])
	_e = graph.add_edge(V[1], V[3])
	_e = graph.add_edge(V[2], V[3])

	var component = graph.find_connected_component(V[0])
	assert_eq(component.size(), 4)
	assert_true(V[0] in component)
	assert_true(V[1] in component)
	assert_true(V[2] in component)
	assert_true(V[3] in component)


func test_get_connected_components():
	var V = []
	for i in 10:
		V.push_back(graph.add_vertex(i))

	var _e = null
	_e = graph.add_edge(V[0], V[1])
	_e = graph.add_edge(V[0], V[2])
	_e = graph.add_edge(V[3], V[4])
	_e = graph.add_edge(V[6], V[7])
	_e = graph.add_edge(V[6], V[8])
	_e = graph.add_edge(V[7], V[8])
	_e = graph.add_edge(V[8], V[9])
	_e = graph.add_edge(V[7], V[9])

	var roots = graph.get_connected_components()
	assert_eq(roots.size(), 4)
	
	for r in roots:
		var members = roots[r]
		assert_true(r in members, "Representative vertex should be a member")

	for r in roots:
		var members = graph.find_connected_component(r)
		assert_lt(members.size(), 5)
		match members.size():
			1:
				assert_eq(members[0], V[5])
			2:
				assert_true(V[3] in members)
				assert_true(V[4] in members)
			3:
				assert_true(V[0] in members)
				assert_true(V[1] in members)
				assert_true(V[2] in members)
			4:
				assert_true(V[6] in members)
				assert_true(V[7] in members)
				assert_true(V[8] in members)
				assert_true(V[9] in members)


class GraphIteratorCustom extends GraphIterator:
	var v: GraphVertex
	var count

	func initialize(root):
		v = root
		count = 0

	func has_next():
		count += 1
		return count < 5

	func next():
		var n = v
		v = v.get_successors()[0]
		return n


func test_iterator():
	var it = graph.iterator
	assert(it is GraphIterator)

	graph.iterator = GraphIteratorCustom.new()

	var a = graph.add_vertex("a")
	var b = graph.add_vertex("b")
	var c = graph.add_vertex("c")

	var _ab = graph.add_directed_edge(a, b)
	var _bc = graph.add_directed_edge(b, c)
	var _ca = graph.add_directed_edge(c, a)

	var component = graph.find_connected_component(a)
	assert_eq(component.size(), 4)
	assert_eq(component[0], a)
	assert_eq(component[1], b)
	assert_eq(component[2], c)
	assert_eq(component[3], a)

	var V = graph.iterator
	V.initialize(a)

	var steps = 0
	while V.has_next():
		var _n = V.next()
		steps += 1
	assert_eq(steps, 4)


class _TestPerformance extends "res://addons/gut/test.gd":

	func test_add_remove_dense():
		var graph = Graph.new()
		var rng = RandomNumberGenerator.new()
		rng.seed = 480789

		var count = 10

		var t1 = OS.get_ticks_msec()
		for i in count:
			var _v = graph.add_vertex(i)

		var vertices = graph.get_vertex_list()

		for i in 1000000:
			var ui = rng.randi() % count
			var vi = rng.randi() % count
			var _e = graph.add_edge(vertices[ui], vertices[vi])

		for i in count:
			var v = vertices[i]
			graph.remove_vertex(v)

		var t2 = OS.get_ticks_msec()
		gut.p(t2 - t1)


	func test_dfs():
		var graph = Graph.new()
		var rng = RandomNumberGenerator.new()
		rng.seed = 480789

		var count = 100000

		for i in count:
			var _v = graph.add_vertex(i)

		var vertices = graph.get_vertex_list()

		for i in count:
			var ui = rng.randi() % count
			var vi = rng.randi() % count
			var _e = graph.add_edge(vertices[ui], vertices[vi])

		var t1 = OS.get_ticks_msec()

		var component = graph.find_connected_component(vertices[0])
		assert_eq(component.size(), 79500)

		var t2 = OS.get_ticks_msec()
		gut.p(t2 - t1)
