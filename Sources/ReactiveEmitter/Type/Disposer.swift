public class Disposer : DisposerProtocol {
    public init<X: DisposerProtocol>(_ base: X) {
        self.box = _DisposerBox<X>(base)
    }
    
    public func dispose() {
        box.dispose()
    }
    
    public func asDisposer() -> Disposer {
        return self
    }
    
    private let box: _AnyDisposerBox
}

extension Disposer {
    public convenience init() {
        self.init(NopDisposer.init())
    }
    
    public convenience init(_ f: @escaping () -> Void) {
        self.init(FuncDisposer.init(f))
    }
}

public class _AnyDisposerBox {
    public func dispose() {
        fatalError("abstract")
    }
}

public class _DisposerBox<X: DisposerProtocol> : _AnyDisposerBox {
    public init(_ base: X) {
        self.base = base
    }
    
    public override func dispose() {
        base.dispose()
    }
    
    private let base: X
}
