import Foundation

public class EventSourceObserveOn<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(source: TSource, dispatchQueue: DispatchQueue) {
        self.source = source
        self.dispatchQueue = dispatchQueue
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposer {
        let sink = Sink(dispatchQueue: dispatchQueue, handler: handler)
        let disposer = CompositeDisposer()
        disposer.add(source.subscribe { sink.send($0) })
        disposer.add(Disposer { sink.dispose() })
        return disposer.asDisposer()
    }
    
    private class Sink {
        public init(dispatchQueue: DispatchQueue, handler: @escaping (T) -> Void) {
            self.dispatchQueue = dispatchQueue
            self.handler = handler
            self.lock = NSLock()
        }
        
        public func send(_ t: T) {
            dispatchQueue.async {
                let disposed = self.lock.scope { self.disposed }
                if disposed {
                    return
                }
                
                self.handler(t)
            }
        }
        
        public func dispose() {
            lock.scope { disposed = true }
        }
        
        private let dispatchQueue: DispatchQueue
        private let handler: (T) -> Void
        private let lock: NSLock
        private var disposed: Bool = false
    }
    
    private let source: TSource
    private let dispatchQueue: DispatchQueue
}

extension EventSourceProtocol {
    public func observeOn(dispatchQueue: DispatchQueue) -> EventSource<Event> {
        return EventSourceObserveOn(source: self, dispatchQueue: dispatchQueue).asEventSource()
    }
}
