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

    private func unsubscribe(_ box: Box<(Event) -> Void>) {
        lock.scope {
            while let index = (handlers.index { $0 === box }) {
                handlers.remove(at: index)
            }
        }
    }
    
    private var handlers: [Box<(Event) -> Void>] = []
    private let lock: NSLock
}
