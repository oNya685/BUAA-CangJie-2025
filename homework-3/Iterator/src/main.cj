package Iterator

import std.collection.ArrayList
import std.collection.HashMap

// 自定义实现了Iterable接口的生肖迭代器
class Zodiac <: Iterable<String> {
    // TODO(1/2): 实现 func iterator()
    public override func iterator(): Iterator<String> {
        return ZodiacIterator()
    }
}

// 定义生肖的迭代器
class ZodiacIterator <: Iterator<String> {
    private let zodiacs: Array<String> = [
        "鼠", "牛", "虎", "兔", "龙", "蛇", 
        "马", "羊", "猴", "鸡", "狗", "猪"
    ]
    private var index: Int = 0
    
    public func next(): Option<String> {
        // TODO(2/2): 实现Iterator接口要求的next()方法
        try {
            if (index < 12) { return zodiacs[index] }
            else { return Option.None }
        } finally { index += 1 }
    }
}

// 使用示例
main() {
    let zodiac = Zodiac()
    
    // 使用for-in直接遍历自定义的Iterable类型
    println("中国十二生肖:")
    for (animal in zodiac) {
        print("${animal} ")
    }
    println("\n")
    
    // 将生肖转换为ArrayList
    let zodiacList = ArrayList<String>()
    for (animal in Zodiac()) {
        zodiacList.append(animal)
    }

    println("生肖列表(ArrayList):")
    for (animal in zodiacList) {
        print("${animal} ")
    }
    println("\n")
    
    // 将生肖与对应年份创建HashMap
    let zodiacMap = HashMap<String, Int>()
    let baseYear = 2020  // 2020年是鼠年
    var year = baseYear
    for (animal in Zodiac()) {
        zodiacMap.put(animal, year)
        year += 1
    }

    println("生肖及对应年份(HashMap):")
    for ((animal, year) in zodiacMap) {
        println("${animal}年: ${year}")
    }
    println()
    
    // 使用while-let遍历方式
    println("使用while-let遍历:")
    var it = Zodiac().iterator()
    while (let Some(animal) <- it.next()) {
        print("${animal} ")
    }
    println()
}
