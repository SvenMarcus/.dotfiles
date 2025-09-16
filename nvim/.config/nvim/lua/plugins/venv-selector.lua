local pdm_venv_path = vim.fn.expand("~") .. "/.local/share/pdm/venvs/"

return {
  "linux-cultist/venv-selector.nvim",
  opts = {
    search = {
      pdm = {
        command = "fd /bin/python$ " .. pdm_venv_path .. " --full-path -IHL -E /proc",
      },
    },
    options = {
      on_fd_result_callback = function(fd_results)
        local out = ""
        for i, result in pairs(fd_results) do
          out = out .. string.format("%d. %s\n", i, result)
        end
        Snacks.notifier.notify(out, "info")
        return fd_results
      end,
    },
  },
}
