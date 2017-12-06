import Foundation

public class CompositeDisposer : Disposer {
    private override init(void: Void) {
        queue = DispatchQueue.init(label: "\(type(of: self))")
        super.init(void: ())
    }
    
    public convenience init() {
        self.init(void: ())
    }
    
    public override func dispose() {
        while let disposer = self.popDisposer() {
            disposer.dispose()
        }
        
        queue.async {
            self.disposed = true
        }
    }
    
    public func add<X: DisposerProtocol>(_ disposer: X) {
        if (queue.sync { disposed }) {
            disposer.dispose()
            return
        }

        queue.async {
            self.disposers.append(disposer.asDisposer())
        }
    }
    
    public func add<X: Sequence>(contentsOf disposers: X)
        where X.Element: DisposerProtocol
    {
        disposers.forEach { d in
            add(d)
        }
    }
    
    private func popDisposer() -> Disposer? {
        return queue.sync {
            guard let d = disposers.first else {
                return nil
            }
            disposers.removeFirst()
            return d
        }
    }
    
    private var disposed: Bool = false
    private var disposers: [Disposer] = []
    private let queue: DispatchQueue
}
