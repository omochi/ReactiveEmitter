import Foundation

public class EventSourceObserveOn<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(source: TSource, dispatchQueue: DispatchQueue) {
        self.source = source
        self.dispatchQueue = dispatchQueue
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposer {
        return Sink(source: source,
                    dispatchQueue: dispatchQueue,
                    handler: handler).asDisposer()
    }
    
    private let source: TSource
    private let dispatchQueue: DispatchQueue
    
    private class Sink : DisposerProtocol {
        public init(source: TSource,
                    dispatchQueue: DispatchQueue,
                    handler: @escaping (T) -> Void)
        {
            self.dispatchQueue = dispatchQueue
            self.handler = handler
            self.lock = NSLock()
            self.disposer = CompositeDisposer()
            
            disposer.add(source.subscribe {
                self.send($0)
            })
            disposer.add(Disposer { [weak self] in
                self?.disposed = true
            })
        }
        
        public func dispose() {
            lock.scope {
                disposed = true
            }
            
            disposer.dispose()
        }
        
        private func send(_ t: T) {
            dispatchQueue.async {
                let disposed = self.lock.scope { self.disposed }
                if disposed {
                    return
                }
                
                self.handler(t)
            }
        }
        
        private let dispatchQueue: DispatchQueue
        private let handler: (T) -> Void
        private let lock: NSLock
        private let disposer: CompositeDisposer
        private var disposed: Bool = false
    }
}

extension EventSourceProtocol {
    public func observeOn(dispatchQueue: DispatchQueue) -> EventSource<Event> {
        return EventSourceObserveOn(source: self, dispatchQueue: dispatchQueue).asEventSource()
    }
}
