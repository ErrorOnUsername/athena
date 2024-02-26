package athena

import "platform"
import "core"
import "core:fmt"

EngineConfig :: struct {
	window_width: int,
	window_height: int,
	title: cstring,
}

EngineState :: struct {
	is_running: bool,
	platform_data: platform.PlatformData,
}

@(private = "file")
engine: EngineState

engine_create :: proc(conf: EngineConfig) -> ^EngineState {
	pc := platform.PlatformConfig {
		conf.window_width,
		conf.window_height,
		conf.title,
	}

	ok := platform.platform_init(&engine.platform_data, pc)
	engine.is_running = ok

	return &engine
}

engine_destroy :: proc(e: ^EngineState) {
	platform.platform_deinit(&e.platform_data)
}

engine_init_event_handlers :: proc(e: ^EngineState) {
	core.event_system_add(&e.platform_data.event_system, {{.Application}, engine_on_event})
}

engine_on_event :: proc(e: core.Event) -> core.EventHandlerResult {
	switch v in e.variant {
		case core.QuitEvent:
			fmt.println("Recieved an application quit event. Exiting next frame...")
			engine.is_running = false
	}

	return .DontPropagate
}

engine_run :: proc(e: ^EngineState) {
	for e.is_running {
		platform.platform_pump_events(&e.platform_data)
	}
}

