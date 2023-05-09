#pragma once

#include "goost/core/math/random.h"

class Random2D : public Random {
	GDCLASS(Random2D, Random);

private:
	static Random2D *singleton;

protected:
	static void _bind_methods();

public:
	static Random2D *get_singleton() { return singleton; }
	virtual Ref<RefCounted> new_instance() const { return memnew(Random2D); }

	real_t get_rotation();
	Vector2 get_direction(); // Unit vector.

	Vector2 point_in_region(const Rect2 &p_region);
	Vector2 point_in_circle(real_t p_min_radius = 0.0, real_t p_max_radius = 1.0);
	Vector2 point_in_triangle(const Vector<Point2> &p_triangle);
	Variant point_in_polygon(const Variant &p_polygon, int p_point_count = 1);

	Random2D() {
		if (!singleton) {
			randomize(); // Only the global one is randomized automatically.
			singleton = this;
		}
	}
};

