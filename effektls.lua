---@brief
---
--- https://github.com/effekt-lang/effekt
---
--- Effekt Language Server

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = { 'effekt', '--server' },
  filetypes = { 'effekt' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('*.effekt')(fname))
  end,
}
