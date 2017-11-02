import Foundation

public class CompositeDisposer : DisposerProtocol {
    public init() {
        lock = NSLock()
    }
    
    public func dispose() {
        while true {
            let disposer: Disposer? = lock.scope {
                if let d = disposers.first {
                    disposers.removeFirst()
                    return d
                }
                return nil
            }
            
            guard let d = disposer else {
                break
            }
            
            d.dispose()
        }
    }
    
    public func add<X: DisposerProtocol>(_ disposer: X) {
        lock.scope {
            disposers.append(disposer.asDisposer())
        }
    }
    
    public func add<X: Sequence>(contentsOf disposers: X)
        where X.Element: DisposerProtocol
    {
        disposers.forEach { d in
            add(d)
        }
    }
    
    private var disposers: [Disposer] = []
    private let lock: NSLock
}
