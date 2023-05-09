#include "goost_engine.h"

#include "core/color_names.inc"
#include "core/os/os.h"

#include "authors.gen.h"
#include "license.gen.h"
#include "version.gen.h"

GoostEngine *GoostEngine::singleton = nullptr;

Dictionary GoostEngine::get_version_info() const {
	Dictionary dict;
	dict["major"] = GOOST_VERSION_MAJOR;
	dict["minor"] = GOOST_VERSION_MINOR;
	dict["patch"] = GOOST_VERSION_PATCH;
	dict["hex"] = 0x10000 * GOOST_VERSION_MAJOR + 0x100 * GOOST_VERSION_MINOR + GOOST_VERSION_PATCH;
	dict["status"] = GOOST_VERSION_STATUS;
	dict["year"] = GOOST_VERSION_YEAR;

	String hash = GOOST_VERSION_HASH;
	dict["hash"] = hash.length() == 0 ? String("unknown") : hash;

	String stringver = String(dict["major"]) + "." + String(dict["minor"]);
	if ((int)dict["patch"] != 0)
		stringver += "." + String(dict["patch"]);
	stringver += "-" + String(dict["status"]);
	dict["string"] = stringver;

	return dict;
}

static Array array_from_info(const char *const *info_list) {
	Array arr;
	for (int i = 0; info_list[i] != nullptr; i++) {
		arr.push_back(info_list[i]);
	}
	return arr;
}

static Array array_from_info_count(const char *const *info_list, int info_count) {
	Array arr;
	for (int i = 0; i < info_count; i++) {
		arr.push_back(info_list[i]);
	}
	return arr;
}

Dictionary GoostEngine::get_author_info() const {
	Dictionary dict;
	dict["lead_developers"] = array_from_info(AUTHORS_LEAD_DEVELOPERS);
	dict["project_managers"] = array_from_info(AUTHORS_PROJECT_MANAGERS);
	dict["founders"] = array_from_info(AUTHORS_FOUNDERS);
	dict["developers"] = array_from_info(AUTHORS_DEVELOPERS);
	return dict;
}

Array GoostEngine::get_copyright_info() const {
	Array components;
	for (int component_index = 0; component_index < COPYRIGHT_INFO_COUNT; component_index++) {
		const ComponentCopyright &cp_info = COPYRIGHT_INFO[component_index];
		Dictionary component_dict;
		component_dict["name"] = cp_info.name;
		Array parts;
		for (int i = 0; i < cp_info.part_count; i++) {
			const ComponentCopyrightPart &cp_part = cp_info.parts[i];
			Dictionary part_dict;
			part_dict["files"] = array_from_info_count(cp_part.files, cp_part.file_count);
			part_dict["copyright"] = array_from_info_count(cp_part.copyright_statements, cp_part.copyright_count);
			part_dict["license"] = cp_part.license;
			parts.push_back(part_dict);
		}
		component_dict["parts"] = parts;

		components.push_back(component_dict);
	}
	return components;
}

Dictionary GoostEngine::get_license_info() const {
	Dictionary licenses;
	for (int i = 0; i < LICENSE_COUNT; i++) {
		licenses[LICENSE_NAMES[i]] = LICENSE_BODIES[i];
	}
	return licenses;
}

String GoostEngine::get_license_text() const {
	return String(GOOST_LICENSE_TEXT);
}

Dictionary GoostEngine::get_color_constants() const {
	if (_named_colors.is_empty()) {
		_populate_named_colors(); // color_names.inc
	}
	Dictionary colors;
	for (HashMap<String, Color>::Element *E = _named_colors.front(); E; E = E->next()) {
		colors[E->key()] = E->get();
	}
	return colors;
}

void GoostEngine::defer_call(Object *p_obj, StringName p_method, VARIANT_ARG_DECLARE) {
	deferred_calls.push_call(p_obj->get_instance_id(), p_method, VARIANT_ARG_PASS);
}

