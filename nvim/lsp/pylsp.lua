local blink = require("blink.cmp")

return {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = true },
        mccabe = { enabled = true },
        rope_completion = { enabled = true },
        jedi_completion = {
          fuzzy = true,
          include_params = true,
        },
      },
    },
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities(),
    {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    }
  ),
}
