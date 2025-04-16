package MacrosAndSyntaxTrees

import MacrosAndSyntaxTrees.macros.*

@log
func getIndex(list: Array<Int64>, num: Int64): Int64 {
    var index = 0
    for (item in list) {
        if (item == num) {
            return index
        }
        index += 1
    }
    return -1
}

main(): Int64 {
    getIndex([1, 2, 3, 4, 5], 3)
    getIndex([1, 2, 3, 4, 5], 0)
}