extension EventSourceProtocol {
    public func flatMapLatest<USource: EventSourceProtocol>(_ flatMap: @escaping (Event) -> USource) -> EventSource<USource.Event> {
        return EventSourceFlatMapLatest(source: self, flatMap: flatMap).asEventSource()
    }
}

public class EventSourceFlatMapLatest<TSource: EventSourceProtocol, USource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    public typealias U = USource.Event
    
    public init(source: TSource, flatMap: @escaping (T) -> USource) {
        self.source = source
        self.flatMap = flatMap
    }
    
    public func subscribe(handler: @escaping (U) -> Void) -> Disposer {
        let sink = Sink(flatMap: flatMap, handler: handler)
        let innerDisposer = source.bind(to: sink)
        return SinkDisposer.init(innerDisposer: innerDisposer, sink: sink).asDisposer()
    }
    
    private let source: TSource
    private let flatMap: (T) -> USource
    
    private class Sink : EventSinkProtocol {
        public init(flatMap: @escaping (T) -> USource,
                    handler: @escaping (U) -> Void)
        {
            self.flatMap = flatMap
            self.handler = handler
        }
        
        public func dispose() {
            uSourceDisposer?.dispose()
            uSourceDisposer = nil
        }
        
        public func send(event t: T) {
            dispose()
            
            let uSource: USource = flatMap(t)
            uSourceDisposer = uSource.subscribe {
                self.handler($0)
            }
        }
        
        private let flatMap: (T) -> USource
        private let handler: (U) -> Void
        private var uSourceDisposer: Disposer?
    }
    
    private class SinkDisposer : DisposerProtocol {
        public init(innerDisposer: Disposer, sink: Sink) {
            self.innerDisposer = innerDisposer
            self.sink = sink
        }
        
        public func dispose() {
            innerDisposer.dispose()
            sink?.dispose()
        }
        
        private let innerDisposer: Disposer
        private weak var sink: Sink?
    }
}

