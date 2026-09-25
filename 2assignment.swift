import Playgrounds

#Playground {
    //1
    let fruits = ["Apple", "Banana", "Cherry", "Mango", "Orange"]
    print(fruits[2])   // Cherry
    
    //2
    var favoriteNumbers: Set<Int> = [7, 13, 21]
    favoriteNumbers.insert(42)
    print(favoriteNumbers)   // например: [21, 7, 42, 13]
    
    //3
    let languages = ["Swift": 2014, "Python": 1991, "Java": 1995]
    print(languages["Swift"] ?? 0)   // 2014
    
    //4
    var colors = ["Red", "Green", "Blue", "Yellow"]
    colors[1] = "Purple"
    print(colors)   // ["Red", "Purple", "Blue", "Yellow"]
    
    //m1
    let setA: Set<Int> = [1, 2, 3, 4]
    let setB: Set<Int> = [3, 4, 5, 6]
    let common = setA.intersection(setB)
    print(common)   // [3, 4] (порядок может отличаться)
    
    //m2
    var scores = ["Ali": 85, "Dana": 90, "Arman": 78]
    scores.updateValue(95, forKey: "Arman")
    print(scores)   // ["Ali": 85, "Dana": 90, "Arman": 95] (порядок может отличаться)
    
    //m3
    let first = ["apple", "banana"]
    let second = ["cherry", "date"]
    let merged = first + second
    print(merged)   // ["apple", "banana", "cherry", "date"]
    
    //h1
    var populations = ["Kazakhstan": 20_000_000, "Japan": 124_000_000, "Germany": 84_000_000]
    populations["Canada"] = 40_000_000
    print(populations)
    
    //h2
    let pets1: Set<String> = ["cat", "dog"]
    let pets2: Set<String> = ["dog", "mouse"]

    let unionSet = pets1.union(pets2)            // ["cat", "dog", "mouse"]
    let result = unionSet.subtracting(pets2)     // ["cat"]
    print(result)   // ["cat"]
    
    //h3
    let studentGrades: [String: [Int]] = [
        "Ali": [85, 92, 78],
        "Dana": [90, 88, 95],
        "Arman": [70, 81, 89]
    ]

    let daneSecond = (studentGrades["Dana"] ?? [])[1]
    print(daneSecond)   // 88
    
    
}
