import Foundation

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
        self.lock = NSLock()
    }
    
    public func dispose() {
        let f: (() -> Void)? = lock.scope {
            let sf = self.f
            self.f = nil
            return sf
        }
    
        f?()
    }
    
    public func asDisposer() -> Disposer {
        return self
    }
    
    private var f: (() -> Void)?
    private let lock: NSLock
}
