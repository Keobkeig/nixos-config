vim.g.mapleader = " " -- set leader key to space

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Send deletes to black hole register so they don't overwrite the yank register
keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole register" })
keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line (black hole)" })
keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete char (black hole)" })
keymap.set({ "n", "v" }, "X", '"_X', { desc = "Delete char before (black hole)" })
keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change (black hole)" })
keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end of line (black hole)" })
