//: [Previous](@previous)

import Foundation

/*
 MARK: Interface Segregation Principle
 Clients shouldn't be forced to depend on methods they don't use
 */

class Document {
    
}

protocol Machine{
    func print(d: Document)
    func scan(d: Document)
    func fax(d: Document)
}

protocol Printer{
    func print(d: Document)
}

protocol Scanner{
    func scan(d: Document)
}

protocol Fax{
    func fax(d: Document)
}

//: [Next](@next)
