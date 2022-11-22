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
  local statusline_bg = string.format('#%06x', vim.api.nvim_get_hl_by_name('StatusLine', true)['foreground'])

  for _, severity in ipairs(severities) do
    local hl_name = string.format('Diagnostic%s', severity['name'])
    local fg_color = string.format('#%06x', vim.api.nvim_get_hl_by_name(hl_name, true)['foreground'])
    vim.api.nvim_set_hl(0, string.format('SL%s', hl_name), { bg=statusline_bg, fg=fg_color })
  end
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
      local color = string.format('%s%s%s', '%#SLDiagnostic', name, '#')
      local icon = vim.fn.sign_getdefined(string.format('DiagnosticSign%s', name))[1]['text']
      local count = vim.tbl_count(vim.diagnostic.get(0, { severity = severity['severity'] }))
      if count > 0 then
        table.insert(diags, string.format('%s%s %s', color, count, icon))
      end
    end

    return string.format('%s%s', table.concat(diags, ' '), '%#StatusLine#')
  end

  if type(module.config.statusline) == 'string' then
    vim.opt.statusline = module.config.statusline
  end
end

return module
