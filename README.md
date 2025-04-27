# nvim-fencepolish

**Fence-aware formatter for Markdown in Neovim**
Automatically formats code inside fenced blocks (` ```lang `) in Markdown using Treesitter and external formatters like `jq`, `black`, `prettier`, etc.

## Features

* Formats fenced code blocks in Markdown based on the language.
* Uses [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to detect code blocks reliably.
* Integrates with external formatters (e.g., `jq`, `black`, `prettier`, etc).
* Supports formatting selected text via keymaps or commands.
* Works with any file type – smartly scopes to Markdown fenced regions.


## Installation (Lazy.nvim)

```lua
{
  dir = "~/.config/nvim/lua/plugins/nvim-fencepolish",
  name = "nvim-fencepolish",
  config = function()
    require("nvim-fencepolish").setup()
  end,
  event = "BufReadPre", -- or as needed
}
```

> You can place this in your `plugins.lua` or equivalent Lazy plugin config.


## Setup

Default config:

```lua
require("nvim-fencepolish").setup({
  formatters = {
    json = "jq",
    python = "black -q -",
    lua = "stylua -",
    javascript = "prettier --parser babel",
    typescript = "prettier --parser typescript",
    sh = "shfmt",
  },
  keymap = "<leader>fp", -- Format fenced block under cursor
})
```


## Usage

### Keymap

* Press `<leader>fp` inside a code block to auto-format it based on the language tag.

### Command

You can also run:

```vim
:lua require("nvim-fencepolish").format_code_block()
```


## How it Works

1. Detects fenced code blocks using Treesitter.
2. Grabs the language (` ```python`, ` ```json`, etc).
3. Feeds content to the right formatter.
4. Replaces the block with the formatted output. Clean & beautiful.


## Requirements

* Neovim 0.9+ with Treesitter configured.
* External formatters for the languages you want to support:
  * `jq`, `black`, `prettier`, `shfmt`, `stylua`, etc.


## Todo

* Auto-format on save
* Support custom formatter fallback
* Preview before applying formatting
* Add tests


## Contributing

PRs and ideas are welcome — just open an issue or submit a pull request.
Even better if you bring your own formatter mappings for cool languages!


## License

MIT


Crafted with ❤️ for Markdown power users.
