return {
  -- Language extras (LSP, formatters, treesitter configured automatically)
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.sql" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.astro" },

  -- Formatting extras
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  -- Linting
  { import = "lazyvim.plugins.extras.linting.eslint" },
}
