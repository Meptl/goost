extends "res://addons/gut/test.gd"

var list: LinkedList


func before_each():
	list = LinkedList.new()


func populate_test_data(p_list: LinkedList):
	var nodes = []
	nodes.append(p_list.push_back("Goost"))
	nodes.append(p_list.push_back(37))
	nodes.append(p_list.push_back(Vector2.ONE))
	nodes.append(p_list.push_back(Color.blue))
	return nodes


func populate_test_data_integers(p_list: LinkedList, p_num_nodes: int):
	var nodes = []
	for i in p_num_nodes:
		nodes.append(p_list.push_back(i))
	return nodes


func test_push_pop_back():
	# Push back
	var n: ListNode
	n = list.push_back("Goost")
	assert_eq(n.value, "Goost")
	n = list.push_back(37)
	assert_eq(n.value, 37)
	n = list.push_back(Color.blue)
	assert_eq(n.value, Color.blue)

	# Pop back
	var v = null
	v = list.back.value
	list.pop_back()
	assert_eq(v, Color.blue)
	v = list.back.value
	list.pop_back()
	assert_eq(v, 37)
	v = list.back.value
	list.pop_back()
	assert_eq(v, "Goost")

	assert_null(list.back)
	assert_null(list.front)


func test_push_pop_front():
	# Push front
	var n: ListNode
	n = list.push_front("Goost")
	assert_eq(n.value, "Goost")
	n = list.push_front(37)
	assert_eq(n.value, 37)
	n = list.push_front(Color.blue)
	assert_eq(n.value, Color.blue)

	# Pop front
	var v = null
	v = list.front.value
	list.pop_front()
	assert_eq(v, Color.blue)
	v = list.front.value
	list.pop_front()
	assert_eq(v, 37)
	v = list.front.value
	list.pop_front()
	assert_eq(v, "Goost")

	assert_null(list.back)
	assert_null(list.front)


func test_get_nodes():
	var test_nodes = populate_test_data(list)
	for node in list.get_nodes():
		gut.p(node)
	var nodes = list.get_nodes()
	assert_eq(nodes[0], test_nodes[0])
	assert_eq(nodes[1], test_nodes[1])
	assert_eq(nodes[2], test_nodes[2])
	assert_eq(nodes[3], test_nodes[3])


func test_get_elements():
	# Alias for `get_nodes`.
	var test_nodes = populate_test_data(list)
	for node in list.get_elements():
		gut.p(node)
	var nodes = list.get_elements()
	assert_eq(nodes[0], test_nodes[0])
	assert_eq(nodes[1], test_nodes[1])
	assert_eq(nodes[2], test_nodes[2])
	assert_eq(nodes[3], test_nodes[3])


func test_insert_before():
	var nodes = populate_test_data(list)
	var n = list.insert_before(nodes[2], "Godot")
	assert_eq(n.value, "Godot")
	assert_eq(list.front.next.next.value, "Godot")
	assert_eq(list.back.prev.prev.value, "Godot")


func test_insert_before_front():
	var _nodes = populate_test_data(list)
	var n = list.insert_before(list.front, "Godot")
	assert_eq(n.value, "Godot")
	assert_eq(list.front.value, "Godot")


func test_insert_after():
	var nodes = populate_test_data(list)
	var n = list.insert_after(nodes[2], "Godot")
	assert_eq(n.value, "Godot")
	assert_eq(list.front.next.next.next.value, "Godot")
	assert_eq(list.back.prev.value, "Godot")


func test_insert_after_back():
	var _nodes = populate_test_data(list)
	var n = list.insert_after(list.back, "Godot")
	assert_eq(n.value, "Godot")
	assert_eq(list.back.value, "Godot")


func test_size():
	var nodes = populate_test_data(list)
	var original_size = nodes.size()
	assert_eq(list.size(), original_size)


func test_front():
	populate_test_data(list)
	assert_eq(list.front.value, "Goost")


func test_back():
	populate_test_data(list)
	assert_eq(list.back.value, Color.blue)


func test_find():
	populate_test_data(list)
	assert_eq(list.find("Goost").value, "Goost")


func test_erase():
	var nodes = populate_test_data(list)
	var original_size = nodes.size()
	var erased = list.erase(Color.blue)
	assert_true(erased)
	assert_eq(list.size(), original_size - 1)
	erased = list.erase("does not exist")
	assert_false(erased)


