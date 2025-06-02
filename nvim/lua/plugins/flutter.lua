return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      fvm = false,
      widget_guides = { enabled = true },
      lsp = {
        settings = {
          showtodos = true,
          completefunctioncalls = true,
          analysisexcludedfolders = {
            vim.fn.expand("$Home/.pub-cache"),
          },
          renamefileswithclasses = "prompt",
          updateimportsonrename = true,
          enablesnippets = true,
        },
      },
    })
  end,
}
