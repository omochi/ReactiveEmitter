extension EventSourceProtocol {
    public func map<U>(_ map: @escaping (Event) -> U) -> EventSource<U> {
        return EventSourceMap(source: self, map: map).asEventSource()
    }
}

public class EventSourceMap<TSource: EventSourceProtocol, U> : EventSourceProtocol {
    public typealias T = TSource.Event

    public init(source: TSource, map: @escaping (T) -> U) {
        self.source = source
        self.map = map
    }
    
    public func subscribe(handler: @escaping (U) -> Void) -> Disposer {
        let sink = Sink(map: map, handler: handler)
        let disposer = source.bind(to: sink)
        return disposer
    }
    
    private let source: TSource
    private let map: (T) -> U
    
    private class Sink : EventSinkProtocol {
        public init(
            map: @escaping (T) -> U,
            handler: @escaping (U) -> Void)
        {
            self.map = map
            self.handler = handler
        }
        
        public func send(event t: T) {
            let u = map(t)
            handler(u)
        }
        
        private let map: (T) -> U
        private let handler: (U) -> Void
    }
}
