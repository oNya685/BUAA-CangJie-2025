package Pyramid

import std.console.*
import std.convert.*

main(): Int64 {
    printPyramid()
    return 0
}

private func printPyramid(out!: ConsoleWriter = Console.stdOut) {
    let n = Int64.parse(Console.stdIn.readln().getOrThrow())
    printStringArray(getPyramid(n), out)
}

private func printStringArray (stringArray: Array<String>, out: ConsoleWriter) {
    for (i in 0 .. stringArray.size) {
        out.writeln(stringArray[i])
    }
}