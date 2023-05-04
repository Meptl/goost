#include "register_types.h"


#include "core/register_core_types.h"
#include "editor/register_editor_types.h"
#include "scene/register_scene_types.h"

void initialize_goost_module(ModuleInitializationLevel p_level) {
#ifdef GOOST_CORE_ENABLED
	if (p_level == MODULE_INITIALIZATION_LEVEL_CORE) {
		goost::register_core_types();
	}
#endif
#ifdef GOOST_SCENE_ENABLED
	if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
		goost::register_scene_types();
	}
#endif
#if defined(TOOLS_ENABLED) && defined(GOOST_EDITOR_ENABLED)
	if (p_level == MODULE_INITIALIZATION_LEVEL_EDITOR) {
		goost::register_editor_types();
	}
#endif
}

void uninitialize_goost_module(ModuleInitializationLevel p_level) {
#ifdef GOOST_CORE_ENABLED
	if (p_level == MODULE_INITIALIZATION_LEVEL_CORE) {
		goost::unregister_core_types();
	}
#endif
#ifdef GOOST_SCENE_ENABLED
	if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
		goost::unregister_scene_types();
	}
#endif
}
