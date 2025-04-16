macro package MacrosAndSyntaxTrees.macros

import std.ast.*
import std.collection.ArrayList

private func param_print_value(func_params: ArrayList<FuncParam>): String {
    let result = StringBuilder()
    var isFirst = true
    for (param in func_params) {
        let param_name = param.identifier.value
        if (isFirst) {
            result.append("${param_name} = \${${param_name}}")
            isFirst = false
        } else {
            result.append(", ${param_name} = \${${param_name}}")
        }
    }
    return result.toString()
}

private func get_assign_node(result_string: String, return_value_tokens: Tokens): Option<VarDecl> {
    if (return_value_tokens.size == 0) { return None }
    let assign_node_tokens = Tokens()
        .append(Token(LET))
        .append(Token(IDENTIFIER, result_string))
        .append(Token(ASSIGN))
        .append(return_value_tokens)
    return VarDecl(assign_node_tokens)
}

private func get_print_node(func_params: ArrayList<FuncParam>, result_string: String, return_value_tokens: Tokens): Option<CallExpr> {
    let print_value_string_builder = StringBuilder()
    print_value_string_builder.append(param_print_value(func_params))
    if (return_value_tokens.size != 0) {
        if (print_value_string_builder.size != 0) {
            print_value_string_builder.append(", ")
        }
        print_value_string_builder.append("return \${${result_string}}")
    }
    let result = CallExpr()
    result.callFunc = RefExpr(Token(IDENTIFIER, "println").toTokens())
    let argument = Argument()
    argument.expr = LitConstExpr(Token(STRING_LITERAL, print_value_string_builder.toString()).toTokens())
    result.arguments.append(argument)
    return result
}

private func get_return_node(result_string: String, return_value_tokens: Tokens): Option<ReturnExpr> {
    if (return_value_tokens.size == 0) { return None }
    let return_node_tokens = Tokens()
        .append(Token(RETURN))
        .append(Token(IDENTIFIER, result_string))
    return ReturnExpr(return_node_tokens)
}

private class ReturnVisitor <: Visitor {
    private var funcParams: ArrayList<FuncParam>

    public init(func_params: ArrayList<FuncParam>) {
        this.funcParams = func_params
    }

    public override func visit(block: Block): Unit {
        var i = 0
        while (i < block.nodes.size) {
            let inner_node = block.nodes[i]
            if (inner_node is ReturnExpr) {
                if ((inner_node as ReturnExpr).getOrThrow().expr is RefExpr && ((inner_node as ReturnExpr).getOrThrow().expr as RefExpr).getOrThrow().identifier.value == "__return_value_only_used_in_log_macro__") {
                    // do nothing
                } else {
                    let result_string = "__return_value_only_used_in_log_macro__"
                    let return_value_tokens = (inner_node as ReturnExpr).getOrThrow().expr.toTokens()
                    block.nodes.remove(i)
                    block.nodes.insert(i, get_assign_node(result_string, return_value_tokens).getOrThrow())
                    block.nodes.insert(i + 1, get_print_node(this.funcParams, result_string, return_value_tokens).getOrThrow())
                    block.nodes.insert(i + 2, get_return_node(result_string, return_value_tokens).getOrThrow())
                    break
                }
            } else {
                inner_node.traverse(this)
            }
            i++
        }
    }
}

public macro log(args: Tokens): Tokens {
    let func_decl = FuncDecl(args)
    let func_params = func_decl.funcParams
    
    let visitor = ReturnVisitor(func_params)

    func_decl.block.traverse(visitor)

    return quote(
        func $(func_decl.identifier)($(func_decl.funcParams)) {
            $(func_decl.block.nodes)
        }
    )
}