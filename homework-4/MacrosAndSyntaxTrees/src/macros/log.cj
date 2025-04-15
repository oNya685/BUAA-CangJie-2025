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

private func find_return_tokens(block: Block, block_nodes_without_return: ArrayList<Node>): Tokens {
    let return_tokens = Tokens()
    for (i in 0 .. block.nodes.size) {
        let node = block.nodes[i]
        if (node.toTokens()[0].kind == RETURN) {
            return_tokens.append(node.toTokens().remove(0))
            break
        }
        block_nodes_without_return.append(node)
    }
    return return_tokens
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

public macro log(args: Tokens): Tokens {
    let func_decl = FuncDecl(args)
    let func_params = func_decl.funcParams
    
    let log_block_nodes = ArrayList<Node>() // codes without return

    var return_value_tokens = find_return_tokens(func_decl.block, log_block_nodes)
    
    let result_string = "__return_value_of_${func_decl.identifier.value}__"
    let assign_node = get_assign_node(result_string, return_value_tokens)
    let print_node = get_print_node(func_params, result_string, return_value_tokens)
    let return_node = get_return_node(result_string, return_value_tokens)

    if (assign_node.isSome()) { log_block_nodes.append(assign_node.getOrThrow()) }
    if (print_node.isSome()) { log_block_nodes.append(print_node.getOrThrow()) }
    if (return_node.isSome()) { log_block_nodes.append(return_node.getOrThrow()) }

    return quote(
        func $(func_decl.identifier)($(func_decl.funcParams)) {
            $(log_block_nodes)
        }
    )
}