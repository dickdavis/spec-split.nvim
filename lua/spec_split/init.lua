local M = {}

-- Define the mapping patterns in order of specificity
local spec_patterns = {
  -- Pattern for controller request specs
  {
    pattern = "app/controllers/(.+)_controller%.rb",
    replacement = "spec/requests/%1_controller_request_spec.rb"
  },
  -- Common pattern for spec organization and naming
  {
    pattern = "app/(.+)%.rb",
    replacement = "spec/%1_spec.rb"
  }
}

-- Make patterns configurable
M.setup = function(opts)
  -- Allow users to override default patterns
  if opts and opts.patterns then
    spec_patterns = opts.patterns
  end

  -- Allow users to extend default patterns
  if opts and opts.append_patterns then
    for _, pattern in ipairs(opts.append_patterns) do
      table.insert(spec_patterns, pattern)
    end
  end

  -- Set the keymap if enabled
  if opts and opts.set_keymap ~= false then
    local keymap = opts.keymap or '<leader>as'
    local desc = opts.desc or 'Open associated spec file'
    vim.keymap.set('n', keymap, M.open_spec, { desc = desc })
  end
end

-- Function to find and open the corresponding spec file
function M.open_spec()
  local current_file = vim.fn.expand('%')
  local spec_file = nil

  -- Try to match the current file against our patterns in order
  for _, pattern_def in ipairs(spec_patterns) do
    if current_file:match(pattern_def.pattern) then
      spec_file = current_file:gsub(pattern_def.pattern, pattern_def.replacement)
      break
    end
  end

  if spec_file then
    -- Check if the spec file exists
    if vim.fn.filereadable(spec_file) == 1 then
      vim.cmd('vsplit ' .. spec_file)
    else
      -- Notify user and offer to create the file
      local create = vim.fn.confirm('Spec file not found: ' .. spec_file .. '\nCreate it?', '&Yes\n&No', 2)
      if create == 1 then
        -- Create the directory if it doesn't exist
        local dir = vim.fn.fnamemodify(spec_file, ':h')
        vim.fn.mkdir(dir, 'p')
        vim.cmd('vsplit ' .. spec_file)
      end
    end
  else
    vim.notify('No spec pattern matched for: ' .. current_file, vim.log.levels.WARN)
  end
end

return M
