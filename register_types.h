#pragma once

#include "modules/register_module_types.h"

// Do not include `goost.h` here.
//
// This may lead to clashes with Godot's namespace, or produce include errors
// when `module_goost_enabled=no` is specified via command-line.

void initialize_goost_module(ModuleInitializationLevel p_level);
void uninitialize_goost_module(ModuleInitializationLevel p_level);

