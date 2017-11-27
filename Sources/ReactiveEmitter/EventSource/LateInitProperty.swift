public class LateInitProperty<Value> : EventSourceProtocol, EventSinkConvertible {
    public init () {
        self._value = nil
        self.emitter = EventEmitter<Value>()
    }
    
    public var value: Value {
        get {
            guard let value = _value else {
                fatalError("value still not inited")
            }
            return value
        }
        set {
            _value = newValue
            emitter.emit(newValue)
        }
    }
    
    public func subscribe(handler: @escaping (Value) -> Void) -> Disposer {
        let disposer = emitter.subscribe(handler: handler)
        if let value = _value {
            handler(value)
        }
        return disposer
    }
    
    public func asEventSink() -> EventSink<Value> {
        return Sink(self).asEventSink()
    }
    
    private class Sink : EventSinkProtocol {
        public init(_ base: LateInitProperty<Value>) {
            self.property = base
        }
        
        public func send(event: Value) {
            property.value = event
        }
        
        private let property: LateInitProperty<Value>
    }
    
    private var _value: Value?
    private let emitter: EventEmitter<Value>
}
