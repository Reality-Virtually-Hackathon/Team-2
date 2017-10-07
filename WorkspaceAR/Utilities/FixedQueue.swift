//
//  FixedQueue.swift
//  WorkspaceAR
//
//  Created by Xiao Ling on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

//
//  FixedQueue.swift
//  Rainbow
//
//  Created by Xiao Ling on 9/13/17.
//  Copyright © 2017 Xiao Ling. All rights reserved.
//

import UIKit

public struct FixedQueue<T> {
    
    fileprivate var array = [T?]()
    fileprivate var head = 0
    var size : Int?
    
    public init(size: Int) {
        self.size = size
    }
    
    public func show(){
        print(self.array)
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        
        if self.array.count > self.size! {
            
            dequeue()
        }
        
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    // read all nonNil elements of queue as array
    
    public func read() -> [T]{
        
        var out : [T] = []
        
        for mt in self.array {
            
            if let t = mt {
                
                out.append(t)
            }
            
        }
        
        return out
        
        
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

