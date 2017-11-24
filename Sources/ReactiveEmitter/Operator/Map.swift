public class EventSourceMap<TSource: EventSourceProtocol, U> : EventSourceProtocol {
    public typealias T = TSource.Event

    public init(source: TSource, map: @escaping (T) -> U) {
        self.source = source
        self.map = map
    }
    
    public func subscribe(handler: @escaping (U) -> Void) -> Disposer {
        let sink = Sink(map: map, handler: handler)
        sink.addDisposer(source.bind(to: sink))
        return sink.disposer
    }
    
    let source: TSource
    let map: (T) -> U
    
    private class Sink : OperatorSinkBase<U>, EventSinkProtocol {
        public init(
            map: @escaping (T) -> U,
            handler: @escaping (U) -> Void)
        {
            self.map = map
            super.init(handler: handler)
        }
        
        public func send(event t: T) {
            let u = map(t)
            emit(event: u)
        }
        
        private let map: (T) -> U
    }
}

extension EventSourceProtocol {
    public func map<U>(_ map: @escaping (Event) -> U) -> EventSource<U> {
        return EventSourceMap(source: self, map: map).asEventSource()
    }
}
