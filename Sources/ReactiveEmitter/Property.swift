public class Property<Value> : EventSourceProtocol {
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
    
    public func subscribe(_ handler: @escaping (Value) -> Void) -> Disposer {
        let disposer = emitter.subscribe(handler)
        handler(_value)
        return disposer
    }
    
    private var _value: Value
    private let emitter: EventEmitter<Value>
}