# Treesitter in Neovim 0.12

## 1. Treesitter 到底是什么

`tree-sitter` 是一个增量语法解析器。
它不是“更花的高亮插件”，而是把 buffer 解析成一棵语法树，然后 Neovim 再基于这棵树做功能。

你可以把它拆成三层：

1. parser
   把源码解析成语法树。每门语言都要有自己的 parser。
2. query
   用类似模式匹配的方式，从语法树里抓出“函数名”“参数”“注释”“字符串”等节点。
3. feature
   Neovim 或插件使用 query 结果来做高亮、折叠、textobjects、增量选择、context、语言注入等功能。

## 2. Neovim 0.12 改了什么

旧思路通常是：

```lua
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})
```

在 `Neovim 0.12` 这条线上，基础能力更偏向 Neovim 原生 `vim.treesitter.*`：

- `vim.treesitter.start()`：启动当前 buffer 的 Treesitter 高亮
- `vim.treesitter.foldexpr()`：做语法树折叠
- `vim.treesitter.language.register()`：把 filetype 映射到 parser 语言

`nvim-treesitter` 仍然很重要，但更像是：

- 管理 parser 安装和更新
- 提供 queries
- 提供一些附加模块，比如增量选择、textobjects、实验性的缩进

## 3. 当前这份配置怎么工作

文件：[treesitter.lua](/home/zgy/.config/nvim/lua/custom/plugins/treesitter.lua)

这份配置现在是“混合模式”：

- 用 `nvim-treesitter` 安装 parser
- 用 `vim.treesitter.start()` 启动原生高亮
- 用 `vim.treesitter.foldexpr()` 做折叠
- 保留 `incremental_selection`
- 保留 `nvim-treesitter-textobjects`
- 暂时不启用插件的 `highlight` / `indent` 模块，避免和 0.12 原生能力重叠

这么做的原因很直接：

- 你的配置仓库目标是往 0.12 迁移
- 但当前本机安装到 `lazy/nvim-treesitter` 的接口仍然带旧式 `configs.setup(...)`
- 所以现在先把“基础能力”切到原生思路，把“附加模块”继续留在插件侧

## 4. 你需要理解的几个关键词

### parser

语言解析器，比如 `lua`、`python`、`markdown`。
如果 parser 没装，Treesitter 就没法生成语法树。

### query

查询规则，通常放在 `queries/<lang>/` 目录。
常见 query 类型：

- `highlights.scm`
- `folds.scm`
- `injections.scm`
- `textobjects.scm`

### capture

query 命中的语义标签，比如：

- `@function`
- `@string`
- `@comment`
- `@parameter.inner`

配色、textobjects、上下文显示，都是围绕 capture 工作。

### injection

在一种语言里嵌另一种语言。
最常见的是 Markdown fenced code block，或者 HTML 里的 CSS / JavaScript。

### textobject

不是正则匹配括号，而是基于语法树理解“函数内部”“类外部”“参数”等结构。

## 5. Treesitter 的工作流水线

把它记成这一条就够了：

```text
源码 -> parser -> syntax tree -> query -> capture -> feature
```

对应关系是：

- `parser`：把源码变成语法树
- `query`：在语法树上匹配结构
- `capture`：给命中的节点打语义标签
- `feature`：消费这些标签来做高亮、折叠、textobjects、增量选择、context

一个实用判断：

- 树不对，后面全都会错
- query 不对，capture 就不对
- capture 对了但显示不对，通常是高亮定义问题

## 6. 常用检查命令

### 看语法树

```vim
:InspectTree
```

这会直接显示当前 buffer 的语法树。看不懂 query 时，先看树。

### 看光标下命中了什么 capture

```vim
:Inspect
```

这能告诉你当前位置命中了哪些 Treesitter capture / 高亮组。

### 看健康检查

```vim
:checkhealth nvim-treesitter
```

重点看：

- parser 是否已安装
- 编译器是否可用
- query 是否报错

### 更新 parser

```vim
:TSUpdate
```

升级 `nvim-treesitter` 后，通常都应该跑一次。

## 7. 怎么理解 query 和 capture

