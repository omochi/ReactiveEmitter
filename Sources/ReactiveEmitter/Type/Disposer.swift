public final class Disposer : DisposerProtocol {
    public init<X: DisposerProtocol>(_ base: X) {
        self.box = _DisposerBox<X>(base)
    }
    
    public init() {
        self.box = _DisposerBox(NopDisposer.init())
    }
    
    public init(_ f: @escaping () -> Void) {
        self.box = _DisposerBox(FuncDisposer.init(f))
    }
    
    public init(_ disposers: [Disposer]) {
        self.box = _DisposerBox(CompositeDisposer.init(disposers))
    }
    
    public func dispose() {
        box.dispose()
    }
    
    public func asDisposer() -> Disposer {
        return self
    }
    
    private let box: _AnyDisposerBox
}

internal class _AnyDisposerBox {
    public func dispose() {
        fatalError("abstract")
    }
}

internal class _DisposerBox<X: DisposerProtocol> : _AnyDisposerBox {
    public init(_ base: X) {
        self.base = base
    }
    
    public override func dispose() {
        base.dispose()
    }
    
    private let base: X
}
