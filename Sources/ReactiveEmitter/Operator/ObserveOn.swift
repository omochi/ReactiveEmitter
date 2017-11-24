import Foundation

public class EventSourceObserveOn<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(source: TSource, dispatchQueue: DispatchQueue) {
        self.source = source
        self.dispatchQueue = dispatchQueue
    }
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        let sink = Sink(dispatchQueue: dispatchQueue, handler: handler)
        sink.addDisposer(source.bind(to: sink))
        return Disposer {
            sink.dispose()
        }
    }
    
    private let source: TSource
    private let dispatchQueue: DispatchQueue
    
    private class Sink : OperatorSinkBase<T>, EventSinkProtocol {
        public init(dispatchQueue: DispatchQueue,
                    handler: @escaping (T) -> Void)
        {
            self.dispatchQueue = dispatchQueue
            self.syncQueue = DispatchQueue.init(label: "\(type(of: self))")

            super.init(handler: handler)
        }

        public func dispose() {
            syncQueue.sync {
                disposed = true
            }
            disposer.dispose()
        }
        
        public func send(event t: T) {
            dispatchQueue.async {
                let disposed = self.syncQueue.sync { self.disposed }
                if disposed {
                    return
                }
                
                self.emit(event: t)
            }
        }
        
        private let dispatchQueue: DispatchQueue
        private let syncQueue: DispatchQueue
        private var disposed: Bool = false
    }
}

extension EventSourceProtocol {
    public func observeOn(dispatchQueue: DispatchQueue) -> EventSource<Event> {
        return EventSourceObserveOn(source: self, dispatchQueue: dispatchQueue).asEventSource()
    }
}
