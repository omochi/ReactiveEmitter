import Foundation

public class CompositeDisposer : DisposerProtocol {
    public init() {
        queue = DispatchQueue.init(label: "\(type(of: self))")
    }
    
    public func dispose() {
        while true {
            let disposer: Disposer? = queue.sync {
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
        
        queue.sync {
            disposed = true
        }
    }
    
    public func add<X: DisposerProtocol>(_ disposer: X) {
        let dispose: Bool = queue.sync {
            if disposed {
                return true
            }

            disposers.append(disposer.asDisposer())
            return false
        }
        
        if dispose {
            disposer.dispose()
        }
    }
    
    public func add<X: Sequence>(contentsOf disposers: X)
        where X.Element: DisposerProtocol
    {
        disposers.forEach { d in
            add(d)
        }
    }
    
    private var disposed: Bool = false
    private var disposers: [Disposer] = []
    private let queue: DispatchQueue
}
