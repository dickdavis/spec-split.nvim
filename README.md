# spec-split.nvim

A simple Neovim plugin to quickly open Ruby spec files alongside their implementation files in a split view.

## Usage

Press <leader>as in normal mode when editing a Ruby file to open the corresponding spec file in a vertical split. If the spec file doesn't exist, you'll be prompted to create it.

## Installation

Install using your package manager of choice.

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  'dickdavis/spec-split.nvim',
  config = function()
    require('spec_split').setup({})
  end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'dickdavis/spec-split.nvim',
  config = function()
    require('spec_split').setup({
      -- Default configuration
    })
  end
}
```

## Configuration

You can customize the plugin by passing options to the setup function.

```lua
require('spec_split').setup({
  -- Override default patterns completely
  patterns = {
    {
      pattern = "app/controllers/(.+)_controller%.rb",
      replacement = "spec/requests/%1_controller_request_spec.rb"
    },
    {
      pattern = "app/(.+)%.rb",
      replacement = "spec/%1_spec.rb"
    }
  },
  
  -- Or append new patterns to the defaults
  append_patterns = {
    {
      pattern = "app/services/(.+)%.rb",
      replacement = "spec/services/%1_spec.rb"
    }
  },
  
  -- Configure keymap
  keymap = '<leader>as',  -- Set to nil to disable automatic keymap
  desc = 'Open associated spec file',
})
```

## License

The plugin is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
