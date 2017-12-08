public func merge<TSource: EventSourceProtocol>(_ sources: [TSource]) -> EventSource<TSource.Event> {
    return EventSourceMerge(sources: sources).asEventSource()
}

public class EventSourceMerge<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(sources: [TSource]) {
        self.sources = sources
    }
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        let disposers = CompositeDisposer.init()
        sources.forEach { source in
            let disposer = source.bind(to: sink)
            disposers.add(disposer)
        }
        return disposers.asDisposer()
    }
    
    private let sources: [TSource]
    
    private class Sink: EventSinkProtocol {
        public init(handler: @escaping (T) -> Void) {
            self.handler = handler
        }
        
        public func send(event: T) {
            handler(event)
        }
        
        private let handler: (T) -> Void
    }
}
