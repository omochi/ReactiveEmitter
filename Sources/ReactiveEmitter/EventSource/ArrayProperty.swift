public class ArrayProperty<T> : EventSourceProtocol {
    public typealias Event = [T]
    
    public struct ReplaceEvent {
        public var range: Range<Int>
        public var elements: [T]
    }
    
    public class Array : RangeReplaceableCollectionClass {
        public typealias Element = T
        public typealias Index = Int
        public typealias IndexDistance = Int
        
        public init(property: ArrayProperty<T>) {
            self.property = property
        }
        
        public var value: [T] {
            get {
                return Swift.Array<T>(self)
            }
            set {
                replaceSubrange(startIndex..<endIndex, with: newValue)
            }
        }
        
        public var startIndex: Int {
            return property._value.startIndex
        }
        
        public var endIndex: Int {
            return property._value.endIndex
        }
        
        public subscript(position: Int) -> T {
            get {
                return property._value[position]
            }
            set {
                replaceSubrange(position..<index(after: position), with: [newValue])
            }
        }
        
        public func index(after index: Int) -> Int {
            return property._value.index(after: index)
        }
        
        public func index(before index: Int) -> Int {
            return property._value.index(before: index)
        }
        
        public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C)
            where C : Collection, C.Element == Element
        {
            property.replaceSubrange(subrange, with: Swift.Array<T>.init(newElements))
        }
        
        public var description: String {
            return property._value.description
        }
        
        private let property: ArrayProperty<T>
    }

    public init(_ value: [T]) {
        self._value = value
        valueEmitter = .init()
        replaceEmitter = .init()
    }
    
    public var value: [T] {
        get {
            return array.value
        }
        set {
            array.value = newValue
        }
    }
    
    public var array: Array {
        get {
            return Array.init(property: self)
        }
    }
    
    public func subscribe(handler: @escaping (Event) -> Void) -> Disposer {
        let disposer = valueEmitter.subscribe(handler: handler)
        handler(_value)
        return disposer
    }
    
    public func subscribeReplace(handler: @escaping (ReplaceEvent) -> Void) -> Disposer {
        let disposer = replaceEmitter.subscribe(handler: handler)
        return disposer
    }
    
    public func asReplaceEventSource() -> EventSource<ReplaceEvent> {
        return replaceEmitter.asEventSource()
    }
    
    private func replaceSubrange(_ range: Range<Int>, with newElements: [T]) {
        _value.replaceSubrange(range, with: newElements)
        replaceEmitter.emit(.init(range: range, elements: newElements))
        valueEmitter.emit(_value)
    }
    
    private var _value: [T]
    
    private let valueEmitter: EventEmitter<[T]>
    private let replaceEmitter: EventEmitter<ReplaceEvent>
}
