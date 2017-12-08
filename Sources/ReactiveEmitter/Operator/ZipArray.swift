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
            valuesArray = Array<[T]>.init(repeating: [], count: count)
            self.handler = handler
        }
        
        public func send(_ index: Int, _ t: T) {
            valuesArray[index].append(t)
            mayEmit()
        }
        
        private func mayEmit() {
            for values in valuesArray {
                if values.count == 0 {
                    return
                }
            }
            
            var event: [T] = []
            
            for i in 0..<valuesArray.count {
                var values = valuesArray[i]
                let headValue = values.removeFirst()
                event.append(headValue)
                valuesArray[i] = values
            }

            handler(event)
        }
        
        private var valuesArray: [[T]]
        private let handler: ([T]) -> Void
    }
}
