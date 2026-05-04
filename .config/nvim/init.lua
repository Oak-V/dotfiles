vim.opt.nu = true
vim.opt.rnu = true

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

