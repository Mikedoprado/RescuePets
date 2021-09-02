import UIKit
import Foundation

class Node {
    var value: Int
    var next: Node?
    
    init(value: Int) {
        self.value = value
    }
}

class LinkedList {
    
    var head : Node?
    var lenght = 0
    
    init(head: Node?){
        self.head = head
        lenght += 1
    }

    func add(value: Int){
        
        let node = Node(value: value)
        let next = head
        node.next = next
        head = node
        lenght += 1
        
    }
    
    func remove(value: Int){
        
        if head?.value == value && head?.next == nil{
            head = nil
            lenght = lenght == 0 ? 0 : (lenght - 1)
            return
        }
        
        if head?.value == value {
            let node = head?.next
            head?.next = nil
            head = node!
            lenght = lenght == 0 ? 0 : (lenght - 1)
            return
        }
        
        var current = head?.next
        var preview = head
            
        while preview != nil {
            if current?.value == value {
                preview?.next = current?.next
                lenght = lenght == 0 ? 0 : (lenght - 1)
                return
            }
            preview = current!
            current = current?.next
        }
    }
    
    func printList(){
        
        if head == nil {
            print([])
            return
        }
        
        if head?.next == nil {
            print([head!.value])
            return
        }
        
        var current = head
        var arryItem = [Int]()
        while current?.next != nil {
            arryItem.append(current!.value)
            if current?.next?.next == nil {
                arryItem.append((current?.next!.value)!)
            }
            current = current?.next!
        }
        print(arryItem)
    }
}

var list = LinkedList(head: Node(value: 1))

//list.printList()

list.add(value: 7)
list.add(value: 9)
list.add(value: 8)

list.printList()
list.lenght

list.remove(value: 7)
list.remove(value: 1)
list.remove(value: 9)
list.remove(value: 8)
list.printList()




