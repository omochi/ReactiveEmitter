//
//  Combine.swift.gysb
//  ReactiveEmitter
//
//  Created by omochimetaru on 2017/11/17.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source
    ) -> EventSource<(T0Source.Event, T1Source.Event)>
{
    return EventSourceCombine2(
        source0: source0,
        source1: source1
        ).asEventSource()
}

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol,
    T2Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source,
    _ source2: T2Source
    ) -> EventSource<(T0Source.Event, T1Source.Event, T2Source.Event)>
{
    return EventSourceCombine3(
        source0: source0,
        source1: source1,
        source2: source2
        ).asEventSource()
}

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol,
    T2Source: EventSourceProtocol,
    T3Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source,
    _ source2: T2Source,
    _ source3: T3Source
    ) -> EventSource<(T0Source.Event, T1Source.Event, T2Source.Event, T3Source.Event)>
{
    return EventSourceCombine4(
        source0: source0,
        source1: source1,
        source2: source2,
        source3: source3
        ).asEventSource()
}

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol,
    T2Source: EventSourceProtocol,
    T3Source: EventSourceProtocol,
    T4Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source,
    _ source2: T2Source,
    _ source3: T3Source,
    _ source4: T4Source
    ) -> EventSource<(T0Source.Event, T1Source.Event, T2Source.Event, T3Source.Event, T4Source.Event)>
{
    return EventSourceCombine5(
        source0: source0,
        source1: source1,
        source2: source2,
        source3: source3,
        source4: source4
        ).asEventSource()
}

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol,
    T2Source: EventSourceProtocol,
    T3Source: EventSourceProtocol,
    T4Source: EventSourceProtocol,
    T5Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source,
    _ source2: T2Source,
    _ source3: T3Source,
    _ source4: T4Source,
    _ source5: T5Source
    ) -> EventSource<(T0Source.Event, T1Source.Event, T2Source.Event, T3Source.Event, T4Source.Event, T5Source.Event)>
{
    return EventSourceCombine6(
        source0: source0,
        source1: source1,
        source2: source2,
        source3: source3,
        source4: source4,
        source5: source5
        ).asEventSource()
}

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol,
    T2Source: EventSourceProtocol,
    T3Source: EventSourceProtocol,
    T4Source: EventSourceProtocol,
    T5Source: EventSourceProtocol,
    T6Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source,
    _ source2: T2Source,
    _ source3: T3Source,
    _ source4: T4Source,
    _ source5: T5Source,
    _ source6: T6Source
    ) -> EventSource<(T0Source.Event, T1Source.Event, T2Source.Event, T3Source.Event, T4Source.Event, T5Source.Event, T6Source.Event)>
{
    return EventSourceCombine7(
        source0: source0,
        source1: source1,
        source2: source2,
        source3: source3,
        source4: source4,
        source5: source5,
        source6: source6
        ).asEventSource()
}

public func combine<
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol,
    T2Source: EventSourceProtocol,
    T3Source: EventSourceProtocol,
    T4Source: EventSourceProtocol,
    T5Source: EventSourceProtocol,
    T6Source: EventSourceProtocol,
    T7Source: EventSourceProtocol
    >(
    _ source0: T0Source,
    _ source1: T1Source,
    _ source2: T2Source,
    _ source3: T3Source,
    _ source4: T4Source,
    _ source5: T5Source,
    _ source6: T6Source,
    _ source7: T7Source
    ) -> EventSource<(T0Source.Event, T1Source.Event, T2Source.Event, T3Source.Event, T4Source.Event, T5Source.Event, T6Source.Event, T7Source.Event)>
{
    return EventSourceCombine8(
        source0: source0,
        source1: source1,
        source2: source2,
        source3: source3,
        source4: source4,
        source5: source5,
        source6: source6,
        source7: source7
        ).asEventSource()
}

