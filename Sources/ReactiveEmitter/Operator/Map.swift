public class EventSourceMap<TSource: EventSourceProtocol, U> : EventSourceProtocol {
    public typealias T = TSource.Event

    public init(source: TSource, map: @escaping (T) -> U) {
        self.source = source
        self.map = map
    }
    
    public func subscribe(_ handler: @escaping (U) -> Void) -> Disposer {
        return Sink(source: source,
                    map: map,
                    handler: handler).asDisposer()
    }
    
    private let source: TSource
    private let map: (T) -> U
    
    private class Sink : DisposerProtocol {
        public init(source: TSource,
                    map: @escaping (T) -> U,
                    handler: @escaping (U) -> Void)
        {
            self.map = map
            self.handler = handler
            self.disposer = CompositeDisposer()
            
            disposer.add(source.subscribe {
                self.send($0)
            })
        }
        
        public func dispose() {
            disposer.dispose()
        }
        
        private func send(_ t: T) {
            let u = map(t)
            handler(u)
        }
        
        private let map: (T) -> U
        private let handler: (U) -> Void
        private let disposer: CompositeDisposer
    }
}

extension EventSourceProtocol {
    public func map<U>(_ map: @escaping (Event) -> U) -> EventSource<U> {
        return EventSourceMap(source: self, map: map).asEventSource()
    }
}
