return {
  "echasnovski/mini.ai",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Disable built-in textobjects that conflict with treesitter-textobjects
    -- (treesitter-textobjects handles: aa/ia, af/if, ai/ii, al/il, am/im, ac/ic)
    custom_textobjects = {
      a = false, -- treesitter: @parameter.outer
      f = false, -- treesitter: @function.outer
      i = false, -- treesitter: @conditional.outer
      l = false, -- treesitter: @loop.outer
    },
    -- Number of lines within which textobject is searched
    n_lines = 50,
    -- How to search for object (first, cover, cover_or_next, cover_or_prev, cover_or_nearest, next, prev, nearest)
    search_method = "cover_or_next",
  },
}
