# Package Manager

现在主流都是使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 了。这里我们也使用它。

安装的部分就不说了，直接按照主页上面来就可以。这里主要指出一些基本使用和配置内容。

## 基本使用方式

最基本的使用方式，就是调用 `require("lazy").setup(plugins, opts)`。其中 `plugins` 和 `opts` 是我们给到的两个 lua table。`plugins` 中记录我们想要安装的 package，`opts` 部分让我们去修改一些 lazy.nvim 的配置。

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