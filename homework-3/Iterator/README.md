# 习题一

## 要求

补全提供的代码。设计生肖迭代器类，通过`for-in 表达式`遍历其对象时可以输出所有生肖，根据需求补全类即可。

## 示例

> 输出：
> 
>   ```
>   中国十二生肖:
>   鼠 牛 虎 兔 龙 蛇 马 羊 猴 鸡 狗 猪 
>   
>   生肖列表(ArrayList):
>   鼠 牛 虎 兔 龙 蛇 马 羊 猴 鸡 狗 猪 
>   
>   生肖及对应年份(HashMap):
>   鼠年: 2020
>   牛年: 2021
>   虎年: 2022
>   兔年: 2023
>   龙年: 2024
>   蛇年: 2025
>   马年: 2026
>   羊年: 2027
>   猴年: 2028
>   鸡年: 2029
>   狗年: 2030
>   猪年: 2031
>   
>   使用while-let遍历:
>   鼠 牛 虎 兔 龙 蛇 马 羊 猴 鸡 狗 猪 
>   
>   ```


## 待补全代码

```CangJie
import std.collection.ArrayList
import std.collection.HashMap

// 自定义实现了Iterable接口的生肖迭代器
class Zodiac <: Iterable<String> {
    // TODO(1/2): 实现 func iterator()
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
```