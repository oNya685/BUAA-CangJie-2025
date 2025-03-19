package Bank

abstract class Account {
    public Account(let name: String, let id: String, var balance: Float64) {}

    public func deposit(amount: Float64) {
        balance += amount
    }

    public func withdraw(amount: Float64): Bool

    public func getInfo(): String
}