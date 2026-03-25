return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup({})
    local floating_border_style = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = floating_border_style,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = floating_border_style,
    })

    -- Change diagnostic symbols in the sign column (gutter)
    local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config({
      virtual_text = true, -- enable inline diagnostic text
      float = { border = floating_border_style },
      signs = { text = diagnostic_signs },
      underline = true, -- optional but recommended
      update_in_insert = false,
      severity_sort = true,
    })

    -- Change diagnostic symbols in the sign column (gutter)
    if vim.g.have_nerd_font then
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config({ signs = { text = diagnostic_signs } })
    end

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local ensure_installed = {
      "lua_ls",
      "bashls",
      "cssls",
      "docker_compose_language_service",
      "dockerls",
      "emmet_ls",
      "sqlls",
      "htmx",
      "eslint",
      "html",
      "jsonls",
      "rust_analyzer",
      "basedpyright",
      "ts_ls",
      "gopls",
      "svelte",
      "tailwindcss",
      "volar",
    }
    local ensure_installed_tools = {
      "eslint_d",
      "stylua",
      "prettierd",
      "prettier",
      "isort",
      -- 'gofmt',
      "gofumpt",
      "golines",
      "black",
      "flake8",
      "golangci-lint",
    }

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed_tools })

    require("mason-lspconfig").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = ensure_installed,
      automatic_installation = {},
    })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
