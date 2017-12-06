internal class NopDisposer : Disposer {
    public convenience init() {
        self.init(void: ())
    }
    
    public override func dispose() {}
}

