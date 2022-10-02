## 01 Setting options with Lua

`init.lua` is the start point.
In this file, we can use `require` to load code in other lua files.

All other lua files can be put into the `lua` directory. It is recommended that
we should put all our personal lua file in a separate directory under the `lua`
directory. Like a namespace, to avoid unexptected overwrite.

## 02 Keymaps set with Lua

Neovim gives a API to let us set keymappings very easily.
We need to handle the keymappings one by one. We can learn from other's
mappings.

## 03 Load path
By default, nvim will file required files from `/lua` directory. Or we can create
subdirectory under `/lua` and create `init.lua` file under that directory.

## References

- Best tutorial video series for beginner: [Neovim from Scratch](https://www.youtube.com/watch?v=6F3ONwrCxMg&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ&index=8&ab_channel=chris%40machine)
- Modulized nvim config from one of the nvim maitainer: [cozynvim](https://github.com/glepnir/cosynvim)
- Yet, a modulized config with spacemacs-like style [cosmos-nvim](https://github.com/yetone/cosmos-nvim)

## Tips

### Describe keys

Use following command to check keymappings, like what we can do in Emacs (but less convenient).

- For built-in: `:help <keys>` (can push the key directly)
- For manualy mapped: `:verb map <keys>` (need to type the key string, better to add description when map keys)

### Get current file type

Sometime it is hard to know the file type of a certain buffer.
Use `:echo &ft` to get that.
