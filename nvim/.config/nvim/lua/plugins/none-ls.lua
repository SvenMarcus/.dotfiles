return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")

    local function resolve_mypy()
      local function is_exec(path)
        return path and path ~= "" and vim.fn.executable(path) == 1
      end

      local ok, venv_selector = pcall(require, "venv-selector")
      if ok then
        local venv_path = venv_selector.venv()
        if venv_path and venv_path ~= vim.NIL and venv_path ~= "" then
          local venv_dir = vim.fn.fnamemodify(venv_path, ":h")
          local mypy_path = venv_dir .. "/mypy"
          if is_exec(mypy_path) then
            return mypy_path
          end
        end
      end

      -- Fall back to global mypy
      local global_mypy = vim.fn.exepath("mypy")
      if is_exec(global_mypy) then
        return global_mypy
      elseif is_exec("mypy") then
        return "mypy"
      else
        vim.notify("⚠️ No valid mypy executable found in PATH or virtualenv.", vim.log.levels.WARN)
        return nil
      end
    end

    local function setup_mypy_source()
      local mypy_path = resolve_mypy()
      if not mypy_path then
        return
      end

      vim.notify("✅ Using mypy from: " .. mypy_path, vim.log.levels.INFO)

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

    -- Attach to venv-selector callback safely
    local ok, venv_selector = pcall(require, "venv-selector")
    if ok then
      local old_callback = venv_selector.options and venv_selector.options.on_venv_activate_callback
      local function combined_callback(...)
        if old_callback then
          pcall(old_callback, ...)
        end
        vim.schedule(setup_mypy_source)
      end
      venv_selector.options = venv_selector.options or {}
      venv_selector.options.on_venv_activate_callback = combined_callback
    end
  end,
}
