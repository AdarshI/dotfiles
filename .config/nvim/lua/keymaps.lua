local map = vim.keymap.set

map("n", "<leader><Tab>", vim.cmd.Ex)

-- greatest remap ever
map("x", "<leader>p", "\"_dP")
map("n", "<leader>d", "\"_d")
map("v", "<leader>d", "\"_d")

-- next greatest remap ever
map("n", "<leader>y", "\"+y")
map("v", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+Y")

map("n", "<leader>f", vim.lsp.buf.format)

-- telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>")
--local builtin = require('telescope.builtin')

-- map('n', '<leader>ff', builtin.find_files, {})
-- map('n', '<leader>fg', builtin.live_grep, {})
-- map('n', '<leader>fb', builtin.buffers, {})
-- map('n', '<leader>fh', builtin.help_tags, {})
