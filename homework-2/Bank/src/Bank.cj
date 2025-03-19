package Bank

import std.collection.HashMap
import std.collection.ArrayList
import std.math.max
import std.core.StringBuilder
import std.format.*

public class Bank {
    let accounts: HashMap<String, Account>
    let transactions: ArrayList<String> 
    
    Bank() {
        accounts = HashMap<String, Account>()
        transactions = ArrayList<String>()
    }

    public func createAccount(accountType: Int, owner: String, id: String, initialBalance: Float64): Bool {
        if (accounts.contains(id)) {
            return false
        }
        var account: Account
        if (accountType == 0) {
            account = SavingsAccount(owner, id, initialBalance)
        } else if (accountType == 1) {
            account = CheckingAccount(owner, id, initialBalance)
        } else {
            return false
        }
        accounts.put(id, account)
        return true
    }

    public func deposit(id: String, amount: Float64): Bool {
        if (!accounts.contains(id)) {
            return false
        } else {
            accounts.get(id)?.deposit(amount)
            transactions.append("deposit ${amount.format(".2")}")
            return true
        }
    }

    public func withdraw(id: String, amount: Float64):Bool {
        if (!accounts.contains(id)) {
            return false
        } else {
            if (!accounts.get(id).getOrThrow().withdraw(amount)) {
                return false
            }
            transactions.append("withdraw ${amount.format(".2")}")
            return true
        }
    }

    public func transfer(sourceId: String, targetId: String, amount: Float64): Bool {
        if (!accounts.contains(sourceId) || !accounts.contains(targetId)) {
            return false
        } else {
            let source = accounts.get(sourceId).getOrThrow()
            let target = accounts.get(targetId).getOrThrow()
            if (!source.withdraw(amount)) {
                return false
            }
            target.deposit(amount)
            transactions.append("transfer ${amount.format(".2")}")
            return true
        }
    }

    public func getAccountInfo(id: String): String {
        if (!accounts.contains(id)) {
            return "Error"
        } else {
            return accounts.get(id).getOrThrow().getInfo()
        }
    }

    public func getHistory(): String {
        let size = transactions.size
        let start = max(0, size - 5)
        let sb = StringBuilder()
        for (i in start .. size) {
            sb.append(transactions.get(i).getOrThrow())
            if (i < size - 1) {
                sb.append('\n')
            }
        }
        return sb.toString()
    }
}
