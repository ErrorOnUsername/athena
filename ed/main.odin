package editor

import "core:fmt"
import "../athena"

main :: proc() {
	conf := athena.EngineConfig {
		1280,
		720,
		"Athena Editor",
	}

	engine := athena.engine_create(conf)
	defer athena.engine_destroy(engine)

	athena.engine_init_event_handlers(engine)

	athena.engine_run(engine)
}

