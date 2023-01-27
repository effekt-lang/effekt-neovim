# Effekt Neovim

Configuration files for using the Effekt language in Neovim (and partly for Vim).
There are syntax, indentation and filetype files (which should also work for Vim) as well as configuration files for using the Effekt Language Server with `nvim-lspconfig`.
The latter can probably be adapted easily to other LSP plugins.

## Installation
### Syntax, Indentation and Filetype
The [syntax](./syntax/effekt.vim), [indentation](./indent/effekt.vim) and [filetype](./filetype.vim) files can simply be copied to the local configuration directory used.
For example, if you use the standard directory for neovim on Linux, copy the directories `syntax` and `indent` and the file `filetype.vim` to `~/.config/nvim/`.

### Language Server
For the language server we use `nvim-lspconfig` but the configuration is not too difficult and can likely be adapted for other plugins without too much work.

Make sure that the `effekt` binary is in your path as the server is started by executing the `effekt` binary with the `--server` option.
Then simply copy the file `effektls.lua` to the `nvim-lspconfig` directory under `nvim-lspconfig/lua/lspconfig/server_configurations/`.
The server can then be set up in `init.vim` almost as any other server.
The only additional thing to do is to add the following line to the `on_attach`-options:

```
client.server_capabilities.textDocumentSync.save.includeText=true
```

A small example configuration that also contains some keybindings is in [init.vim](./init.vim).

With this setup the server should start when an Effekt file is opened.
