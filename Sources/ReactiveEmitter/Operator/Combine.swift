//
//  Combine.swift
//  ReactiveEmitter
//
//  Created by omochimetaru on 2017/11/14.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class EventSourceCombine2<T0Source, T1Source> where
    T0Source: EventSourceProtocol,
    T1Source: EventSourceProtocol
{
    public typealias T0 = T0Source.Event
    public typealias T1 = T1Source.Event
    
    public init(source0: T0Source, source1: T1Source) {
        self.source0 = source0
        self.source1 = source1
    }
    
    public func subscribe(_ handler: @escaping (T0, T1) -> Void) -> Disposer {
        
    }
    
    private let source0: T0Source
    private let source1: T1Source
}
