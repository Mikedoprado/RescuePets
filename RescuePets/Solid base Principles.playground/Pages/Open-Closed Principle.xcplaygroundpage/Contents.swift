//: [Previous](@previous)

import Foundation

/*
 MARK: Open closed principle
 The class should be open to extension but closed to modification
 */
protocol Specification{
    associatedtype T
    func isSatisfied(_ item: T) -> Bool
}

protocol Filter{
    associatedtype T
    func filter<Spec: Specification>(_ items : [T], _ spec: Spec) ->[T]
        where Spec.T == T
}

class ColorSpecification : Specification {
    
    typealias T = Product
    
    let color : Color
    init(_ color: Color){
        self.color = color
    }
    
    func isSatisfied(_ item: Product) -> Bool {
        return item.color == color
    }
}

class SizeSpecification : Specification {
    
    typealias T = Product
    
    let size : Size
    init(_ size: Size){
        self.size = size
    }
    
    func isSatisfied(_ item: Product) -> Bool {
        return item.size == size
    }
}

class AndSpecification<T, SpecA: Specification, SpecB: Specification> : Specification where SpecA.T == SpecB.T, T == SpecA.T, T == SpecB.T {
    
    let first : SpecA
    let second : SpecB
    
    init(_ first: SpecA, _ second : SpecB){
        self.first = first
        self.second = second
    }
    
    func isSatisfied(_ item: T) -> Bool {
        return first.isSatisfied(item) && second.isSatisfied(item)
    }
}

class BetterFilter : Filter {
    typealias T = Product
    
    func filter<Spec : Specification>(_ items: [Product], _ spec: Spec) -> [T] where Spec.T == T {
        return items.filter { spec.isSatisfied($0) }
    }
}


enum Color{
    case red, green, blue
}

enum Size{
    case small, medium, large, huge
}

class Product {
    var name : String
    var color : Color
    var size : Size
    
    init(_ name: String, _ color: Color, _ size: Size){
        self.name = name
        self.color = color
        self.size = size
    }
}


class ProductFilter{
    func filterByColor(_ products: [Product], _ color: Color) -> [Product]{
        return products.filter{$0.color == color}
    }
}

func main(){
    
    let apple = Product("Apple", .green, .small)
    let tree = Product("Tree", .green, .large)
    let house = Product("House", .blue, .large)
    
    let products = [apple, tree, house]
    
    let pf = ProductFilter()
    print("Green products (old):")
    for p in pf.filterByColor(products, .green){
        print(" - \(p.name) is green")
    }
    print("-------------------------")
    print("Green products (new):")
    let bf = BetterFilter()
    for p in bf.filter(products, SizeSpecification(.large)){
        print(" - \(p.name) is large")
    }
    print("-------------------------")
    for p in bf.filter(products, AndSpecification(ColorSpecification(.green), SizeSpecification(.small))){
        print(" - \(p.name) is \(p.size) and \(p.color)")
    }
}
main()
//: [Next](@next)
