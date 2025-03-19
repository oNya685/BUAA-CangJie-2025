package Bank

import std.format.*

class SavingsAccount <: Account {
    public SavingsAccount(name: String, id: String, balance: Float64) { super(name, id, balance) }

    public override func withdraw(amount: Float64): Bool {
        if (balance < amount) {
            return false
        }
        balance -= amount
        return true
    }

    public override func getInfo(): String {
        return "saving account, id: ${id}, owner: ${name}, balance: ${balance.format(".2")}"
    }
}