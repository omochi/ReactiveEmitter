internal class WeakBox<Value: AnyObject> {
    public init(_ value: Value?) {
        self._value = value
    }

    public var value: Value? {
        get {
            return _value
        }
        set {
            _value = newValue
        }
    }
    
    private weak var _value: Value?
}

