#pragma once

#include "core/object/object.h"

class FuncBuffer {
public:
	struct Call {
		ObjectID instance_id;
		StringName target;
		uint8_t argcount;
		Vector<Variant> args;
	};

private:
	Vector<Call *> buffer;

public:
	Error push_call(ObjectID p_id, const StringName &p_method, const Variant **p_args, int p_argcount);
	Error push_call(ObjectID p_id, const StringName &p_method, const Variant **p_args, int p_argcount, bool p_show_error);

	Error push_call_unique(ObjectID p_id, const StringName &p_method, const Variant **p_args, int p_argcount);
	Error push_call_unique(ObjectID p_id, const StringName &p_method, const Variant **p_args, int p_argcount, bool p_show_error);

	void flush();

	~FuncBuffer() {
		for (int i = 0; i < buffer.size(); ++i) {
			memdelete(buffer[i]);
		}
		buffer.clear();
	}
};

