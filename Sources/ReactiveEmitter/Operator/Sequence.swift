public func sequence<X: EventSourceProtocol>(_ streamOrNone: X?) -> EventSource<X.Event?> {
    guard let stream = streamOrNone else {
        return .of(nil)
    }
    return stream.map { event -> X.Event? in
        .some(event) }
}

