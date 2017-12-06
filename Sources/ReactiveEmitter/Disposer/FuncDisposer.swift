internal class FuncDisposer : Disposer {
    public init(proc: @escaping () -> Void) {
        self.f = proc
        super.init(void: ())
    }
    
    public override func dispose() {
        f()
    }
    
    private var f: () -> Void
}

