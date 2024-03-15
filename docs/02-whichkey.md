# Which-Key

除了最基本的显示keybinding 的功能之外，也提供了一些插件，来提供一些具体的功能。
比如，可以显示 register 里面的内容。

另外一个用处是可以直接用命令来显示keybindings，比如

```
:WhichKey " show all mappings
:WhichKey <leader> " show all <leader> mappings
:WhichKey <leader> v " show all <leader> mappings for VISUAL mode
:WhichKey '' v " show ALL mappings for VISUAL mode
```

## Configuration

https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration

没有什么特别需要修改的地方，绝大多数内容都只影响 UI。

## Setup

这个地方比较关键。Which-key 本身已经可以读已存在的keybingdings了，所以建议在配置按键的时候，把 desc 部分也带上，如此一来 which-key 就能显出有意义的内容了。

which-key 提供了 `register()` 这个函数来让我们创建新的按键，本质上还是调用的 `nvim_set_keymap()` 这个built-in 函数。具体用法如下：

```lua
local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register({
  f = {
    name = "file", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
    n = { "New File" }, -- just a label. don't create any mapping
    e = "Edit File", -- same as above
    ["1"] = "which_key_ignore",  -- special label to hide it in the popup
    b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
  },
}, { prefix = "<leader>" })
```

利用 which-key 来分组配置keybinding，还是把keybinding 写在 plugin 的配置里属于仁者见仁了。
也可以搭配使用，因为 `register()` 可以在任何地方被多次使用，不过就需要注意which-key要最先被load 才可以了，考虑这个情况，可能统一在 which-key 的配置文件中写会更好。

## Plugins

目前有4个内置的插件，我个人觉得好用的是显示 register 内容和built-in 操作的提示。
都不需要配置，默认就已经开启。

built-in 操作的提示就是我们在操作的时候，只按开头的部分，然后停下来，就会出现提示了。

Vim 的操作模式为`[count]operator[count][text-object]`，我们按下 operator 的时候，会给出可用的motion或者text-object选择的提示。

motion 本身也有提示，比如点 `[`，就能看到跳转提示。
