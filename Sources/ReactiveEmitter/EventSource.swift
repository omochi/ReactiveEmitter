public protocol EventSourceProtocol {
    associatedtype Event
    
    func subscribe(handler: @escaping (Event) -> Void) -> Disposer
    
    func asEventSource() -> EventSource<Event>
}

extension EventSourceProtocol {
    public func asEventSource() -> EventSource<Event> {
        return EventSource<Event>(self)
    }
}

public class EventSource<Event> : EventSourceProtocol {
    public init<X: EventSourceProtocol>(_ base: X)
        where X.Event == Event
    {
        self.box = _EventSourceBox<X>(base)
    }
    
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        return box.subscribe(handler: handler)
    }
    
    public func asEventSource() -> EventSource<(Event)> {
        return self;
    }
    
    private let box: _AnyEventSourceBox<Event>
}

public class _AnyEventSourceBox<Event> {
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        fatalError("abstract")
    }
}

public class _EventSourceBox<X: EventSourceProtocol> : _AnyEventSourceBox<X.Event> {
    public typealias Event = X.Event
    
    public init(_ base: X) {
        self.base = base
    }
    
    public override func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        return base.subscribe(handler: handler)
    }
    
    private let base: X
}
