package MacrosAndSyntaxTrees

import MacrosAndSyntaxTrees.macros.log

@log
func test(a: Int64, b: Int64) {
    return a + b
}

main(): Int64 {
    test(114, 514)
    return 0
}