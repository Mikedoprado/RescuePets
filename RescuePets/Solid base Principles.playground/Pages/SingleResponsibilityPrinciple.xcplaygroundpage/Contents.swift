import UIKit

/*
 MARK: Single responsibility
 The class has just once reason to change, that means the class has its own specific area of responsibility
 */

class Journal : CustomStringConvertible {
    
    
    var entries = [String]()
    var count = 0
    
    func addEntries( _ text: String) -> Int{
        count += 1
        entries.append(text)
        return count - 1
    }
    
    func removeEntry(_ index: Int){
        entries.remove(at: index)
    }
    
    var description: String {
        return entries.joined(separator: "\n")
    }
}

func main(){
    let j = Journal()
    let _ = j.addEntries("I cry like a baby")
    let bug = j.addEntries("I ate a bug")
    
    print(j)
    
    j.removeEntry(bug)
    print("====")
    print(j)
    
}

main()
