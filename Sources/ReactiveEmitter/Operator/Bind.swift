extension EventSourceProtocol {
    public func bind<X: EventSinkProtocol>(to sink: X) -> Disposer
        where Event == X.Event
    {
        return self.subscribe { sink.send(event: $0) }
    }
}
