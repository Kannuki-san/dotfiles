local function current_file()
  return vim.fn.expand("%:p")
end

local function current_dir()
  return vim.fn.expand("%:p:h")
end

local function project_root()
  return vim.fn.getcwd()
end

return {
  {
    name = "Python: uv run current file",
    condition = {
      filetype = { "python" },
    },
    builder = function()
      local file = current_file()
      return {
        cmd = "uv",
        args = { "run", file },
        cwd = current_dir(),
        components = { "default" },
        name = "uv run " .. vim.fn.expand("%:t"),
      }
    end,
  },

  {
    name = "Python: pytest",
    condition = {
      filetype = { "python" },
    },
    builder = function()
      return {
        cmd = "uv",
        args = { "run", "pytest" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    name = "Python: ruff check",
    condition = {
      filetype = { "python" },
    },
    builder = function()
      return {
        cmd = "uv",
        args = { "run", "ruff", "check", "." },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    name = "Python: ruff format",
    condition = {
      filetype = { "python" },
    },
    builder = function()
      return {
        cmd = "uv",
        args = { "run", "ruff", "format", "." },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },
}
