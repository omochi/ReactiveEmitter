public class EventSourceMerge<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(sources: [TSource]) {
        self.sources = sources
    }
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        
        sources.forEach { source in
            sink.addDisposer(source.subscribe { sink.emit($0) })
        }

        return sink.disposer
    }
    
    private let sources: [TSource]
    
    private class Sink: SinkBase<T> {
        public override init(handler: @escaping (T) -> Void) {
            super.init(handler: handler)
        }
    }
}

public func merge<TSource: EventSourceProtocol>(_ sources: [TSource]) -> EventSource<TSource.Event> {
    return EventSourceMerge(sources: sources).asEventSource()
}
