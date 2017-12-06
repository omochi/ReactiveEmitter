import Foundation

public class EventEmitter<Event> : EventSourceProtocol, EventSinkConvertible {
    public init() {
        queue = DispatchQueue.init(label: "\(type(of: self)).queue")
    }
    
    public func emit(_ event: Event) {
        let handlers = queue.sync {
            self.handlerBoxes
        }

        handlers.forEach { handler in
            handler.value(event)
        }
    }
    
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        let handlerBox = Box(handler)
        
        queue.async {
            self.handlerBoxes.append(handlerBox)
        }
        
        return Unsubscriber.init(emitter: self, handlerBox: handlerBox)
    }
    
    public func asEventSink() -> EventSink<(Event)> {
        return Sink(self).asEventSink()
    }
    
    private class Unsubscriber : Disposer {
        public init(emitter: EventEmitter<Event>,
                    handlerBox: Box<(Event) -> Void>)
        {
            self.emitter = emitter
            self.handlerBox = handlerBox
            super.init(void: ())
        }
        
        public override func dispose() {
            guard let emitter = self.emitter,
                let handlerBox = self.handlerBox else
            {
                return
            }
            
            emitter.unsubscribe(handlerBox)
        }
        
        private weak var emitter: EventEmitter<Event>?
        private weak var handlerBox: Box<(Event) -> Void>?
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
            guard let index = (handlerBoxes.index { $0 === box }) else {
                return
            }
            
            handlerBoxes.remove(at: index)
        }
    }
    
    private var handlerBoxes: [Box<(Event) -> Void>] = []
    private let queue: DispatchQueue
}
