public class EventEmitter<Event> : EventSourceProtocol {
    public init() {}
    
    public func emit(_ event: Event) {
        let handlers = self.handlers
        handlers.forEach { handler in
            handler.value(event)
        }
    }
    
    public func subscribe(_ handler: @escaping (Event) -> Void) -> Disposer {
        let handlerBox = Box(handler)
        handlers.append(handlerBox)
        return Disposer { [weak self] in
            self?.unsubscribe(handlerBox)
        }
    }

    private func unsubscribe(_ box: Box<(Event) -> Void>) {
        handlers = handlers.filter { $0 !== box }
    }
    
    private var handlers: [Box<(Event) -> Void>] = []
}
