extension EventSourceProtocol {
    @discardableResult
    public func subscribeOnce(handler: @escaping (Event) -> Void) -> Disposer {
        let disposer = CompositeDisposer()
        
        let innerDisposer = subscribe { event in
            handler(event)
            disposer.dispose()
        }
        
        //  即座に発火していた場合、ここで即disposeされる。
        disposer.add(innerDisposer)

        return disposer
    }
}
