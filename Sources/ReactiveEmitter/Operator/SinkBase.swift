//
//  SinkBase.swift
//  ReactiveEmitter
//
//  Created by omochimetaru on 2017/11/14.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class SinkBase<U> {
    public init(handler: @escaping (U) -> Void) {
        _disposer = .init()
        self.handler = handler
    }
    
    
    public var disposer: Disposer {
        return _disposer.asDisposer()
    }
    
    public func emit(_ u: U) {
        handler(u)
    }
    
    public func addDisposer(_ disposer: Disposer) {
        _disposer.add(disposer)
    }
    
    private let _disposer: CompositeDisposer
    private let handler: (U) -> Void

}
