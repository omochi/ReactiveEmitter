public protocol DisposerProtocol {
    func dispose()
    
    func asDisposer() -> Disposer
}

extension DisposerProtocol {
    public func asDisposer() -> Disposer {
        return Disposer.init(self)
    }
}

