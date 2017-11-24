public class EventSourceFlatMapLatest<TSource: EventSourceProtocol, USource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    public typealias U = USource.Event
    
    public init(source: TSource, flatMap: @escaping (T) -> USource) {
        self.source = source
        self.flatMap = flatMap
    }
    
    public func subscribe(handler: @escaping (U) -> Void) -> Disposer {
        let sink = Sink(flatMap: flatMap, handler: handler)
        sink.addDisposer(source.bind(to: sink))
        return sink.disposer
    }
    
    private let source: TSource
    private let flatMap: (T) -> USource
    
    private class Sink : OperatorSinkBase<U>, EventSinkProtocol {
        public init(flatMap: @escaping (T) -> USource,
                    handler: @escaping (U) -> Void)
        {
            self.flatMap = flatMap
            self.innerDisposer = CompositeDisposer()
            
            super.init(handler: handler)
            
            addDisposer(innerDisposer.asDisposer())
        }
        
        public func send(event t: T) {
            innerDisposer.dispose()
            
            let uSource: USource = flatMap(t)
            innerDisposer.add(uSource.subscribe { self.emit(event: $0) })
        }
        
        private let flatMap: (T) -> USource
        private let innerDisposer: CompositeDisposer
    }
}

extension EventSourceProtocol {
    public func flatMapLatest<USource: EventSourceProtocol>(_ flatMap: @escaping (Event) -> USource) -> EventSource<USource.Event> {
        return EventSourceFlatMapLatest(source: self, flatMap: flatMap).asEventSource()
    }
}
