public class WeakProperty<Value: AnyObject> : EventSourceProtocol, EventSinkConvertible {
    public typealias Event = Value?
    
    public init(_ value: Value?) {
        self.property = .init(WeakBox(value))
    }
    
    public var value: Value? {
        get {
            return property.value.value
        }
        set {
            property.value = WeakBox(newValue)
        }
    }
    
    public func subscribe(handler: @escaping (Value?) -> Void) -> Disposer {
        return property.map { $0.value }.subscribe(handler: handler)
    }
    
    public func asEventSink() -> EventSink<Value?> {
        return Sink(self).asEventSink()
    }
    
    private class Sink : EventSinkProtocol {
        public init(_ base: WeakProperty<Value>) {
            self.property = base
        }
        
        public func send(event: Value?) {
            property.value = event
        }
        
        private let property: WeakProperty<Value>
    }

    private let property: Property<WeakBox<Value>>
}
