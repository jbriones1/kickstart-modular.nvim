-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local CONTROLLER = '.ts'
local TEMPLATE = '.html'
local TEST = '.spec.ts'
local STYLE_EXTS = { '.scss', '.sass', '.css', '.less' } -- precedence order

-- All recognised suffixes, longest first, so '.spec.ts' wins over '.ts'.
local KNOWN_EXTS = vim.deepcopy(STYLE_EXTS)
table.insert(KNOWN_EXTS, TEST)
table.insert(KNOWN_EXTS, CONTROLLER)
table.insert(KNOWN_EXTS, TEMPLATE)
table.sort(KNOWN_EXTS, function(a, b) return #a > #b end)

local function uv() return vim.uv or vim.loop end

local function file_exists(path) return uv().fs_stat(path) ~= nil end

-- Strip a recognised suffix off `name`. Returns base, ext (or nil, nil).
local function strip_known_ext(name)
  for _, ext in ipairs(KNOWN_EXTS) do
    if name:sub(-#ext) == ext then return name:sub(1, -(#ext + 1)), ext end
  end
end

-- Probe disk for whichever style extension exists at base_path.
local function find_style(base_path)
  for _, ext in ipairs(STYLE_EXTS) do
    if file_exists(base_path .. ext) then return base_path .. ext end
  end
end

-- Pick the preferred style file out of an in-memory {ext = path} group.
local function pick_style(files)
  for _, ext in ipairs(STYLE_EXTS) do
    if files[ext] then return files[ext] end
  end
end

-- Scan a directory for files whose base is `dir_name` or `dir_name.<something>`.
-- Returns { [base] = { [ext] = full_path, ... }, ... }
local function scan_directory_sets(dir_path, dir_name)
  local handle = uv().fs_scandir(dir_path)
  if not handle then return {} end

  local groups = {}
  while true do
    local name, typ = uv().fs_scandir_next(handle)
    if not name then break end
    if typ == nil then
      local stat = uv().fs_stat(dir_path .. '/' .. name)
      typ = stat and stat.type
    end
    if typ == 'file' or typ == 'link' then
      local base, ext = strip_known_ext(name)
      if base and (base == dir_name or base:sub(1, #dir_name + 1) == dir_name .. '.') then
        groups[base] = groups[base] or {}
        groups[base][ext] = dir_path .. '/' .. name
      end
    end
  end
  return groups
end

-- Turn raw groups into valid, ordered "sets". A set is valid only if it has
-- a .ts file (controller OR spec — both literally end in .ts).
local function build_sets(groups, dir_name)
  local sets = {}
  for base, files in pairs(groups) do
    if files[CONTROLLER] or files[TEST] then
      local count = 0
      for _ in pairs(files) do
        count = count + 1
      end
      table.insert(sets, { base = base, files = files, count = count })
    end
  end
  table.sort(sets, function(a, b)
    if a.count ~= b.count then return a.count > b.count end
    local a_base, b_base = a.base == dir_name, b.base == dir_name
    if a_base ~= b_base then return a_base end -- prefer the exact-name set on ties
    return a.base < b.base
  end)
  return sets
end

-- Open one tab for one resolved file set.
-- files = { controller = path?, template = path?, style = path?, test = path? }
-- force_test_pair: true only when the user clicked the .spec.ts file directly.
local function open_layout(state, node, cmds, files, force_test_pair)
  if force_test_pair and files.test then
    if files.controller then
      node.path = files.test
      cmds.open_tabnew(state)
      node.path = files.controller
      cmds.open_vsplit(state)
      vim.cmd 'wincmd h' -- cursor precedence: test > class
    else
      node.path = files.test
      cmds.open_tabnew(state) -- nothing to pair it with
    end
    return
  end

  local order = { 'controller', 'template', 'style' }
  local present = {}
  for _, key in ipairs(order) do
    if files[key] then table.insert(present, key) end
  end
  if #present == 0 then return end

  if #present == 1 then
    node.path = files[present[1]]
    cmds.open_tabnew(state)
  elseif #present == 2 then
    node.path = files[present[1]]
    cmds.open_tabnew(state)
    node.path = files[present[2]]
    cmds.open_vsplit(state)
    vim.cmd 'wincmd h' -- back to the higher-precedence (left) pane
  else
    node.path = files.controller
    cmds.open_tabnew(state)
    node.path = files.template
    cmds.open_vsplit(state) -- right column
    node.path = files.style
    cmds.open_split(state) -- bottom-right
    vim.cmd 'wincmd h' -- back to class (full-height left pane)
  end
end

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree action=focus source=filesystem position=right toggle=true reveal=true<CR>', desc = 'NeoTree reveal', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    filesystem = {
      filtered_items = {
        always_show = {
          '.env*',
          '.gitignore',
        },
      },
      commands = {
        ng_open = function(state)
          local node = state.tree:get_node()
          if node == nil then return end
          local cmds = require 'neo-tree.sources.filesystem.commands'

          if node.type == 'directory' then
            local groups = scan_directory_sets(node.path, node.name)
            local sets = build_sets(groups, node.name)
            if #sets == 0 then return end

            local best_tab
            for i, set in ipairs(sets) do
              local files = {
                -- directories never show the test file unless class is missing
                controller = set.files[CONTROLLER] or set.files[TEST],
                template = set.files[TEMPLATE],
                style = pick_style(set.files),
              }
              open_layout(state, node, cmds, files, false)
              if i == 1 then best_tab = vim.fn.tabpagenr() end
            end
            if best_tab then vim.cmd('tabnext ' .. best_tab) end
            return
          end

          if node.type ~= 'file' then return end

          local dir = vim.fn.fnamemodify(node.path, ':h')
          local stripped, ext = strip_known_ext(node.name)
          if stripped == nil then return end
          local base_path = dir .. '/' .. stripped

          if ext == TEST then
            local controller_path = base_path .. CONTROLLER
            open_layout(state, node, cmds, {
              controller = file_exists(controller_path) and controller_path or nil,
              test = base_path .. TEST,
            }, true)
            return
          end

          local controller_path = base_path .. CONTROLLER
          if not file_exists(controller_path) then return end -- must have a .ts file

          local style_path
          if ext and vim.tbl_contains(STYLE_EXTS, ext) then
            style_path = base_path .. ext
          else
            style_path = find_style(base_path)
          end

          open_layout(state, node, cmds, {
            controller = controller_path,
            template = file_exists(base_path .. TEMPLATE) and (base_path .. TEMPLATE) or nil,
            style = style_path,
          }, false)
        end,
      },
      window = {
        position = 'right',
        mappings = {
          ['s'] = 'open_split',
          ['v'] = 'open_vsplit',
          ['<C-1>'] = 'ng_open',
        },
      },
    },
  },
}
