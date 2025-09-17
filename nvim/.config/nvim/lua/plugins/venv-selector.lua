local pdm_venv_path = vim.fn.expand("~") .. "/.local/share/pdm/venvs"

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
      },
    },
  },
}
