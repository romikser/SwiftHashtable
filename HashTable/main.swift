//
//  main.swift
//  HashTable
//
//  Created by Roman Serga on 22/5/16.
//  Copyright © 2016 romikser. All rights reserved.
//

import Foundation


let table = HashTable<Int, String>(count: 10)

print("Enter command: ")
while let command = readLine() where !command.hasPrefix("end") {
    let components = command.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    switch components[0] {
    case "print": for node in table.values { print(node.description) }
    case "add"  where components.count == 3:
        if let key = Int(components[1]) {
            let value = components[2]
            table.addValue(value, forKey: key)
        } else {
            print("Wrong Key Format")
        }
    case "get" where components.count == 2:
        if let key = Int(components[1]) {
            if let value = table.getValue(forKey: key) {
                print(value)
            } else {
                print("No value for key")
            }
        } else {
            print("Wrong Key Format")
        }
    case "delete" where components.count == 2:
        if let key = Int(components[1]) {
            print(table.deleteValue(forKey: key))
        } else {
            print("Wrong Key Format")
        }
    case "loadFactor":
        print(table.loadFactor)
    case "end": break
    default: print("Wrong Command")
    }
    print("Enter commant: ")
}