### query 是什么

query 是一套匹配规则，通常放在：

- `queries/<lang>/highlights.scm`
- `queries/<lang>/textobjects.scm`
- `queries/<lang>/folds.scm`
- `queries/<lang>/injections.scm`

它的职责是：

- 从语法树里找出某种结构
- 给这个结构打上 capture 标签

一个简化例子：

```scm
(function_definition
  name: (identifier) @function)
```

意思是：

- 找到 `function_definition`
- 它的 `name` 字段里如果是 `identifier`
- 就标成 `@function`

### capture 是什么

capture 是 query 命中后打上的语义标签。

常见 capture：

- `@function`
- `@function.call`
- `@string`
- `@comment`
- `@keyword`
- `@parameter`
- `@type`

要点是：

- capture 不是颜色本身
- capture 也不是按键本身
- 它只是“这个节点在语义上是什么”

然后别的系统再消费它：

- 高亮系统消费 `@function`、`@comment` 这类 capture
- `nvim-treesitter-textobjects` 消费 `@function.outer`、`@function.inner` 这类 capture
- 折叠系统消费 `folds.scm` 里的 capture

### 先看树，再看 capture

排错时顺序固定：

1. `:echo &ft`
2. `:InspectTree`
3. `:Inspect`
4. 再决定是改 query 还是改高亮

如果 `:Inspect` 里 capture 已经对了，但显示不对：

- 改高亮定义

如果 `:Inspect` 里 capture 根本不对：

- 改 query

## 8. textobjects 和你的键位是怎么连起来的

在 [treesitter.lua](/home/zgy/.config/nvim/lua/custom/plugins/treesitter.lua) 里有这类映射：

```lua
goto_next_start = {
  ["]f"] = "@function.outer",
  ["]c"] = "@class.outer",
  ["]a"] = "@parameter.inner",
}
```

它的真实含义不是“找下一个 `function` 关键字”，而是：

- `]f` 去找下一个命中 `@function.outer` 的位置
- `]c` 去找下一个命中 `@class.outer` 的位置
- `]a` 去找下一个命中 `@parameter.inner` 的位置

所以按键只是“消费 capture”，不是定义 capture。

真正定义这些语义的是 `textobjects.scm`。

### `outer` 和 `inner`

通常一个 textobject 会拆成两类：

- `@function.outer`：整个函数结构
- `@function.inner`：函数内部主体

可以把它类比成 Vim 里的：

- `a)`：outer
- `i)`：inner

同理还会有：

- `@class.outer`
- `@class.inner`
- `@parameter.inner`

如果某个语言里 `]f` 不工作，常见原因是：

1. parser 没装
2. 该语言没有 `textobjects.scm`
3. `textobjects.scm` 里没有定义 `@function.outer`

## 9. injection 是什么

injection 是“语言里嵌另一门语言”。

最常见的是 Markdown 代码块：

````md
```lua
print("hello")
```
````

这里外层是 `markdown`，代码块内部是 `lua`。

流程通常是：

- Markdown parser 先解析外层结构
- `injections.scm` 识别 fenced code block 的语言标记
- Neovim 再为内部区域挂一棵 `lua` 的 language tree

这就是为什么 Markdown 代码块内部还能有 Lua 高亮。

## 10. 这份配置里已经定义的行为

### 自动安装 parser

打开以下语言时会优先保证 parser 可用：

- `bash`
- `c`
- `diff`
- `html`
- `lua`
- `luadoc`
- `markdown`
- `markdown_inline`
- `python`
- `query`
- `regex`
- `toml`
- `vim`
- `vimdoc`
- `yaml`

### 自动启用原生 Treesitter

这些 filetype 会在进入 buffer 时执行：

- `vim.treesitter.start()`
- `foldmethod=expr`
- `foldexpr=v:lua.vim.treesitter.foldexpr()`

### 增量选择

- `<C-space>`：开始选择 / 扩大到更大的语法节点
- `<bs>`：缩回到更小的节点

### textobjects 跳转

