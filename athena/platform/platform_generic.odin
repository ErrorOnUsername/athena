package platform

import "core:fmt"
import "core:os"
import "vendor:sdl2"

import "../core"

PlatformConfig :: struct {
	window_width: int,
	window_height: int,
	title: cstring,
}

PlatformData :: struct {
	window: ^sdl2.Window,
	event_system: core.EventSystem,
}

WINDOW_FLAGS :: sdl2.WindowFlags { .SHOWN, .VULKAN }

platform_init :: proc(pd: ^PlatformData, pc: PlatformConfig) -> bool {
	res := sdl2.Init({ .VIDEO })
	if res != 0 {
		fmt.printf("Could not create SDL2 context! [error: {:s}]\n", sdl2.GetError())
		return false
	}

	pd.window = sdl2.CreateWindow(
		pc.title,
		sdl2.WINDOWPOS_CENTERED,
		sdl2.WINDOWPOS_CENTERED,
		i32(pc.window_width),
		i32(pc.window_height),
		WINDOW_FLAGS,
	)

	if pd.window == nil {
		fmt.printf("Could not create SDL2 window! [error: {:s}]\n", sdl2.GetError())
		return false
	}

	return true
}

platform_deinit :: proc(pd: ^PlatformData) {
	sdl2.DestroyWindow(pd.window)
}

platform_pump_events :: proc(pd: ^PlatformData) {
	sdl_ev: sdl2.Event

	for sdl2.PollEvent(&sdl_ev) {
		e: core.Event

		#partial switch sdl_ev.type {
			case sdl2.EventType.QUIT:
				e.variant = core.QuitEvent { }
			case:
				continue
		}

		core.inject_event(&pd.event_system, e)
	}
}

