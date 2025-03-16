package PrimeSum

import std.console.*
import std.convert.*

main(): Int64 {
    Console.stdOut.writeln(
        primeFactorSum(
            Int64.parse(
                Console.stdIn.readln().getOrThrow()
            )
        )
    )
    return 0
}

private func primeFactorSum(n: Int64): Int64 {
    var total = 0

    var remainder = n
    var i = 2
    while (i <= remainder) {
        while (remainder % i == 0) {
            total += i
            remainder /= i
        }
        i += 1
    }
    return total
}