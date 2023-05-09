#include "goost_math.h"

GoostMath *GoostMath::singleton = nullptr;

bool GoostMath::is_equal_approx(real_t a, real_t b, real_t tolerance) {
	// Check for exact equality first, required to handle "infinity" values.
	if (a == b) {
		return true;
	}
	// Then check for approximate equality.
	return abs(a - b) < tolerance;
}

bool GoostMath::is_zero_approx(real_t s, real_t tolerance) {
	return abs(s) < tolerance;
}

bool GoostMath::is_between(real_t s, real_t a, real_t b) {
	if (a > b) {
		SWAP(a, b);
	}
	return s >= a && s <= b;
}

bool GoostMath::is_in_range(real_t s, real_t min, real_t max) {
	ERR_FAIL_COND_V_MSG(min > max, false, "Invalid range");
	return s >= min && s <= max;
}

real_t GoostMath::log(real_t x, real_t base) {
	if (base == 1.0) {
		return NAN;
	}
	if (x != 1.0 && (base == 0.0 || Math::is_inf(base))) {
		return NAN;
	}
	return Math::log(x) / Math::log(base);
}

Variant GoostMath::catmull_rom(const Variant &p0, const Variant &p1, const Variant &p2, const Variant &p3, float t) {
#ifdef DEBUG_ENABLED
	ERR_FAIL_COND_V(t < 0.0f, Variant());
	ERR_FAIL_COND_V(t > 1.0f, Variant());
#endif
	switch (p0.get_type()) {
		case Variant::INT:
		case Variant::FLOAT: {
			return goost::math::catmull_rom(p0.operator real_t(), p1.operator real_t(), p2.operator real_t(), p3.operator real_t(), t);
		} break;
		case Variant::VECTOR2: {
			return goost::math::catmull_rom(p0.operator Vector2(), p1.operator Vector2(), p2.operator Vector2(), p3.operator Vector2(), t);
		} break;
		case Variant::VECTOR3: {
			return goost::math::catmull_rom(p0.operator Vector3(), p1.operator Vector3(), p2.operator Vector3(), p3.operator Vector3(), t);
		} break;
		default: {
			ERR_FAIL_V_MSG(Variant(), "Unsupported types.");
		}
	}
	return Variant();
}

Variant GoostMath::bezier(const Variant &p0, const Variant &p1, const Variant &p2, const Variant &p3, float t) {
#ifdef DEBUG_ENABLED
	ERR_FAIL_COND_V(t < 0.0f, Variant());
	ERR_FAIL_COND_V(t > 1.0f, Variant());
#endif
	switch (p0.get_type()) {
		case Variant::INT:
		case Variant::FLOAT: {
			return goost::math::bezier(p0.operator real_t(), p1.operator real_t(), p2.operator real_t(), p3.operator real_t(), t);
		} break;
		case Variant::VECTOR2: {
			return goost::math::bezier(p0.operator Vector2(), p1.operator Vector2(), p2.operator Vector2(), p3.operator Vector2(), t);
		} break;
		case Variant::VECTOR3: {
			return goost::math::bezier(p0.operator Vector3(), p1.operator Vector3(), p2.operator Vector3(), p3.operator Vector3(), t);
		} break;
		default: {
			ERR_FAIL_V_MSG(Variant(), "Unsupported types.");
		}
	}
	return Variant();
}

void GoostMath::_bind_methods() {
	ClassDB::bind_method(D_METHOD("is_equal_approx", "a", "b", "tolerance"), &GoostMath::is_equal_approx, DEFVAL(GOOST_CMP_EPSILON));
	ClassDB::bind_method(D_METHOD("is_zero_approx", "s", "tolerance"), &GoostMath::is_zero_approx, DEFVAL(GOOST_CMP_EPSILON));

	ClassDB::bind_method(D_METHOD("is_between", "s", "a", "b"), &GoostMath::is_between);
	ClassDB::bind_method(D_METHOD("is_in_range", "s", "min", "max"), &GoostMath::is_in_range);

	ClassDB::bind_method(D_METHOD("log", "x", "base"), &GoostMath::log, DEFVAL(Math_E));
	ClassDB::bind_method(D_METHOD("log2", "x"), &GoostMath::log2);
	ClassDB::bind_method(D_METHOD("log10", "x"), &GoostMath::log10);

	ClassDB::bind_method(D_METHOD("catmull_rom", "ac", "a", "b", "bc", "weight"), &GoostMath::catmull_rom);
	ClassDB::bind_method(D_METHOD("bezier", "a", "ac", "bc", "b", "weight"), &GoostMath::bezier);
}
