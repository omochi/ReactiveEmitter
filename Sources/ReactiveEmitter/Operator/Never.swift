extension EventSource {
    public static func never() -> EventSource<Event> {
        return EventSourceNever<Event>.init().asEventSource()
    }
}

public class EventSourceNever<T> : EventSourceProtocol {
    public typealias Event = T
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        return Disposer.init()
    }
}
