import Foundation

public class EventEmitter<Event> : EventSourceProtocol {
    public init() {
        lock = NSLock()
    }
    
    public func emit(_ event: Event) {
        let handlers = lock.scope {
            self.handlers
        }

        handlers.forEach { handler in
            handler.value(event)
        }
    }
    
    public func subscribe(_ handler: @escaping (Event) -> Void) -> Disposer {
        let handlerBox = Box(handler)
        
        lock.scope {
            handlers.append(handlerBox)
        }
        
        return Disposer { [weak self] in
            self?.unsubscribe(handlerBox)
        }
    }

    private func unsubscribe(_ box: Box<(Event) -> Void>) {
        lock.scope {
            handlers = handlers.filter { $0 !== box }
        }
    }
    
    private var handlers: [Box<(Event) -> Void>] = []
    private let lock: NSLock
}
