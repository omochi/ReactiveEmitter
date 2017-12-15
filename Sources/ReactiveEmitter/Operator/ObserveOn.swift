import Foundation

extension EventSourceProtocol {
    public func observeOn(queue: DispatchQueue) -> EventSource<Event> {
        return EventSourceObserveOn(source: self, observeQueue: queue).asEventSource()
    }
}

public class EventSourceObserveOn<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(source: TSource, observeQueue: DispatchQueue) {
        self.source = source
        self.observeQueue = observeQueue
    }
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        let sink = Sink(observeQueue: observeQueue, handler: handler)
        let innerDisposer = source.bind(to: sink)
        return SinkDisposer.init(innerDisposer: innerDisposer, sink: sink).asDisposer()
    }
    
    private let source: TSource
    private let observeQueue: DispatchQueue
    
    private class Sink : EventSinkProtocol {
        public init(observeQueue: DispatchQueue,
                    handler: @escaping (T) -> Void)
        {
            self.observeQueue = observeQueue
            self.syncQueue = DispatchQueue.init(label: "\(type(of: self)).syncQueue")
            self.handler = handler
        }
        
        public func dispose() {
            syncQueue.sync {
                self.disposed = true
            }
        }
        
        public func send(event t: T) {
            observeQueue.async {
                self._send(event: t)
            }
        }
        
        private func _send(event t: T) {
            if (syncQueue.sync { self.disposed }) {
                return
            }
            
            handler(t)
        }
        
        private let observeQueue: DispatchQueue
        private let handler: (T) -> Void
        
        private let syncQueue: DispatchQueue
        private var disposed: Bool = false
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
        
        private weak var sink: Sink?
        private let innerDisposer: Disposer
    }
}
