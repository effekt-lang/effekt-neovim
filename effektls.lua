local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'effekt.sh', '--server' },
    filetypes = { 'effekt' },
    root_dir = util.root_pattern('*.effekt'),
  },
  docs = {
    description = [[
https://github.com/effekt-lang/effekt

The Effekt language server.
]],
  },
}
