public class CompositeDisposer : DisposerProtocol {
    public init() {}
    
    public func dispose() {
        while let disposer = disposers.first {
            disposers.removeFirst()
            disposer.dispose()
        }
    }
    
    public func add<X: DisposerProtocol>(_ disposer: X) {
        disposers.append(disposer.asDisposer())
    }
    
    public func add<X: Sequence>(contentsOf disposers: X)
        where X.Element: DisposerProtocol
    {
        self.disposers.append(contentsOf: disposers.map { $0.asDisposer() })
    }
    
    private var disposers: [Disposer] = []
}
