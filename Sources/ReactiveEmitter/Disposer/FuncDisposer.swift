internal class FuncDisposer : DisposerProtocol {
    public init(_ proc: @escaping () -> Void) {
        self.f = proc
    }
    
    public func dispose() {
        f()
    }
    
    private var f: () -> Void
}

