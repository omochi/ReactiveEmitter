public class EventSourceMerge<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(sources: [TSource]) {
        self.sources = sources
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposer {
        let disposer = CompositeDisposer()
        sources.forEach { source in
            let sink = Sink(handler: handler)
            let d = source.subscribe { sink.send($0) }
            disposer.add(d)
        }
        return disposer.asDisposer()
    }
    
    private class Sink {
        public init(handler: @escaping (T) -> Void) {
            self.handler = handler
        }
        
        public func send(_ t: T) {
            handler(t)
        }
        
        private let handler: (T) -> Void
    }
    
    private let sources: [TSource]
}

public func merge<TSource: EventSourceProtocol>(_ sources: [TSource]) -> EventSource<TSource.Event> {
    return EventSourceMerge(sources: sources).asEventSource()
}
