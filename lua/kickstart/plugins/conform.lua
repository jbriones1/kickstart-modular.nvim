local function organize_imports(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.name == 'ts_ls' then
      local params = {
        command = '_typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }
      client:request('workspace/executeCommand', params, nil, 0)
    end
  end
end

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          organize_imports()
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
          organize_imports(bufnr)
          return {
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
