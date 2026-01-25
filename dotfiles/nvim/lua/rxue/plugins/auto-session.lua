return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>AutoSession Restore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ws", "<cmd>AutoSession Save<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
    keymap.set({"n", "v"}, "<A-j>", ":m .+1<cr>gv==", { desc = "Move line down" })
    keymap.set({"n", "v"}, "<A-k>", ":m .-2<cr>gv==", { desc = "Move line up" })
  end,
}