public class EventSourceCombine2<T0Source, T1Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event

    public init(source0: T0Source, source1: T1Source) {
        self.source0 = source0
        self.source1 = source1
    }
    
    public func subscribe(handler: @escaping ((T0, T1)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source

    private class Sink: SinkBase<(T0, T1)> {
        public override init(handler: @escaping (T0, T1) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1 else
            {
                return
            }
            
            emit((t0, t1))
        }
        
        private var t0: T0?
        private var t1: T1?
    }
}

public class EventSourceCombine3<T0Source, T1Source, T2Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol, 
    T2Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    public typealias T2 = T2Source.Event

    public init(source0: T0Source, source1: T1Source, source2: T2Source) {
        self.source0 = source0
        self.source1 = source1
        self.source2 = source2
    }
    
    public func subscribe(handler: @escaping ((T0, T1, T2)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        sink.addDisposer(source2.subscribe { sink.send2($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source
    private let source2: T2Source

    private class Sink: SinkBase<(T0, T1, T2)> {
        public override init(handler: @escaping (T0, T1, T2) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        public func send2(_ t2: T2) {
            self.t2 = t2
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1,
                let t2 = t2 else
            {
                return
            }
            
            emit((t0, t1, t2))
        }
        
        private var t0: T0?
        private var t1: T1?
        private var t2: T2?
    }
}

public class EventSourceCombine4<T0Source, T1Source, T2Source, T3Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol, 
    T2Source: EventSourceProtocol, 
    T3Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    public typealias T2 = T2Source.Event
    public typealias T3 = T3Source.Event

    public init(source0: T0Source, source1: T1Source, source2: T2Source, source3: T3Source) {
        self.source0 = source0
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
    }
    
    public func subscribe(handler: @escaping ((T0, T1, T2, T3)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        sink.addDisposer(source2.subscribe { sink.send2($0) })
        sink.addDisposer(source3.subscribe { sink.send3($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source
    private let source2: T2Source
    private let source3: T3Source

    private class Sink: SinkBase<(T0, T1, T2, T3)> {
        public override init(handler: @escaping (T0, T1, T2, T3) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        public func send2(_ t2: T2) {
            self.t2 = t2
            mayEmit()
        }
        public func send3(_ t3: T3) {
            self.t3 = t3
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1,
                let t2 = t2,
                let t3 = t3 else
            {
                return
            }
            
            emit((t0, t1, t2, t3))
        }
        
        private var t0: T0?
        private var t1: T1?
        private var t2: T2?
        private var t3: T3?
    }
}

public class EventSourceCombine5<T0Source, T1Source, T2Source, T3Source, T4Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol, 
    T2Source: EventSourceProtocol, 
    T3Source: EventSourceProtocol, 
    T4Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    public typealias T2 = T2Source.Event
    public typealias T3 = T3Source.Event
    public typealias T4 = T4Source.Event

    public init(source0: T0Source, source1: T1Source, source2: T2Source, source3: T3Source, source4: T4Source) {
        self.source0 = source0
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
    }
    
    public func subscribe(handler: @escaping ((T0, T1, T2, T3, T4)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        sink.addDisposer(source2.subscribe { sink.send2($0) })
        sink.addDisposer(source3.subscribe { sink.send3($0) })
        sink.addDisposer(source4.subscribe { sink.send4($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source
    private let source2: T2Source
    private let source3: T3Source
    private let source4: T4Source

    private class Sink: SinkBase<(T0, T1, T2, T3, T4)> {
        public override init(handler: @escaping (T0, T1, T2, T3, T4) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        public func send2(_ t2: T2) {
            self.t2 = t2
            mayEmit()
        }
        public func send3(_ t3: T3) {
            self.t3 = t3
            mayEmit()
        }
        public func send4(_ t4: T4) {
            self.t4 = t4
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1,
                let t2 = t2,
                let t3 = t3,
                let t4 = t4 else
            {
                return
            }
            
            emit((t0, t1, t2, t3, t4))
        }
        
        private var t0: T0?
        private var t1: T1?
        private var t2: T2?
        private var t3: T3?
        private var t4: T4?
    }
}

public class EventSourceCombine6<T0Source, T1Source, T2Source, T3Source, T4Source, T5Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol, 
    T2Source: EventSourceProtocol, 
    T3Source: EventSourceProtocol, 
    T4Source: EventSourceProtocol, 
    T5Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    public typealias T2 = T2Source.Event
    public typealias T3 = T3Source.Event
    public typealias T4 = T4Source.Event
    public typealias T5 = T5Source.Event

    public init(source0: T0Source, source1: T1Source, source2: T2Source, source3: T3Source, source4: T4Source, source5: T5Source) {
        self.source0 = source0
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
        self.source5 = source5
    }
    
    public func subscribe(handler: @escaping ((T0, T1, T2, T3, T4, T5)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        sink.addDisposer(source2.subscribe { sink.send2($0) })
        sink.addDisposer(source3.subscribe { sink.send3($0) })
        sink.addDisposer(source4.subscribe { sink.send4($0) })
        sink.addDisposer(source5.subscribe { sink.send5($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source
    private let source2: T2Source
    private let source3: T3Source
    private let source4: T4Source
    private let source5: T5Source

    private class Sink: SinkBase<(T0, T1, T2, T3, T4, T5)> {
        public override init(handler: @escaping (T0, T1, T2, T3, T4, T5) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        public func send2(_ t2: T2) {
            self.t2 = t2
            mayEmit()
        }
        public func send3(_ t3: T3) {
            self.t3 = t3
            mayEmit()
        }
        public func send4(_ t4: T4) {
            self.t4 = t4
            mayEmit()
        }
        public func send5(_ t5: T5) {
            self.t5 = t5
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1,
                let t2 = t2,
                let t3 = t3,
                let t4 = t4,
                let t5 = t5 else
            {
                return
            }
            
            emit((t0, t1, t2, t3, t4, t5))
        }
        
        private var t0: T0?
        private var t1: T1?
        private var t2: T2?
        private var t3: T3?
        private var t4: T4?
        private var t5: T5?
    }
}

public class EventSourceCombine7<T0Source, T1Source, T2Source, T3Source, T4Source, T5Source, T6Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol, 
    T2Source: EventSourceProtocol, 
    T3Source: EventSourceProtocol, 
    T4Source: EventSourceProtocol, 
    T5Source: EventSourceProtocol, 
    T6Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    public typealias T2 = T2Source.Event
    public typealias T3 = T3Source.Event
    public typealias T4 = T4Source.Event
    public typealias T5 = T5Source.Event
    public typealias T6 = T6Source.Event

    public init(source0: T0Source, source1: T1Source, source2: T2Source, source3: T3Source, source4: T4Source, source5: T5Source, source6: T6Source) {
        self.source0 = source0
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
        self.source5 = source5
        self.source6 = source6
    }
    
    public func subscribe(handler: @escaping ((T0, T1, T2, T3, T4, T5, T6)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        sink.addDisposer(source2.subscribe { sink.send2($0) })
        sink.addDisposer(source3.subscribe { sink.send3($0) })
        sink.addDisposer(source4.subscribe { sink.send4($0) })
        sink.addDisposer(source5.subscribe { sink.send5($0) })
        sink.addDisposer(source6.subscribe { sink.send6($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source
    private let source2: T2Source
    private let source3: T3Source
    private let source4: T4Source
    private let source5: T5Source
    private let source6: T6Source

    private class Sink: SinkBase<(T0, T1, T2, T3, T4, T5, T6)> {
        public override init(handler: @escaping (T0, T1, T2, T3, T4, T5, T6) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        public func send2(_ t2: T2) {
            self.t2 = t2
            mayEmit()
        }
        public func send3(_ t3: T3) {
            self.t3 = t3
            mayEmit()
        }
        public func send4(_ t4: T4) {
            self.t4 = t4
            mayEmit()
        }
        public func send5(_ t5: T5) {
            self.t5 = t5
            mayEmit()
        }
        public func send6(_ t6: T6) {
            self.t6 = t6
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1,
                let t2 = t2,
                let t3 = t3,
                let t4 = t4,
                let t5 = t5,
                let t6 = t6 else
            {
                return
            }
            
            emit((t0, t1, t2, t3, t4, t5, t6))
        }
        
        private var t0: T0?
        private var t1: T1?
        private var t2: T2?
        private var t3: T3?
        private var t4: T4?
        private var t5: T5?
        private var t6: T6?
    }
}

public class EventSourceCombine8<T0Source, T1Source, T2Source, T3Source, T4Source, T5Source, T6Source, T7Source> : EventSourceProtocol where
    T0Source: EventSourceProtocol, 
    T1Source: EventSourceProtocol, 
    T2Source: EventSourceProtocol, 
    T3Source: EventSourceProtocol, 
    T4Source: EventSourceProtocol, 
    T5Source: EventSourceProtocol, 
    T6Source: EventSourceProtocol, 
    T7Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    public typealias T2 = T2Source.Event
    public typealias T3 = T3Source.Event
    public typealias T4 = T4Source.Event
    public typealias T5 = T5Source.Event
    public typealias T6 = T6Source.Event
    public typealias T7 = T7Source.Event

    public init(source0: T0Source, source1: T1Source, source2: T2Source, source3: T3Source, source4: T4Source, source5: T5Source, source6: T6Source, source7: T7Source) {
        self.source0 = source0
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
        self.source5 = source5
        self.source6 = source6
        self.source7 = source7
    }
    
    public func subscribe(handler: @escaping ((T0, T1, T2, T3, T4, T5, T6, T7)) -> Void) -> Disposer {
        let sink = Sink(handler: handler)
        sink.addDisposer(source0.subscribe { sink.send0($0) })
        sink.addDisposer(source1.subscribe { sink.send1($0) })
        sink.addDisposer(source2.subscribe { sink.send2($0) })
        sink.addDisposer(source3.subscribe { sink.send3($0) })
        sink.addDisposer(source4.subscribe { sink.send4($0) })
        sink.addDisposer(source5.subscribe { sink.send5($0) })
        sink.addDisposer(source6.subscribe { sink.send6($0) })
        sink.addDisposer(source7.subscribe { sink.send7($0) })
        return sink.disposer
    }
    
    private let source0: T0Source
    private let source1: T1Source
    private let source2: T2Source
    private let source3: T3Source
    private let source4: T4Source
    private let source5: T5Source
    private let source6: T6Source
    private let source7: T7Source

    private class Sink: SinkBase<(T0, T1, T2, T3, T4, T5, T6, T7)> {
        public override init(handler: @escaping (T0, T1, T2, T3, T4, T5, T6, T7) -> Void) {
            super.init(handler: handler)
        }
        
        public func send0(_ t0: T0) {
            self.t0 = t0
            mayEmit()
        }
        public func send1(_ t1: T1) {
            self.t1 = t1
            mayEmit()
        }
        public func send2(_ t2: T2) {
            self.t2 = t2
            mayEmit()
        }
        public func send3(_ t3: T3) {
            self.t3 = t3
            mayEmit()
        }
        public func send4(_ t4: T4) {
            self.t4 = t4
            mayEmit()
        }
        public func send5(_ t5: T5) {
            self.t5 = t5
            mayEmit()
        }
        public func send6(_ t6: T6) {
            self.t6 = t6
            mayEmit()
        }
        public func send7(_ t7: T7) {
            self.t7 = t7
            mayEmit()
        }
        
        private func mayEmit() {
            guard
                let t0 = t0,
                let t1 = t1,
                let t2 = t2,
                let t3 = t3,
                let t4 = t4,
                let t5 = t5,
                let t6 = t6,
                let t7 = t7 else
            {
                return
            }
            
            emit((t0, t1, t2, t3, t4, t5, t6, t7))
        }
        
        private var t0: T0?
        private var t1: T1?
        private var t2: T2?
        private var t3: T3?
        private var t4: T4?
        private var t5: T5?
        private var t6: T6?
        private var t7: T7?
    }
}

