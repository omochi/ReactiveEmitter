internal protocol FactoryInitializable {
    init(factory: () -> Self)
}

extension FactoryInitializable {
    init(factory: () -> Self) {
        self = factory()
    }
}
