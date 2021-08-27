import UIKit

let array = [-1,-2,-3,-4,-5]

var target = -8

func twoSum(_ nums: [Int], _ target: Int) -> [Int] { //o(n)
    
    var dict = [Int: Int]()
    
    for (i, num) in nums.enumerated() {
        if dict[target-num] != nil {
            if i != dict[target-num] {
                return [dict[target-num]!, i]
            }
        }
        dict[num] = i
    }
    return[0]
}

func twoSum2(_ nums: [Int], _ target: Int) -> [Int] { //o(n)
    
    var dict = [Int: Int]()
    
    var left = 0
    var right = nums.count - 1
    
    while left < nums.count - 1{
        if dict[target - nums[left]] != nil {
            print("1")
            if left != dict[target - nums[left]] {
                return [dict[target - nums[left]]!, left]
            }
        }
        dict[target - nums[left]] = left
        left += 1
        if dict[target - nums[right]] != nil {
            if right != dict[target - nums[right]] {
                return [dict[target - nums[right]]!, right]
            }
        }
        dict[target - nums[right]] = right
        right -= 1
        print(dict[target - nums[right]])
        print(dict)
    }
    return[0]
}

//print(twoSum(array, target))
print(twoSum2(array, target))

func twoSumBruteForce(_ nums: [Int], _ target: Int) -> [Int] {
    
    var result = [Int]()
    let mod = nums.map{ ($0 <= target) ? abs($0 - target) : -1 }
    
    for (i, num) in nums.enumerated() {
        if mod.contains(num){
            let index = mod.firstIndex(of: num)!
            if i != index{
                result.append(i)
                result.append(index)
                return result
            }
        }
    }
    return []
}
print((-10) - (9))
//print(twoSumBruteForce(array, target))


