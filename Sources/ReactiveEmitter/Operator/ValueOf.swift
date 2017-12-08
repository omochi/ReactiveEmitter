extension EventSource {
    public static func of(_ value: Event) -> EventSource<Event> {
        return Property<Event>.init(value).asEventSource()
    }
}
