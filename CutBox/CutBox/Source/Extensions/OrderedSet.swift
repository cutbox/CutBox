//
//  OrderedSet.swift
//
//  Written By Kai Chen
//  https://github.com/raywenderlich/swift-algorithm-club/tree/master/Ordered%20Set
//

import Foundation

public class OrderedSet<T: Hashable> {

    public var count: Int {
        return objects.count
    }

    private var objects: [T] = []
    private var indexOfKey: [T: Int] = [:]

    public init() {}

    public func add(_ object: T) {
        guard indexOfKey[object] == nil else {
            return
        }

        objects.append(object)
        indexOfKey[object] = objects.count - 1
    }

    public func insert(_ object: T, at index: Int) {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")

        guard indexOfKey[object] == nil else {
            return
        }

        objects.insert(object, at: index)
        indexOfKey[object] = index
        for idx in index + 1..<objects.count {
            indexOfKey[objects[idx]] = idx
        }
    }

    public func object(at index: Int) -> T {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")

        return objects[index]
    }

    public func set(_ object: T, at index: Int) {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")

        guard indexOfKey[object] == nil else {
            return
        }

        indexOfKey.removeValue(forKey: objects[index])
        indexOfKey[object] = index
        objects[index] = object
    }

    public func indexOf(_ object: T) -> Int {
        return indexOfKey[object] ?? -1
    }

    public func remove(_ object: T) {
        guard let index = indexOfKey[object] else {
            return
        }

        indexOfKey.removeValue(forKey: object)
        objects.remove(at: index)
        for idx in index..<objects.count {
            indexOfKey[objects[idx]] = idx
        }
    }

    public func all() -> [T] {
        return objects
    }
}
