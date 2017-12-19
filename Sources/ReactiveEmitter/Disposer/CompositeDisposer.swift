import Foundation

public class CompositeDisposer : DisposerProtocol {
    public init() {
        queue = DispatchQueue.init(label: "\(type(of: self))")
    }
    
    public convenience init(_ disposers: [Disposer]) {
        self.init()
        add(contentsOf: disposers)
    }
    
    public func dispose() {
        while let disposer = self.popDisposer() {
            disposer.dispose()
        }
        
        queue.sync {
            self.disposed = true
        }
    }
    
    public func add<X: DisposerProtocol>(_ disposer: X) {
        if (queue.sync { disposed }) {
            disposer.dispose()
            return
        }

        let _ = queue.sync {
            self.disposers.insertAfterLast(disposer.asDisposer())
        }
    }
    
    public func add<X: Sequence>(contentsOf disposers: X)
        where X.Element: DisposerProtocol
    {
        disposers.forEach { d in
            add(d)
        }
    }
    
    private typealias Disposers = LinkedList<Disposer>
    
    private func popDisposer() -> Disposer? {
        return queue.sync {
            guard let d = disposers.first else {
                return nil
            }
            disposers.remove(node: disposers.firstNode!)
            return d
        }
    }
    
    private var disposed: Bool = false
    private var disposers: Disposers = .init()
    private let queue: DispatchQueue
}
