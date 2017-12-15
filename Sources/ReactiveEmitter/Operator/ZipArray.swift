public func zip<TSource: EventSourceProtocol>(_ sources: [TSource]) -> EventSource<[TSource.Event]> {
    return EventSourceZipArray.init(sources: sources).asEventSource()
}

public class EventSourceZipArray<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(sources: [TSource]) {
        self.sources = sources
    }
    
    public func subscribe(handler: @escaping ([T]) -> Void) -> Disposer {
        let sink = Sink(count: sources.count, handler: handler)
        let disposers = CompositeDisposer.init()
        sources.enumerated().forEach { (arg: (Int, TSource)) in
            let (index, source) = arg
            let innerDisposer = source.subscribe {
                sink.send(index, $0)
            }
            disposers.add(innerDisposer)
        }
        return disposers.asDisposer()
    }
    
    private let sources: [TSource]
    
    private class Sink {
        public init(count: Int, handler: @escaping ([T]) -> Void) {
            var valuesArray: [LinkedList<T>] = .init()
            valuesArray.reserveCapacity(count)
            for _ in 0..<count {
                valuesArray.append(LinkedList<T>.init())
            }
            self.valuesArray = valuesArray
            self.handler = handler
        }
        
        public func send(_ index: Int, _ t: T) {
            valuesArray[index].insertAfterLast(t)
            mayEmit()
        }
        
        private func mayEmit() {
            for values in valuesArray {
                if values.count == 0 {
                    return
                }
            }
            
            var event: Array<T> = .init()
            event.reserveCapacity(valuesArray.count)
            
            for values in valuesArray {
                let headNode = values.firstNode!
                event.append(headNode.value)
                values.remove(node: headNode)
            }

            handler(event)
        }
        
        private let valuesArray: [LinkedList<T>]
        private let handler: ([T]) -> Void
    }
}
