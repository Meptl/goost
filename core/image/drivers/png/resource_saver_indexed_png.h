#pragma once

#include "core/io/resource_saver.h"
#include "goost/core/image/image_indexed.h"

class ResourceSaverIndexedPNG : public ResourceFormatSaver {
public:
	static Error save_image(const String &p_path, const Ref<ImageIndexed> &p_img);

	virtual Error save(const String &p_path, const Ref<Resource> &p_resource, uint32_t p_flags = 0);
	virtual bool recognize(const Ref<Resource> &p_resource) const;
	virtual void get_recognized_extensions(const Ref<Resource> &p_resource, List<String> *p_extensions) const;

	ResourceSaverIndexedPNG();
};

