public class ArrayProperty<T> {
    public class Value : RangeReplaceableCollectionClass {
        public typealias Element = T
        public typealias Index = Int
        public typealias IndexDistance = Int
        
        public init(property: ArrayProperty<T>) {
            self.property = property
        }
        
        public var array: [T] {
            get {
                return Array<T>(self)
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
            // TODO: emit edit event
            property._value.replaceSubrange(subrange, with: newElements)
        }
        
        public var description: String {
            return property._value.description
        }
        
        private let property: ArrayProperty<T>
    }

    public init(_ value: [T]) {
        self._value = value
    }
    
    public var value: Value {
        get {
            return Value.init(property: self)
        }
    }
    
    private var _value: [T]
}
