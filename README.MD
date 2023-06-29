# diagline-nvim

Neovim plugin that allows easy inclusion of diagnostic counts in the statusline.

![](/screenshots/statusline.png)

## Installation

Install manually or with your favorite plugin manager and add the following line to your startup script:

```lua
require('diagline-nvim').setup()
```

## Configuration

### Status Line Content

Customize your status line using status line item codes (see [`:help statusline`](https://neovim.io/doc/user/options.html#'statusline')) and the Diagline_nvim_counts function exposed by this plugin. Example below is the default value.

```lua
require('diagline-nvim').setup({
  statusline = ' %-f %-m %-q%=%{%luaeval("Diagline_nvim_counts()")%}%=%l,%c   %P '
})
```

If statusline is not a string this plugin will not set the statusline, but the Diagline_nvim_counts function will still be exposed.

```lua
require('diagline-nvim').setup({
  statusline = false
})

```

### Colors and Icons

The colors and icons used are those of the Diagnostic(Error|Warn|Hint|Info) highlights, and the DiagnosticSign(Error|Warn|Hint|Info) signs. Here is an example of how to modify those items:

```lua
local severities = {
  Error = {
    icon = '',
    fg = '#cc241d'
  },
  Warn = {
    icon = '',
    fg = '#d65d0e'
  },
  Hint = {
    icon = '',
    fg = '#458588'
  },
  Info = {
    icon = '',
    fg = '#a89984'
  }
}

for type, config in pairs(severities) do
  vim.cmd('highlight clear Diagnostic' .. type)
  vim.cmd('highlight Diagnostic' .. type .. ' guifg=' .. config.fg)

  vim.fn.sign_define(
    'DiagnosticSign' .. type,
    {
      text = config.icon,
      texthl = 'Diagnostic' .. type,
      numhl = 'Diagnostic' .. type,
    })
end
```
