local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- wrap words "softly" (no carriage return) in mail buffer
api.nvim_create_autocmd("Filetype", {
  pattern = "mail",
  callback = function()
    vim.opt.textwidth = 0
    vim.opt.wrapmargin = 0
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.columns = 80
    vim.opt.colorcolumn = "80"
  end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- auto close brackets
-- this
api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
  {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = "en,de"
    end,
  }
)

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
--     vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "Normal" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
--   end,
-- })

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- resize neovim split when terminal is resized
vim.api.nvim_command("autocmd VimResized * wincmd =")

-- fix terraform and hcl comment string
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).

    -- [G]oto [D]efinition(s)
    vim.keymap.set("n", "gd", function()
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
        local items = result
        if type(result) == "table" and result.result then
          items = result.result
        end

        if not items or vim.tbl_isempty(items) then
          vim.notify("No definition found", vim.log.levels.ERROR)
        elseif #items == 1 then
          vim.lsp.buf.definition(params)
        else
          require("fzf-lua").lsp_definitions()
        end
      end)
    end, { desc = "[G]oto [D]efinition(s)" })

    -- [G]oto [R]eference(s)
    vim.keymap.set("n", "gr", function()
      local params = vim.lsp.util.make_position_params()
      params.context = { includeDeclaration = true }
      vim.lsp.buf_request(0, "textDocument/references", params, function(_, result)
        local items = result
        if type(result) == "table" and result.result then
          items = result.result
        end

        if not items or vim.tbl_isempty(items) then
          vim.notify("No references found", vim.log.levels.ERROR)
        else
          require("fzf-lua").lsp_references()
        end
      end)
    end, { desc = "[G]oto [R]eference(s)" })

    -- [G]oto [I]mplementation(s)
    vim.keymap.set("n", "gi", function()
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, "textDocument/implementation", params, function(_, result)
        local items = result
        if type(result) == "table" and result.result then
          items = result.result
        end

        if not items or vim.tbl_isempty(items) then
          vim.notify("No implementation found", vim.log.levels.ERROR)
        elseif #items == 1 then
          vim.lsp.buf.implementation(params)
        else
          require("fzf-lua").lsp_implementations()
        end
      end)
    end, { desc = "[G]oto [I]mplementation(s)" })

    -- [G]oto [D]eclaration
    vim.keymap.set("n", "gD", function()
      -- Check if declaration is supported
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      local has_support = false
      for _, client in ipairs(clients) do
        if client.supports_method("textDocument/declaration") then
          has_support = true
          break
        end
      end

      if not has_support then
        vim.notify("LSP method textDocument/declaration not supported", vim.log.levels.ERROR)
        return
      end

      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, "textDocument/declaration", params, function(_, result)
        local items = result
        if type(result) == "table" and result.result then
          items = result.result
        end

        if not items or vim.tbl_isempty(items) then
          vim.notify("No declaration found", vim.log.levels.ERROR)
        elseif #items == 1 then
          vim.lsp.buf.declaration(params)
        else
          require("fzf-lua").lsp_declarations()
        end
      end)
    end, { desc = "[G]oto [D]eclaration" })

    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
    vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    vim.keymap.set("n", "<leader>D", require("fzf-lua").lsp_typedefs, { desc = "Type [D]efinition" })

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]ename" })

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "LSP Hover Documentation" })

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, { desc = "Toggle [U]i Inlay [H]ints" })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
