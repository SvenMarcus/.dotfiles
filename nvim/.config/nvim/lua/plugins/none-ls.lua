return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")

    local function resolve_mypy()
      local venv_selector = require("venv-selector")

      local venv_path = venv_selector.venv()
      if not venv_path or venv_path == vim.NIL or venv_path == "" then
        return vim.fn.exepath("mypy") or "mypy"
      end

      local venv_dir = vim.fn.fnamemodify(venv_path, ":h")
      local mypy_bin = venv_dir .. "/mypy"
      return vim.fn.executable(mypy_bin) == 1 and mypy_bin or (vim.fn.exepath("mypy") or "mypy")
    end

    local function setup_mypy_source()
      local mypy_path = resolve_mypy()
      if mypy_path == "" then
        vim.notify("⚠️ mypy not found in PATH or venv", vim.log.levels.WARN)
      else
        vim.notify("✅ Using mypy from: " .. mypy_path, vim.log.levels.INFO)
      end

      opts.sources = vim.tbl_filter(function(src)
        return src.name ~= "mypy"
      end, opts.sources or {})

      table.insert(
        opts.sources,
        null_ls.builtins.diagnostics.mypy.with({
          command = mypy_path,
        })
      )
    end

    -- Initial setup
    setup_mypy_source()

    -- Safely attach to the existing on_activate callback (if present)
    local venv_selector = require("venv-selector")
    local old_callback = venv_selector.options and venv_selector.options.on_venv_activate_callback
    local function combined_callback(...)
      if old_callback then
        pcall(old_callback, ...)
      end
      vim.schedule(setup_mypy_source)
    end
    -- Just patch the existing options table instead of re-calling setup()
    venv_selector.options = venv_selector.options or {}
    venv_selector.options.on_venv_activate_callback = combined_callback
  end,
}
