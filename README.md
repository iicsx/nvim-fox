<div align="center">

  # NVIM Fox

##### A simple plugin that lets you open selected text in a floating buffer, attachable to any other buffer.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.5+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

</div>

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Options](#options)

## Features

Open selected text in a floating window and keep it in view at all times.
Attach the window to any buffer so it only shows when that buffer is focused.
Allows for attachment of different windows to different buffers. You can carry over a non-attached buffer anywhere and even override another attached buffer.


## Requirements

- Neovim 0.5+


## Installation

nvim-fox supports all the usual plugin managers

<details>
  <summary>lazy.nvim</summary>

```lua
{
  'iicsx/nvim-fox',
  opts = { /* setup options */ },
  -- There are no current dependencies
  dependencies = { },
  -- There are no known issues with lazy loading
  lazy = true,
}
```

</details>

<details>
  <summary>Packer</summary>

```lua
require("packer").startup(function()
  use({
    "iicsx/nvim-fox",
    config = function()
      require("fox").setup({ /* setup options */ })
    end,
  })
end)
```

</details>

<details>
  <summary>vim-plug</summary>

```vim
Plug 'iicsx/nvim-fox'
```

</details>

... and more


## Options

```lua
require("fox").setup({
  context = {
    enable = true,
    -- The usual border options
    borders = "rounded",
    -- The title for the floating window
    title = " Floating Context ",
    -- Offset from the top
    padding_top = 1,
    -- Offset from the right
    padding_right = 2,
    -- Width the window should not exceed
    max_width = nil -- default is vim.fn.strdisplaywidth(), determined by the longest selcted line
    -- Height the window should not exceed
    max_height = nil -- default is the number of selected lines
  }
}
```
