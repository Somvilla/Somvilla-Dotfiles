return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
      local transparent_background = true

      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = transparent_background,
      })
      vim.cmd.colorscheme "catppuccin"

      local toggle_transparency = function()
          transparent_background = not transparent_background

          -- re-apply catppuccin using the toggled value
          require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = transparent_background,
          })

          vim.cmd [[colorscheme catppuccin]]
      end

      vim.keymap.set('n', '<leader>bg', toggle_transparency,
        { noremap = true, silent = true })
  end
}
