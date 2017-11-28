import Foundation

public class EventEmitter<Event> : EventSourceProtocol, EventSinkConvertible {
    public init() {
        queue = DispatchQueue.init(label: "\(type(of: self))")
    }
    
    public func emit(_ event: Event) {
        let handlers = queue.sync {
            self.handlers
        }

        handlers.forEach { handler in
            handler.value(event)
        }
    }
    
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        let handlerBox = Box(handler)
        
        queue.sync {
            handlers.append(handlerBox)
        }
        
        weak var wself = self
        
        return Disposer { [wself, weak handlerBox] in
            guard let sself = wself else {
                return
            }
            guard let handlerBox = handlerBox else {
                return
            }
            sself.unsubscribe(handlerBox)
        }
    }
    
    public func asEventSink() -> EventSink<(Event)> {
        return Sink(self).asEventSink()
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

    private func unsubscribe(_ box: Box<(Event) -> Void>) {
        queue.sync {
            while let index = (handlers.index { $0 === box }) {
                handlers.remove(at: index)
            }
        }
    }
    
    private var handlers: [Box<(Event) -> Void>] = []
    private let queue: DispatchQueue
}