func test_remove():
	var nodes = populate_test_data(list)
	var original_size = nodes.size()
	var removed = list.remove(list.find("Goost"))
	assert_true(removed)
	assert_eq(list.size(), original_size - 1)
	assert_null(list.find("Goost"))


func test_empty():
	populate_test_data(list)
	var n: ListNode = list.front
	while n:
		var removed = list.remove(n)
		assert_true(removed)
		n = list.front
	assert_eq(list.size(), 0)


func test_clear():
	populate_test_data(list)
	list.clear()
	assert_eq(list.size(), 0)
	assert_null(list.find("Goost"))
	assert_null(list.find(37))
	assert_null(list.find(Color.blue))


func test_next():
	populate_test_data(list)
	var n = list.front
	assert_eq(n.value, "Goost")
	n = n.next
	assert_eq(n.value, 37)


func test_prev():
	populate_test_data(list)
	var n = list.back
	assert_eq(n.value, Color.blue)
	n = n.prev
	assert_eq(n.value, Vector2.ONE)


func test_swap_adjacent_front_and_back():
	var nodes = populate_test_data_integers(list, 2)
	list.swap(nodes[0], nodes[1])

	assert_null(list.front.prev)
	assert_ne(list.front, list.front.next)

	assert_eq(list.front, nodes[1])
	assert_eq(list.back, nodes[0])

	assert_null(list.back.next)
	assert_ne(list.back, list.back.prev)


func test_swap_0_1__first_adjacent_pair():
	var nodes = populate_test_data_integers(list, 4)
	list.swap(nodes[0], nodes[1])

	assert_null(list.front.prev)
	assert_ne(list.front, list.front.next)

	assert_eq(list.front, nodes[1])
	assert_eq(list.front.next, nodes[0])
	assert_eq(list.back.prev, nodes[2])
	assert_eq(list.back, nodes[3])

	assert_null(list.back.next)
	assert_ne(list.back, list.back.prev)


func test_swap_1_2__middle_adjacent_pair():
	var nodes = populate_test_data_integers(list, 4)
	list.swap(nodes[1], nodes[2])

	assert_null(list.front.prev)

	assert_eq(list.front, nodes[0])
	assert_eq(list.front.next, nodes[2])
	assert_eq(list.back.prev, nodes[1])
	assert_eq(list.back, nodes[3])

	assert_null(list.back.next)


func test_swap_2_3__last_adjacent_pair():
	var nodes = populate_test_data_integers(list, 4)
	list.swap(nodes[2], nodes[3])

	assert_null(list.front.prev)

	assert_eq(list.front, nodes[0])
	assert_eq(list.front.next, nodes[1])
	assert_eq(list.back.prev, nodes[3])
	assert_eq(list.back, nodes[2])

	assert_null(list.back.next)


func test_swap_0_2__first_cross_pair():
	var nodes = populate_test_data_integers(list, 4)
	list.swap(nodes[0], nodes[2])

	assert_null(list.front.prev)

	assert_eq(list.front, nodes[2])
	assert_eq(list.front.next, nodes[1])
	assert_eq(list.back.prev, nodes[0])
	assert_eq(list.back, nodes[3])

	assert_null(list.back.next)


func test_swap_1_3__last_cross_pair():
	var nodes = populate_test_data_integers(list, 4)
	list.swap(nodes[1], nodes[3])

	assert_null(list.front.prev)

	assert_eq(list.front, nodes[0])
	assert_eq(list.front.next, nodes[3])
	assert_eq(list.back.prev, nodes[2])
	assert_eq(list.back, nodes[1])

	assert_null(list.back.next)


func test_swap_0_3__front_and_back():
	var nodes = populate_test_data_integers(list, 4)
	list.swap(nodes[0], nodes[3])

	assert_null(list.front.prev)

	assert_eq(list.front, nodes[3])
	assert_eq(list.front.next, nodes[1])
	assert_eq(list.back.prev, nodes[2])
	assert_eq(list.back, nodes[0])

	assert_null(list.back.next)


func test_swap_adjacent_front_back_reverse():
	var nodes = populate_test_data_integers(list, 2)
	list.swap(nodes[1], nodes[0])
	var it = list.front
	while it:
		var prev_it = it
		it = it.next
		if it == prev_it:
			assert_true(false, "Infinite loop detected.")
			break


