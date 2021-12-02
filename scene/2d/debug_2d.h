#pragma once

#include "core/engine.h"
#include "core/resource.h"
#include "scene/2d/node_2d.h"

class DebugDrawState;

class Debug2D : public Node {
	GDCLASS(Debug2D, Node);

private:
	static Debug2D *singleton;

	Node2D *canvas_item = nullptr;
	Ref<DebugDrawState> state;

	struct DrawCommand {
		enum Type {
			POLYLINE,
			CLEAR,
		};
		Type type;
		Vector<Variant> args;
	};
	Vector<DrawCommand> commands;
	int capture_begin = 0;
	int capture_end = 0;

protected:
	void _notification(int p_what);
	static void _bind_methods();

	void _on_canvas_item_draw();
	void _push_command(const DrawCommand &p_command);
	void _draw_command(const DrawCommand &p_command);

public:
	static Debug2D *get_singleton() { return singleton; }
	Ref<DebugDrawState> get_state() const { return state; }

	void draw_polyline(const Vector<Point2> &p_polyline, const Color &p_color, real_t p_width = 1.0);
	void draw_clear();

	void update();
	void capture();
	void clear();

	Debug2D() {
		ERR_FAIL_COND_MSG(singleton != nullptr, "Singleton already exists");
		singleton = this;
		state.instance();
	}
};

class DebugDrawState : public Reference {
	GDCLASS(DebugDrawState, Reference);

	friend class Debug2D;

protected:
	static void _bind_methods();

	Vector<int> snapshots;
	int snapshot = -1;

public:
	void draw_snapshot(int p_index);
	void draw_next_snapshot();
	void draw_prev_snapshot();

	int get_snapshot_count() { return snapshots.size() / 2; }

	void reset();
};
