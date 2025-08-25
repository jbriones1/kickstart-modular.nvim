-- Quick switch between template/class/style files in Angular
return {
  'jbriones1/angular-quickswitch.nvim',
  keys = {
    {
      '<localleader>q',
      ':NgQuickSwitchClass<CR>',
      mode = 'n',
      desc = 'Switch to class',
    },
    {
      '<localleader>w',
      ':NgQuickSwitchTemplate<CR>',
      mode = 'n',
      desc = 'Switch to template',
    },
    {
      '<localleader>e',
      ':NgQuickSwitchStyle<CR>',
      mode = 'n',
      desc = 'Switch to style',
    },
    {
      '<localleader>r',
      ':NgQuickSwitchSpec<CR>',
      mode = 'n',
      desc = 'Switch to test',
    },
  },
  opts = {},
}
