public protocol DisposerProtocol {
    func dispose()
    
    func asDisposer() -> Disposer
}

extension DisposerProtocol {
    public func asDisposer() -> Disposer {
        return Disposer { self.dispose() }
    }
}

public class Disposer : DisposerProtocol {
    public init(_ f: (() -> Void)?) {
        self.f = f
    }
    
    public func dispose() {
        guard let f = self.f else {
            return
        }
        self.f = nil
        f()
    }
    
    public func asDisposer() -> Disposer {
        return self
    }
    
    private var f: (() -> Void)?
}
