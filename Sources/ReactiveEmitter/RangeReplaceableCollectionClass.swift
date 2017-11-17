public protocol RangeReplaceableCollectionClass : class, Collection {    
    func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C)
    where C: Collection, C.Element == Element
    
    subscript(position: Index) -> Element { get set }
    
    func append(_ element: Element)
    func append<C>(contentsOf newElements: C) where C: Collection, C.Element == Element
    
    func insert(_ element: Element, at index: Index)
    func insert<C>(contentsOf newElements: C, at index: Index) where C: Collection, C.Element == Element
    
    func remove(at index: Index)
    func removeSubrange(_ subrange: Range<Index>)
    func removeAll()
}

public extension RangeReplaceableCollectionClass {
    // 本当は自動で subscript set を提供したいけど、
    // get の実装が求められてしまうのでできない。    
    
    func append(_ element: Element) {
        replaceSubrange(endIndex..<endIndex, with: [element])
    }
    
    func append<C>(contentsOf newElements: C) where C: Collection, C.Element == Element {
        replaceSubrange(endIndex..<endIndex, with: newElements)
    }
    
    func insert(_ element: Element, at i: Index) {
        replaceSubrange(i..<i, with: [element])
    }
    
    func insert<C>(contentsOf newElements: C, at index: Index) where C: Collection, C.Element == Element {
        replaceSubrange(index..<index, with: newElements)
    }
 
    func remove(at index: Index) {
        replaceSubrange(index..<self.index(after: index), with: [])
    }
    
    func removeSubrange(_ subrange: Range<Index>) {
        replaceSubrange(subrange, with: [])
    }
    
    func removeAll() {
        replaceSubrange(startIndex..<endIndex, with: [])
    }
}
