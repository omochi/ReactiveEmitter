internal class LinkedList<T> {
    public class Node {
        public init(value: T) {
            self.value = value
        }
        
        public var value: T
        
        public var next: Node?
        public weak var prev: Node?
        
        public static func link(_ node0: Node?, _ node1: Node?) {
            node0?.next = node1
            node1?.prev = node0
        }
        
        public static func link(_ node0: Node?, _ node1: Node?, _ node2: Node?) {
            link(node0, node1)
            link(node1, node2)
        }
    }
    
    public struct Iterator : IteratorProtocol {
        typealias Element = T
        
        public init(list: LinkedList<T>) {
            self.list = list
            self._node = list._first
        }
        
        public mutating func next() -> T? {
            guard let currentNode = self._node else {
                return nil
            }
            self._node = currentNode.next
            return currentNode.value
        }
        
        private let list: LinkedList<T>
        private var _node: Node?
    }
    
    public init() {
    }
    
    public var firstNode: Node? {
        return _first
    }
    
    public var first: T? {
        return _first?.value
    }
    
    public var lastNode: Node? {
        return _last
    }
    
    public var last: T? {
        return _last?.value
    }
    
    public var count: Int {
        return _count
    }
    
    @discardableResult
    public func insert(_ value: T, after node0: Node) -> Node {
        let node2: Node? = node0.next
        let node1: Node = Node.init(value: value)
        
        Node.link(node0, node1, node2)
        
        if _last === node0 {
            assert(node2 == nil)
            assert(_first != nil)
            _last = node1
        }
        
        _count += 1
        
        return node1
    }
    
    @discardableResult
    public func insertAfterLast(_ value: T) -> Node {
        if let last = self._last {
            return insert(value, after: last)
        }
        
        assert(_first == nil && _last == nil && _count == 0)
        
        let node = Node.init(value: value)
        _first = node
        _last = node
        
        _count += 1
        
        return node
    }
    
    @discardableResult
    public func insert(_ value: T, before node2: Node) -> Node {
        let node1: Node = Node.init(value: value)
        let node0: Node? = node1.prev
        
        Node.link(node0, node1, node2)
        
        if _first === node2 {
            assert(node0 == nil)
            assert(_last != nil)
            _first = node1
        }
        
        _count += 1
        
        return node1
    }
    
    @discardableResult
    public func insertBeforeFirst(_ value: T) -> Node {
        if let first = self._first {
            return insert(value, before: first)
        }
        
        assert(_first == nil && _last == nil && _count == 0)
        
        let node = Node.init(value: value)
        _first = node
        _last = node
        
        _count += 1
        
        return node
    }
    
    public func remove(node node1: Node) {
        let node0: Node? = node1.prev
        let node2: Node? = node1.next
        
        Node.link(node0, node2)
        Node.link(nil, node1, nil)
        
        if node0 == nil {
            assert(_first === node1)
            _first = node2
        }
        
        if node2 == nil {
            assert(_last === node1)
            _last = node0
        }
        
        _count -= 1
        
        assert((_first == nil && _last == nil && _count == 0) ||
            (_first != nil && _last != nil && _count > 0))
    }
    
    private var _first: Node?
    private var _last: Node?
    private var _count: Int = 0
}

extension LinkedList : Sequence {
    public func makeIterator() -> LinkedList<T>.Iterator {
        return LinkedList<T>.Iterator.init(list: self)
    }
}
