extension EventSource {
    public static func of<T>(_ value: T) -> EventSource<T> {
        return Property<T>.init(value).asEventSource()
    }
}
