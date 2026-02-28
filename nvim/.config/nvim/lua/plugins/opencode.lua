return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    {
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    local opencode_cmd = "opencode --port --agent OpenAgent"
    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      win = {
        position = "right",
        enter = false,
        on_win = function(win)
          -- Set up keymaps and cleanup for an arbitrary terminal
          require("opencode.terminal").setup(win.win)
        end,
      },
    }
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
        end,
        stop = function()
          require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
        end,
        toggle = function()
          require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
        end,
      },
    }
  end,
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
