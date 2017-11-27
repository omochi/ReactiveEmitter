import XCTest
@testable import ReactiveEmitter

class ArrayPropertyTests: XCTestCase {
    func test0() {
        let a = ArrayProperty<Int>.init([0, 1, 2, 3])
        var ary: [Int] = .init(a.value)
        a.value.forEach {
            print($0)
        }
    }
}
