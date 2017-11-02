import Foundation

extension NSLocking {
    internal func scope<R>(_ f: () throws -> R) rethrows -> R {
        self.lock()
        defer { self.unlock() }
        return try f()
    }
}