Variant GoostEngine::_defer_call_bind(const Variant **p_args, int p_argcount, Variant::CallError &r_error) {
	if (p_argcount < 2) {
		r_error.error = Variant::CallError::CALL_ERROR_TOO_FEW_ARGUMENTS;
		r_error.argument = 0;
		return Variant();
	}
	if (p_args[0]->get_type() != Variant::OBJECT) {
		r_error.error = Variant::CallError::CALL_ERROR_INVALID_ARGUMENT;
		r_error.argument = 0;
		r_error.expected = Variant::OBJECT;
		return Variant();
	}
	if (p_args[1]->get_type() != Variant::STRING) {
		r_error.error = Variant::CallError::CALL_ERROR_INVALID_ARGUMENT;
		r_error.argument = 1;
		r_error.expected = Variant::STRING;
		return Variant();
	}
	r_error.error = Variant::CallError::CALL_OK;

	Object *obj = *p_args[0];
	StringName method = *p_args[1];
	deferred_calls.push_call(obj->get_instance_id(), method, &p_args[2], p_argcount - 2);

	return Variant();
}

void GoostEngine::defer_call_unique(Object *p_obj, StringName p_method, VARIANT_ARG_DECLARE) {
	deferred_calls.push_call_unique(p_obj->get_instance_id(), p_method, VARIANT_ARG_PASS);
}

Variant GoostEngine::_defer_call_unique_bind(const Variant **p_args, int p_argcount, Variant::CallError &r_error) {
	if (p_argcount < 2) {
		r_error.error = Variant::CallError::CALL_ERROR_TOO_FEW_ARGUMENTS;
		r_error.argument = 0;
		return Variant();
	}
	if (p_args[0]->get_type() != Variant::OBJECT) {
		r_error.error = Variant::CallError::CALL_ERROR_INVALID_ARGUMENT;
		r_error.argument = 0;
		r_error.expected = Variant::OBJECT;
		return Variant();
	}
	if (p_args[1]->get_type() != Variant::STRING) {
		r_error.error = Variant::CallError::CALL_ERROR_INVALID_ARGUMENT;
		r_error.argument = 1;
		r_error.expected = Variant::STRING;
		return Variant();
	}
	r_error.error = Variant::CallError::CALL_OK;

	Object *obj = *p_args[0];
	StringName method = *p_args[1];
	deferred_calls.push_call_unique(obj->get_instance_id(), method, &p_args[2], p_argcount - 2);

	return Variant();
}

Ref<InvokeState> GoostEngine::_invoke(Object *p_obj, StringName p_method, real_t p_delay, real_t p_rate, bool p_pause_mode, bool p_deferred) {
	ERR_FAIL_NULL_V_MSG(p_obj, Ref<InvokeState>(), "Invalid object");

	SceneTree *tree = Object::cast_to<SceneTree>(OS::get_singleton()->get_main_loop());
	ERR_FAIL_NULL_V_MSG(tree, Ref<InvokeState>(), "The `invoke()` method requires a SceneTree to work.");

	Ref<SceneTreeTimer> timer = tree->create_timer(p_delay, p_pause_mode);

	Ref<InvokeState> state;
	state.instantiate();
	state->instance_id = p_obj->get_instance_id();
	state->method = p_method;
	state->timer = timer;
	state->active = true;
	state->repeat_rate = p_rate;

	timer->connect("timeout", this, "_on_invoke_timeout",
			varray(state, p_pause_mode, p_deferred), p_deferred ? CONNECT_DEFERRED : 0);

	invokes.push_back(state);
	return state;
}

Ref<InvokeState> GoostEngine::invoke(Object *p_obj, StringName p_method, real_t p_delay, real_t p_rate, bool p_pause_mode) {
	return _invoke(p_obj, p_method, p_delay, p_rate, p_pause_mode, false);
}

Ref<InvokeState> GoostEngine::invoke_deferred(Object *p_obj, StringName p_method, real_t p_delay, real_t p_rate, bool p_pause_mode) {
	return _invoke(p_obj, p_method, p_delay, p_rate, p_pause_mode, true);
}

