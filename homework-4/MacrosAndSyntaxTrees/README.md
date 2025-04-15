# 习题

实现一个函数参数与返回值打印宏。

## 要求

实现一个非属性宏`log`，以函数定义作为传入参数，对函数体进行修改，使得修改后的函数在调用时能够打印出当前传参与返回值。

## 示例

例如，对于下面这个函数，`log`作用于它会被展开为（内部语句不必和下面完全相同，只要打印出来的内容相同即可）：

```CangJie
@log
func test(a: Int64, b: Int64) {
    return a + b
}
```

宏展开为：

```CangJie
func test(a: Int64, b: Int64) {
    let result = a + b
    println("a = \(a), b = \(b), return \(result)")
    return result
}
```

## 提示

可以使用Lambda表达式来获取返回值。相关API和类结构请查阅[在线文档](https://cangjie-lang.cn/docs)。
