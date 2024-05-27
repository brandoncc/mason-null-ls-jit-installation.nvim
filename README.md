# mason-null-ls-jit-installation.nvim

This plugin provides "just in time" installation of null-ls sources. This is
just a fancy way of saying "sources are not installed until you are ready to
use them".

## Installation and setup

The plugin expects you to provide a specific a list of sources you would like
to install based on the current buffer's filetype. If you do not provide this
list, initialization will no-op.

I use lazy.nvim, so that is the example I'm adding. I will happily accept pull
requests adding more examples.

### lazy.nvim

```lua
{
  "brandoncc/mason-null-ls-jit-installation.nvim",
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  opts = {
    sources = {
      "typos",
      eslint_d = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      stylua = { "lua" },
    },
  },
}
```

## Configuration

The plugin has a `setup()` function which should be called with a list of
sources. Sources can be specified in two ways:

```lua
{
  sources = {
    "typos"
  }
}
```

or:

```lua
{
  sources = {
    typos = { "markdown" }
  }
}
```

These two methods of specification can be mixed, as seen in the lazy.nvim setup
example above.

### "string" sources

Sources specified using a simple string will be installed immediately. This is
no different than providing the same source to `mason-null-ls`'s
`ensure_installed` option.

### { "table" } sources

Sources specified using a table should have the source name as the key and a
list of applicable filetypes as the value. When a buffer matching one of the
listed filetypes is opened, the source will be installed if it wasn't already.

## Motivation

Mason-based tools provide a setting called `ensure_installed`, which installs
tooling as soon as neovim is opened. This doesn't solve my problem, which is
that I don't want to install tools until I actually need them. I work on a lot
of development servers that are spun up and thrown away quickly, so installing
a bunch of tools that will not be used is a waste of time. Conversely, removing
my `ensure_installed` setting causes me to forget to install the tools that I
_do_ need.
