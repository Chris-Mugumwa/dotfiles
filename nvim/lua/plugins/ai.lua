return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = { api_key = "ANTHROPIC_API_KEY" },
            schema = { model = { default = "claude-opus-4-7" } },
          })
        end,
      },
      strategies = {
        chat = { adapter = "anthropic" },
        inline = { adapter = "anthropic" },
        agent = { adapter = "anthropic" },
      },
      display = {
        chat = {
          window = { width = 0.4 },
          show_header_separator = true,
          show_settings = false,
        },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat toggle", mode = { "n", "v" } },
      { "<leader>ai", ":CodeCompanion ", desc = "AI Inline prompt", mode = { "n", "v" } },
    },
  },
}
