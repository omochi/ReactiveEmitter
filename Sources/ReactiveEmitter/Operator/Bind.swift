extension EventSourceProtocol {
    public func bind<X: EventSinkConvertible>(to sinkConvertible: X) -> Disposer
        where Event == X._Event
    {
        let sink = sinkConvertible.asEventSink()
        let disposer = self.subscribe {
            sink.send(event: $0)
        }
        return disposer
    }
}
