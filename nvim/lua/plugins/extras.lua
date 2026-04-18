return {
  { import = "lazyvim.plugins.extras.editor.trouble" },
  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },

  { "folke/todo-comments.nvim", event = "VeryLazy", opts = {} },

  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
    opts = {},
    keys = {
      { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Task list" },
    },
  },

  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome" },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    event = { "BufReadPre " .. vim.fn.expand("~") .. "/vault/*.md" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = { { name = "main", path = "~/vault" } },
      completion = { nvim_cmp = true, min_chars = 2 },
      daily_notes = { folder = "daily", date_format = "%Y-%m-%d" },
      new_notes_location = "notes_subdir",
      notes_subdir = "inbox",
      ui = { enable = true },
    },
  },
}
