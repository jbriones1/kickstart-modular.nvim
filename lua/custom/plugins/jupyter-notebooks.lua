-- Setup for running Jupyter notebooks
-- https://github.com/benlubas/molten-nvim/blob/main/docs/Notebook-Setup.md

return {
  -- Jupytext.nvim is for opening Jupyter notebooks by converting ipynb files to markdown and markdown to ipynb when saving
  -- https://github.com/GCBallesteros/jupytext.nvim
  -- Required 'pip install jupytext'
  {
    'GCBallesteros/jupytext.nvim',
    opts = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },
  -- Molten-nvim is for running Jupyter notebooks
  -- https://github.com/benlubas/molten-nvim
  -- Required `pip install pynvim jupyter_client`
  -- No image.nvim configured, so images can't be displayed
  {
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    build = ':UpdateRemotePlugins',
    keys = {
      { '<localleader>mi', ':MoltenInit<CR>', mode = 'n', desc = 'Initialize Molten', silent = true },
      { '<localleader>e', ':MoltenEvaluateOperator<CR>', mode = 'n', desc = '(Molten) Evaluate', silent = true },
      { '<localleader>rr', ':MoltenReevaluateCell<CR>', mode = 'n', desc = '(Molten) [R]e[r]run cell', silent = true },
      { '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', mode = 'n', desc = '(Molten) [O]utput show', silent = true },
      { '<localleader>oh', ':MoltenHideOutput<CR>', mode = 'n', desc = '(Molten) [O]utput hide', silent = true },
      { '<localleader>rv', ':<C-u>MoltenEvaluateVisual<CR>gv', mode = 'n', desc = '(Molten) [R]un [v]isual', silent = true },
      { '<localleader>rl', ':MoltenEvaluateLine<CR>', mode = 'n', desc = '(Molten) [R]un [l]ine', silent = true },
    },
    config = function()
      -- Disables outputs automatically showing when hovering over a cell
      vim.g.molten_auto_open_output = false

      -- Outputs come out as virtual text
      vim.g.molten_virt_text_output = true

      -- Displays output below the cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true

      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
            if venv ~= nil then
              kernel_name = string.match(venv, '/.+/(.+)')
            end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(('MoltenInit %s'):format(kernel_name))
          end
          vim.cmd 'MoltenImportOutput'
        end)
      end

      -- ## This section is for converting Jupyter notebooks properly
      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd('BufAdd', {
        pattern = { '*.ipynb' },
        callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.ipynb' },
        callback = function(e)
          if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
            imb(e)
          end
        end,
      })
      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then
            vim.cmd 'MoltenExportOutput!'
          end
        end,
      })
      -- ##

      -- ## Toggles Jupyter stuff on and off based on the file type
      -- change the configuration when editing a python file
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*.py',
        callback = function(e)
          if string.match(e.file, '.otter.') then
            return
          end
          if require('molten.status').initialized() == 'Molten' then -- this is kinda a hack...
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', false)
            vim.fn.MoltenUpdateOption('virt_text_output', false)
          else
            vim.g.molten_virt_lines_off_by_1 = false
            vim.g.molten_virt_text_output = false
          end
        end,
      })

      -- Undo those config changes when we go back to a markdown or quarto file
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.qmd', '*.md', '*.ipynb' },
        callback = function(e)
          if string.match(e.file, '.otter.') then
            return
          end
          if require('molten.status').initialized() == 'Molten' then
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', true)
            vim.fn.MoltenUpdateOption('virt_text_output', true)
          else
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
          end
        end,
      })
      -- ##
    end,
  },
  -- Quarto is to support Molten in editing Jupyter notebooks
  -- https://github.com/quarto-dev/quart-nvim
  {
    'quarto-dev/quarto-nvim',
    dependencies = {
      -- for languages that have code cells
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'quarto', 'markdown' },
    dev = false,
    opts = {
      lspFeatures = {
        languages = { 'python' },
        chunks = 'all',
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = {
          enabled = true,
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten',
        },
      },
    },
    config = function(_, opts)
      require('quarto').setup(opts)
      local runner = require 'quarto.runner'

      vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = '(Quarto) [R]un [c]ell', silent = true })
      -- Run every cell above this cell and this cell, in order from top to bottom
      vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = '(Quarto) [R]un [a]bove and this cell', silent = true })
      vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = '(Quarto) [R]un [A]ll cells', silent = true })
      vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = '(Quarto) [R]un [l]ine', silent = true })
      vim.keymap.set('v', '<localleader>r', runner.run_cell, { desc = '(Quarto) [R]un visual range', silent = true })
      vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = '(Quarto) [R]un cell', silent = true })
    end,
  },
}
