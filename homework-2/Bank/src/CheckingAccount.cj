package Bank

import std.format.*

class CheckingAccount <: Account {
    public CheckingAccount(name: String, id: String, balance: Float64) { super(name, id, balance) }

    public override func withdraw(amount: Float64): Bool {
        balance -= amount
        return true
    }

    public override func getInfo(): String {
        return "checking account, id: ${id}, owner: ${name}, balance: ${balance.format(".2")}"
    }
}