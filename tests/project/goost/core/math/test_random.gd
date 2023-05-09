extends "res://addons/gut/test.gd"


func test_create_local_instantiate():
	var rng = Random.new_instance()
	Random.seed = hash("Goost")
	rng.seed = 37
	assert_ne(rng, Random, "The new local instance should not override the global one")
	assert_ne(rng.seed, Random.seed)
	assert_lt(rng.randf(), 1.0)


func test_singleton():
	Random.randomize()
	Random.seed = 37
	for x in 100:
		var f = Random.randf()
		assert_true(f >= 0.0)
		assert_true(f <= 1.0)
	for x in 100:
		var i = Random.randi() % 100
		assert_true(i >= 0)
		assert_true(i <= 99)


func test_range():
	for x in 100:
		var i = Random.range(5, 10)
		assert_typeof(i, TYPE_INT)
		assert_true(i >= 5)
		assert_true(i <= 10)
	for x in 100:
		var f = Random.range(5.0, 10.0)
		assert_typeof(f, TYPE_REAL)
		assert_true(f >= 5.0)
		assert_true(f <= 10.0)
	# Interpolation.
	for x in 100:
		var point = Random.range(Vector2(0, 0), Vector2(100, 0))
		assert_true(point.x >= 0.0)
		assert_true(point.x <= 100.0)


func test_value():
	for x in 100:
		var f = Random.value
		assert_typeof(f, TYPE_REAL)
		assert_true(f >= 0.0)
		assert_true(f <= 1.0)


func test_number():
	for x in 100:
		var i = randi() % 100
		assert_typeof(i, TYPE_INT)
		assert_true(i >= 0)
		assert_true(i <= 99)


func test_color():
	for x in 100:
		var c = Random.color
		assert_typeof(c, TYPE_COLOR)
		assert_true(c.r >= 0.0)
		assert_true(c.r <= 1.0)
		assert_true(c.g >= 0.0)
		assert_true(c.g <= 1.0)
		assert_true(c.b >= 0.0)
		assert_true(c.b <= 1.0)
		assert_true(c.a == 1.0)


func test_color_rgb():
	for x in 100:
		var c = Random.color_rgb()
		assert_typeof(c, TYPE_COLOR)
		assert_true(c.r >= 0.0)
		assert_true(c.r <= 1.0)
		assert_true(c.g >= 0.0)
		assert_true(c.g <= 1.0)
		assert_true(c.b >= 0.0)
		assert_true(c.b <= 1.0)
		assert_true(c.a == 1.0)


func test_color_hsv():
	for x in 100:
		var c = Random.color_hsv()
		assert_typeof(c, TYPE_COLOR)
		assert_true(c.h >= 0.0)
		assert_true(c.h <= 1.0)
		assert_true(c.s >= 0.0)
		assert_true(c.s <= 1.0)
		assert_true(c.v >= 0.0)
		assert_true(c.v <= 1.0)
		assert_true(c.a == 1.0)


func test_condition():
	var false_count = 0
	var true_count = 0
	for x in 100000:
		if Random.condition:
			true_count += 1
		else:
			false_count += 1
	assert_almost_eq(false_count / float(true_count), 1.0, 0.05)


func test_decision_high():
	var hit_count = 0
	for x in 100000:
		if Random.decision(0.7):
			hit_count += 1
	assert_almost_eq(hit_count / 100000.0, 0.7, 0.05)


func test_decision_low():
	var hit_count = 0
	for x in 100000:
		if Random.decision(0.1):
			hit_count += 1
	assert_almost_eq(hit_count / 100000.0, 0.1, 0.05)


func test_randi_range_unbiased():
	var zero_count = 0
	var one_count = 0
	for x in 10000:
		var i = Random.randi_range(0, 1)
		if i == 0:
			zero_count += 1
		if i == 1:
			one_count += 1
	assert_almost_eq(zero_count / float(one_count), 1.0, 0.1)


func test_pick():
	var rng = Random.new_instance()

	rng.seed = 58885
	var element = rng.pick(["Godot", Color.blue, "Goost", Color.red])
	assert_eq(element, "Goost")

	rng.seed = 222
	element = rng.pick("Goost")
	assert_eq(element, "G")

	rng.seed = 335
	element = rng.pick({0 : "Godot", 1 : "Goost", 2 : "Godex"})
	assert_eq(element, "Goost")

	Engine.print_error_messages = false

	assert_null(rng.pick(""))
	assert_null(rng.pick([]))

	Engine.print_error_messages = true


