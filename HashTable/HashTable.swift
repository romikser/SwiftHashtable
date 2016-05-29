//
//  HashTable.swift
//  HashTable
//
//  Created by Roman Serga on 24/5/16.
//  Copyright © 2016 romikser. All rights reserved.
//

import Foundation

class Node<KeyType : Hashable , ValueType> : CustomStringConvertible {
    var key : KeyType?
    var value : ValueType?
    var empty : Bool = false
    
    init(key: KeyType?, value: ValueType?) {
        self.key = key
        self.value = value
    }
    
    var description: String {
        let address = unsafeAddressOf(self).debugDescription
        guard !self.empty else { return "Empty Node" }
        
        var keyDescription = ""
        var valueDescription = ""
        
        if let k = key as? CustomStringConvertible {
            keyDescription = k.description
        } else if let k = key as? String {
            keyDescription = k
        }
        
        if let v = value as? CustomStringConvertible {
            valueDescription = v.description
        } else if let v = value as?  String {
            valueDescription = v
        }
        
        var description = "Node: " + address
        if !keyDescription.isEmpty { description += " Key: " + keyDescription }
        if !valueDescription.isEmpty { description +=  " Value: " + valueDescription }

        return description
    }
}

class HashTable<KeyType : Hashable, ValueType> {
    
    typealias NodeType = Node<KeyType, ValueType>
    
    var values : [NodeType]
    var count : Int
    
    init (count : Int = 0) {
        self.count = count
        self.values = [NodeType]()
        for _ in 0..<count {
            let node = NodeType(key: nil, value: nil)
            node.empty = true
            self.values.append(node)
        }
    }
    
    func addValue(value: ValueType, forKey key : KeyType) {
        if let node = self.getNode(forKey: key) {
            node.value = value
            node.empty = false
        } else {
            if let emptyNode = self.findEmptyNode(forKey: key) {
                emptyNode.key = key
                emptyNode.value = value
                emptyNode.empty = false
            } else {
                self.increaseSizeBy(self.count)
                self.addValue(value, forKey: key)
            }
        }
    }
    
    private func findEmptyNode(forKey key : KeyType) -> NodeType? {
        var hasPassedTheEnd = false
        let startingIndex = hashForKey(key)
        var index = startingIndex
        while !self.values[index].empty && !(index == startingIndex && hasPassedTheEnd) {
            if index == self.count - 1 {
                index = 0
                hasPassedTheEnd = true
            } else {
                index += 1
            }
        }
        let node = self.values[index]
        return node.empty ? node : nil
    }
    
    func getValue(forKey key : KeyType) -> ValueType? {
        guard let node = self.getNode(forKey: key) else { return nil }
        return node.value
    }
    
    func deleteValue(forKey key: KeyType) {
        if let node = self.getNode(forKey: key) {
            node.empty = true
        }
    }
    
    private func increaseSizeBy(count : Int) {
        self.count += count
        for _ in 0..<count {
            let node = NodeType(key: nil, value: nil)
            node.empty = true
            self.values.append(node)
        }
    }
    
    private func getNode(forKey key : KeyType) -> NodeType? {
        var hasPassedTheEnd = false
        let startingIndex = hashForKey(key)
        var index = startingIndex
        while self.values[index].key != key && !(index == startingIndex && hasPassedTheEnd) {
            if index == self.count - 1 {
                index = 0
                hasPassedTheEnd = true
            } else {
                index += 1
            }
        }
        let node = self.values[index]
        return node.key == key && !node.empty ? node : nil
    }
    
    private func hashForKey(key : KeyType) -> Int {
        return key.hashValue % self.count
    }
    
}