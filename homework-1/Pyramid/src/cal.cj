package Pyramid

public func getPyramid (n: Int64): Array<String> {
    let stringArray = Array<String>(n, item: "")
    let pyramidArray = Array<Int64>(n * (n + 1) / 2, item: 0)
    // let count = 0i64
    for (i in 0 .. n) {
        var str: String = ""
        for (j in 0 ..= i) {
            var result: Int64 = 0
            if (i == 0 || j == 0 || j == i) {
                result = 1
            } else {
                result = pyramidArray[getPos(i - 1, j - 1)] + pyramidArray[getPos(i - 1, j)]
            }
            pyramidArray[getPos(i, j)] = result
            str += result.toString() + " "
        }
        stringArray[i] = str
    }
    return stringArray
}

private func getPos(x: Int64, y: Int64): Int64 {
    return x * (x - 1) / 2 + y
}