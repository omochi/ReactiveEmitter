//
//  Never.swift
//  ReactiveEmitter
//
//  Created by omochimetaru on 2017/11/22.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class EventSourceNever<T> : EventSourceProtocol {
    public typealias Event = T
    
    public func subscribe(handler: @escaping (T) -> Void) -> Disposer {
        return Disposer {}
    }
}

extension EventSource {
    public static func never<T>() -> EventSource<T> {
        return EventSourceNever<T>.init().asEventSource()
    }
}