void GoostEngine::_on_invoke_timeout(Ref<InvokeState> p_state, bool p_pause_mode, bool p_deferred) {
	ERR_FAIL_COND(p_state.is_null());

	Object *obj = ObjectDB::get_instance(p_state->instance_id);
	if (!obj) {
		p_state->active = false;
	}
	if (obj && p_state->is_active()) {
		Variant::CallError ce;
		p_state->emit_signal("pre_call");
		obj->call(p_state->method, nullptr, 0, ce);
		if (ce.error != Variant::CallError::CALL_OK) {
			ERR_PRINT("Error invoking method: " + Variant::get_call_error_text(obj, p_state->method, nullptr, 0, ce) + ".");
			p_state->active = false;
		}
		p_state->emit_signal("post_call");
		if (p_state->is_repeating() && ce.error == Variant::CallError::CALL_OK) {
			SceneTree *tree = Object::cast_to<SceneTree>(OS::get_singleton()->get_main_loop());
			Ref<SceneTreeTimer> timer = tree->create_timer(p_state->repeat_rate, p_pause_mode);
			p_state->timer = timer;
			timer->connect("timeout", this, "_on_invoke_timeout",
					varray(p_state, p_pause_mode, p_deferred), p_deferred ? CONNECT_DEFERRED : 0);
		} else {
			p_state->active = false;
			p_state->emit_signal("completed");
		}
	}
	if (!p_state->is_active()) {
		invokes.erase(p_state);
	}
}

Array GoostEngine::get_invokes() const {
	Array ret;
	for (int i = 0; i < invokes.size(); ++i) {
		ret.push_back(invokes[i]);
	}
	return ret;
}

void GoostEngine::flush_calls() {
	singleton->deferred_calls.flush();
}

void GoostEngine::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_version_info"), &GoostEngine::get_version_info);
	ClassDB::bind_method(D_METHOD("get_author_info"), &GoostEngine::get_author_info);
	ClassDB::bind_method(D_METHOD("get_copyright_info"), &GoostEngine::get_copyright_info);
	ClassDB::bind_method(D_METHOD("get_license_info"), &GoostEngine::get_license_info);
	ClassDB::bind_method(D_METHOD("get_license_text"), &GoostEngine::get_license_text);

	ClassDB::bind_method(D_METHOD("get_color_constants"), &GoostEngine::get_color_constants);
	{
		MethodInfo mi;
		mi.name = "defer_call";
		mi.arguments.push_back(PropertyInfo(Variant::OBJECT, "object"));
		mi.arguments.push_back(PropertyInfo(Variant::STRING, "method"));
		ClassDB::bind_vararg_method(METHOD_FLAGS_DEFAULT, "defer_call", &GoostEngine::_defer_call_bind, mi, varray(), false);
	}
	{
		MethodInfo mi;
		mi.name = "defer_call_unique";
		mi.arguments.push_back(PropertyInfo(Variant::OBJECT, "object"));
		mi.arguments.push_back(PropertyInfo(Variant::STRING, "method"));
		ClassDB::bind_vararg_method(METHOD_FLAGS_DEFAULT, "defer_call_unique", &GoostEngine::_defer_call_unique_bind, mi, varray(), false);
	}
	ClassDB::bind_method(D_METHOD("invoke", "object", "method", "delay", "repeat_rate", "pause_mode_process"), &GoostEngine::invoke, DEFVAL(-1.0), DEFVAL(true));
	ClassDB::bind_method(D_METHOD("invoke_deferred", "object", "method", "delay", "repeat_rate", "pause_mode_process"), &GoostEngine::invoke_deferred, DEFVAL(-1.0), DEFVAL(true));
	ClassDB::bind_method(D_METHOD("get_invokes"), &GoostEngine::get_invokes);
	ClassDB::bind_method(D_METHOD("_on_invoke_timeout"), &GoostEngine::_on_invoke_timeout);
}
