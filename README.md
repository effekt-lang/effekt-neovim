# Effekt Neovim

Configuration files for using the Effekt language in Neovim (and partly for Vim).
There are syntax, indentation and filetype files (which should also work for Vim) as well as configuration files for using the Effekt Language Server with `nvim-lspconfig`.
The latter can probably be adapted easily to other LSP plugins.

## Installation
### Syntax, Indentation and Filetype
The [syntax](./syntax/effekt.vim), [indentation](./indent/effekt.vim) and [filetype](./filetype.vim) files can simply be copied to the local configuration directory used.
For example, if you use the standard directory for neovim on Linux, copy the directories `syntax` and `indent` and the file `filetype.vim` to `~/.config/nvim/`.

### Language Server
The language setup has been tested with `nvim-lspconfig` but the configuration is not too difficult and can likely be adapted for other settings without too much work.

Make sure that the `effekt` binary is in your path as the server is started by executing `effekt` with the `--server` option.
Then simply copy the file `effektls.lua` to the `nvim-lspconfig` directory under `nvim-lspconfig/lsp`.
The server can be set up in `init.vim` just as any other server.

A small example configuration that also contains some key bindings is in [init.vim](./init.vim).

With this setup the server should start when an Effekt file is opened.
