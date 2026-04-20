vim.opt.nu = true
vim.opt.rnu = true

vim.pack.add { { src = "https://github.com/neovim/nvim-lspconfig" } }
vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }
vim.pack.add {
  {
    src = "https://github.com/m4xshen/hardtime.nvim",
    dependencies = {
      "https://github.com/MunifTanjim/nui.nvim",
    },
  },
}

vim.cmd.colorscheme "catppuccin-mocha"

vim.opt.mouse = ""

vim.g.clipboard = {
  name = "tmux",
  copy = {
    ["+"] = { "tmux", "load-buffer", "-" },
    ["*"] = { "tmux", "load-buffer", "-" },
  },
  paste = {
    ["+"] = { "tmux", "save-buffer", "-" },
    ["*"] = { "tmux", "save-buffer", "-" },
  },
  cache_enabled = 0,
}

vim.opt.clipboard = "unnamedplus"

vim.lsp.enable('lua_ls')

require("hardtime").setup()
