vim.filetype.add {
  pattern = {
    ['.*%.component%.html'] = 'htmlangular',
    ['.*%.screen%.html'] = 'htmlangular',
    ['.*%.widget%.html'] = 'htmlangular',
  },
  extension = {
    mdx = 'markdown',
  },
}
