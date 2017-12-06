public class Disposer : DisposerProtocol, FactoryInitializable {
    internal init(void: Void) {}
    
    public convenience init() {
        self.init(factory: { NopDisposer.init(void: ()) })
    }
    
    public convenience init(_ f: @escaping () -> Void) {
        self.init(factory: { FuncDisposer.init(proc: f) })
    }
    
    public convenience init<X: DisposerProtocol>(_ base: X) {
        self.init(factory: { _DisposerBox.init(base: base) })
    }
    
    public func dispose() {
        fatalError("abstract")
    }
    
    public func asDisposer() -> Disposer {
        return self
    }
}

internal class _DisposerBox<X: DisposerProtocol> : Disposer {
    public init(base: X) {
        self.base = base
        super.init(void: ())
    }
    
    public override func dispose() {
        base.dispose()
    }
    
    private let base: X
}
