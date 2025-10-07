return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")
    opts.sources = opts.sources or {}

    local function add_mypy_source()
      local mypy_path = vim.fn.exepath("mypy")
      if mypy_path == "" then
        vim.notify("⚠️ mypy not found (no venv active?)", vim.log.levels.WARN)
        return
      end
      table.insert(
        opts.sources,
        null_ls.builtins.diagnostics.mypy.with({
          command = mypy_path,
        })
      )
      require("null-ls").setup(opts)
      vim.notify("✅ Registered mypy from " .. mypy_path, vim.log.levels.INFO)
    end

    -- Initial registration (might be empty)
    add_mypy_source()

    -- Register callback when venv changes
    local ok, venv_selector = pcall(require, "venv-selector")
    if ok and venv_selector.on_venv_activate_callback then
      venv_selector.on_venv_activate_callback(add_mypy_source)
    else
      vim.api.nvim_create_autocmd("User", {
        pattern = "VenvSelectActivated",
        callback = add_mypy_source,
      })
    end
  end,
}
