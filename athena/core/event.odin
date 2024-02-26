package core

QuitEvent :: struct { }

EventVariant :: union {
	QuitEvent,
}

Event :: struct {
	variant: EventVariant,
}

EventHandlerResult :: enum {
	Propagate,
	DontPropagate
}

EventCategory :: enum {
	Application,
}

EventCategories :: bit_set[EventCategory]

MAX_EVENT_HANDLERS :: 8
EventHandler :: struct {
	recv_categories: EventCategories,
	callback: proc(e: Event) -> EventHandlerResult,
}

EventSystem :: struct {
	handler_count: int,
	handlers: [MAX_EVENT_HANDLERS]EventHandler,
}

event_system_add :: proc(es: ^EventSystem, h: EventHandler) {
	es.handlers[es.handler_count] = h
	es.handler_count += 1
}

inject_event :: proc(e_sys: ^EventSystem, e: Event) {
	for i := 0; i < e_sys.handler_count; i += 1 {
		h := &e_sys.handlers[i]
		switch v in e.variant {
			case QuitEvent:
				if !(EventCategory.Application in h.recv_categories) {
					continue
				}
		}

		handled := h.callback(e)
		if handled == .DontPropagate {
			break
		}
	}
}

