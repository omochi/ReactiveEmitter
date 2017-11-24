public protocol EventSinkConvertible {
    associatedtype _Event

    func asEventSink() -> EventSink<_Event>
}

public protocol EventSinkProtocol : EventSinkConvertible {
    associatedtype Event
    
    func send(event: Event)
}

extension EventSinkProtocol {
    public func asEventSink() -> EventSink<Event> {
        return EventSink.init(self)
    }
}

public class EventSink<Event> : EventSinkProtocol {
    public init<X: EventSinkProtocol>(_ base: X)
        where X.Event == Event
    {
        self.box = _EventSinkBox.init(base: base)
    }
    
    public init(_ f: @escaping (Event) -> Void) {
        self.box = _FuncEventSinkBox.init(f)
    }
    
    public func send(event: Event) {
        box.send(event: event)
    }
    
    private let box: _AnyEventSinkBox<Event>
}

public class _AnyEventSinkBox<Event> {
    public func send(event: Event) {
        fatalError("abstract")
    }
}

public class _EventSinkBox<X: EventSinkProtocol> : _AnyEventSinkBox<X.Event> {
    public typealias Event = X.Event
    
    public init(base: X) {
        self.base = base
    }
    
    public override func send(event: Event) {
        base.send(event: event)
    }
    
    private let base: X
}

public class _FuncEventSinkBox<Event> : _AnyEventSinkBox<Event> {
    public init(_ f: @escaping (Event) -> Void) {
        self.f = f
    }
    
    public override func send(event: Event) {
        f(event)
    }
    
    private let f: (Event) -> Void
}
