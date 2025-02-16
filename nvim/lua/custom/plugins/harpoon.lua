return {
  -- Harpoon plugin configuration
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    lazy = false,
    requires = { 'nvim-lua/plenary.nvim' }, -- if harpoon requires this
    config = function()
      require('harpoon').setup {}

      local function toggle_telescope_with_harpoon(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = require('telescope.config').values.file_previewer {},
            sorter = require('telescope.config').values.generic_sorter {},
          })
          :find()
      end
      vim.keymap.set('n', '<leader>hw', function()
        local harpoon = require 'harpoon'
        toggle_telescope_with_harpoon(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
    keys = {
      {
        '<leader>ha',
        function()
          require('harpoon'):list():append()
        end,
        desc = 'Add File to Harpoon List',
      },
      {
        '<leader>he',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'harpoon quick menu',
      },
      {
        '<leader>hh',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Select First File in Harpoon List',
      },
      {
        '<leader>hj',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Select Second File in Harpoon List',
      },
      {
        '<leader>hk',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Select Third File in Harpoon List',
      },
      {
        '<leader>hl',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Select Fourth File in Harpoon List',
      },
      {
        '<leader>hp',
        function()
          require('harpoon'):list():prev()
        end,
        desc = 'Go to Previous Buffer',
      },
      {
        '<leader>hn',
        function()
          require('harpoon'):list():next()
        end,
        desc = 'Go to Next Buffer',
      },
    },
  },
}
