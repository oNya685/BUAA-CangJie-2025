package Repeat

import std.console.Console
import std.convert.Parsable
import std.collection.HashMap

main(): Int64 {
    let map = HashMap<Int, Int>()
    let str_nums = Console.stdIn.readln().getOrThrow().split(' ', removeEmpty: true)
    for (str_num in str_nums) {
        let num = Int.parse(str_num)
        if (map.contains(num)) { map[num]++ }
        else { map[num] = 1 }
        if (map[num] == 2) { Console.stdOut.write(num.toString() + " ") }
    }
    return 0
}