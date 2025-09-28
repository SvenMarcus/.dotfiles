return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  keys = {
    {
      "<leader>oA",
      function()
        require("opencode").ask()
      end,
      desc = "Ask opencode",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@cursor: ")
      end,
      desc = "Ask opencode about this",
      mode = "n",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@selection: ")
      end,
      desc = "Ask opencode about selection",
      mode = "v",
    },
    {
      "<leader>ot",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle embedded opencode",
    },
  },
}
