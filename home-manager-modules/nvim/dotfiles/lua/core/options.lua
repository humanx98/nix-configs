vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true 

-- opt.wrap = true

-- search settings
-- opt.ignorecase = true
-- opt.smartcase = true

opt.signcolumn = "no"

opt.backspace = "indent,eol,start"
-- opt.delete = "indent,eol,start"

opt.clipboard:append("unnamedplus") -- use system clipboard as default register, requires wl-clipboard or xclip

opt.splitright = true
opt.splitbelow = true
