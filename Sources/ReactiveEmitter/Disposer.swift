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
        self.queue = DispatchQueue.init(label: "\(type(of: self))")
    }
    
    public func dispose() {
        let f: (() -> Void)? = queue.sync {
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
    private let queue: DispatchQueue
}
