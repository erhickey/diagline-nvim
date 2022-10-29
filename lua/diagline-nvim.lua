local severities = {
  {
    name = 'Error',
    severity = vim.diagnostic.severity.ERROR
  },
  {
    name = 'Warn',
    severity = vim.diagnostic.severity.WARN
  },
  {
    name = 'Info',
    severity = vim.diagnostic.severity.INFO
  },
  {
    name = 'Hint',
    severity = vim.diagnostic.severity.HINT
  },
}

local function create_diag_statusline_highlights()
  local slbg = string.format('#%06x', vim.api.nvim_get_hl_by_name('StatusLine', true)['foreground'])
  local defg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticError', true)['foreground'])
  local dwfg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticWarn', true)['foreground'])
  local difg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticInfo', true)['foreground'])
  local dhfg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticHint', true)['foreground'])
  vim.highlight.create('SLDiagnosticError', { guibg=slbg, guifg=defg })
  vim.highlight.create('SLDiagnosticWarn', { guibg=slbg, guifg=dwfg })
  vim.highlight.create('SLDiagnosticInfo', { guibg=slbg, guifg=difg })
  vim.highlight.create('SLDiagnosticHint', { guibg=slbg, guifg=dhfg })
end

local separator = '%='
local file_name = ' %-f'
local modified = ' %-m %-q'
local diag_counts = '%{%luaeval("Diagline_nvim_counts()")%}'
local line_info = '%l,%c   %P '

local module = {
  config = {
    statusline = string.format(
      '%s%s%s%s%s%s',
      file_name,
      modified,
      separator,
      diag_counts,
      separator,
      line_info
    ),
  }
}

function module.setup(config)
  if config ~= nil then
    for k, v in pairs(config) do module.config[k] = v end
  end

  create_diag_statusline_highlights()

  function Diagline_nvim_counts()
    local diags = {}

    for _, severity in ipairs(severities) do
      local name = severity['name']
      local color = '%#SLDiagnostic' .. name .. '#'
      local icon = vim.fn.sign_getdefined('DiagnosticSign' .. name)[1]['text']
      local count = vim.tbl_count(vim.diagnostic.get(0, { severity = severity['severity'] }))
      if count > 0 then
        table.insert(diags, color .. count .. ' ' .. icon)
      end
    end

    return table.concat(diags, ' ') ..  '%#StatusLine#'
  end

  if type(module.config.statusline) == 'string' then
    vim.opt.statusline = module.config.statusline
  end
end

return module
