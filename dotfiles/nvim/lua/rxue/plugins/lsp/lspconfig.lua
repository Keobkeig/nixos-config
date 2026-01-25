return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- =====================
    -- LSP Server Configurations using vim.lsp.config (Neovim 0.11+)
    -- =====================

    -- Pyrefly for Python (custom server)
    vim.lsp.config.pyrefly = {
      cmd = { "pyrefly", "lsp" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
      capabilities = capabilities,
    }

    -- OCaml LSP (installed via opam)
    vim.lsp.config.ocamllsp = {
      cmd = { "ocamllsp" },
      filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
      root_markers = { "*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace" },
      capabilities = capabilities,
    }

    vim.lsp.config.ts_ls = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            includeCompletionsForModuleExports = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            includeCompletionsForModuleExports = true,
          },
        },
        completions = {
          completeFunctionCalls = true,
        },
      },
    }

    -- HTML
    vim.lsp.config.html = {
      cmd = { "vscode-html-language-server", "--stdio" },
      filetypes = { "html", "templ" },
      root_markers = { "package.json", ".git" },
      capabilities = capabilities,
    }

    -- CSS
    vim.lsp.config.cssls = {
      cmd = { "vscode-css-language-server", "--stdio" },
      filetypes = { "css", "scss", "less" },
      root_markers = { "package.json", ".git" },
      capabilities = capabilities,
    }

    -- Tailwind CSS
    vim.lsp.config.tailwindcss = {
      cmd = { "tailwindcss-language-server", "--stdio" },
      filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte" },
      root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts", "package.json", ".git" },
      capabilities = capabilities,
    }

    -- Svelte
    vim.lsp.config.svelte = {
      cmd = { "svelteserver", "--stdio" },
      filetypes = { "svelte" },
      root_markers = { "package.json", ".git" },
      capabilities = capabilities,
    }

    -- Lua
    vim.lsp.config.lua_ls = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    }

    -- GraphQL
    vim.lsp.config.graphql = {
      cmd = { "graphql-lsp", "server", "-m", "stream" },
      filetypes = { "graphql", "typescriptreact", "javascriptreact" },
      root_markers = { ".graphqlrc*", ".graphql.config.*", "graphql.config.*", "package.json", ".git" },
      capabilities = capabilities,
    }

    -- Emmet
    vim.lsp.config.emmet_ls = {
      cmd = { "emmet-ls", "--stdio" },
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      root_markers = { "package.json", ".git" },
      capabilities = capabilities,
    }

    -- Prisma
    vim.lsp.config.prismals = {
      cmd = { "prisma-language-server", "--stdio" },
      filetypes = { "prisma" },
      root_markers = { ".git" },
      capabilities = capabilities,
    }

    -- Java
    vim.lsp.config.jdtls = {
      cmd = { "jdtls" },
      filetypes = { "java" },
      root_markers = { "pom.xml", "gradle.build", "build.gradle", ".git" },
      capabilities = capabilities,
    }

    -- Enable all configured servers
    vim.lsp.enable({
      "pyrefly",
      "ocamllsp",
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "prismals",
      "jdtls",
    })
  end,
}