- `]f` / `[f`：下一个 / 上一个函数开始
- `]F` / `[F`：下一个 / 上一个函数结束
- `]c` / `[c`：下一个 / 上一个类开始
- `]C` / `[C`：下一个 / 上一个类结束
- `]a` / `[a`：下一个 / 上一个参数

## 11. 自定义高亮和 query

### 先分清两类修改

你能改的东西主要有两类：

1. 改 capture 的显示方式
2. 改 query 的匹配规则

前者改“表现”，后者改“语义”。

判断规则：

- `:Inspect` 显示 capture 对了，但颜色不对：改高亮
- `:Inspect` 显示 capture 错了：改 query

### 自定义 capture 高亮

你可以直接给 capture 设高亮：

```lua
vim.api.nvim_set_hl(0, "@function", { fg = "#88c0d0", bold = true })
vim.api.nvim_set_hl(0, "@parameter", { fg = "#d08770", italic = true })
vim.api.nvim_set_hl(0, "@comment", { fg = "#616e88", italic = true })
```

更稳的做法是放在 colorscheme 加载之后：

```lua
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "@function", { fg = "#88c0d0", bold = true })
    vim.api.nvim_set_hl(0, "@parameter", { fg = "#d08770", italic = true })
    vim.api.nvim_set_hl(0, "@comment", { fg = "#616e88", italic = true })
  end,
})
```

原因很简单：

- 很多主题会在加载时重设高亮
- 你自己的覆盖最好在主题之后再应用

### capture 是分层的

capture 往往有层级，比如：

- `@function`
- `@function.call`
- `@function.method`
- `@comment`
- `@comment.documentation`

所以当你改 `@function` 却没效果时，要先用 `:Inspect` 看当前位置实际命中的是否是更具体的 capture。

### 自定义 query 放哪里

标准位置是：

- `after/queries/lua/highlights.scm`
- `after/queries/lua/textobjects.scm`
- `after/queries/markdown/injections.scm`

`after/queries` 的含义是：

- 在插件自带 query 之后加载
- 适合做追加或覆盖

建议原则：

- 语义规则放 `after/queries`
- 颜色表现放主题或颜色覆盖配置里

### 一个最小 query 例子

```scm
(function_call
  name: (identifier) @function.call)
```

意思是：

- 遇到 `function_call`
- 它的 `name` 是 `identifier`
- 就标成 `@function.call`

然后你再为 `@function.call` 单独设高亮。

### 调试 query 的流程

1. 打开目标文件
2. `:InspectTree`
3. `:Inspect`
4. 修改 `after/queries/<lang>/...`
5. `:edit`
6. 再次检查 capture 是否变化

最常见的失败原因只有三个：

1. 路径写错
2. 语言名写错
3. 节点名和语法树里实际名字不一致

### `after/queries` 做追加时别忘了 `;; extends`

如果你在：

- `after/queries/<lang>/highlights.scm`
- `after/queries/<lang>/folds.scm`

里写自定义 query，而且目标是“在默认 query 基础上追加”，文件顶部需要加：

```scm
;; extends
```

否则它不一定会按“扩展当前语言 query”的方式参与合并。

这个点很容易忽略，尤其是第一次自己写 `after/queries` 时。

## 12. 教学例子：给 C 增加 branch-level folds

这次配置里有一个真实例子：

- [after/queries/c/folds.scm](/home/zgy/.config/nvim/after/queries/c/folds.scm)

目标不是改高亮，而是改折叠粒度。

### 场景

默认的 C `folds.scm` 是这样的：

```scm
[
  (for_statement)
  (if_statement)
  (while_statement)
  (do_statement)
  (switch_statement)
  (case_statement)
  (function_definition)
  (struct_specifier)
  (enum_specifier)
  (comment)
  (preproc_if)
  (preproc_elif)
  (preproc_else)
  (preproc_ifdef)
  (preproc_function_def)
  (initializer_list)
  (gnu_asm_expression)
  (preproc_include)+
] @fold

(compound_statement
  (compound_statement) @fold)
```

这份默认规则的一个直接后果是：

- `if_statement` 会整体折叠
- `if/else` 不会天然按 branch 粒度拆开

