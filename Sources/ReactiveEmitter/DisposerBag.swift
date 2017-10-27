public class DisposerBag {
    public init() {}
    
    deinit {
        cd.dispose()
    }
    
    public func add<X: DisposerProtocol>(_ disposer: X) {
        cd.add(disposer)
    }

    private let cd: CompositeDisposer = .init()
}

extension DisposerProtocol {
    public func disposed(by bag: DisposerBag) {
        bag.add(self)
    }
}
