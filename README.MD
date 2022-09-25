# diagline-nvim

Neovim plugin that allows easy inclusion of diagnostic counts in the statusline. Default configuration requires a [NerdFont](https://www.nerdfonts.com/).

![](/screenshots/statusline.png)

## Installation

Install manually or with your favorite plugin manager and add the following line to your startup script:

```lua
require('diagline-nvim').setup()
```

## Configuration

### Diagnostic Level Indicators

If you don't have a NerdFont installed you should set custom indicators for each severity level.

```lua
require('diagline-nvim').setup({
  indicators = {
    [vim.diagnostic.severity.ERROR] = 'X',
    [vim.diagnostic.severity.WARN] = '!',
    [vim.diagnostic.severity.HINT] = '*',
    [vim.diagnostic.severity.INFO] = 'i',
  }
})
```

### Status Line Content

Customize your status line using status line item codes (see :help statusline) and the diagline_nvim_counts function exposed by this plugin. Example below is the default value.

```lua
require('diagline-nvim').setup({
  statusline = ' %-f %-m %-q%=%{%luaeval("diagline_nvim_counts()")%}%=%l,%c   %P '
})
```
