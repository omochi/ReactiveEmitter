public class OperatorSinkBase<U> {
    public init(handler: @escaping (U) -> Void) {
        _disposer = .init()
        self.handler = handler
    }

    public var disposer: Disposer {
        return _disposer.asDisposer()
    }
    
    public func emit(event: U) {
        handler(event)
    }
    
    public func addDisposer(_ disposer: Disposer) {
        _disposer.add(disposer)
    }
    
    private let _disposer: CompositeDisposer
    private let handler: (U) -> Void
}
