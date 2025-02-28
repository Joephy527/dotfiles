return {
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'Open lazy git' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signs_staged = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
      }
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function() -- Go to the next hunk (or next change in diff)
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Go to the next hunk (or change in diff)', noremap = true }) -- Do not remap

      map('n', '[c', function() -- Go to the previous hunk (or previous change in diff)
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Go to the previous hunk (or change in diff)', noremap = true }) -- Do not remap

      -- Actions
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage the current hunk (line)', noremap = true })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset the current hunk (undo)', noremap = true })

      map('v', '<leader>ghs', function() -- Stage the selected hunk in visual mode
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage the selected hunk in visual mode', noremap = true }) -- Do not remap

      map('v', '<leader>ghr', function() -- Reset the selected hunk in visual mode
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset the selected hunk in visual mode', noremap = true }) -- Do not remap

      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Stage the entire buffer', noremap = true })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Reset the entire buffer', noremap = true })
      map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Preview the current hunk', noremap = true })
      map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = 'Inline preview of the current hunk', noremap = true })

      map('n', '<leader>ghb', function() -- Blame the current line (full commit info)
        gitsigns.blame_line { full = true }
      end, { desc = 'Blame the current line (full commit info)', noremap = true }) -- Do not remap

      map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Show the diff for the current file', noremap = true })
      map('n', '<leader>ghD', function() -- Show the diff for the current file vs. the last commit
        gitsigns.diffthis '~'
      end, { desc = 'Show the diff for the current file vs. the last commit', noremap = true }) -- Do not remap

      map('n', '<leader>ghQ', function() -- Add all changes to the quickfix list
        gitsigns.setqflist 'all'
      end, { desc = 'Add all changes to the quickfix list', noremap = true }) -- Do not remap

      map('n', '<leader>ghq', gitsigns.setqflist, { desc = 'Add current changes to the quickfix list', noremap = true })

      -- Toggles
      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame visibility', noremap = true })
      map('n', '<leader>gtd', gitsigns.preview_hunk_inline, { desc = 'Toggle inline diff preview', noremap = true })
      map('n', '<leader>gtw', gitsigns.toggle_word_diff, { desc = 'Toggle word diff', noremap = true })

      -- Text Object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select the current hunk as a text object', noremap = true })
    end,
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gvdiffsplit', 'Gedit', 'Gstatus', 'Gwrite', 'Gread', 'Gremove', 'Gmove' },
    keys = {
      -- Git status
      { '<leader>ffs', ':Git<CR>', desc = 'Git status' },

      -- Committing, pushing, and pulling
      { '<leader>fc', ':Git commit<CR>', desc = 'Git commit' },
      { '<leader>fP', ':Git push<CR>', desc = 'Git push' },
      { '<leader>fp', ':Git pull<CR>', desc = 'Git pull' },
      { '<leader>ffp', ':Git push --force<CR>', desc = 'Git push with force' },

      -- Diff and comparison
      { '<leader>fD', ':Gdiffsplit<CR>', desc = 'Git diff split' },
      { '<leader>fs', ':Gvdiffsplit<CR>', desc = 'Git vertical diff split' },
      { '<leader>fdp', ':Git diff @{upstream}<CR>', desc = 'Git diff against upstream' },
      { '<leader>fdl', ':Git diff HEAD~1<CR>', desc = 'Git diff last commit' },

      -- Blame and logs
      { '<leader>fb', ':Git blame<CR>', desc = 'Git blame' },
      { '<leader>fl', ':Git log<CR>', desc = 'Git log' },

      -- Branch and reset
      { '<leader>fgc', ':Git checkout ', desc = 'Git checkout branch' },
      { '<leader>frs', ':Git reset --soft HEAD~1<CR>', desc = 'Git reset soft' },
      { '<leader>frh', ':Git reset --hard HEAD~1<CR>', desc = 'Git reset hard' },

      -- Stash
      { '<leader>fss', ':Git stash<CR>', desc = 'Git stash' },
      { '<leader>fsp', ':Git stash pop<CR>', desc = 'Git stash pop' },

      -- File operations
      { '<leader>fgC', ':Gread<CR>', desc = 'Git checkout file' },
      { '<leader>fgD', ':Gremove<CR>', desc = 'Git remove file' },
      { '<leader>fgM', ':Gmove ', desc = 'Git move/rename file' },

      -- Git diffget/diffput from left and right
      { '<leader>fdg', ':diffget //2<CR>', desc = 'Git diffget (take from left)' },
      { '<leader>fdr', ':diffget //3<CR>', desc = 'Git diffget (take from right)' },

      -- Git add (stage changes from diff)
      { '<leader>fA', ':Gwrite<CR>', desc = 'Git stage current file' },
      { '<leader>fa', ':Git add .<CR>', desc = 'Git stage all changes' },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
    },
    config = function()
      local neogit = require 'neogit'

      neogit.setup {
        -- Hides the hints at the top of the status buffer
        disable_hint = false,
        -- Disables changing the buffer highlights based on where the cursor is.
        disable_context_highlighting = false,
        -- Disables signs for sections/items/hunks
        disable_signs = false,
        -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
        -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
        -- normal mode.
        disable_insert_on_commit = 'auto',
        -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
        -- events.
        filewatcher = {
          interval = 1000,
          enabled = true,
        },
        -- "ascii"   is the graph the git CLI generates
        -- "unicode" is the graph like https://github.com/rbong/vim-flog
        -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
        graph_style = 'ascii',
        -- Show relative date by default. When set, use `strftime` to display dates
        commit_date_format = nil,
        log_date_format = nil,
        -- Show message with spinning animation when a git command is running.
        process_spinner = false,
        -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
        -- sorter instead. By default, this function returns `nil`.
        telescope_sorter = function()
          return require('telescope').extensions.fzf.native_fzf_sorter()
        end,
        -- Persist the values of switches/options within and across sessions
        remember_settings = true,
        -- Scope persisted settings on a per-project basis
        use_per_project_settings = true,
        -- Table of settings to never persist. Uses format "Filetype--cli-value"
        ignored_settings = {
          'NeogitPushPopup--force-with-lease',
          'NeogitPushPopup--force',
          'NeogitPullPopup--rebase',
          'NeogitCommitPopup--allow-empty',
          'NeogitRevertPopup--no-edit',
        },
        -- Configure highlight group features
        highlight = {
          italic = true,
          bold = true,
          underline = true,
        },
        -- Set to false if you want to be responsible for creating _ALL_ keymappings
        use_default_keymaps = true,
        -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
        -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
        auto_refresh = true,
        -- Value used for `--sort` option for `git branch` command
        -- By default, branches will be sorted by commit date descending
        -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
        -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
        sort_branches = '-committerdate',
        -- Default for new branch name prompts
        initial_branch_name = '',
        -- Change the default way of opening neogit
        kind = 'tab',
        -- Disable line numbers
        disable_line_numbers = true,
        -- Disable relative line numbers
        disable_relative_line_numbers = true,
        -- The time after which an output console is shown for slow running commands
        console_timeout = 2000,
        -- Automatically show console if a command takes more than console_timeout milliseconds
        auto_show_console = true,
        -- Automatically close the console if the process exits with a 0 (success) status
        auto_close_console = true,
        notification_icon = '󰊢',
        status = {
          show_head_commit_hash = true,
          recent_commit_count = 10,
          HEAD_padding = 10,
          HEAD_folded = false,
          mode_padding = 3,
          mode_text = {
            M = 'modified',
            N = 'new file',
            A = 'added',
            D = 'deleted',
            C = 'copied',
            U = 'updated',
            R = 'renamed',
            DD = 'unmerged',
            AU = 'unmerged',
            UD = 'unmerged',
            UA = 'unmerged',
            DU = 'unmerged',
            AA = 'unmerged',
            UU = 'unmerged',
            ['?'] = '',
          },
        },
        commit_editor = {
          kind = 'tab',
          show_staged_diff = true,
          -- Accepted values:
          -- "split" to show the staged diff below the commit editor
          -- "vsplit" to show it to the right
          -- "split_above" Like :top split
          -- "vsplit_left" like :vsplit, but open to the left
          -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
          staged_diff_split_kind = 'split',
          spell_check = true,
        },
        commit_select_view = {
          kind = 'tab',
        },
        commit_view = {
          kind = 'vsplit',
          verify_commit = vim.fn.executable 'gpg' == 1, -- Can be set to true or false, otherwise we try to find the binary
        },
        log_view = {
          kind = 'tab',
        },
        rebase_editor = {
          kind = 'auto',
        },
        reflog_view = {
          kind = 'tab',
        },
        merge_editor = {
          kind = 'auto',
        },
        description_editor = {
          kind = 'auto',
        },
        tag_editor = {
          kind = 'auto',
        },
        preview_buffer = {
          kind = 'floating',
        },
        popup = {
          kind = 'split',
        },
        stash = {
          kind = 'tab',
        },
        refs_view = {
          kind = 'tab',
        },
        signs = {
          -- { CLOSED, OPENED }
          hunk = { '', '' },
          item = { '>', 'v' },
          section = { '>', 'v' },
        },
        -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
        integrations = {
          -- If enabled, use telescope for menu selection rather than vim.ui.select.
          -- Allows multi-select and some things that vim.ui.select doesn't.
          telescope = false,
          -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
          -- The diffview integration enables the diff popup.
          --
          -- Requires you to have `sindrets/diffview.nvim` installed.
          diffview = true,

          -- If enabled, uses fzf-lua for menu selection. If the telescope integration
          -- is also selected then telescope is used instead
          -- Requires you to have `ibhagwan/fzf-lua` installed.
          fzf_lua = false,

          -- If enabled, uses mini.pick for menu selection. If the telescope integration
          -- is also selected then telescope is used instead
          -- Requires you to have `echasnovski/mini.pick` installed.
          mini_pick = false,
        },
        sections = {
          -- Reverting/Cherry Picking
          sequencer = {
            folded = false,
            hidden = false,
          },
          untracked = {
            folded = false,
            hidden = false,
          },
          unstaged = {
            folded = false,
            hidden = false,
          },
          staged = {
            folded = false,
            hidden = false,
          },
          stashes = {
            folded = true,
            hidden = false,
          },
          unpulled_upstream = {
            folded = true,
            hidden = false,
          },
          unmerged_upstream = {
            folded = false,
            hidden = false,
          },
          unpulled_pushRemote = {
            folded = true,
            hidden = false,
          },
          unmerged_pushRemote = {
            folded = false,
            hidden = false,
          },
          recent = {
            folded = true,
            hidden = false,
          },
          rebase = {
            folded = true,
            hidden = false,
          },
        },
        mappings = {
          commit_editor = {
            ['q'] = 'Close',
            ['<c-c><c-c>'] = 'Submit',
            ['<c-c><c-k>'] = 'Abort',
            ['<m-p>'] = 'PrevMessage',
            ['<m-n>'] = 'NextMessage',
            ['<m-r>'] = 'ResetMessage',
          },
          commit_editor_I = {
            ['<c-c><c-c>'] = 'Submit',
            ['<c-c><c-k>'] = 'Abort',
          },
          rebase_editor = {
            ['p'] = 'Pick',
            ['r'] = 'Reword',
            ['e'] = 'Edit',
            ['s'] = 'Squash',
            ['f'] = 'Fixup',
            ['x'] = 'Execute',
            ['d'] = 'Drop',
            ['b'] = 'Break',
            ['q'] = 'Close',
            ['<cr>'] = 'OpenCommit',
            ['gk'] = 'MoveUp',
            ['gj'] = 'MoveDown',
            ['<c-c><c-c>'] = 'Submit',
            ['<c-c><c-k>'] = 'Abort',
            ['[c'] = 'OpenOrScrollUp',
            [']c'] = 'OpenOrScrollDown',
          },
          rebase_editor_I = {
            ['<c-c><c-c>'] = 'Submit',
            ['<c-c><c-k>'] = 'Abort',
          },
          finder = {
            ['<cr>'] = 'Select',
            ['<c-c>'] = 'Close',
            ['<esc>'] = 'Close',
            ['<c-n>'] = 'Next',
            ['<c-p>'] = 'Previous',
            ['<down>'] = 'Next',
            ['<up>'] = 'Previous',
            ['<tab>'] = 'InsertCompletion',
            ['<space>'] = 'MultiselectToggleNext',
            ['<s-space>'] = 'MultiselectTogglePrevious',
            ['<c-j>'] = 'NOP',
            ['<ScrollWheelLeft>'] = 'NOP',
            ['<ScrollWheelRight>'] = 'NOP',
            ['<2-LeftMouse>'] = 'NOP',
          },
          -- Setting any of these to `false` will disable the mapping.
          popup = {
            ['?'] = 'HelpPopup',
            ['A'] = 'CherryPickPopup',
            ['d'] = 'DiffPopup',
            ['M'] = 'RemotePopup',
            ['P'] = 'PushPopup',
            ['X'] = 'ResetPopup',
            ['Z'] = 'StashPopup',
            ['i'] = 'IgnorePopup',
            ['t'] = 'TagPopup',
            ['b'] = 'BranchPopup',
            ['B'] = 'BisectPopup',
            ['w'] = 'WorktreePopup',
            ['c'] = 'CommitPopup',
            ['f'] = 'FetchPopup',
            ['l'] = 'LogPopup',
            ['m'] = 'MergePopup',
            ['p'] = 'PullPopup',
            ['r'] = 'RebasePopup',
            ['v'] = 'RevertPopup',
          },
          status = {
            ['j'] = 'MoveDown',
            ['k'] = 'MoveUp',
            ['o'] = 'OpenTree',
            ['q'] = 'Close',
            ['I'] = 'InitRepo',
            ['1'] = 'Depth1',
            ['2'] = 'Depth2',
            ['3'] = 'Depth3',
            ['4'] = 'Depth4',
            ['Q'] = 'Command',
            ['<tab>'] = 'Toggle',
            ['x'] = 'Discard',
            ['s'] = 'Stage',
            ['S'] = 'StageUnstaged',
            ['<c-s>'] = 'StageAll',
            ['u'] = 'Unstage',
            ['K'] = 'Untrack',
            ['U'] = 'UnstageStaged',
            ['y'] = 'ShowRefs',
            ['$'] = 'CommandHistory',
            ['Y'] = 'YankSelected',
            ['<c-r>'] = 'RefreshBuffer',
            ['<cr>'] = 'GoToFile',
            ['<c-v>'] = 'VSplitOpen',
            ['<c-x>'] = 'SplitOpen',
            ['<c-t>'] = 'TabOpen',
            ['{'] = 'GoToPreviousHunkHeader',
            ['}'] = 'GoToNextHunkHeader',
            ['[c'] = 'OpenOrScrollUp',
            [']c'] = 'OpenOrScrollDown',
            ['<c-k>'] = 'PeekUp',
            ['<c-j>'] = 'PeekDown',
            ['<c-n>'] = 'NextSection',
            ['<c-p>'] = 'PreviousSection',
          },
        },
      }
    end,
  },
}
