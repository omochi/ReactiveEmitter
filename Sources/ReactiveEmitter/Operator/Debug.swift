public class EventSourceDebug<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event

    public init(source: TSource) {
        self.source = source
    }
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        let sink = Sink.init(handler: handler)
        let disposer = source.bind(to: sink)
        return disposer
    }
    
    private let source: TSource
    
    private class Sink : EventSinkProtocol {
        public init(handler: @escaping (T) -> Void) {
            self.handler = handler
        }
        
        public func send(event: T) {
            self.handler(event)
        }
        
        private let handler: (T) -> Void
    }
}
