public class Property<Value> : EventSourceProtocol, EventSinkConvertible {
    public init(_ value: Value) {
        self._value = value
        self.emitter = EventEmitter<Value>()
    }
    
    public var value: Value {
        get {
            return _value
        }
        set {
            _value = newValue
            emitter.emit(_value)
        }
    }
    
    public func subscribe(handler: @escaping (Value) -> Void) -> Disposer {
        let disposer = emitter.subscribe(handler: handler)
        handler(_value)
        return disposer
    }
    
    public func asEventSink() -> EventSink<Value> {
        return Sink(self).asEventSink()
    }
    
    private class Sink : EventSinkProtocol {
        public init(_ base: Property<Value>) {
            self.property = base
        }
        
        public func send(event: Value) {
            property.value = event
        }
        
        private let property: Property<Value>
    }
    
    private var _value: Value
    private let emitter: EventEmitter<Value>
}
