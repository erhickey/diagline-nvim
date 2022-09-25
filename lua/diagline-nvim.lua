local levels = {
  {
    level = vim.diagnostic.severity.ERROR,
    color = '%#SLDiagnosticError#'
  },
  {
    level = vim.diagnostic.severity.WARN,
    color = '%#SLDiagnosticWarn#'
  },
  {
    level = vim.diagnostic.severity.INFO,
    color = '%#SLDiagnosticInfo#'
  },
  {
    level = vim.diagnostic.severity.HINT,
    color = '%#SLDiagnosticHint#'
  },
}

local function create_diag_highlights()
  local slbg = string.format('#%06x', vim.api.nvim_get_hl_by_name('StatusLine', true)['foreground'])
  local defg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticError', true)['foreground'])
  local dwfg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticWarn', true)['foreground'])
  local difg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticInfo', true)['foreground'])
  local dhfg = string.format('#%06x', vim.api.nvim_get_hl_by_name('DiagnosticHint', true)['foreground'])
  vim.highlight.create('SLDiagnosticError', {guibg=slbg, guifg=defg})
  vim.highlight.create('SLDiagnosticWarn', {guibg=slbg, guifg=dwfg})
  vim.highlight.create('SLDiagnosticInfo', {guibg=slbg, guifg=difg})
  vim.highlight.create('SLDiagnosticHint', {guibg=slbg, guifg=dhfg})
end

local separator = '%='
local file_name = ' %-f'
local modified = ' %-m %-q'
local diag_counts = '%{%luaeval("diagline_nvim_counts()")%}'
local line_info = '%l,%c   %P '

local presets = {
  indicators = {
    [vim.diagnostic.severity.ERROR] = '',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.INFO] = '',
    [vim.diagnostic.severity.HINT] = ''
  },
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

local module = {
  options = presets
}

function module.setup(opts)
  if opts ~= nil then
    if opts.indicators ~= nil then
      for k, v in pairs(opts.indicators) do
        module.options.indicators[k] = v
      end
    end

    if opts.statusline ~= nil then
      module.options.statusline = opts.statusline
    end
  end

  function diagline_nvim_counts()
    local diags = {}

    for _, l in pairs(levels) do
      local level = l['level']
      local color = l['color']
      local ind = module.options.indicators[level]
      local count = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
      if count > 0 then
        table.insert(diags, color .. count .. " " .. ind)
      end
    end

    return table.concat(diags, '  ') ..  '%#StatusLine#'
  end

  create_diag_highlights()
  vim.opt.statusline = module.options.statusline
end

return module
