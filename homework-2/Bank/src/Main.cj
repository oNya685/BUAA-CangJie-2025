package Bank

import std.console.Console
import std.convert.Parsable

main() {
    let bank = Bank()
    while (true) {
        let tokens = Console.stdIn.readln().getOrThrow()
            .split(' ', removeEmpty: true)
        if (tokens.isEmpty()) { continue }
        if (!commandDispatcher(bank, tokens)) { break }
    }
}

func commandDispatcher(bank: Bank, commandTokens: Array<String>): Bool {
    let command = commandTokens[0]
    match (command) {
        case "Exit" => return false
        case "create" => 
            if (commandTokens.size != 5) {
                Console.stdOut.writeln("Error: Invalid number of arguments in creating account")
                return true
            }
            try {
                let accountType = Int.parse(commandTokens[1])
                let initialBalance = Float64.parse(commandTokens[4])
                if (!bank.createAccount(accountType, commandTokens[2], commandTokens[3], initialBalance)) {
                    Console.stdOut.writeln("Error")
                }
                return true
            } catch (e: Exception) {
                Console.stdOut.writeln("Unknown Error: ${e}")
                return false
            }
        case "deposit" =>
            if (commandTokens.size != 3) {
                Console.stdOut.writeln("Error: Invalid number of arguments in depositing")
                return true
            }
            try {
                let amount = Float64.parse(commandTokens[2])
                if (!bank.deposit(commandTokens[1], amount)) {
                    Console.stdOut.writeln("Error")
                }
                return true
            } catch (e: Exception) {
                Console.stdOut.writeln("Unknown Error: ${e}")
                return false
            }
        case "withdraw" =>
            if (commandTokens.size != 3) {
                Console.stdOut.writeln("Error: Invalid number of arguments in withdrawing")
                return true
            }
            try {
                let amount = Float64.parse(commandTokens[2])
                if (!bank.withdraw(commandTokens[1], amount)) {
                    Console.stdOut.writeln("Error")
                }
                return true
            } catch (e: Exception) {
                Console.stdOut.writeln("Unknown Error: ${e}")
                return false
            }
        case "transfer" =>
            if (commandTokens.size != 4) {
                Console.stdOut.writeln("Error: Invalid number of arguments in transferring")
                return true
            }
            try {
                let amount = Float64.parse(commandTokens[3])
                if (!bank.transfer(commandTokens[1], commandTokens[2], amount)) {
                    Console.stdOut.writeln("Error")
                }
                return true
            } catch (e: Exception) {
                Console.stdOut.writeln("Unknown Error: ${e}")
                return false
            }
        case "info" =>
            if (commandTokens.size != 2) {
                Console.stdOut.writeln("Error: Invalid number of arguments in printing info")
                return true
            }
            Console.stdOut.writeln(bank.getAccountInfo(commandTokens[1]))
            return true
        case "history" =>
            Console.stdOut.writeln(bank.getHistory())
            return true
        case _ => return true
    }
}
