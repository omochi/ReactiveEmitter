public class EventSourceFlatMapLatest<TSource: EventSourceProtocol, USource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    public typealias U = USource.Event
    
    public init(source: TSource, flatMap: @escaping (T) -> USource) {
        self.source = source
        self.flatMap = flatMap
    }
    
    public func subscribe(_ handler: @escaping (U) -> Void) -> Disposer {
        let sink = Sink(flatMap: flatMap, handler: handler)
        return source.subscribe { sink.send($0) }
    }
    
    private class Sink {
        public init(flatMap: @escaping (T) -> USource, handler: @escaping (U) -> Void) {
            self.flatMap = flatMap
            self.handler = handler
            self.disposer = CompositeDisposer()
        }
        
        public func dispose() {
            disposer.dispose()
        }
        
        public func send(_ t: T) {
            dispose()
            let uSource: USource = flatMap(t)
            let uDisposer = uSource.subscribe { [weak self] (u: U) in
                self?.handler(u)
            }
            disposer.add(uDisposer)
        }
        
        private let flatMap: (T) -> USource
        private let handler: (U) -> Void
        private let disposer : CompositeDisposer
    }
    
    private let source: TSource
    private let flatMap: (T) -> USource
}

extension EventSourceProtocol {
    public func flatMap<USource: EventSourceProtocol>(_ flatMap: @escaping (Event) -> USource) -> EventSource<USource.Event> {
        return EventSourceFlatMapLatest(source: self, flatMap: flatMap).asEventSource()
    }
}
