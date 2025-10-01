return {
  "snacks.nvim",
  keys = {
    {
      "<leader>fa",
      function()
        Snacks.picker.files({
          sources = {
            files = {
              hidden = true,
              ignored = true,
            },
          },
        })
      end,
    },
  },
  opts = {
    scroll = { enabled = true },
    styles = {
      terminal = {
        border = "rounded",
      },
    },
    terminal = {
      win = {
        position = "float",
      },
    },
    picker = {
      hidden = true,
    },
  },
}
