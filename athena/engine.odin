package athena

EngineConfig :: struct {
	window_width: int,
	window_height: int,
	title: string,
}

EngineState :: struct {
	is_running: bool
}

engine_create :: proc(conf: EngineConfig) -> EngineState {
	return EngineState { };
}

engine_destroy :: proc(e: ^EngineState) {
}

engine_run :: proc(e: ^EngineState) {
}

