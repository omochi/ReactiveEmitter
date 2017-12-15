import Foundation

public class EventEmitter<Event> : EventSourceProtocol, EventSinkConvertible {
    public init() {
        syncQueue = DispatchQueue.init(label: "\(type(of: self)).syncQueue")
    }
    
    public func emit(_ event: Event) {
        let handlers = syncQueue.sync {
            Array<(Event)->Void>(self.handlers)
        }

        handlers.forEach { handler in
            handler(event)
        }
    }
    
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        let node = syncQueue.sync {
            self.handlers.insertAfterLast(handler)
        }
        
        return Unsubscriber.init(emitter: self, node: node).asDisposer()
    }
    
    public func asEventSink() -> EventSink<(Event)> {
        return Sink(self).asEventSink()
    }
    
    private typealias Handlers = LinkedList<(Event) -> Void>
    
    private class Unsubscriber : DisposerProtocol {
        public init(emitter: EventEmitter<Event>,
                    node: Handlers.Node)
        {
            self.emitter = emitter
            self.node = node
        }

        public func dispose() {
            guard let emitter = self.emitter,
                let node = self.node else
            {
                return
            }

            emitter.unsubscribe(node)
        }

        private weak var emitter: EventEmitter<Event>?
        private weak var node: Handlers.Node?
    }

    private class Sink<Event> : EventSinkProtocol {
        public init(_ base: EventEmitter<Event>) {
            self.emitter = base
        }
        
        public func send(event: Event) {
            emitter.emit(event)
        }
        
        private let emitter: EventEmitter<Event>
    }

    private func unsubscribe(_ node: Handlers.Node) {
        syncQueue.sync {
            handlers.remove(node: node)
        }
    }
    
    private var handlers: Handlers = .init()
    private let syncQueue: DispatchQueue
}
