#pragma once

#include "core/object/object.h"
#include "scene/main/scene_tree.h"

#include "func_buffer.h"
#include "invoke_state.h"

class GoostEngine : public Object {
	GDCLASS(GoostEngine, Object);

private:
	static GoostEngine *singleton;
	FuncBuffer deferred_calls;
	Vector<Ref<InvokeState>> invokes;

protected:
	static void _bind_methods();

	Variant _defer_call_bind(const Variant **p_args, int p_argcount, Callable::CallError &r_error);
	Variant _defer_call_unique_bind(const Variant **p_args, int p_argcount, Callable::CallError &r_error);

	Ref<InvokeState> _invoke(Object *p_obj, StringName p_method, real_t p_delay, real_t p_repeat_rate, bool p_pause_mode_process, bool p_deferred);
	void _on_invoke_timeout(Ref<InvokeState> p_state, bool p_pause_mode, bool p_deferred);

public:
	static GoostEngine *get_singleton() { return singleton; }

	Dictionary get_version_info() const;
	Dictionary get_author_info() const;
	Array get_copyright_info() const;
	Dictionary get_license_info() const;
	String get_license_text() const;

	Dictionary get_color_constants() const;

	template <typename... VarArgs>
	void defer_callp(Object *p_obj, StringName p_method, VarArgs... p_args) {
		Variant args[sizeof...(p_args) + 1] = { p_args..., Variant() }; // +1 makes sure zero sized arrays are also supported.
		const Variant *argptrs[sizeof...(p_args) + 1];
		for (uint32_t i = 0; i < sizeof...(p_args); i++) {
			argptrs[i] = &args[i];
		}
		defer_callp(0, p_method, sizeof...(p_args) == 0 ? nullptr : (const Variant **)argptrs, sizeof...(p_args));
	}

	template <typename... VarArgs>
	void defer_call_uniquep(Object *p_obj, StringName p_method, VarArgs... p_args) {
		Variant args[sizeof...(p_args) + 1] = { p_args..., Variant() }; // +1 makes sure zero sized arrays are also supported.
		const Variant *argptrs[sizeof...(p_args) + 1];
		for (uint32_t i = 0; i < sizeof...(p_args); i++) {
			argptrs[i] = &args[i];
		}
		defer_call_uniquep(0, p_method, sizeof...(p_args) == 0 ? nullptr : (const Variant **)argptrs, sizeof...(p_args));
	}

	Ref<InvokeState> invoke(Object *p_obj, StringName p_method, real_t p_delay, real_t p_repeat_rate, bool p_pause_mode_process = true);
	Ref<InvokeState> invoke_deferred(Object *p_obj, StringName p_method, real_t p_delay, real_t p_repeat_rate, bool p_pause_mode_process = true);
	Array get_invokes() const;

	static void flush_calls();

	GoostEngine() {
		ERR_FAIL_COND_MSG(singleton != nullptr, "Singleton already exists");
		singleton = this;
	}
};