func test_swap_adjacent_middle_reverse():
	var nodes = populate_test_data_integers(list, 10)
	list.swap(nodes[5], nodes[4])
	var it = list.front
	while it:
		var prev_it = it
		it = it.next
		if it == prev_it:
			assert_true(false, "Infinite loop detected.")
			break


func test_swap_random():
	var size = 100
	var nodes = populate_test_data_integers(list, size)
	assert_eq(nodes.size(), size)
	seed(0)
	for _i in 1000:
		var a = nodes[randi() % size]
		var b = nodes[randi() % size]
		var va = a.value
		var vb = b.value
		list.swap(a, b)

		var num_nodes = 0

		# Fully traversable after swap?
		var it = list.front
		while it:
			num_nodes += 1
			var prev_it = it
			it = it.next
			if it == prev_it:
				assert_true(false, "Infinite loop detected.")
				break

		# Even if traversed,
		# we should not lose anything in the process.
		if num_nodes != size:
			assert_true(false, "Node count mismatch.")
			break

		assert_eq(va, a.value)
		assert_eq(vb, b.value)


func test_swap_front_and_back_2_nodes():
	var a = list.push_back("Goost")
	var b = list.push_back(Color.blue)

	list.swap(a, b)

	assert_eq(list.front.value, Color.blue)
	assert_eq(list.back.value, "Goost")


func test_swap_front_and_back_3_nodes():
	var a = list.push_back("Goost")
	var _b = list.push_back(37)
	var c = list.push_back(Vector2.ONE)

	list.swap(a, c)

	assert_eq(list.front.value, Vector2.ONE)
	assert_eq(list.back.value, "Goost")


func test_swap_front_and_back_4_nodes():
	var a = list.push_back("Goost")
	var _b = list.push_back(37)
	var _c = list.push_back(Vector2.ONE)
	var d = list.push_back(Color.blue)

	list.swap(a, d)

	assert_eq(list.front.value, Color.blue)
	assert_eq(list.back.value, "Goost")


func test_swap_self():
	var a = list.push_back("Goost")
	list.swap(a, a)
	assert_eq(list.front.value, "Goost")
	assert_eq(list.back.value, "Goost")


func test_invert():
	populate_test_data(list)
	list.invert()
	assert_eq(list.front.value, Color.blue)
	assert_eq(list.front.next.value, Vector2.ONE)
	assert_eq(list.back.prev.value, 37)
	assert_eq(list.back.value, "Goost")


func test_move_to_front():
	var nodes = populate_test_data(list)
	list.move_to_front(nodes[2])
	assert_eq(list.front.value, Vector2.ONE)


func test_move_to_back():
	var nodes = populate_test_data(list)
	list.move_to_back(nodes[0])
	assert_eq(list.back.value, "Goost")


func test_move_before():
	var nodes = populate_test_data(list)
	assert_eq(nodes[3].value, Color.blue)
	list.move_before(nodes[3], nodes[1])
	assert_eq(list.front.next.value, nodes[3].value)


func test_custom_iterators():
	populate_test_data(list)
	for node in list:
		gut.p(node)


func tets_sort():
	var n: ListNode
	n = list.push_back("B")
	assert_eq(n.value, "B")
	n = list.push_back("D")
	assert_eq(n.value, "D")
	n = list.push_back("A")
	assert_eq(n.value, "A")
	n = list.push_back("C")
	assert_eq(n.value, "C")

	list.sort()

	assert_eq(list.front.value, "A")
	assert_eq(list.front.next.value, "B")
	assert_eq(list.back.prev.value, "C")
	assert_eq(list.back.value, "D")

	var abcd = ["A", "B", "C", "D"]
	var abcd_list = list.get_nodes()

	for i in 4:
		gut.p(abcd_list[i])
		assert_eq(abcd[i], abcd_list[i])


func test_print_list_node():
	var node = list.push_back("Goost")
	gut.p(node)


func test_print_list():
	populate_test_data(list)
	gut.p(list)


func test_cleanup():
	assert_eq(list.size(), 0)
	var n = list.push_back("Goost")
	assert_eq(list.size(), 1)
	assert_not_null(n)
	list = null
	assert_null(n)