### 第一步：先判断是“追加”还是“覆盖”

这次先采用了“追加，不覆盖”的策略，原因是：

- 改动小
- 能快速验证手感
- 即使结果不理想，也能帮助定位问题出在哪一层

### 第二步：给普通 `if_statement` 加 branch fold

在 `after/queries/c/folds.scm` 里追加：

```scm
;; extends

(if_statement
  consequence: (compound_statement) @fold)

(if_statement
  alternative: (else_clause
    (compound_statement) @fold))
```

这个例子成立的前提是，语法树里真的有这些字段。

用 `:InspectTree` 看到的结构是：

```text
(if_statement
  consequence: (compound_statement ...)
  alternative: (else_clause
    (compound_statement ...)))
```

所以这里能做的判断是：

- `if` branch 有明确的 `compound_statement`
- `else` branch 也有明确的 `compound_statement`
- 因此可以分别给它们打 `@fold`

### 为什么追加后 `if` 看起来有时还是会整块 fold

因为默认规则还保留着：

```scm
(if_statement) @fold
```

所以行为会变成：

- 光标在 `if (...)` 头部时，仍然更容易命中整个 `if_statement`
- 光标在 `consequence` 的 `{ ... }` 上时，能命中分支级 fold
- 光标在 `else` 的 `{ ... }` 上时，也能命中分支级 fold

这正说明了：

- 追加规则已经生效
- 但默认外层大 fold 仍然存在

如果目标是“彻底改变默认粒度”，后续就要考虑覆盖默认 `folds.scm`，而不只是追加。

### 第三步：给 preprocessor 也尝试做同样的事

直觉上会想给 `preproc_if` 和 `preproc_else` 也做 branch fold，但关键不能靠猜，要先看树。

实际看到的 `preproc_if` 结构是：

```text
(preproc_if
  condition: (identifier)
  (declaration)
  alternative: (preproc_else
    (declaration)))
```

这里和普通 `if_statement` 的差异非常关键：

- `preproc_else` 有独立节点
- 但 `preproc_if` 的 `if` branch 没有独立的 `consequence` 或 `compound_statement`
- `if` branch 的内容只是直接挂在 `preproc_if` 下面的普通子节点

这意味着：

- `preproc_else` 可以单独折叠
- 但 `preproc_if` 的 `if` body 不能像普通 `if` 那样轻松抓成一个独立 fold 单元

### 这次踩到的一个错误例子

曾经尝试过：

```scm
(preproc_if
  condition: (preproc_defined) @fold)
```

这条规则的问题是：

- 它命中的是 `condition`
- 不是 `if` branch 的内容
- 所以折叠粒度和预期完全不一样

这个例子很适合作为提醒：

- query 语法写对，不代表语义就对
- 真正决定效果的是“你抓到的节点是不是你想操作的结构单元”

### 这个例子的结论

普通 `if_statement`：

- 可以做 branch-level fold
- 因为语法树里有明确的 `consequence` / `alternative` / `compound_statement`

`preproc_if`：

- `preproc_else` 可以独立 fold
- `if` branch 很难单独 fold
- 不是因为 query 写法不够聪明，而是语法树本身没有提供一个独立的 branch 容器节点

这个例子说明了一个很重要的 Treesitter 原则：

- 不是你想折什么，就一定能折什么
- 能不能折，先看语法树有没有那个独立结构

## 13. 排错顺序

如果 Treesitter 不工作，按这个顺序查：

1. `:echo &ft`
   先确认 filetype 对不对。
2. `:checkhealth nvim-treesitter`
   看 parser 和 query 有没有问题。
3. `:InspectTree`
   看是否真的生成了语法树。
4. `:Inspect`
   看 capture 是否命中。
5. `:TSUpdate`
   更新 parser 和 queries。

## 14. 一个实用判断

看到“高亮不对”时，不要先怀疑 colorscheme。
先问这三个问题：

1. 当前 filetype 对吗？
2. 当前 parser 装了吗？
3. 当前 query 有没有命中对的 capture？

这三个问题里，只要有一个不成立，Treesitter 表现就会偏。
