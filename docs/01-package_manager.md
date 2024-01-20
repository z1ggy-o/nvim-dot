# Package Manager

现在主流都是使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 了。这里我们也使用它。

安装的部分就不说了，直接按照主页上面来就可以。这里主要指出一些基本使用和配置内容。

## 基本使用方式

最基本的使用方式，就是在 `init.lua` 文件中调用 `require("lazy").setup(plugins, opts)`。其中 `plugins` 和 `opts` 是我们给到的两个 lua table。`plugins` 中记录我们想要安装的 package，`opts` 部分让我们去修改一些 lazy.nvim 的配置。

一般来说我们都不会改配置，所以 `opts` 部分给个空的 table 就好。`plugins` 部分填写 package 的地址，以及它们的配置。

```lua
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.5', -- or , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}}),
}

local opts = { }

require("lazy").setup(plugins, opts) -- lazy.nvim install packages
```

大概就是这个样子，开头第一个元素是 github repo 的地址。我们不使用 github 也可以，也有相应的配置，这里就先不说了。

里面的选项都是 lazy.nvim 带的，可以详查文档。

对了，文档里面会经常看到 `spec` 这个概念。其实它就是一个 lua table，里面记录了 lazy.nvim 该如何以及何时加载每个插件。我们配置的这些选项，最终也会被融合到一个总的 spec lua table 中。

## 更常用的方式

把所有的配置都放在一个 `init.lua` 文件里面不是不行，但可能会有些杂乱。许多人都会使用单独的文件来进行管理。对于基于 lua 的配置来说，就是把每个 package，或者相关的 package 放到一个 lua module 里面，然后引用。

这种方式很常见，所以 lazy.nvim 直接应对这个需求，自动会去加载属于某个文件夹下面的 lua module，而且每次有修改，都会自动更新，也不需要我们不停调用 `require()`。

```lua
-- in init.lua
require("lazy").setup("plugins")
-- require("lazy").setup(plugins, opts) 这一句就不要了
```

如果我们使用上面的语句，那么 `~/.config/nvim/lua/plugins.lua` 或者 `~/.config/nvim/lua/plugins/*.lua` 这些文件就会被自动加载。更准确来说 `plugins/` 文件下的第一级文件夹内的文件也会被加载。

实际上来说，就是任何你想交给 lazy.nvim 的东西，你都可以在上述的文件里面 `return` 就好了。比如，要安装一个插件

```lua
-- in catppuccin.lua file
 return { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
```

但是仅仅安装一个 package 不是我们想要的，我们一般还需要配置这个 package。但是上述的 lua module 直接就 `return` 了，后面再添加内容也没用。在这之前配置又不行，因为这个 package 还没被载入。怎么办呢？为了解决这个问题，lazy.nvim 提供了 [`config`](https://github.com/folke/lazy.nvim?tab=readme-ov-file#-plugin-spec) 这个 plugin spec。

当 lazy.nvim 去自动 load 上述文件夹下的 lua module 的时候，它也会自动的运行 `config`。lazy.nvim 把 `config` 的内容当作一个具体的语句，直接运行。所以我们需要给它一个具体的语句，一般会是一个函数。又或者可以直接给 `true` 这个值，那么 lazy.nvim 会使用它的默认实现，即 `require(plugin).setup()`。

lazy.nvim 里面还有一个 spec 项 `opts`，是一个 table。它和 `config` 是搭配工作的。因为 `config` 的缺省实现是 `require(plugin).setup(opts)`。如果我们不单独重写 `config`，也可以直接在 `opts` 中给出 package 的配置项，lazy.nvim 缺省的 `config` 自动就采用了。
