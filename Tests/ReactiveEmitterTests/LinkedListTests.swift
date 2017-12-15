import XCTest
@testable import ReactiveEmitter

class LinkedListTests: XCTestCase {
    func test0() {
        let list = LinkedList<Int>.init()
        XCTAssertEqual(Array(list), [])
        
        let n0 = list.insertAfterLast(0)
        XCTAssertEqual(Array(list), [0])
        
        let n1 = list.insertAfterLast(1)
        XCTAssertEqual(Array(list), [0, 1])
        
        let n2 = list.insertAfterLast(2)
        XCTAssertEqual(Array(list), [0, 1, 2])
        
        list.insert(10, after: n0)
        XCTAssertEqual(Array(list), [0, 10, 1, 2])

        list.insert(11, after: n1)
        XCTAssertEqual(Array(list), [0, 10, 1, 11, 2])
        
        list.insert(12, after: n2)
        XCTAssertEqual(Array(list), [0, 10, 1, 11, 2, 12])
     
        list.remove(node: n1)
        XCTAssertEqual(Array(list), [0, 10, 11, 2, 12])
        
        list.remove(node: list.firstNode!)
        XCTAssertEqual(Array(list), [10, 11, 2, 12])

        list.remove(node: list.firstNode!.next!.next!.next!)
        XCTAssertEqual(Array(list), [10, 11, 2])
        
        list.remove(node: list.lastNode!.prev!)
        XCTAssertEqual(Array(list), [10, 2])
        
        list.remove(node: list.firstNode!)
        XCTAssertEqual(Array(list), [2])
        
        list.remove(node: n2)
        XCTAssertEqual(Array(list), [])
    }
    
    func test1() {
        let list = LinkedList<Int>.init()
        XCTAssertEqual(Array(list), [])
        
        let n0 = list.insertBeforeFirst(0)
        XCTAssertEqual(Array(list), [0])
        
        let n1 = list.insertBeforeFirst(1)
        XCTAssertEqual(Array(list), [1, 0])
        
        let n2 = list.insertBeforeFirst(2)
        XCTAssertEqual(Array(list), [2, 1, 0])
        
        list.insert(10, after: n0)
        XCTAssertEqual(Array(list), [2, 1, 0, 10])
        
        list.insert(11, after: n1)
        XCTAssertEqual(Array(list), [2, 1, 11, 0, 10])
        
        list.insert(12, after: n2)
        XCTAssertEqual(Array(list), [2, 12, 1, 11, 0, 10])
    }
}
