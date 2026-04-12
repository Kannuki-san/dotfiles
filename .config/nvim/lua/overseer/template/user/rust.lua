-- Rust用のOverseerテンプレート集

-- いったん現在の作業ディレクトリをプロジェクトルート扱いにする
local function project_root()
  return vim.fn.getcwd()
end

return {
  {
    -- cargo run
    name = "Rust: cargo run",

    condition = {
      filetype = { "rust" },
    },

    builder = function()
      return {
        cmd = { "cargo", "run" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- cargo test
    name = "Rust: cargo test",

    condition = {
      filetype = { "rust" },
    },

    builder = function()
      return {
        cmd = { "cargo", "test" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- cargo check
    name = "Rust: cargo check",

    condition = {
      filetype = { "rust" },
    },

    builder = function()
      return {
        cmd = { "cargo", "check" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- cargo clippy
    name = "Rust: cargo clippy",

    condition = {
      filetype = { "rust" },
    },

    builder = function()
      return {
        cmd = { "cargo", "clippy" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- cargo fmt
    name = "Rust: cargo fmt",

    condition = {
      filetype = { "rust" },
    },

    builder = function()
      return {
        cmd = { "cargo", "fmt" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },
}
