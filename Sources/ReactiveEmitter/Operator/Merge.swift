public class EventSourceMerge<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(sources: [TSource]) {
        self.sources = sources
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposer {
        return Sink(sources: sources,
                    handler: handler).asDisposer()
    }
    
    private let sources: [TSource]
    
    private class Sink : DisposerProtocol {
        public init(sources: [TSource], handler: @escaping (T) -> Void) {
            self.handler = handler
            self.disposer = CompositeDisposer()
            
            sources.forEach { source in
                disposer.add(source.subscribe {
                    self.send($0)
                })
            }
        }
        
        public func dispose() {
            disposer.dispose()
        }
        
        private func send(_ t: T) {
            handler(t)
        }
        
        private let handler: (T) -> Void
        private let disposer: CompositeDisposer
    }
}

public func merge<TSource: EventSourceProtocol>(_ sources: [TSource]) -> EventSource<TSource.Event> {
    return EventSourceMerge(sources: sources).asEventSource()
}
