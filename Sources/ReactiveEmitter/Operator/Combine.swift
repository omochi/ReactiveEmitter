//
//  Combine.swift
//  ReactiveEmitter
//
//  Created by omochimetaru on 2017/11/14.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

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
            guard let t0 = t0,
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


public func combine<
    TSource0: EventSourceProtocol,
    TSource1: EventSourceProtocol>(
    _ source0: TSource0,
    _ source1: TSource1)
    -> EventSource<(TSource0.Event, TSource1.Event)>
{
    return EventSourceCombine2(source0: source0, source1: source1).asEventSource()
}

