public class EventSourceFlatMapLatest<TSource: EventSourceProtocol, USource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    public typealias U = USource.Event
    
    public init(source: TSource, flatMap: @escaping (T) -> USource) {
        self.source = source
        self.flatMap = flatMap
    }
    
    public func subscribe(_ handler: @escaping (U) -> Void) -> Disposer {
        return Sink(source: source,
                    flatMap: flatMap,
                    handler: handler).asDisposer()
    }
    
    private let source: TSource
    private let flatMap: (T) -> USource
    
    private class Sink : DisposerProtocol {
        public init(source: TSource,
                    flatMap: @escaping (T) -> USource,
                    handler: @escaping (U) -> Void)
        {
            self.flatMap = flatMap
            self.handler = handler
            self.disposer = CompositeDisposer()
            self.innerDisposer = CompositeDisposer()
            
            disposer.add(innerDisposer)
            disposer.add(source.subscribe {
                self.send($0)
            })
        }
        
        public func dispose() {
            disposer.dispose()
        }
        
        private func send(_ t: T) {
            innerDisposer.dispose()
            
            let uSource: USource = flatMap(t)
            innerDisposer.add(uSource.subscribe { [handler] (u: U) in
                handler(u)
            })
        }
        
        private let flatMap: (T) -> USource
        private let handler: (U) -> Void
        private let disposer: CompositeDisposer
        private let innerDisposer: CompositeDisposer
    }
}

extension EventSourceProtocol {
    public func flatMap<USource: EventSourceProtocol>(_ flatMap: @escaping (Event) -> USource) -> EventSource<USource.Event> {
        return EventSourceFlatMapLatest(source: self, flatMap: flatMap).asEventSource()
    }
}