func test_choices():
	var rng = Random.new_instance()

	rng.seed = 58885
	var elements = rng.choices(["Godot", Color.blue, "Goost", Color.red], 4, [1,3,6,9])
	assert_eq(elements, [Color.red, Color.red, "Goost", "Godot"])

	rng.seed = 222
	elements = rng.choices("Goost", 7, [1,14,6,9,5])
	assert_eq(elements, ['G', 'o', 't', 'G', 's', 's', 't'])

	rng.seed = 335
	elements = rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4)
	assert_eq(elements, ['Godex', 'Godot', 'Godex', 'Godex'])

	rng.seed = 335
	elements = rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [])
	assert_eq(elements, ['Godex', 'Godot', 'Godex', 'Godex'])

	rng.seed = 335
	elements = rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, 9, 16])
	assert_eq(elements, ['Godex', 'Godex', 'Godex', 'Godot'])

	rng.seed = 335
	elements = rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [], true)
	assert_eq(elements, ['Godot', 'Goost', 'Godot', 'Goost'])

	rng.seed = 335
	elements = rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, 9, 16], true)
	assert_eq(elements, ['Godex', 'Godot', 'Godot', 'Goost'])

	Engine.print_error_messages = false

	assert_eq(rng.choices(""), Array([]))
	assert_eq(rng.choices([]), Array([]))

	# Unequal sizes.
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, 9, 16, 18], true), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, 9], true), Array([]))
	assert_eq(rng.choices(["Godot", "Goost", "Godex"], 4, [4, 9, 16, 18], true), Array([]))
	assert_eq(rng.choices(["Godot", "Goost", "Godex"], 4, [4, 9], true), Array([]))

	# Decreasing / negative.
	assert_eq(rng.choices({"Godot": 3, "Goost": -8, "Godex": 10}, 4, [], false), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": -8, "Godex": 10}, 4, [], true), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 7}, 4, [], true), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, -9, 16, 18], false), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, -9, 16, 18], true), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [4, 9, 6, 18], true), Array([]))

	# All zero weights.
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [0, 0, 0], true), Array([]))
	assert_eq(rng.choices({"Godot": 3, "Goost": 8, "Godex": 10}, 4, [0, 0, 0], false), Array([]))

	Engine.print_error_messages = true


func test_pop():
	var rng = Random.new_instance()
	rng.seed = 38

	var array = [1, 2, 3, 4]
	var popped = []
	for i in array.size():
		var e = rng.pop(array)
		assert_not_null(e)
		popped.push_back(e)
		assert_eq(array.size() + popped.size(), 4)

	assert_eq(popped[0], 3)
	assert_eq(popped[1], 1)
	assert_eq(popped[2], 4)
	assert_eq(popped[3], 2)
	popped.clear()

	var dictionary = {a = 1, b = 2, c = 3, d = 4}
	for i in 4:
		var e = rng.pop(dictionary)
		assert_not_null(e)
		popped.push_back(e)
		assert_eq(dictionary.size() + popped.size(), 4)

	assert_eq(popped[0], 3)
	assert_eq(popped[1], 2)
	assert_eq(popped[2], 1)
	assert_eq(popped[3], 4)
	popped.clear()

	array.clear()
	for i in 100:
		array.push_back(i)

	while not array.empty():
		var _e = rng.pop(array)

	assert_eq(array.size(), 0)

	Engine.print_error_messages = false

	assert_null(rng.pop([]))
	assert_null(rng.pop({}))

	Engine.print_error_messages = true


func test_shuffle_array():
	var rng = Random.new_instance()

	rng.seed = 100
	var array = [
		"Godot",
		37,
		"Goost",
		Color.red,
		Vector2.UP
	]
	rng.shuffle(array)
	assert_eq(array[0], Color.red)
	assert_eq(array[1], "Godot")
	assert_eq(array[2], "Goost")
	assert_eq(array[3], 37)
	assert_eq(array[4], Vector2.UP)

	rng.shuffle(array)
	assert_eq(array[0], "Goost")
	assert_eq(array[1], Vector2.UP)
	assert_eq(array[2], Color.red)
	assert_eq(array[3], 37)
	assert_eq(array[4], "Godot")
