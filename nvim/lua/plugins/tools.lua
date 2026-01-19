return {
  -- Additional tools to install via Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Go
        "gopls",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "delve", -- debugger

        -- Python
        "pyright",
        "ruff",
        "black",

        -- TypeScript/JavaScript
        "typescript-language-server",
        "prettier",
        "eslint-lsp",

        -- SQL
        "sqlls",

        -- Shell
        "shellcheck",
        "shfmt",

        -- Lua (for neovim config)
        "lua-language-server",
        "stylua",

        -- YAML/Docker
        "yaml-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
      },
    },
  },

  -- Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "prisma",
        "python",
        "regex",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "astro",
      },
    },
  },
}
