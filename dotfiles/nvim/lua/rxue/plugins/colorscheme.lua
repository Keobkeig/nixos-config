return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
      integrations = {
        treesitter = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        which_key = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
