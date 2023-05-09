#include "register_physics_types.h"

#include "goost/classes_enabled.gen.h"

namespace goost {

void register_physics_types() {
#if defined(GOOST_GEOMETRY_ENABLED) && defined(GOOST_PolyNode2D) && defined(GOOST_PolyShape2D)
	ClassDB::register_class<PolyCollisionShape2D>();
#endif
}

void unregister_physics_types() {
	// Nothing to do.
}

} // namespace goost
