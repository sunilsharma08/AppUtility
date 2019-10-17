//
//  AUDispatchQueue.swift
//  AppUtilityExample
//
//  Created by Apple on 29/05/17.
//  Copyright © 2017 Sunil Sharma. All rights reserved.
//

#if canImport(Foundation)
import Foundation

extension DispatchQueue {
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}

// MARK: - Properties
public extension DispatchQueue {

    /// SwifterSwift: A Boolean value indicating whether the current dispatch queue is the main queue.
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }

}

// MARK: - Methods
public extension DispatchQueue {

    /// SwifterSwift: Returns a Boolean value indicating whether the current dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue is the specified queue, otherwise `false`.
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }

}

#endif
