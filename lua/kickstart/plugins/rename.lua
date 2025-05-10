-- Rename module for the LSP
local lsp_priority = {
  rename = {
    'ts_ls',
    'angularls',
  },
}

local lsp_have_rename = function(client)
  return client.supports_method 'textDocument/rename'
end

local get_lsp_clients = function(have_feature)
  local client_names = {}
  local attached_clients = vim.lsp.get_clients { bufnr = 0 }
  for _, client in ipairs(attached_clients) do
    if have_feature(client) then
      table.insert(client_names, client.name)
    end
  end
  return client_names
end

local lsp_rename = function(client_name)
  vim.lsp.buf.rename(nil, { name = client_name })
end

local lsp_rename_use_one = function(fallback)
  local client_names = get_lsp_clients(lsp_have_rename)
  if #client_names == 1 then
    lsp_rename(client_names[1])
    return
  end
  if fallback then
    fallback()
  end
end

local lsp_rename_use_select = function(fallback)
  local client_names = get_lsp_clients(lsp_have_rename)
  local prompt = 'Select which LSP to use for renaming:'
  local on_choice = function(client_name)
    if client_name then
      lsp_rename(client_name)
      return
    end
    if fallback then
      fallback()
    end
  end
  vim.ui.select(client_names, { prompt = prompt }, on_choice)
end

local lsp_rename_use_priority = function(fallback)
  local client_names = get_lsp_clients(lsp_have_rename)
  for _, priority in ipairs(lsp_priority.rename) do
    for _, client_name in ipairs(client_names) do
      print(client_name)
      if priority == client_name then
        lsp_rename(client_name)
        return
      end
    end
  end
  if fallback then
    print 'fallback'
    fallback()
  end
end

local lsp_rename_use_priority_or_select = function()
  lsp_rename_use_one(function()
    lsp_rename_use_priority(function()
      lsp_rename_use_select()
    end)
  end)
end

return {
  rename = lsp_rename_use_priority_or_select,
}
