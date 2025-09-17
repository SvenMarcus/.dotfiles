local pdm_venv_path = vim.fn.expand("~") .. "/.local/share/pdm/venvs"

local function on_venv_activate()
  -- local venv = require("venv-selector").venv()
  -- local mypy = venv .. "/bin/mypy"
  -- if vim.fn.filereadable(mypy) == 1 then
  --   Snacks.notifier.notify("mypy was found in the selected venv", "info")
  --   local null_ls = require("null-ls")
  --   null_ls.builtins.diagnostics.mypy.with({
  --     only_local = mypy,
  --   })
  -- end
end

return {
  "linux-cultist/venv-selector.nvim",
  opts = {
    settings = {
      search = {
        pdm = {
          command = "$FD '/bin/python$' '" .. pdm_venv_path .. "' --full-path -IHL -a -E /proc -E site-packages/",
        },
      },
      options = {
        picker = "snacks",
        on_venv_activate_callback = on_venv_activate,
      },
    },
  },
}
