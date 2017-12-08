import Foundation

public class EventEmitter<Event> : EventSourceProtocol, EventSinkConvertible {
    public init() {
        syncQueue = DispatchQueue.init(label: "\(type(of: self)).syncQueue")
    }
    
    public func emit(_ event: Event) {
        let handlers = syncQueue.sync {
            self.handlerBoxes
        }

        handlers.forEach { handler in
            handler.value(event)
        }
    }
    
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        let handlerBox = Box(handler)
        
        syncQueue.async {
            self.handlerBoxes.append(handlerBox)
        }
        
        return Unsubscriber.init(emitter: self, handlerBox: handlerBox).asDisposer()
    }
    
    public func asEventSink() -> EventSink<(Event)> {
        return Sink(self).asEventSink()
    }
    
    private class Unsubscriber : DisposerProtocol {
        public init(emitter: EventEmitter<Event>,
                    handlerBox: Box<(Event) -> Void>)
        {
            self.emitter = emitter
            self.handlerBox = handlerBox
        }

        public func dispose() {
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
        syncQueue.sync {
            guard let index = (handlerBoxes.index { $0 === box }) else {
                return
            }
            
            handlerBoxes.remove(at: index)
        }
    }
    
    private var handlerBoxes: [Box<(Event) -> Void>] = []
    private let syncQueue: DispatchQueue
}
