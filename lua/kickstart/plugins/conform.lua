return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      {
        '<leader>tfb',
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          if vim.b.disable_autoformat then
            print 'Auto-format disabled on buffer.'
          else
            print 'Auto-format enabled on buffer.'
          end
        end,
        mode = 'n',
        desc = '[T]oggle Auto-[F]ormat on buffer',
      },
      {
        '<leader>tfg',
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          if vim.g.disable_autoformat then
            print 'Auto-format disabled globally.'
          else
            print 'Auto-format enabled globally.'
          end
        end,
        mode = 'n',
        desc = '[T]oggle Auto-[F]ormat globally',
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat then
          print 'Auto format disabled globally.'
          return
        end
        if vim.b[bufnr].disable_autoformat then
          print 'Auto format disabled on buffer.'
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        latex = { 'latexindent' },
        lua = { 'stylua' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        html = { 'prettierd' },
        htmlangular = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        python = { 'isort', 'black' },
        -- cpp = { 'clang-format' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
