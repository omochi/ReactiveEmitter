public class FuncDisposer : DisposerProtocol {
    public init(_ f: @escaping () -> Void) {
        self.f = f
    }
    
    public func dispose() {
        f()
    }
    
    private var f: () -> Void
}

